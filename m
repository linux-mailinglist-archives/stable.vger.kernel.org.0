Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FD351A7B3
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355291AbiEDRGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356379AbiEDRFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C180F506FD;
        Wed,  4 May 2022 09:54:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163AD616F8;
        Wed,  4 May 2022 16:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6056CC385A5;
        Wed,  4 May 2022 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683244;
        bh=IiDFosyBKEsDaEHgStrTUiiJs7CTh4KNL6+mOht+meQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSDJ5iyRXm8J/cq26pEAIm42B9zIbR+f16s03aVy8GAqAQbkS+RCPT7mS47gbtp38
         +PB1SxR0wfQmAihPJ2fh+fTOUSePmAxz1eAeErz8qmfvpDlIqQyz4bm5uFvbp8ZpV2
         WzFJyCDN07vVJU3TyWqBad7/ReTPJCwhdWvjrXRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/177] drm/sun4i: Remove obsolete references to PHYS_OFFSET
Date:   Wed,  4 May 2022 18:45:02 +0200
Message-Id: <20220504153102.988331294@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit dc3ae06c5f2170d879ff58696f629d8c3868aec3 ]

commit b4bdc4fbf8d0 ("soc: sunxi: Deal with the MBUS DMA offsets in a
central place") added a platform device notifier that sets the DMA
offset for all of the display engine frontend and backend devices.

The code applying the offset to DMA buffer physical addresses was then
removed from the backend driver in commit 756668ba682e ("drm/sun4i:
backend: Remove the MBUS quirks"), but the code subtracting PHYS_OFFSET
was left in the frontend driver.

As a result, the offset was applied twice in the frontend driver. This
likely went unnoticed because it only affects specific configurations
(scaling or certain pixel formats) where the frontend is used, on boards
with both one of these older SoCs and more than 1 GB of DRAM.

In addition, the references to PHYS_OFFSET prevent compiling the driver
on architectures where PHYS_OFFSET is not defined.

Fixes: b4bdc4fbf8d0 ("soc: sunxi: Deal with the MBUS DMA offsets in a central place")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220424162633.12369-4-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_frontend.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.c b/drivers/gpu/drm/sun4i/sun4i_frontend.c
index edb60ae0a9b7..faecc2935039 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.c
@@ -222,13 +222,11 @@ void sun4i_frontend_update_buffer(struct sun4i_frontend *frontend,
 
 	/* Set the physical address of the buffer in memory */
 	paddr = drm_fb_cma_get_gem_addr(fb, state, 0);
-	paddr -= PHYS_OFFSET;
 	DRM_DEBUG_DRIVER("Setting buffer #0 address to %pad\n", &paddr);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR0_REG, paddr);
 
 	if (fb->format->num_planes > 1) {
 		paddr = drm_fb_cma_get_gem_addr(fb, state, swap ? 2 : 1);
-		paddr -= PHYS_OFFSET;
 		DRM_DEBUG_DRIVER("Setting buffer #1 address to %pad\n", &paddr);
 		regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR1_REG,
 			     paddr);
@@ -236,7 +234,6 @@ void sun4i_frontend_update_buffer(struct sun4i_frontend *frontend,
 
 	if (fb->format->num_planes > 2) {
 		paddr = drm_fb_cma_get_gem_addr(fb, state, swap ? 1 : 2);
-		paddr -= PHYS_OFFSET;
 		DRM_DEBUG_DRIVER("Setting buffer #2 address to %pad\n", &paddr);
 		regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR2_REG,
 			     paddr);
-- 
2.35.1



