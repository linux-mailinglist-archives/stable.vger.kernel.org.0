Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3405412E0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354044AbiFGTyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358597AbiFGTwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D62F3AD;
        Tue,  7 Jun 2022 11:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4007460DB7;
        Tue,  7 Jun 2022 18:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E678C385A2;
        Tue,  7 Jun 2022 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626079;
        bh=Fip7iQDSr+SZ/arPL1+2akkIFJzGJcippf1XA2GNJk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMr97/m4GKc90SLQaQ7TeGSEXlDrRmHyDuocfFsU5hgM98i7crrzHdAT6ygCBR49q
         qBmLbgggdBa/LMy9FOP6BM58xo0VH6ujLjvdc3mYsir8WMNkHCgXFFTWKnGAwK4MD9
         336+qFjk4+KOqFY/MUGrBku01nF7JhWbIiNjbzjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 248/772] drm/vc4: hvs: Reset muxes at probe time
Date:   Tue,  7 Jun 2022 18:57:20 +0200
Message-Id: <20220607164956.335636084@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 8514e6b1f40319e31ac4aa3fbf606796786366c9 ]

By default, the HVS driver will force the HVS output 3 to be muxed to
the HVS channel 2. However, the Transposer can only be assigned to the
HVS channel 2, so whenever we try to use the writeback connector, we'll
mux its associated output (Output 2) to the channel 2.

This leads to both the output 2 and 3 feeding from the same channel,
which is explicitly discouraged in the documentation.

In order to avoid this, let's reset all the output muxes to their reset
value.

Fixes: 87ebcd42fb7b ("drm/vc4: crtc: Assign output to channel automatically")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220328153659.2382206-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index c8cae10500b9..9d88bfb50c9b 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -605,6 +605,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 	struct vc4_hvs *hvs = NULL;
 	int ret;
 	u32 dispctrl;
+	u32 reg;
 
 	hvs = devm_kzalloc(&pdev->dev, sizeof(*hvs), GFP_KERNEL);
 	if (!hvs)
@@ -676,6 +677,26 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 
 	vc4->hvs = hvs;
 
+	reg = HVS_READ(SCALER_DISPECTRL);
+	reg &= ~SCALER_DISPECTRL_DSP2_MUX_MASK;
+	HVS_WRITE(SCALER_DISPECTRL,
+		  reg | VC4_SET_FIELD(0, SCALER_DISPECTRL_DSP2_MUX));
+
+	reg = HVS_READ(SCALER_DISPCTRL);
+	reg &= ~SCALER_DISPCTRL_DSP3_MUX_MASK;
+	HVS_WRITE(SCALER_DISPCTRL,
+		  reg | VC4_SET_FIELD(3, SCALER_DISPCTRL_DSP3_MUX));
+
+	reg = HVS_READ(SCALER_DISPEOLN);
+	reg &= ~SCALER_DISPEOLN_DSP4_MUX_MASK;
+	HVS_WRITE(SCALER_DISPEOLN,
+		  reg | VC4_SET_FIELD(3, SCALER_DISPEOLN_DSP4_MUX));
+
+	reg = HVS_READ(SCALER_DISPDITHER);
+	reg &= ~SCALER_DISPDITHER_DSP5_MUX_MASK;
+	HVS_WRITE(SCALER_DISPDITHER,
+		  reg | VC4_SET_FIELD(3, SCALER_DISPDITHER_DSP5_MUX));
+
 	dispctrl = HVS_READ(SCALER_DISPCTRL);
 
 	dispctrl |= SCALER_DISPCTRL_ENABLE;
@@ -683,10 +704,6 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		    SCALER_DISPCTRL_DISPEIRQ(1) |
 		    SCALER_DISPCTRL_DISPEIRQ(2);
 
-	/* Set DSP3 (PV1) to use HVS channel 2, which would otherwise
-	 * be unused.
-	 */
-	dispctrl &= ~SCALER_DISPCTRL_DSP3_MUX_MASK;
 	dispctrl &= ~(SCALER_DISPCTRL_DMAEIRQ |
 		      SCALER_DISPCTRL_SLVWREIRQ |
 		      SCALER_DISPCTRL_SLVRDEIRQ |
@@ -700,7 +717,6 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		      SCALER_DISPCTRL_DSPEISLUR(1) |
 		      SCALER_DISPCTRL_DSPEISLUR(2) |
 		      SCALER_DISPCTRL_SCLEIRQ);
-	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_DSP3_MUX);
 
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
-- 
2.35.1



