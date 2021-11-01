Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AB0441837
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhKAJpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232576AbhKAJlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CFD2611F0;
        Mon,  1 Nov 2021 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758879;
        bh=yXj4WjHLyogmSQdfxjkcC3+Dk1Yc30lX/qyP66SJ1U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0Efa2hOEanIdnslEl4+O4Ljy4fEdCtPdMcrgUF/IwL+2kxnBylrmxbjIixOw73PC
         Sv1Gs2dpKyZl822LATIeJ3g7ZXBnAwMyP2mni/WguW6Ws628CyNg6jJmLdqnAzZDO4
         WHOvYbJytEeSzgD7MdlDJog9UOO6ysp/JEAPfBqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 020/125] mmc: tmio: reenable card irqs after the reset callback
Date:   Mon,  1 Nov 2021 10:16:33 +0100
Message-Id: <20211101082537.280758304@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 90935eb303e0d12f3d3d0383262e65290321f5f6 upstream.

The reset callback may clear the internal card detect interrupts, so
make sure to reenable them if needed.

Fixes: b4d86f37eacb ("mmc: renesas_sdhi: do hard reset if possible")
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211028195149.8003-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/tmio_mmc_core.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -195,6 +195,10 @@ static void tmio_mmc_reset(struct tmio_m
 	sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK, host->sdcard_irq_mask_all);
 	host->sdcard_irq_mask = host->sdcard_irq_mask_all;
 
+	if (host->native_hotplug)
+		tmio_mmc_enable_mmc_irqs(host,
+				TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT);
+
 	tmio_mmc_set_bus_width(host, host->mmc->ios.bus_width);
 
 	if (host->pdata->flags & TMIO_MMC_SDIO_IRQ) {
@@ -956,8 +960,15 @@ static void tmio_mmc_set_ios(struct mmc_
 	case MMC_POWER_OFF:
 		tmio_mmc_power_off(host);
 		/* For R-Car Gen2+, we need to reset SDHI specific SCC */
-		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2) {
 			host->reset(host);
+
+			if (host->native_hotplug)
+				tmio_mmc_enable_mmc_irqs(host,
+						TMIO_STAT_CARD_REMOVE |
+						TMIO_STAT_CARD_INSERT);
+		}
+
 		host->set_clock(host, 0);
 		break;
 	case MMC_POWER_UP:
@@ -1185,10 +1196,6 @@ int tmio_mmc_host_probe(struct tmio_mmc_
 	_host->set_clock(_host, 0);
 	tmio_mmc_reset(_host);
 
-	if (_host->native_hotplug)
-		tmio_mmc_enable_mmc_irqs(_host,
-				TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT);
-
 	spin_lock_init(&_host->lock);
 	mutex_init(&_host->ios_lock);
 


