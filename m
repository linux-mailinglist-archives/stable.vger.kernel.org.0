Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C7212C58A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbfL2Rgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730074AbfL2Rgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F636206CB;
        Sun, 29 Dec 2019 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640996;
        bh=F5EBHiBNJQ7dqwdk87xUNn4kv1JHaLOhk5LxSD3uTkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o77kjp9wF4Yj/g1vE46vnn9JwPOQp8CC63dUAD/A1HAYgzMvqny9DKwfNuqWGJEkM
         +q4Iiuk5PWS9EgbRBLnq7X4gAQParmR6JjRY/iM/y89gyY/C/Wmwlu+04XzcsCwr7J
         3kzgZudZJjC12z0tMsGFrtRJ9ZV/G06f8pIce+NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 218/219] mmc: sdhci: Add a quirk for broken command queuing
Date:   Sun, 29 Dec 2019 18:20:20 +0100
Message-Id: <20191229162543.254151435@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 75d27ea1abf7af3cc2cdec3513e74f52191605c8 upstream.

Command queuing has been reported broken on some systems based on Intel
GLK. A separate patch disables command queuing in some cases.

This patch adds a quirk for broken command queuing, which enables users
with problems to disable command queuing using sdhci module parameters for
quirks.

Fixes: 8ee82bda230f ("mmc: sdhci-pci: Add CQHCI support for Intel GLK")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191217095349.14592-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    3 +++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3549,6 +3549,9 @@ int sdhci_setup_host(struct sdhci_host *
 		       mmc_hostname(mmc), host->version);
 	}
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CQE)
+		mmc->caps2 &= ~MMC_CAP2_CQE;
+
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_SDMA;
 	else if (!(host->caps & SDHCI_CAN_DO_SDMA))
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -391,6 +391,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
+/* Controller has unusable command queue engine */
+#define SDHCI_QUIRK_BROKEN_CQE				(1<<17)
 /* Controller does not like fast PIO transfers */
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<18)
 /* Controller has to be forced to use block size of 2048 bytes */


