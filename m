Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71754F67CD
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfKJGmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:50 -0500
Received: from www.linuxtv.org ([130.149.80.248]:56029 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfKJGmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:50 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvt-0004xS-Df; Sun, 10 Nov 2019 06:42:45 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 09 Nov 2019 08:05:40 +0000
Subject: [git:media_tree/master] media: hantro: Fix motion vectors usage condition
To:     linuxtv-commits@linuxtv.org
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Francois Buergisser <fbuergisser@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvt-0004xS-Df@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Fix motion vectors usage condition
Author:  Francois Buergisser <fbuergisser@chromium.org>
Date:    Tue Oct 29 02:24:47 2019 +0100

The setting of the motion vectors usage and the setting of motion
vectors address are currently done under different conditions.

When decoding pre-recorded videos, this results of leaving the motion
vectors address unset, resulting in faulty memory accesses. Fix it
by using the same condition everywhere, which matches the profiles
that support motion vectors.

Fixes: dea0a82f3d22 ("media: hantro: Add support for H264 decoding on G1")
Signed-off-by: Francois Buergisser <fbuergisser@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/staging/media/hantro/hantro_g1_h264_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/staging/media/hantro/hantro_g1_h264_dec.c b/drivers/staging/media/hantro/hantro_g1_h264_dec.c
index 29130946dea4..a1cb18680200 100644
--- a/drivers/staging/media/hantro/hantro_g1_h264_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_h264_dec.c
@@ -35,7 +35,7 @@ static void set_params(struct hantro_ctx *ctx)
 	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
 		reg |= G1_REG_DEC_CTRL0_SEQ_MBAFF_E;
 	reg |= G1_REG_DEC_CTRL0_PICORD_COUNT_E;
-	if (dec_param->nal_ref_idc)
+	if (sps->profile_idc > 66 && dec_param->nal_ref_idc)
 		reg |= G1_REG_DEC_CTRL0_WRITE_MVS_E;
 
 	if (!(sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY) &&
@@ -245,7 +245,7 @@ static void set_buffers(struct hantro_ctx *ctx)
 	vdpu_write_relaxed(vpu, dst_dma, G1_REG_ADDR_DST);
 
 	/* Higher profiles require DMV buffer appended to reference frames. */
-	if (ctrls->sps->profile_idc > 66) {
+	if (ctrls->sps->profile_idc > 66 && ctrls->decode->nal_ref_idc) {
 		size_t pic_size = ctx->h264_dec.pic_size;
 		size_t mv_offset = round_up(pic_size, 8);
 
