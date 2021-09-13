Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC682409218
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244920AbhIMOHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344302AbhIMOEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1F261A7A;
        Mon, 13 Sep 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540355;
        bh=IadMZ0pUGcyaAMKR50sje3LsncERJJKFmuooJ5ChcpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym6wIGfDL8Jlv53F84M5/tOA12q5/2Rqzhte46660uFzVKnSkEJ1izeGw1rlXDqns
         1Luuq6T6R8S/8FiSQyG8YQh/isCvO2yDXJT2Za2bxW56z5N1ebE6xyzRrZQqQlOPb7
         zNRE+CVhJpO2erh1WwHmnZW2o1di/BcggzLtQYfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Daniel Abrecht <public@danielabrecht.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 128/300] drm: mxsfb: Enable recovery on underflow
Date:   Mon, 13 Sep 2021 15:13:09 +0200
Message-Id: <20210913131113.719397585@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0c9856e4edcdcac22d65618e8ceff9eb41447880 ]

There is some sort of corner case behavior of the controller,
which could rarely be triggered at least on i.MX6SX connected
to 800x480 DPI panel and i.MX8MM connected to DPI->DSI->LVDS
bridged 1920x1080 panel (and likely on other setups too), where
the image on the panel shifts to the right and wraps around.
This happens either when the controller is enabled on boot or
even later during run time. The condition does not correct
itself automatically, i.e. the display image remains shifted.

It seems this problem is known and is due to sporadic underflows
of the LCDIF FIFO. While the LCDIF IP does have underflow/overflow
IRQs, neither of the IRQs trigger and neither IRQ status bit is
asserted when this condition occurs.

All known revisions of the LCDIF IP have CTRL1 RECOVER_ON_UNDERFLOW
bit, which is described in the reference manual since i.MX23 as
"
  Set this bit to enable the LCDIF block to recover in the next
  field/frame if there was an underflow in the current field/frame.
"
Enable this bit to mitigate the sporadic underflows.

Fixes: 45d59d704080 ("drm: Add new driver for MXSFB controller")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Daniel Abrecht <public@danielabrecht.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Stefan Agner <stefan@agner.ch>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210620224701.189289-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c  | 29 +++++++++++++++++++++++++++++
 drivers/gpu/drm/mxsfb/mxsfb_regs.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 300e7bab0f43..01e0f525360f 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -115,6 +115,35 @@ static void mxsfb_enable_controller(struct mxsfb_drm_private *mxsfb)
 	reg |= VDCTRL4_SYNC_SIGNALS_ON;
 	writel(reg, mxsfb->base + LCDC_VDCTRL4);
 
+	/*
+	 * Enable recovery on underflow.
+	 *
+	 * There is some sort of corner case behavior of the controller,
+	 * which could rarely be triggered at least on i.MX6SX connected
+	 * to 800x480 DPI panel and i.MX8MM connected to DPI->DSI->LVDS
+	 * bridged 1920x1080 panel (and likely on other setups too), where
+	 * the image on the panel shifts to the right and wraps around.
+	 * This happens either when the controller is enabled on boot or
+	 * even later during run time. The condition does not correct
+	 * itself automatically, i.e. the display image remains shifted.
+	 *
+	 * It seems this problem is known and is due to sporadic underflows
+	 * of the LCDIF FIFO. While the LCDIF IP does have underflow/overflow
+	 * IRQs, neither of the IRQs trigger and neither IRQ status bit is
+	 * asserted when this condition occurs.
+	 *
+	 * All known revisions of the LCDIF IP have CTRL1 RECOVER_ON_UNDERFLOW
+	 * bit, which is described in the reference manual since i.MX23 as
+	 * "
+	 *   Set this bit to enable the LCDIF block to recover in the next
+	 *   field/frame if there was an underflow in the current field/frame.
+	 * "
+	 * Enable this bit to mitigate the sporadic underflows.
+	 */
+	reg = readl(mxsfb->base + LCDC_CTRL1);
+	reg |= CTRL1_RECOVER_ON_UNDERFLOW;
+	writel(reg, mxsfb->base + LCDC_CTRL1);
+
 	writel(CTRL_RUN, mxsfb->base + LCDC_CTRL + REG_SET);
 }
 
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_regs.h b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
index 55d28a27f912..df90e960f495 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_regs.h
+++ b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
@@ -54,6 +54,7 @@
 #define CTRL_DF24			BIT(1)
 #define CTRL_RUN			BIT(0)
 
+#define CTRL1_RECOVER_ON_UNDERFLOW	BIT(24)
 #define CTRL1_FIFO_CLEAR		BIT(21)
 #define CTRL1_SET_BYTE_PACKAGING(x)	(((x) & 0xf) << 16)
 #define CTRL1_GET_BYTE_PACKAGING(x)	(((x) >> 16) & 0xf)
-- 
2.30.2



