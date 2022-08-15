Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FAE593EE0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbiHOVNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344646AbiHOVLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A4CD9E86;
        Mon, 15 Aug 2022 12:19:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC0BB81122;
        Mon, 15 Aug 2022 19:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A66C433D7;
        Mon, 15 Aug 2022 19:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591165;
        bh=WU8kE6p9yJ72bRifA3r1RnbfoV1epnk0R1xMzc53M1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDj7dwOz08Z12sSHmwbuQ+BREqNVNyiqdnGtFbYu+CliW0ly8a/IgIHyP1/VjwLDx
         7Qhmqs+iveLGWY4rekrqanhsm/rmhwLIFBj97ClhAVTjdHCav9cbxG5zGHa7ZaTLQE
         +bFSZ1V3iY1NYZ1LXuhXSN0UCh8EZAkD9vPh3RMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0465/1095] media: uapi: HEVC: Change pic_order_cnt definition in v4l2_hevc_dpb_entry
Date:   Mon, 15 Aug 2022 19:57:44 +0200
Message-Id: <20220815180448.839228146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit c4a179c7167ee16aad1267f9c99bc1ecff475585 ]

The HEVC specification describes the following:
"PicOrderCntVal is derived as follows:
PicOrderCntVal = PicOrderCntMsb + slice_pic_order_cnt_lsb
The value of PicOrderCntVal shall be in the range of
−2^31 to 2^31 − 1, inclusive."

To match with these definitions change __u16 pic_order_cnt[2]
into __s32 pic_order_cnt_val.
Change v4l2_ctrl_hevc_slice_params->slice_pic_order_cnt to __s32 too.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Acked-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Tested-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst | 2 +-
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c         | 7 +++----
 drivers/staging/media/hantro/hantro_hevc.c                | 2 +-
 drivers/staging/media/hantro/hantro_hw.h                  | 4 ++--
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c          | 4 ++--
 include/media/hevc-ctrls.h                                | 4 ++--
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
index 4cd7c541fc30..bcdc14144105 100644
--- a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
+++ b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
@@ -2975,7 +2975,7 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
     * - __u8
       - ``colour_plane_id``
       -
-    * - __u16
+    * - __s32
       - ``slice_pic_order_cnt``
       -
     * - __u8
diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index 5df6f08e26f5..d28653d04d20 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -390,11 +390,10 @@ static int set_ref(struct hantro_ctx *ctx)
 			 !!(pps->flags & V4L2_HEVC_PPS_FLAG_LOOP_FILTER_ACROSS_TILES_ENABLED));
 
 	/*
-	 * Write POC count diff from current pic. For frame decoding only compute
-	 * pic_order_cnt[0] and ignore pic_order_cnt[1] used in field-coding.
+	 * Write POC count diff from current pic.
 	 */
 	for (i = 0; i < decode_params->num_active_dpb_entries && i < ARRAY_SIZE(cur_poc); i++) {
-		char poc_diff = decode_params->pic_order_cnt_val - dpb[i].pic_order_cnt[0];
+		char poc_diff = decode_params->pic_order_cnt_val - dpb[i].pic_order_cnt_val;
 
 		hantro_reg_write(vpu, &cur_poc[i], poc_diff);
 	}
@@ -421,7 +420,7 @@ static int set_ref(struct hantro_ctx *ctx)
 	dpb_longterm_e = 0;
 	for (i = 0; i < decode_params->num_active_dpb_entries &&
 	     i < (V4L2_HEVC_DPB_ENTRIES_NUM_MAX - 1); i++) {
-		luma_addr = hantro_hevc_get_ref_buf(ctx, dpb[i].pic_order_cnt[0]);
+		luma_addr = hantro_hevc_get_ref_buf(ctx, dpb[i].pic_order_cnt_val);
 		if (!luma_addr)
 			return -ENOMEM;
 
diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index bd924896e409..4f7e2acb46ec 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -33,7 +33,7 @@ void hantro_hevc_ref_init(struct hantro_ctx *ctx)
 }
 
 dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx,
-				   int poc)
+				   s32 poc)
 {
 	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
 	int i;
diff --git a/drivers/staging/media/hantro/hantro_hw.h b/drivers/staging/media/hantro/hantro_hw.h
index b480cf329b13..457eb8bb6dc2 100644
--- a/drivers/staging/media/hantro/hantro_hw.h
+++ b/drivers/staging/media/hantro/hantro_hw.h
@@ -143,7 +143,7 @@ struct hantro_hevc_dec_hw_ctx {
 	struct hantro_aux_buf tile_bsd;
 	struct hantro_aux_buf ref_bufs[NUM_REF_PICTURES];
 	struct hantro_aux_buf scaling_lists;
-	int ref_bufs_poc[NUM_REF_PICTURES];
+	s32 ref_bufs_poc[NUM_REF_PICTURES];
 	u32 ref_bufs_used;
 	struct hantro_hevc_dec_ctrls ctrls;
 	unsigned int num_tile_cols_allocated;
@@ -351,7 +351,7 @@ void hantro_hevc_dec_exit(struct hantro_ctx *ctx);
 int hantro_g2_hevc_dec_run(struct hantro_ctx *ctx);
 int hantro_hevc_dec_prepare_run(struct hantro_ctx *ctx);
 void hantro_hevc_ref_init(struct hantro_ctx *ctx);
-dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx, int poc);
+dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx, s32 poc);
 int hantro_hevc_add_ref_buf(struct hantro_ctx *ctx, int poc, dma_addr_t addr);
 int hantro_hevc_validate_sps(struct hantro_ctx *ctx, const struct v4l2_ctrl_hevc_sps *sps);
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index 2febdf7a97fe..c26e515d64c9 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -143,8 +143,8 @@ static void cedrus_h265_frame_info_write_dpb(struct cedrus_ctx *ctx,
 	for (i = 0; i < num_active_dpb_entries; i++) {
 		int buffer_index = vb2_find_timestamp(vq, dpb[i].timestamp, 0);
 		u32 pic_order_cnt[2] = {
-			dpb[i].pic_order_cnt[0],
-			dpb[i].pic_order_cnt[1]
+			dpb[i].pic_order_cnt_val,
+			dpb[i].pic_order_cnt_val
 		};
 
 		cedrus_h265_frame_info_write_single(ctx, i, dpb[i].field_pic,
diff --git a/include/media/hevc-ctrls.h b/include/media/hevc-ctrls.h
index 01ccda48d8c5..88e804578cb1 100644
--- a/include/media/hevc-ctrls.h
+++ b/include/media/hevc-ctrls.h
@@ -135,7 +135,7 @@ struct v4l2_hevc_dpb_entry {
 	__u64	timestamp;
 	__u8	flags;
 	__u8	field_pic;
-	__u16	pic_order_cnt[2];
+	__s32	pic_order_cnt_val;
 	__u8	padding[2];
 };
 
@@ -178,7 +178,7 @@ struct v4l2_ctrl_hevc_slice_params {
 	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
 	__u8	slice_type;
 	__u8	colour_plane_id;
-	__u16	slice_pic_order_cnt;
+	__s32	slice_pic_order_cnt;
 	__u8	num_ref_idx_l0_active_minus1;
 	__u8	num_ref_idx_l1_active_minus1;
 	__u8	collocated_ref_idx;
-- 
2.35.1



