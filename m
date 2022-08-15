Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AC5947A1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345158AbiHOXnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354330AbiHOXlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6C2C670;
        Mon, 15 Aug 2022 13:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B837F6077B;
        Mon, 15 Aug 2022 20:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6078C433C1;
        Mon, 15 Aug 2022 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594366;
        bh=OzJrhHoWezHSiKoUoOVlcSSDC8fVKfDYPyy4cgaLBnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BupXyloczGEliip6uj4sH/RhTDPYbQHgzTWqiBKPRxCEOkBV2Zvvl6xRpDmOxkUdn
         riuDL4NVbsr0OMFJOfOnD3eWFfTY988GFRuznx3WGcZRtqd8lQA7e5uHddJdLyQpDY
         kXhCcUJT5wQMPuqD4+OxcBTlGiZy4GELFdz+KeJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0423/1157] drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes
Date:   Mon, 15 Aug 2022 19:56:19 +0200
Message-Id: <20220815180456.592927553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 drivers/gpu/drm/vc4/vc4_hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 3829e13c8627..ad7fcfa5a068 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1040,13 +1040,13 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
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
 	unsigned long flags;
 	unsigned char gcp;
-- 
2.35.1



