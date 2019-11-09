Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630D2F67CC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfKJGmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:50 -0500
Received: from www.linuxtv.org ([130.149.80.248]:56032 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfKJGmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:50 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvt-0004x4-BH; Sun, 10 Nov 2019 06:42:45 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 09 Nov 2019 08:06:27 +0000
Subject: [git:media_tree/master] media: hantro: Fix picture order count table enable
To:     linuxtv-commits@linuxtv.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jonas Karlman <jonas@kwiboo.se>, stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Francois Buergisser <fbuergisser@chromium.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvt-0004x4-BH@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Fix picture order count table enable
Author:  Francois Buergisser <fbuergisser@chromium.org>
Date:    Tue Oct 29 02:24:48 2019 +0100

The picture order count table only makes sense for profiles
higher than Baseline. This is confirmed by the H.264 specification
(See 8.2.1 Decoding process for picture order count), which
clarifies how POC are used for features not present in Baseline.

"""
Picture order counts are used to determine initial picture orderings
for reference pictures in the decoding of B slices, to represent picture
order differences between frames or fields for motion vector derivation
in temporal direct mode, for implicit mode weighted prediction in B slices,
and for decoder conformance checking.
"""

As a side note, this change matches various vendors downstream codebases,
including ChromiumOS and IMX VPU libraries.

Fixes: dea0a82f3d22 ("media: hantro: Add support for H264 decoding on G1")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/staging/media/hantro/hantro_g1_h264_dec.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

diff --git a/drivers/staging/media/hantro/hantro_g1_h264_dec.c b/drivers/staging/media/hantro/hantro_g1_h264_dec.c
index a1cb18680200..70a6b5b26477 100644
--- a/drivers/staging/media/hantro/hantro_g1_h264_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_h264_dec.c
@@ -34,9 +34,11 @@ static void set_params(struct hantro_ctx *ctx)
 	reg = G1_REG_DEC_CTRL0_DEC_AXI_WR_ID(0x0);
 	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
 		reg |= G1_REG_DEC_CTRL0_SEQ_MBAFF_E;
-	reg |= G1_REG_DEC_CTRL0_PICORD_COUNT_E;
-	if (sps->profile_idc > 66 && dec_param->nal_ref_idc)
-		reg |= G1_REG_DEC_CTRL0_WRITE_MVS_E;
+	if (sps->profile_idc > 66) {
+		reg |= G1_REG_DEC_CTRL0_PICORD_COUNT_E;
+		if (dec_param->nal_ref_idc)
+			reg |= G1_REG_DEC_CTRL0_WRITE_MVS_E;
+	}
 
 	if (!(sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY) &&
 	    (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD ||
