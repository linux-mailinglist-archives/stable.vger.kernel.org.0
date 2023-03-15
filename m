Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F6C6BB2C2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjCOMi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjCOMiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1AE149A4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F58ECE19BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D040C433D2;
        Wed, 15 Mar 2023 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883826;
        bh=lm4xLsnfSuP+LF0wMZJL7bhEZ7urhR31TpLcljNvGI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOmxeglFxIE5+ME4ApDsIoJhgxmDQ6F2RVnYNe8JqRgjSQY9ma3BBr1PxvA+RZ0i+
         hWx5yquw1OiZq5/RqJs1HN9S/QwyRo/Qq/e2f4H0R4l8cobeuRaF7Rm/YZor8R0YPj
         QuC6uPIVp3GngU2K2yEZ0ySztyerb640pDDbb21g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/143] drm/amdgpu/soc21: dont expose AV1 if VCN0 is harvested
Date:   Wed, 15 Mar 2023 13:13:22 +0100
Message-Id: <20230315115744.020399580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a6de636eb04f146d23644dbbb7173e142452a9b7 ]

Only VCN0 supports AV1.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6ce2ea07c5ff ("drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 61 +++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 00df439ed493d..61ee41aa8abb7 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -47,19 +47,31 @@
 static const struct amd_ip_funcs soc21_common_ip_funcs;
 
 /* SOC21 */
-static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array[] =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn0[] =
 {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
 };
 
-static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn1[] =
 {
-	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array),
-	.codec_array = vcn_4_0_0_video_codecs_encode_array,
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn0 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array_vcn0),
+	.codec_array = vcn_4_0_0_video_codecs_encode_array_vcn0,
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn1 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_encode_array_vcn1),
+	.codec_array = vcn_4_0_0_video_codecs_encode_array_vcn1,
 };
 
-static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array[] =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array_vcn0[] =
 {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
@@ -68,23 +80,46 @@ static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array[
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
-static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode =
+static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_decode_array_vcn1[] =
 {
-	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array),
-	.codec_array = vcn_4_0_0_video_codecs_decode_array,
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode_vcn0 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array_vcn0),
+	.codec_array = vcn_4_0_0_video_codecs_decode_array_vcn0,
+};
+
+static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode_vcn1 =
+{
+	.codec_count = ARRAY_SIZE(vcn_4_0_0_video_codecs_decode_array_vcn1),
+	.codec_array = vcn_4_0_0_video_codecs_decode_array_vcn1,
 };
 
 static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 				 const struct amdgpu_video_codecs **codecs)
 {
-	switch (adev->ip_versions[UVD_HWIP][0]) {
+	if (adev->vcn.num_vcn_inst == hweight8(adev->vcn.harvest_config))
+		return -EINVAL;
 
+	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
-		if (encode)
-			*codecs = &vcn_4_0_0_video_codecs_encode;
-		else
-			*codecs = &vcn_4_0_0_video_codecs_decode;
+		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
+			if (encode)
+				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
+			else
+				*codecs = &vcn_4_0_0_video_codecs_decode_vcn1;
+		} else {
+			if (encode)
+				*codecs = &vcn_4_0_0_video_codecs_encode_vcn0;
+			else
+				*codecs = &vcn_4_0_0_video_codecs_decode_vcn0;
+		}
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.39.2



