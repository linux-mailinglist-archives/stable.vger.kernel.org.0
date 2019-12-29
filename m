Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EF312C913
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbfL2R7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387528AbfL2R61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630E1208C4;
        Sun, 29 Dec 2019 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642306;
        bh=irBTXJO5M41OcAwgoz9Wl6r8hqKKns6HU2jay+CD41M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQVAn8i7/q4Om/Txl2EtrgiUFOPBHEh0pFoCpzqRgL96xU2VfuyDoOoA77Kc8ZYUd
         6rgTfEVvLwE50842kuDoxaTHynCd+Crm6Sv1ajKhr3OkjNWgkcgHo7xp1DavwhEfER
         ueK4pM5eaPm4oN705AIUdZRJvrizkWRtozCEXwVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 429/434] mmc: sdhci: Update the tuning failed messages to pr_debug level
Date:   Sun, 29 Dec 2019 18:28:02 +0100
Message-Id: <20191229172731.819065335@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit 2c92dd20304f505b6ef43d206fff21bda8f1f0ae upstream.

Tuning support in DDR50 speed mode was added in SD Specifications Part1
Physical Layer Specification v3.01. Its not possible to distinguish
between v3.00 and v3.01 from the SCR and that is why since
commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
tuning failures are ignored in DDR50 speed mode.

Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
error gets printed during enumeration and also if retune is triggered at
any time during operation. Update the printk level to pr_debug so that
these errors don't lead to false error reports.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20191206114326.15856-1-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2406,8 +2406,8 @@ static int __sdhci_execute_tuning(struct
 		sdhci_send_tuning(host, opcode);
 
 		if (!host->tuning_done) {
-			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
-				mmc_hostname(host->mmc));
+			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
+				 mmc_hostname(host->mmc));
 			sdhci_abort_tuning(host, opcode);
 			return -ETIMEDOUT;
 		}


