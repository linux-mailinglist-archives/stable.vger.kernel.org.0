Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078E7599FDA
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351287AbiHSQG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351656AbiHSQGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:06:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA39310D59D;
        Fri, 19 Aug 2022 08:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F69B82819;
        Fri, 19 Aug 2022 15:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E273C433D6;
        Fri, 19 Aug 2022 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924541;
        bh=UkBWJBsPX5cel+6FFhNtQye+XSIHvRfMM+W2Ur21r/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alDaY5iezDOBdYyu5F46FfVKnRafUofoq5U7uoOBH5gSVwyR9QIinXju3mflWCCRE
         80S4yXVi+mOsfbcaC1kHMqF1jEewFO9bERUqLyhswyZvtMYkAIkpHItbvju6mHQ+HU
         tzVy51sMPSkGWs32AnhUqNK6/rnM9+X8HPWi1xaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/545] drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes
Date:   Fri, 19 Aug 2022 17:39:34 +0200
Message-Id: <20220819153838.504850553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit fb10dc451c0f15e3c19798a2f41d357f3f7576f5 ]

For interlaced modes the timings were not being correctly
programmed into the HDMI block, so correct them.

Fixes: 8323989140f3 ("drm/vc4: hdmi: Support the BCM2711 HDMI controllers")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-33-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -565,13 +565,13 @@ static void vc5_hdmi_set_timings(struct
 		     VC4_SET_FIELD(mode->crtc_vsync_start - mode->crtc_vdisplay,
 				   VC5_HDMI_VERTA_VFP) |
 		     VC4_SET_FIELD(mode->crtc_vdisplay, VC5_HDMI_VERTA_VAL));
-	u32 vertb = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
-		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
-				   interlaced,
+	u32 vertb = (VC4_SET_FIELD(mode->htotal >> (2 - pixel_rep),
+				   VC5_HDMI_VERTB_VSPO) |
+		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
 				   VC4_HDMI_VERTB_VBP));
 	u32 vertb_even = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
 			  VC4_SET_FIELD(mode->crtc_vtotal -
-					mode->crtc_vsync_end,
+					mode->crtc_vsync_end - interlaced,
 					VC4_HDMI_VERTB_VBP));
 
 	HDMI_WRITE(HDMI_VEC_INTERFACE_XBAR, 0x354021);


