Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E278F3D7CFA
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhG0SBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:01:04 -0400
Received: from mxwww.masterlogin.de ([95.129.51.170]:41268 "EHLO
        mxwww.masterlogin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG0SBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:01:03 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 14:01:03 EDT
Received: from mxout3.routing.net (unknown [192.168.10.111])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id 8DD592C47D
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 17:40:42 +0000 (UTC)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout3.routing.net (Postfix) with ESMTP id 7644A6005D;
        Tue, 27 Jul 2021 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1627407638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oAQQgPNZgfTb/V+cg35mAaEzCq2sct/B3InUQfVpE6Q=;
        b=aVIoSBXYg6LRHismpnHvMUH2J13IfxJ46BOZztr38jIfdqnpeuor6enpd20R6f6+iBn75b
        YTgMXQjfWUI9iH7TGO/PX4/mhA8nEeHJx/hr+nwMzJwKojN3akNYeg7hNx5qxL5SXZU9km
        ZGheeRS3BdSOeiPGdhwc7b4fjTmOcKw=
Received: from localhost.localdomain (fttx-pool-217.61.157.47.bambit.de [217.61.157.47])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 9638E10020A;
        Tue, 27 Jul 2021 17:40:37 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
Date:   Tue, 27 Jul 2021 19:40:25 +0200
Message-Id: <20210727174025.10552-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 0978cf90-281f-44e8-be75-2549ae4719a7
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: CK Hu <ck.hu@mediatek.com>

SOUT has many bits and need to be cleared before set new value.
Write only could do the clear, but for MOUT, it clears bits that
should not be cleared. So use a mask to reset only the needed bits.

this fixes HDMI issues on MT7623/BPI-R2 since 5.13

Cc: stable@vger.kernel.org
Fixes: 440147639ac7 ("soc: mediatek: mmsys: Use an array for setting the routing registers")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
---
code is taken from here (upstreamed without mask part)
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/2345186/5
basicly CK Hu's code so i set him as author
---
 drivers/soc/mediatek/mtk-mmsys.c |   7 +-
 drivers/soc/mediatek/mtk-mmsys.h | 133 +++++++++++++++++++++----------
 2 files changed, 98 insertions(+), 42 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-mmsys.c b/drivers/soc/mediatek/mtk-mmsys.c
index 080660ef11bf..0f949896fd06 100644
--- a/drivers/soc/mediatek/mtk-mmsys.c
+++ b/drivers/soc/mediatek/mtk-mmsys.c
@@ -68,7 +68,9 @@ void mtk_mmsys_ddp_connect(struct device *dev,
 
 	for (i = 0; i < mmsys->data->num_routes; i++)
 		if (cur == routes[i].from_comp && next == routes[i].to_comp) {
-			reg = readl_relaxed(mmsys->regs + routes[i].addr) | routes[i].val;
+			reg = readl_relaxed(mmsys->regs + routes[i].addr);
+			reg &= ~routes[i].mask;
+			reg |= routes[i].val;
 			writel_relaxed(reg, mmsys->regs + routes[i].addr);
 		}
 }
@@ -85,7 +87,8 @@ void mtk_mmsys_ddp_disconnect(struct device *dev,
 
 	for (i = 0; i < mmsys->data->num_routes; i++)
 		if (cur == routes[i].from_comp && next == routes[i].to_comp) {
-			reg = readl_relaxed(mmsys->regs + routes[i].addr) & ~routes[i].val;
+			reg = readl_relaxed(mmsys->regs + routes[i].addr);
+			reg &= ~routes[i].mask;
 			writel_relaxed(reg, mmsys->regs + routes[i].addr);
 		}
 }
diff --git a/drivers/soc/mediatek/mtk-mmsys.h b/drivers/soc/mediatek/mtk-mmsys.h
index a760a34e6eca..5f3e2bf0c40b 100644
--- a/drivers/soc/mediatek/mtk-mmsys.h
+++ b/drivers/soc/mediatek/mtk-mmsys.h
@@ -35,41 +35,54 @@
 #define RDMA0_SOUT_DSI1				0x1
 #define RDMA0_SOUT_DSI2				0x4
 #define RDMA0_SOUT_DSI3				0x5
+#define RDMA0_SOUT_MASK				0x7
 #define RDMA1_SOUT_DPI0				0x2
 #define RDMA1_SOUT_DPI1				0x3
 #define RDMA1_SOUT_DSI1				0x1
 #define RDMA1_SOUT_DSI2				0x4
 #define RDMA1_SOUT_DSI3				0x5
+#define RDMA1_SOUT_MASK				0x7
 #define RDMA2_SOUT_DPI0				0x2
 #define RDMA2_SOUT_DPI1				0x3
 #define RDMA2_SOUT_DSI1				0x1
 #define RDMA2_SOUT_DSI2				0x4
 #define RDMA2_SOUT_DSI3				0x5
+#define RDMA2_SOUT_MASK				0x7
 #define DPI0_SEL_IN_RDMA1			0x1
 #define DPI0_SEL_IN_RDMA2			0x3
+#define DPI0_SEL_IN_MASK			0x3
 #define DPI1_SEL_IN_RDMA1			(0x1 << 8)
 #define DPI1_SEL_IN_RDMA2			(0x3 << 8)
+#define DPI1_SEL_IN_MASK			(0x3 << 8)
 #define DSI0_SEL_IN_RDMA1			0x1
 #define DSI0_SEL_IN_RDMA2			0x4
+#define DSI0_SEL_IN_MASK			0x7
 #define DSI1_SEL_IN_RDMA1			0x1
 #define DSI1_SEL_IN_RDMA2			0x4
+#define DSI1_SEL_IN_MASK			0x7
 #define DSI2_SEL_IN_RDMA1			(0x1 << 16)
 #define DSI2_SEL_IN_RDMA2			(0x4 << 16)
+#define DSI2_SEL_IN_MASK			(0x7 << 16)
 #define DSI3_SEL_IN_RDMA1			(0x1 << 16)
 #define DSI3_SEL_IN_RDMA2			(0x4 << 16)
+#define DSI3_SEL_IN_MASK			(0x7 << 16)
 #define COLOR1_SEL_IN_OVL1			0x1
 
 #define OVL_MOUT_EN_RDMA			0x1
 #define BLS_TO_DSI_RDMA1_TO_DPI1		0x8
 #define BLS_TO_DPI_RDMA1_TO_DSI			0x2
+#define BLS_RDMA1_DSI_DPI_MASK			0xf
 #define DSI_SEL_IN_BLS				0x0
 #define DPI_SEL_IN_BLS				0x0
+#define DPI_SEL_IN_MASK				0x1
 #define DSI_SEL_IN_RDMA				0x1
+#define DSI_SEL_IN_MASK				0x1
 
 struct mtk_mmsys_routes {
 	u32 from_comp;
 	u32 to_comp;
 	u32 addr;
+	u32 mask;
 	u32 val;
 };
 
@@ -91,124 +104,164 @@ struct mtk_mmsys_driver_data {
 static const struct mtk_mmsys_routes mmsys_default_routing_table[] = {
 	{
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_OUT_SEL, BLS_TO_DSI_RDMA1_TO_DPI1
+		DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
+		BLS_TO_DSI_RDMA1_TO_DPI1
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_BLS
+		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
+		DSI_SEL_IN_BLS
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_OUT_SEL, BLS_TO_DPI_RDMA1_TO_DSI
+		DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
+		BLS_TO_DPI_RDMA1_TO_DSI
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_RDMA
+		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
+		DSI_SEL_IN_RDMA
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_BLS
+		DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_MASK,
+		DPI_SEL_IN_BLS
 	}, {
 		DDP_COMPONENT_GAMMA, DDP_COMPONENT_RDMA1,
-		DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1
+		DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1,
+		GAMMA_MOUT_EN_RDMA1
 	}, {
 		DDP_COMPONENT_OD0, DDP_COMPONENT_RDMA0,
-		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0
+		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0,
+		OD_MOUT_EN_RDMA0
 	}, {
 		DDP_COMPONENT_OD1, DDP_COMPONENT_RDMA1,
-		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1
+		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1,
+		OD1_MOUT_EN_RDMA1
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
-		DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0
+		DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0,
+		OVL0_MOUT_EN_COLOR0
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
-		DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0
+		DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0,
+		COLOR0_SEL_IN_OVL0
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_RDMA0,
-		DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA
+		DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA,
+		OVL_MOUT_EN_RDMA
 	}, {
 		DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
-		DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1
+		DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1,
+		OVL1_MOUT_EN_COLOR1
 	}, {
 		DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
-		DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1
+		DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1,
+		COLOR1_SEL_IN_OVL1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
+		DPI0_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
+		DPI1_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
+		DSI0_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
+		DSI1_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
+		DSI2_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
+		DSI3_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
+		DPI0_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
+		DPI1_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
+		DSI0_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
+		DSI1_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
+		DSI2_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
+		DSI3_SEL_IN_RDMA2
 	}
 };
 
-- 
2.25.1

