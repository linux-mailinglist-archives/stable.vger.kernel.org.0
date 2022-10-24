Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888860AA1E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiJXNbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiJXN1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EBCAA3E3;
        Mon, 24 Oct 2022 05:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C6E0612DB;
        Mon, 24 Oct 2022 12:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9A3C433C1;
        Mon, 24 Oct 2022 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613643;
        bh=Ta5mvod/xTVjJfuaXj2rb0yeljAOvEtb7iU+NeRk/2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2FAVM6egEaskD0FHTWMpgZ+BFiQRLtkYionctl4I6mur9iS37ptYPydfAUSAh231
         a74XG+2DODMv37eeS66cgf1+vFJ6GEFgAkfOQS/JOf9d+wu4aY79m2zpd2xrejs5Br
         u90ZlaS7So9jozWTXvJIGqdO5Gwl17lDuH3kYyT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/255] drm/vc4: vec: Fix timings for VEC modes
Date:   Mon, 24 Oct 2022 13:32:04 +0200
Message-Id: <20221024113010.173682818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>

[ Upstream commit 30d7565be96b3946c18a1ce3fd538f7946839092 ]

This commit fixes vertical timings of the VEC (composite output) modes
to accurately represent the 525-line ("NTSC") and 625-line ("PAL") ITU-R
standards.

Previous timings were actually defined as 502 and 601 lines, resulting
in non-standard 62.69 Hz and 52 Hz signals being generated,
respectively.

Signed-off-by: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220728-rpi-analog-tv-properties-v2-28-459522d653a7@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_vec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_vec.c b/drivers/gpu/drm/vc4/vc4_vec.c
index 7402bc768664..0c764fd8399a 100644
--- a/drivers/gpu/drm/vc4/vc4_vec.c
+++ b/drivers/gpu/drm/vc4/vc4_vec.c
@@ -256,7 +256,7 @@ static void vc4_vec_ntsc_j_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode ntsc_mode = {
 	DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 14, 720 + 14 + 64, 720 + 14 + 64 + 60, 0,
-		 480, 480 + 3, 480 + 3 + 3, 480 + 3 + 3 + 16, 0,
+		 480, 480 + 7, 480 + 7 + 6, 525, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
@@ -278,7 +278,7 @@ static void vc4_vec_pal_m_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode pal_mode = {
 	DRM_MODE("720x576", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 20, 720 + 20 + 64, 720 + 20 + 64 + 60, 0,
-		 576, 576 + 2, 576 + 2 + 3, 576 + 2 + 3 + 20, 0,
+		 576, 576 + 4, 576 + 4 + 6, 625, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
-- 
2.35.1



