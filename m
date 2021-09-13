Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071814094AD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344359AbhIMOdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344124AbhIMObY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2806137B;
        Mon, 13 Sep 2021 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541111;
        bh=pyy8q8caTEBVtMulRO5jgxfmBBL852cVJ3x3bjtFNsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ce/EcOyjBso/zZKTLGCWtmXY4kTdmP0jdCzpOSOl6l4D7OwnvADrKQGgMWxV/t9t6
         vnmdLEROBvV7moghT8r1LxvjAvK+IZWcwLrjdDR7cVN9Aoym3eSKGNH5HeEssiuyYO
         R7B3YiqLvY+x+fb/7VgXsZt28qO2XqUi9C+t8/QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Daniel Abrecht <public@danielabrecht.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 135/334] drm: mxsfb: Increase number of outstanding requests on V4 and newer HW
Date:   Mon, 13 Sep 2021 15:13:09 +0200
Message-Id: <20210913131117.930281367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9891cb54445bc65bf156bda416b6215048c7f617 ]

In case the DRAM is under high load, the MXSFB FIFO might underflow
and that causes visible artifacts. This could be triggered on i.MX8MM
using e.g. "$ memtester 128M" on a device with 1920x1080 panel. The
first "Stuck Address" test of the memtester will completely corrupt
the image on the panel and leave the MXSFB FIFO in odd state.

To avoid this underflow, increase number of outstanding requests to
DRAM from 2 to 16, which is the maximum. This mitigates the issue
and it can no longer be triggered.

Fixes: 45d59d704080 ("drm: Add new driver for MXSFB controller")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Daniel Abrecht <public@danielabrecht.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Stefan Agner <stefan@agner.ch>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210620224759.189351-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_drv.c  | 3 +++
 drivers/gpu/drm/mxsfb/mxsfb_drv.h  | 1 +
 drivers/gpu/drm/mxsfb/mxsfb_kms.c  | 8 ++++++++
 drivers/gpu/drm/mxsfb/mxsfb_regs.h | 8 ++++++++
 4 files changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.c b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
index 6da93551e2e5..c277d3f61a5e 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -51,6 +51,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0xff,
 		.hs_wdth_shift	= 24,
 		.has_overlay	= false,
+		.has_ctrl2	= false,
 	},
 	[MXSFB_V4] = {
 		.transfer_count	= LCDC_V4_TRANSFER_COUNT,
@@ -59,6 +60,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0x3fff,
 		.hs_wdth_shift	= 18,
 		.has_overlay	= false,
+		.has_ctrl2	= true,
 	},
 	[MXSFB_V6] = {
 		.transfer_count	= LCDC_V4_TRANSFER_COUNT,
@@ -67,6 +69,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0x3fff,
 		.hs_wdth_shift	= 18,
 		.has_overlay	= true,
+		.has_ctrl2	= true,
 	},
 };
 
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.h b/drivers/gpu/drm/mxsfb/mxsfb_drv.h
index 399d23e91ed1..7c720e226fdf 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.h
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.h
@@ -22,6 +22,7 @@ struct mxsfb_devdata {
 	unsigned int	hs_wdth_mask;
 	unsigned int	hs_wdth_shift;
 	bool		has_overlay;
+	bool		has_ctrl2;
 };
 
 struct mxsfb_drm_private {
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 01e0f525360f..5bcc06c1ac0b 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -107,6 +107,14 @@ static void mxsfb_enable_controller(struct mxsfb_drm_private *mxsfb)
 		clk_prepare_enable(mxsfb->clk_disp_axi);
 	clk_prepare_enable(mxsfb->clk);
 
+	/* Increase number of outstanding requests on all supported IPs */
+	if (mxsfb->devdata->has_ctrl2) {
+		reg = readl(mxsfb->base + LCDC_V4_CTRL2);
+		reg &= ~CTRL2_SET_OUTSTANDING_REQS_MASK;
+		reg |= CTRL2_SET_OUTSTANDING_REQS_16;
+		writel(reg, mxsfb->base + LCDC_V4_CTRL2);
+	}
+
 	/* If it was disabled, re-enable the mode again */
 	writel(CTRL_DOTCLK_MODE, mxsfb->base + LCDC_CTRL + REG_SET);
 
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_regs.h b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
index df90e960f495..694fea13e893 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_regs.h
+++ b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
@@ -15,6 +15,7 @@
 #define LCDC_CTRL			0x00
 #define LCDC_CTRL1			0x10
 #define LCDC_V3_TRANSFER_COUNT		0x20
+#define LCDC_V4_CTRL2			0x20
 #define LCDC_V4_TRANSFER_COUNT		0x30
 #define LCDC_V4_CUR_BUF			0x40
 #define LCDC_V4_NEXT_BUF		0x50
@@ -61,6 +62,13 @@
 #define CTRL1_CUR_FRAME_DONE_IRQ_EN	BIT(13)
 #define CTRL1_CUR_FRAME_DONE_IRQ	BIT(9)
 
+#define CTRL2_SET_OUTSTANDING_REQS_1	0
+#define CTRL2_SET_OUTSTANDING_REQS_2	(0x1 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_4	(0x2 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_8	(0x3 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_16	(0x4 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_MASK	(0x7 << 21)
+
 #define TRANSFER_COUNT_SET_VCOUNT(x)	(((x) & 0xffff) << 16)
 #define TRANSFER_COUNT_GET_VCOUNT(x)	(((x) >> 16) & 0xffff)
 #define TRANSFER_COUNT_SET_HCOUNT(x)	((x) & 0xffff)
-- 
2.30.2



