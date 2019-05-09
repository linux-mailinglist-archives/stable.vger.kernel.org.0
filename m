Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C31C191A8
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfEIS6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfEISw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E142177E;
        Thu,  9 May 2019 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427976;
        bh=KcBNhjf5N9TzoKLJ8rSU60ZB8nQ2vfmXWLvk1pOJ5Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wr3OV0v7I6qIptX4wBgxN62XjSaxvolk9t5L1rGPejTgSenU2GnnWLd6wXNo9RVdj
         N9rdWMkaGwnRg5PEzRi4MhrE6maIUGsRfq1XvO1XbojeSBrz58ZauYBjxjtNBzQkmc
         EXsxGZsTotSqm2W2voIGwpPA4iezf7XpZE8KqvFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Jyri Sarha <jsarha@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 29/95] drm/omap: hdmi4_cec: Fix CEC clock handling for PM
Date:   Thu,  9 May 2019 20:41:46 +0200
Message-Id: <20190509181311.346632359@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 36a1da15b5df493241b0011d2185fdd724ac1ed1 ]

If CONFIG_OMAP4_DSS_HDMI_CEC is enabled in .config, deeper SoC idle
states are blocked because the CEC clock gets always enabled on init.

Let's fix the issue by moving the CEC clock handling to happen later in
hdmi_cec_adap_enable() as suggested by Hans Verkuil <hverkuil@xs4all.nl>.
This way the CEC clock gets only enabled when needed. This can be tested
by doing cec-ctl --playback to enable the CEC, and doing cec-ctl --clear
to disable it.

Let's also fix the typo for "divider" in the comments while at it.

Fixes: 8d7f934df8d8 ("omapdrm: hdmi4_cec: add OMAP4 HDMI CEC support")
Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190326151438.32414-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 26 ++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
index 340383150fb98..ebf9c96d43eee 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
@@ -175,6 +175,7 @@ static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		REG_FLD_MOD(core->base, HDMI_CORE_SYS_INTR_UNMASK4, 0, 3, 3);
 		hdmi_wp_clear_irqenable(core->wp, HDMI_IRQ_CORE);
 		hdmi_wp_set_irqstatus(core->wp, HDMI_IRQ_CORE);
+		REG_FLD_MOD(core->wp->base, HDMI_WP_CLK, 0, 5, 0);
 		hdmi4_core_disable(core);
 		return 0;
 	}
@@ -182,16 +183,24 @@ static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	if (err)
 		return err;
 
+	/*
+	 * Initialize CEC clock divider: CEC needs 2MHz clock hence
+	 * set the divider to 24 to get 48/24=2MHz clock
+	 */
+	REG_FLD_MOD(core->wp->base, HDMI_WP_CLK, 0x18, 5, 0);
+
 	/* Clear TX FIFO */
 	if (!hdmi_cec_clear_tx_fifo(adap)) {
 		pr_err("cec-%s: could not clear TX FIFO\n", adap->name);
-		return -EIO;
+		err = -EIO;
+		goto err_disable_clk;
 	}
 
 	/* Clear RX FIFO */
 	if (!hdmi_cec_clear_rx_fifo(adap)) {
 		pr_err("cec-%s: could not clear RX FIFO\n", adap->name);
-		return -EIO;
+		err = -EIO;
+		goto err_disable_clk;
 	}
 
 	/* Clear CEC interrupts */
@@ -236,6 +245,12 @@ static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		hdmi_write_reg(core->base, HDMI_CEC_INT_STATUS_1, temp);
 	}
 	return 0;
+
+err_disable_clk:
+	REG_FLD_MOD(core->wp->base, HDMI_WP_CLK, 0, 5, 0);
+	hdmi4_core_disable(core);
+
+	return err;
 }
 
 static int hdmi_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
@@ -333,11 +348,8 @@ int hdmi4_cec_init(struct platform_device *pdev, struct hdmi_core_data *core,
 		return ret;
 	core->wp = wp;
 
-	/*
-	 * Initialize CEC clock divider: CEC needs 2MHz clock hence
-	 * set the devider to 24 to get 48/24=2MHz clock
-	 */
-	REG_FLD_MOD(core->wp->base, HDMI_WP_CLK, 0x18, 5, 0);
+	/* Disable clock initially, hdmi_cec_adap_enable() manages it */
+	REG_FLD_MOD(core->wp->base, HDMI_WP_CLK, 0, 5, 0);
 
 	ret = cec_register_adapter(core->adap, &pdev->dev);
 	if (ret < 0) {
-- 
2.20.1



