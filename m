Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1EE6AEED3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbjCGSQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjCGSQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:16:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A34A2F33
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CBEF6152F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C527C433D2;
        Tue,  7 Mar 2023 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212686;
        bh=qAkJwvDNj/QkE9DY1RcAzs7HpzFux2BMkiKzaOByEuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/5v/Kl9srtVpSVTiZ4Iw86U7hXdI06pgvYpF/BXIuJVXjXi73HRb5eB74u8t7U2H
         SFbhNmBXhFKsTEME2+KKQ7m3IQQD8hCL4MhUB4NkCuTCJq7tLJ64otGApa2Ug7i234
         xXKgnVWnTi3qd8To81hQhgXbQYq0nuI8csFdkkjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/885] drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats
Date:   Tue,  7 Mar 2023 17:53:18 +0100
Message-Id: <20230307170013.489751326@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 6fb6c979ca628583d4d0c59a0f8ff977e581ecc0 ]

As of commit eae06120f1974e1a ("drm: refuse ADDFB2 ioctl for broken
bigendian drivers"), drivers must set the
quirk_addfb_prefer_host_byte_order quirk to make the drm_mode_addfb()
compat code work correctly on big-endian machines.

While that works fine for big-endian XRGB8888 and ARGB8888, which are
mapped to the existing little-endian BGRX8888 and BGRA8888 formats, it
does not work for big-endian XRGB1555 and RGB565, as the latter are not
listed in the format database.

Fix this by adding the missing formats.  Limit this to big-endian
platforms, as there is currently no need to support these formats on
little-endian platforms.

Fixes: 6960e6da9cec3f66 ("drm: fix drm_mode_addfb() on big endian machines.")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/3ee1f8144feb96c28742b22384189f1f83bcfc1a.1669221671.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fourcc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 6242dfbe92402..0f17dfa8702b4 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -190,6 +190,10 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_BGRA5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
 		{ .format = DRM_FORMAT_RGB565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_BGR565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+#ifdef __BIG_ENDIAN
+		{ .format = DRM_FORMAT_XRGB1555 | DRM_FORMAT_BIG_ENDIAN, .depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+		{ .format = DRM_FORMAT_RGB565 | DRM_FORMAT_BIG_ENDIAN, .depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+#endif
 		{ .format = DRM_FORMAT_RGB888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_BGR888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_XRGB8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-- 
2.39.2



