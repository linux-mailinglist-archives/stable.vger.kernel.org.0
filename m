Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6CE12C8EB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfL2R6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387517AbfL2R6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B53206DB;
        Sun, 29 Dec 2019 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642304;
        bh=aGTEswSv5AoqkJCw0q7T4G4fu/TIPylEKe8c8Gu/PK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GqbBBa7bOxl5dQvZPGKEk2xSZXHfh7wlEj4qk5fHO2nLWsTysX0zXiIkIhW6pw8I
         4Ecwt57/879e4QcnNat3XEbMXZTI+XiU1+9f6wc4DL3dME8ZwgV7yvgFnfgwIMy6yC
         d+rtzePJe16SiR9OWqrd3AEVJAkLQiV6i+9fz3r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 428/434] mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add erratum A-009204 support"
Date:   Sun, 29 Dec 2019 18:28:01 +0100
Message-Id: <20191229172731.736290640@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 8b6dc6b2d60221e90703babbc141f063b8a07e72 upstream.

This reverts commit 5dd195522562542bc6ebe6e7bd47890d8b7ca93c.

First, the fix seems to be plain wrong, since the erratum suggests
waiting 5ms before setting setting SYSCTL[RSTD], but this msleep()
happens after the call of sdhci_reset() which is where that bit gets
set (if SDHCI_RESET_DATA is in mask).

Second, walking the whole device tree to figure out if some node has a
"fsl,p2020-esdhc" compatible string is hugely expensive - about 70 to
100 us on our mpc8309 board. Walking the device tree is done under a
raw_spin_lock, so this is obviously really bad on an -rt system, and a
waste of time on all.

In fact, since esdhc_reset() seems to get called around 100 times per
second, that mpc8309 now spends 0.8% of its time determining that
it is not a p2020. Whether those 100 calls/s are normal or due to some
other bug or misconfiguration, regularly hitting a 100 us
non-preemptible window is unacceptable.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191204085447.27491-1-linux@rasmusvillemoes.dk
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -710,9 +710,6 @@ static void esdhc_reset(struct sdhci_hos
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
 
-	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc"))
-		mdelay(5);
-
 	if (mask & SDHCI_RESET_ALL) {
 		val = sdhci_readl(host, ESDHC_TBCTL);
 		val &= ~ESDHC_TB_EN;


