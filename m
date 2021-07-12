Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9CC3C4842
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhGLGhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236968AbhGLGfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B2E610D1;
        Mon, 12 Jul 2021 06:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071561;
        bh=RYXMFqHcSr4bL2PoGyJZ5nwwl1DauA2EAjLBUbL/NXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7s8Qe79thB93km4Vd5zisy/TU+8fBpdyt8pZGWBTcqNY5/SlqqN9jIot6WAOeFW2
         AauE1YWn6U3c/NTEkS2FVHxD+SZ8y64j8j2X/zMm6ewrALZTVXZkb1wAhqoQV+tW/b
         z63ZRQcSwkPlJDlffyRVcGgijmTQ6tkGFc+9O/u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/593] media: hevc: Fix dependent slice segment flags
Date:   Mon, 12 Jul 2021 08:04:44 +0200
Message-Id: <20210712060856.803388908@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



