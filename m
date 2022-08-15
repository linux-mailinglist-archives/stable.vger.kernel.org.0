Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA25593FFA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiHOVKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348038AbiHOVIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3EE3C8D7;
        Mon, 15 Aug 2022 12:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC732B81106;
        Mon, 15 Aug 2022 19:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12156C433C1;
        Mon, 15 Aug 2022 19:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591077;
        bh=lbTs/5k4Wl+Wd+pYJniOD4sGSRSPcOtCJRp3bCpZ5HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arYoZvUYIf8O3wuGUl5+0ZT7tm0p0IvyyTo0NJHaiiaJ96nOMvSSrMoqCMOYOwTrQ
         EpZYBgxYKmkaFMKz8U/j3UFHP5pglNi2LkDLJSvXm+lwDp2MkKoSP9RfcfDB861deD
         MGP8CKqVdhBRb+TocG2FYw+WAhdqzw8Hla1xB/Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0434/1095] media: hantro: HEVC: Fix output frame chroma offset
Date:   Mon, 15 Aug 2022 19:57:13 +0200
Message-Id: <20220815180447.634825691@linuxfoundation.org>
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

[ Upstream commit 579846ec52593e6ca123c30379103377cd25728a ]

Hantro decoder doesn't take care of the requested and aligned size
of the capture buffer.
Stop using the bitstream width/height and use capture frame size
stored in the context to get the correct values.

hantro_hevc_chroma_offset() and hantro_hevc_motion_vectors_offset()
are only used in hantro_g2_hevc_dec.c so take the opportunity
to move them here.

fluster HEVC score goes up from 77 to 85 successful tests (over 147)
with this patch.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/hantro/hantro_g2_hevc_dec.c | 19 ++++++++++++++++---
 drivers/staging/media/hantro/hantro_hevc.c    | 17 -----------------
 drivers/staging/media/hantro/hantro_hw.h      |  2 --
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index a4642ed1f463..7c046d456038 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -8,6 +8,20 @@
 #include "hantro_hw.h"
 #include "hantro_g2_regs.h"
 
+#define G2_ALIGN	16
+
+static size_t hantro_hevc_chroma_offset(struct hantro_ctx *ctx)
+{
+	return ctx->dst_fmt.width * ctx->dst_fmt.height;
+}
+
+static size_t hantro_hevc_motion_vectors_offset(struct hantro_ctx *ctx)
+{
+	size_t cr_offset = hantro_hevc_chroma_offset(ctx);
+
+	return ALIGN((cr_offset * 3) / 2, G2_ALIGN);
+}
+
 static void prepare_tile_info_buffer(struct hantro_ctx *ctx)
 {
 	struct hantro_dev *vpu = ctx->dev;
@@ -330,7 +344,6 @@ static void set_ref_pic_list(struct hantro_ctx *ctx)
 static int set_ref(struct hantro_ctx *ctx)
 {
 	const struct hantro_hevc_dec_ctrls *ctrls = &ctx->hevc_dec.ctrls;
-	const struct v4l2_ctrl_hevc_sps *sps = ctrls->sps;
 	const struct v4l2_ctrl_hevc_pps *pps = ctrls->pps;
 	const struct v4l2_ctrl_hevc_decode_params *decode_params = ctrls->decode_params;
 	const struct v4l2_hevc_dpb_entry *dpb = decode_params->dpb;
@@ -338,8 +351,8 @@ static int set_ref(struct hantro_ctx *ctx)
 	struct hantro_dev *vpu = ctx->dev;
 	struct vb2_v4l2_buffer *vb2_dst;
 	struct hantro_decoded_buffer *dst;
-	size_t cr_offset = hantro_hevc_chroma_offset(sps);
-	size_t mv_offset = hantro_hevc_motion_vectors_offset(sps);
+	size_t cr_offset = hantro_hevc_chroma_offset(ctx);
+	size_t mv_offset = hantro_hevc_motion_vectors_offset(ctx);
 	u32 max_ref_frames;
 	u16 dpb_longterm_e;
 	static const struct hantro_reg cur_poc[] = {
diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index 9c351f7fe6bd..b3a057beaf19 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -27,23 +27,6 @@
 
 #define UNUSED_REF	-1
 
-#define G2_ALIGN		16
-
-size_t hantro_hevc_chroma_offset(const struct v4l2_ctrl_hevc_sps *sps)
-{
-	int bytes_per_pixel = sps->bit_depth_luma_minus8 == 0 ? 1 : 2;
-
-	return sps->pic_width_in_luma_samples *
-	       sps->pic_height_in_luma_samples * bytes_per_pixel;
-}
-
-size_t hantro_hevc_motion_vectors_offset(const struct v4l2_ctrl_hevc_sps *sps)
-{
-	size_t cr_offset = hantro_hevc_chroma_offset(sps);
-
-	return ALIGN((cr_offset * 3) / 2, G2_ALIGN);
-}
-
 static void hantro_hevc_ref_init(struct hantro_ctx *ctx)
 {
 	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
diff --git a/drivers/staging/media/hantro/hantro_hw.h b/drivers/staging/media/hantro/hantro_hw.h
index c5dc77125fb7..df142f31e31b 100644
--- a/drivers/staging/media/hantro/hantro_hw.h
+++ b/drivers/staging/media/hantro/hantro_hw.h
@@ -341,8 +341,6 @@ int hantro_hevc_dec_prepare_run(struct hantro_ctx *ctx);
 dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx, int poc);
 int hantro_hevc_add_ref_buf(struct hantro_ctx *ctx, int poc, dma_addr_t addr);
 void hantro_hevc_ref_remove_unused(struct hantro_ctx *ctx);
-size_t hantro_hevc_chroma_offset(const struct v4l2_ctrl_hevc_sps *sps);
-size_t hantro_hevc_motion_vectors_offset(const struct v4l2_ctrl_hevc_sps *sps);
 
 static inline unsigned short hantro_vp9_num_sbs(unsigned short dimension)
 {
-- 
2.35.1



