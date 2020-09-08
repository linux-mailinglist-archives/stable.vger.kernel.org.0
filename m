Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A32261423
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgIHQGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731217AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008B8224B0;
        Tue,  8 Sep 2020 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579954;
        bh=Vxf8thUXD9HDmFrlefoNCGBHtvxhE+QvMWyMaGEiawk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpIPdnIos3VGvS250go4Qjo0QZDovh2FGPm2ffxiJxFCFuAwQBtrW8IC/Dd+wtQev
         6MhIr0hCsAxsPrRKKx9Riyh1YDLJFCk2+Wj1Gbg4o+94UrDZkeSOXeZuJbiqib2uVX
         I6VP+LoprjKypMoCfD7new4S6ptNUyCzgS14JkLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 100/129] mmc: mediatek: add optional module reset property
Date:   Tue,  8 Sep 2020 17:25:41 +0200
Message-Id: <20200908152234.812316496@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenbin Mei <wenbin.mei@mediatek.com>

commit 855d388df217989fbf1f18c781ae6490dbb48e86 upstream.

This patch fixs eMMC-Access on mt7622/Bpi-64.
Before we got these Errors on mounting eMMC ion R64:
[   48.664925] blk_update_request: I/O error, dev mmcblk0, sector 204800 op 0x1:(WRITE)
flags 0x800 phys_seg 1 prio class 0
[   48.676019] Buffer I/O error on dev mmcblk0p1, logical block 0, lost sync page write

This patch adds a optional reset management for msdc.
Sometimes the bootloader does not bring msdc register
to default state, so need reset the msdc controller.

Cc: <stable@vger.kernel.org> # v5.4+
Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20200814014346.6496-4-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/reset.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/core.h>
@@ -412,6 +413,7 @@ struct msdc_host {
 	struct pinctrl_state *pins_uhs;
 	struct delayed_work req_timeout;
 	int irq;		/* host interrupt */
+	struct reset_control *reset;
 
 	struct clk *src_clk;	/* msdc source clock */
 	struct clk *h_clk;      /* msdc h_clk */
@@ -1474,6 +1476,12 @@ static void msdc_init_hw(struct msdc_hos
 	u32 val;
 	u32 tune_reg = host->dev_comp->pad_tune_reg;
 
+	if (host->reset) {
+		reset_control_assert(host->reset);
+		usleep_range(10, 50);
+		reset_control_deassert(host->reset);
+	}
+
 	/* Configure to MMC/SD mode, clock free running */
 	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_MODE | MSDC_CFG_CKPDN);
 
@@ -2232,6 +2240,11 @@ static int msdc_drv_probe(struct platfor
 	if (IS_ERR(host->src_clk_cg))
 		host->src_clk_cg = NULL;
 
+	host->reset = devm_reset_control_get_optional_exclusive(&pdev->dev,
+								"hrst");
+	if (IS_ERR(host->reset))
+		return PTR_ERR(host->reset);
+
 	host->irq = platform_get_irq(pdev, 0);
 	if (host->irq < 0) {
 		ret = -EINVAL;


