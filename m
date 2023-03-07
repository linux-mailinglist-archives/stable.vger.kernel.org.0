Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9E06AE9DE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjCGR2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCGR2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12558315D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9432B819AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0385CC433EF;
        Tue,  7 Mar 2023 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209799;
        bh=guyVeRhx9rqRPMoWZeA5l+dclD/Xz5JoDYKUwyP2oGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKh32H99dPoHPqq1xsJ92exBzR9llsQtanvoSheHFz1LoSXQ2d5dYFWXLuRvVD9Ud
         qpaB1pMg4wK8jrXM6HqVQTyCDP+mtGmQ/myJArNSmPeyPQTbxyBGvTBN/V7A/1HUxa
         dPCJN7rDWxdEF14MHlMGAhoDYVm8Y8aHdIqFgZ5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0336/1001] drm/vc4: dpi: Fix format mapping for RGB565
Date:   Tue,  7 Mar 2023 17:51:48 +0100
Message-Id: <20230307170036.059572191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 0870d86eac8a9abd89a0be1b719d5dc5bac936f0 ]

The mapping is incorrect for RGB565_1X16 as it should be
DPI_FORMAT_18BIT_666_RGB_1 instead of DPI_FORMAT_18BIT_666_RGB_3.

Fixes: 08302c35b59d ("drm/vc4: Add DPI driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20221013-rpi-dpi-improvements-v3-7-eb76e26a772d@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dpi.c b/drivers/gpu/drm/vc4/vc4_dpi.c
index 1f8f44b7b5a5f..61ef7d232a12c 100644
--- a/drivers/gpu/drm/vc4/vc4_dpi.c
+++ b/drivers/gpu/drm/vc4/vc4_dpi.c
@@ -179,7 +179,7 @@ static void vc4_dpi_encoder_enable(struct drm_encoder *encoder)
 						       DPI_FORMAT);
 				break;
 			case MEDIA_BUS_FMT_RGB565_1X16:
-				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_3,
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_1,
 						       DPI_FORMAT);
 				break;
 			default:
-- 
2.39.2



