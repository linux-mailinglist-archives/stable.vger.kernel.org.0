Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9613BB1EE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhGDXN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232301AbhGDXMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56197611ED;
        Sun,  4 Jul 2021 23:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440120;
        bh=RYXMFqHcSr4bL2PoGyJZ5nwwl1DauA2EAjLBUbL/NXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxAfaTGOXN35P2tr6L+TR8dNRgjO7fEjsxFxwtqdYx6Xx6u7SNtYBIWxzpsvOmd85
         yPSQQeUl820dHfcs75tBtaJoTndCbn90g91zDmAjlHRhSENqo1LDl+LSoTIHTOQ13H
         QC/+4dT5xuT3dNYy1XNkAzNZ4FounrfrO2+cu4yHBGNiCNCPLSfKeyQ2Y/MT1O/eXp
         7EuLbt/lmvSc/tvL5UGcS2LHAI79aISHzLfi30qz3frN0jLqiaH67kLAUSYHUV3q0U
         0WQ3Wuwn7I2UYW2rdogz21zg6sBxJFm6eWGvfvLwfQAbdBz9kTky/e5eW3k8zukWVg
         WD/pUo+d1Z95Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 26/70] media: hevc: Fix dependent slice segment flags
Date:   Sun,  4 Jul 2021 19:07:19 -0400
Message-Id: <20210704230804.1490078-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 67a7e53d5b21f3a84efc03a4e62db7caf97841ef ]

Dependent slice segment flag for PPS control is misnamed. It should have
"enabled" at the end. It only tells if this flag is present in slice
header or not and not the actual value.

Fix this by renaming the PPS flag and introduce another flag for slice
control which tells actual value.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst | 5 ++++-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c          | 4 ++--
 include/media/hevc-ctrls.h                                | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
index ce728c757eaf..b864869b42bc 100644
--- a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
+++ b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
@@ -4030,7 +4030,7 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
     :stub-columns: 0
     :widths:       1 1 2
 
-    * - ``V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT``
+    * - ``V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT_ENABLED``
       - 0x00000001
       -
     * - ``V4L2_HEVC_PPS_FLAG_OUTPUT_FLAG_PRESENT``
@@ -4238,6 +4238,9 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
     * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED``
       - 0x00000100
       -
+    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_DEPENDENT_SLICE_SEGMENT``
+      - 0x00000200
+      -
 
 .. c:type:: v4l2_hevc_dpb_entry
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index ce497d0197df..10744fab7cea 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -477,8 +477,8 @@ static void cedrus_h265_setup(struct cedrus_ctx *ctx,
 				slice_params->flags);
 
 	reg |= VE_DEC_H265_FLAG(VE_DEC_H265_DEC_SLICE_HDR_INFO0_FLAG_DEPENDENT_SLICE_SEGMENT,
-				V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT,
-				pps->flags);
+				V4L2_HEVC_SLICE_PARAMS_FLAG_DEPENDENT_SLICE_SEGMENT,
+				slice_params->flags);
 
 	/* FIXME: For multi-slice support. */
 	reg |= VE_DEC_H265_DEC_SLICE_HDR_INFO0_FLAG_FIRST_SLICE_SEGMENT_IN_PIC;
diff --git a/include/media/hevc-ctrls.h b/include/media/hevc-ctrls.h
index 1009cf0891cc..a3b650ab00f6 100644
--- a/include/media/hevc-ctrls.h
+++ b/include/media/hevc-ctrls.h
@@ -81,7 +81,7 @@ struct v4l2_ctrl_hevc_sps {
 	__u64	flags;
 };
 
-#define V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT		(1ULL << 0)
+#define V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT_ENABLED	(1ULL << 0)
 #define V4L2_HEVC_PPS_FLAG_OUTPUT_FLAG_PRESENT			(1ULL << 1)
 #define V4L2_HEVC_PPS_FLAG_SIGN_DATA_HIDING_ENABLED		(1ULL << 2)
 #define V4L2_HEVC_PPS_FLAG_CABAC_INIT_PRESENT			(1ULL << 3)
@@ -160,6 +160,7 @@ struct v4l2_hevc_pred_weight_table {
 #define V4L2_HEVC_SLICE_PARAMS_FLAG_USE_INTEGER_MV		(1ULL << 6)
 #define V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_DEBLOCKING_FILTER_DISABLED (1ULL << 7)
 #define V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED (1ULL << 8)
+#define V4L2_HEVC_SLICE_PARAMS_FLAG_DEPENDENT_SLICE_SEGMENT	(1ULL << 9)
 
 struct v4l2_ctrl_hevc_slice_params {
 	__u32	bit_size;
-- 
2.30.2

