Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57976674DF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbjALOPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbjALOOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA6F5C1E5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A17F62026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46991C433EF;
        Thu, 12 Jan 2023 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532402;
        bh=TAhR6hW8z6oZY73xgyuh8KyVSP1vitLHyfYO3q1MEFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17EFQTSq/X2x7Su6vnvu6b14Q/rdqmX18f9ThsBkwvDWTw3aT59iFqTGrniMw1zR7
         uCaMoa/UX24iQ9ZWIhKrL+HmuyGAKX6Hf+y8lkvn9lXaiXe4TWSHy5HEK2+DTNyTCa
         A2UK8yv0tdWqRAZvKG0bXR3THnnVzNt+RnwUS9BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/783] drm/fourcc: Add packed 10bit YUV 4:2:0 format
Date:   Thu, 12 Jan 2023 14:47:47 +0100
Message-Id: <20230112135531.342377685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 006ea1b5822f9019bd722ffc6242bc0880879e3d ]

Adds a format that is 3 10bit YUV 4:2:0 samples packed into
a 32bit word (with 2 spare bits).

Supported on Broadcom BCM2711 chips.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20211215091739.135042-2-maxime@cerno.tech
Stable-dep-of: b230555f3257 ("drm/fourcc: Fix vsub/hsub for Q410 and Q401")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fourcc.c  |  3 +++
 include/uapi/drm/drm_fourcc.h | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 722c7ebe4e88..4d4b65a88bd1 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -286,6 +286,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		  .num_planes = 3, .char_per_block = { 2, 2, 2 },
 		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 0,
 		  .vsub = 0, .is_yuv = true },
+		{ .format = DRM_FORMAT_P030,            .depth = 0,  .num_planes = 2,
+		  .char_per_block = { 4, 8, 0 }, .block_w = { 3, 3, 0 }, .block_h = { 1, 1, 0 },
+		  .hsub = 2, .vsub = 2, .is_yuv = true},
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 5498d7a6556a..dad9d3b4a97a 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -271,6 +271,13 @@ extern "C" {
  */
 #define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
 
+/* 2 plane YCbCr420.
+ * 3 10 bit components and 2 padding bits packed into 4 bytes.
+ * index 0 = Y plane, [31:0] x:Y2:Y1:Y0 2:10:10:10 little endian
+ * index 1 = Cr:Cb plane, [63:0] x:Cr2:Cb2:Cr1:x:Cb1:Cr0:Cb0 [2:10:10:10:2:10:10:10] little endian
+ */
+#define DRM_FORMAT_P030		fourcc_code('P', '0', '3', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel packed */
+
 /* 3 plane non-subsampled (444) YCbCr
  * 16 bits per component, but only 10 bits are used and 6 bits are padded
  * index 0: Y plane, [15:0] Y:x [10:6] little endian
@@ -777,6 +784,10 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
  * and UV.  Some SAND-using hardware stores UV in a separate tiled
  * image from Y to reduce the column height, which is not supported
  * with these modifiers.
+ *
+ * The DRM_FORMAT_MOD_BROADCOM_SAND128_COL_HEIGHT modifier is also
+ * supported for DRM_FORMAT_P030 where the columns remain as 128 bytes
+ * wide, but as this is a 10 bpp format that translates to 96 pixels.
  */
 
 #define DRM_FORMAT_MOD_BROADCOM_SAND32_COL_HEIGHT(v) \
-- 
2.35.1



