Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F866AEF13
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjCGSUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjCGSTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF39E076
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B82E614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3200DC4339E;
        Tue,  7 Mar 2023 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212835;
        bh=YztqTdRYKo6cqEj+HtcKx/RTQmFLC3HRBXy6WYGoYwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYid810d26TwjFM9+AjSffFUlMpm5FWupRmgkMUIzxmh9liovtDb3Ravp0H29rCLR
         tv5I4Njlr3zXLdDnY2blxDJIF684F3gZf77QPQm7AudjyCBQfN+rkh715r+G3DS8rf
         lClvfvvedVOb0CKvUrmJGWi0ZFGrs28aQ2F78Q3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 283/885] drm/vc4: hvs: Correct interrupt masking bit assignment for HVS5
Date:   Tue,  7 Mar 2023 17:53:37 +0100
Message-Id: <20230307170014.312516957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 87551ec650bb87d35f1b29bba6a2430896e08da0 ]

HVS5 has moved the interrupt enable bits around within the
DISPCTRL register, therefore the configuration has to be updated
to account for this.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-4-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c  | 52 +++++++++++++++++++++++-----------
 drivers/gpu/drm/vc4/vc4_regs.h | 10 +++++--
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 413ebb6f56a23..47990ecbfc4df 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -658,7 +658,8 @@ void vc4_hvs_mask_underrun(struct vc4_hvs *hvs, int channel)
 		return;
 
 	dispctrl = HVS_READ(SCALER_DISPCTRL);
-	dispctrl &= ~SCALER_DISPCTRL_DSPEISLUR(channel);
+	dispctrl &= ~(hvs->vc4->is_vc5 ? SCALER5_DISPCTRL_DSPEISLUR(channel) :
+					 SCALER_DISPCTRL_DSPEISLUR(channel));
 
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
@@ -675,7 +676,8 @@ void vc4_hvs_unmask_underrun(struct vc4_hvs *hvs, int channel)
 		return;
 
 	dispctrl = HVS_READ(SCALER_DISPCTRL);
-	dispctrl |= SCALER_DISPCTRL_DSPEISLUR(channel);
+	dispctrl |= (hvs->vc4->is_vc5 ? SCALER5_DISPCTRL_DSPEISLUR(channel) :
+					SCALER_DISPCTRL_DSPEISLUR(channel));
 
 	HVS_WRITE(SCALER_DISPSTAT,
 		  SCALER_DISPSTAT_EUFLOW(channel));
@@ -701,6 +703,7 @@ static irqreturn_t vc4_hvs_irq_handler(int irq, void *data)
 	int channel;
 	u32 control;
 	u32 status;
+	u32 dspeislur;
 
 	/*
 	 * NOTE: We don't need to protect the register access using
@@ -717,9 +720,11 @@ static irqreturn_t vc4_hvs_irq_handler(int irq, void *data)
 	control = HVS_READ(SCALER_DISPCTRL);
 
 	for (channel = 0; channel < SCALER_CHANNELS_COUNT; channel++) {
+		dspeislur = vc4->is_vc5 ? SCALER5_DISPCTRL_DSPEISLUR(channel) :
+					  SCALER_DISPCTRL_DSPEISLUR(channel);
 		/* Interrupt masking is not always honored, so check it here. */
 		if (status & SCALER_DISPSTAT_EUFLOW(channel) &&
-		    control & SCALER_DISPCTRL_DSPEISLUR(channel)) {
+		    control & dspeislur) {
 			vc4_hvs_mask_underrun(hvs, channel);
 			vc4_hvs_report_underrun(dev);
 
@@ -872,19 +877,34 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		    SCALER_DISPCTRL_DISPEIRQ(1) |
 		    SCALER_DISPCTRL_DISPEIRQ(2);
 
-	dispctrl &= ~(SCALER_DISPCTRL_DMAEIRQ |
-		      SCALER_DISPCTRL_SLVWREIRQ |
-		      SCALER_DISPCTRL_SLVRDEIRQ |
-		      SCALER_DISPCTRL_DSPEIEOF(0) |
-		      SCALER_DISPCTRL_DSPEIEOF(1) |
-		      SCALER_DISPCTRL_DSPEIEOF(2) |
-		      SCALER_DISPCTRL_DSPEIEOLN(0) |
-		      SCALER_DISPCTRL_DSPEIEOLN(1) |
-		      SCALER_DISPCTRL_DSPEIEOLN(2) |
-		      SCALER_DISPCTRL_DSPEISLUR(0) |
-		      SCALER_DISPCTRL_DSPEISLUR(1) |
-		      SCALER_DISPCTRL_DSPEISLUR(2) |
-		      SCALER_DISPCTRL_SCLEIRQ);
+	if (!vc4->is_vc5)
+		dispctrl &= ~(SCALER_DISPCTRL_DMAEIRQ |
+			      SCALER_DISPCTRL_SLVWREIRQ |
+			      SCALER_DISPCTRL_SLVRDEIRQ |
+			      SCALER_DISPCTRL_DSPEIEOF(0) |
+			      SCALER_DISPCTRL_DSPEIEOF(1) |
+			      SCALER_DISPCTRL_DSPEIEOF(2) |
+			      SCALER_DISPCTRL_DSPEIEOLN(0) |
+			      SCALER_DISPCTRL_DSPEIEOLN(1) |
+			      SCALER_DISPCTRL_DSPEIEOLN(2) |
+			      SCALER_DISPCTRL_DSPEISLUR(0) |
+			      SCALER_DISPCTRL_DSPEISLUR(1) |
+			      SCALER_DISPCTRL_DSPEISLUR(2) |
+			      SCALER_DISPCTRL_SCLEIRQ);
+	else
+		dispctrl &= ~(SCALER_DISPCTRL_DMAEIRQ |
+			      SCALER5_DISPCTRL_SLVEIRQ |
+			      SCALER5_DISPCTRL_DSPEIEOF(0) |
+			      SCALER5_DISPCTRL_DSPEIEOF(1) |
+			      SCALER5_DISPCTRL_DSPEIEOF(2) |
+			      SCALER5_DISPCTRL_DSPEIEOLN(0) |
+			      SCALER5_DISPCTRL_DSPEIEOLN(1) |
+			      SCALER5_DISPCTRL_DSPEIEOLN(2) |
+			      SCALER5_DISPCTRL_DSPEISLUR(0) |
+			      SCALER5_DISPCTRL_DSPEISLUR(1) |
+			      SCALER5_DISPCTRL_DSPEISLUR(2) |
+			      SCALER_DISPCTRL_SCLEIRQ);
+
 
 	/* Set AXI panic mode.
 	 * VC4 panics when < 2 lines in FIFO.
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index 95deacdc31e77..1256f0877ff66 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -234,15 +234,21 @@
  * always enabled.
  */
 # define SCALER_DISPCTRL_DSPEISLUR(x)		BIT(13 + (x))
+# define SCALER5_DISPCTRL_DSPEISLUR(x)		BIT(9 + ((x) * 4))
 /* Enables Display 0 end-of-line-N contribution to
  * SCALER_DISPSTAT_IRQDISP0
  */
 # define SCALER_DISPCTRL_DSPEIEOLN(x)		BIT(8 + ((x) * 2))
+# define SCALER5_DISPCTRL_DSPEIEOLN(x)		BIT(8 + ((x) * 4))
 /* Enables Display 0 EOF contribution to SCALER_DISPSTAT_IRQDISP0 */
 # define SCALER_DISPCTRL_DSPEIEOF(x)		BIT(7 + ((x) * 2))
+# define SCALER5_DISPCTRL_DSPEIEOF(x)		BIT(7 + ((x) * 4))
 
-# define SCALER_DISPCTRL_SLVRDEIRQ		BIT(6)
-# define SCALER_DISPCTRL_SLVWREIRQ		BIT(5)
+# define SCALER5_DISPCTRL_DSPEIVST(x)		BIT(6 + ((x) * 4))
+
+# define SCALER_DISPCTRL_SLVRDEIRQ		BIT(6)	/* HVS4 only */
+# define SCALER_DISPCTRL_SLVWREIRQ		BIT(5)	/* HVS4 only */
+# define SCALER5_DISPCTRL_SLVEIRQ		BIT(5)
 # define SCALER_DISPCTRL_DMAEIRQ		BIT(4)
 /* Enables interrupt generation on the enabled EOF/EOLN/EISLUR
  * bits and short frames..
-- 
2.39.2



