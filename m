Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BF614B63A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgA1ODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbgA1ODc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54D1A24694;
        Tue, 28 Jan 2020 14:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220211;
        bh=w3mIiLiBLhBbNSIrRZreHeBRo36GmABG/nd5bGKH9rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaMtuGckqZaDQLIhOiiJpRHF7bm0Ro5YomEeWttCAAdY93eB9RDbY2Z3IhH9S06D9
         qCfqLw+WLx74j21NZ0unY/c7h/RfRXzak7lJPXDKu1h9xT9T2sMSAgy46l/Ia9YOEC
         JaB7DMOh0CZZaJBGOWRcg3h4yJg4S6B09aIMEbOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 061/104] mmc: sdhci_am654: Reset Command and Data line after tuning
Date:   Tue, 28 Jan 2020 15:00:22 +0100
Message-Id: <20200128135826.005373766@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit de31f6ab68a3f548d88686d53514f252d78f61d5 upstream.

The tuning data is leftover in the buffer after tuning. This can cause
issues in future data commands, especially with CQHCI. Reset the command
and data lines after tuning to continue from a clean state.

Fixes: 41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200108143301.1929-3-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci_am654.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -236,6 +236,22 @@ static void sdhci_am654_write_b(struct s
 	writeb(val, host->ioaddr + reg);
 }
 
+static int sdhci_am654_execute_tuning(struct mmc_host *mmc, u32 opcode)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	int err = sdhci_execute_tuning(mmc, opcode);
+
+	if (err)
+		return err;
+	/*
+	 * Tuning data remains in the buffer after tuning.
+	 * Do a command and data reset to get rid of it
+	 */
+	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
+
+	return 0;
+}
+
 static struct sdhci_ops sdhci_am654_ops = {
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
 	.get_timeout_clock = sdhci_pltfm_clk_get_max_clock,
@@ -477,6 +493,8 @@ static int sdhci_am654_probe(struct plat
 		goto pm_runtime_put;
 	}
 
+	host->mmc_host_ops.execute_tuning = sdhci_am654_execute_tuning;
+
 	ret = sdhci_am654_init(host);
 	if (ret)
 		goto pm_runtime_put;


