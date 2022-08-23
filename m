Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22DD59D666
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiHWJH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbiHWJGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:06:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C466185FE1;
        Tue, 23 Aug 2022 01:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B977FB81C58;
        Tue, 23 Aug 2022 08:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C82CC433D6;
        Tue, 23 Aug 2022 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243341;
        bh=BkWQsObRD0qHdiFNBqOcDLLUMiSRZ6gAZkju3pfvCZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIuSCHcy9xkaEOYAgYkhuHnDug6Wx8v/TTtki0OciE2vDkkRcVgwjUgoaXl7b+ED+
         l8DStnsE1d1YbsretWzuD2AAi7XRDaYPY9itLP5qaNdSOpE/5nEVtLqXbqBOrCDSXn
         FXcJTMj37Xq3oK8dMRn0dNYMG8I21KmY5lmZwDqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 247/365] drm/sun4i: dsi: Prevent underflow when computing packet sizes
Date:   Tue, 23 Aug 2022 10:02:28 +0200
Message-Id: <20220823080128.539277076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 82a1356a933d8443139f8886f11b63c974a09a67 ]

Currently, the packet overhead is subtracted using unsigned arithmetic.
With a short sync pulse, this could underflow and wrap around to near
the maximal u16 value. Fix this by using signed subtraction. The call to
max() will correctly handle any negative numbers that are produced.

Apply the same fix to the other timings, even though those subtractions
are less likely to underflow.

Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220812031623.34057-1-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index b4dfa166eccd..34234a144e87 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -531,7 +531,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 				    struct drm_display_mode *mode)
 {
 	struct mipi_dsi_device *device = dsi->device;
-	unsigned int Bpp = mipi_dsi_pixel_format_to_bpp(device->format) / 8;
+	int Bpp = mipi_dsi_pixel_format_to_bpp(device->format) / 8;
 	u16 hbp = 0, hfp = 0, hsa = 0, hblk = 0, vblk = 0;
 	u32 basic_ctl = 0;
 	size_t bytes;
@@ -555,7 +555,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * (4 bytes). Its minimal size is therefore 10 bytes
 		 */
 #define HSA_PACKET_OVERHEAD	10
-		hsa = max((unsigned int)HSA_PACKET_OVERHEAD,
+		hsa = max(HSA_PACKET_OVERHEAD,
 			  (mode->hsync_end - mode->hsync_start) * Bpp - HSA_PACKET_OVERHEAD);
 
 		/*
@@ -564,7 +564,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * therefore 6 bytes
 		 */
 #define HBP_PACKET_OVERHEAD	6
-		hbp = max((unsigned int)HBP_PACKET_OVERHEAD,
+		hbp = max(HBP_PACKET_OVERHEAD,
 			  (mode->htotal - mode->hsync_end) * Bpp - HBP_PACKET_OVERHEAD);
 
 		/*
@@ -574,7 +574,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * 16 bytes
 		 */
 #define HFP_PACKET_OVERHEAD	16
-		hfp = max((unsigned int)HFP_PACKET_OVERHEAD,
+		hfp = max(HFP_PACKET_OVERHEAD,
 			  (mode->hsync_start - mode->hdisplay) * Bpp - HFP_PACKET_OVERHEAD);
 
 		/*
@@ -583,7 +583,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * bytes). Its minimal size is therefore 10 bytes.
 		 */
 #define HBLK_PACKET_OVERHEAD	10
-		hblk = max((unsigned int)HBLK_PACKET_OVERHEAD,
+		hblk = max(HBLK_PACKET_OVERHEAD,
 			   (mode->htotal - (mode->hsync_end - mode->hsync_start)) * Bpp -
 			   HBLK_PACKET_OVERHEAD);
 
-- 
2.35.1



