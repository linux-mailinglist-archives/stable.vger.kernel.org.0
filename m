Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563375940EA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbiHOVKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348042AbiHOVIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165D43C8D8;
        Mon, 15 Aug 2022 12:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD9A9B810C6;
        Mon, 15 Aug 2022 19:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D4FC433C1;
        Mon, 15 Aug 2022 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591080;
        bh=mhEgBORyV3PVFKJt5jhDc4jGPUxc6GqM6YMT/Qmh7G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwr1SnVsUckarkzKQAFCfHNbSMDzqrnyN34f9Y4MUpFv6JUcGxGY3ubG//gjpwgZ1
         SFwqx/8gokSjXHatTaFuBSuyvMkXgWhxdVeW9MnIIfkHRKwuyUkacbwbMvnjskHOCT
         T8yfa4DrV2KOiDwaAsiZuwBQDXhK5VT6oOey9YAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0435/1095] media: hantro: HEVC: Fix reference frames management
Date:   Mon, 15 Aug 2022 19:57:14 +0200
Message-Id: <20220815180447.674145076@linuxfoundation.org>
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

[ Upstream commit 387d1176956883635c63a7d1c91b1f45e19c1777 ]

PoC shall be int the range of -2^31 to 2^31 -1
(HEVC spec section 8.3.1 Decoding process for picture order count).
The current way to know if an entry in reference picture array is free
is to test if PoC = UNUSED_REF. Since UNUSED_REF is defined as '-1' that
could lead to decode issue if one PoC also equal '-1'.
PoC with value = '-1' exists in conformance test SLIST_B_Sony_9.

Change the way unused entries are managed in reference pictures array to
avoid using PoC to detect then.

This patch doesn't change fluster HEVC score.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/hantro/hantro_g2_hevc_dec.c |  4 +--
 drivers/staging/media/hantro/hantro_hevc.c    | 27 +++----------------
 drivers/staging/media/hantro/hantro_hw.h      |  2 +-
 3 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index 7c046d456038..5df6f08e26f5 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -415,7 +415,7 @@ static int set_ref(struct hantro_ctx *ctx)
 	set_ref_pic_list(ctx);
 
 	/* We will only keep the reference pictures that are still used */
-	ctx->hevc_dec.ref_bufs_used = 0;
+	hantro_hevc_ref_init(ctx);
 
 	/* Set up addresses of DPB buffers */
 	dpb_longterm_e = 0;
@@ -456,8 +456,6 @@ static int set_ref(struct hantro_ctx *ctx)
 	hantro_write_addr(vpu, G2_OUT_CHROMA_ADDR, chroma_addr);
 	hantro_write_addr(vpu, G2_OUT_MV_ADDR, mv_addr);
 
-	hantro_hevc_ref_remove_unused(ctx);
-
 	for (; i < V4L2_HEVC_DPB_ENTRIES_NUM_MAX; i++) {
 		hantro_write_addr(vpu, G2_REF_LUMA_ADDR(i), 0);
 		hantro_write_addr(vpu, G2_REF_CHROMA_ADDR(i), 0);
diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index b3a057beaf19..f86c98e19177 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -25,15 +25,11 @@
 #define MAX_TILE_COLS 20
 #define MAX_TILE_ROWS 22
 
-#define UNUSED_REF	-1
-
-static void hantro_hevc_ref_init(struct hantro_ctx *ctx)
+void hantro_hevc_ref_init(struct hantro_ctx *ctx)
 {
 	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
-	int i;
 
-	for (i = 0;  i < NUM_REF_PICTURES; i++)
-		hevc_dec->ref_bufs_poc[i] = UNUSED_REF;
+	hevc_dec->ref_bufs_used = 0;
 }
 
 dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx,
@@ -60,7 +56,7 @@ int hantro_hevc_add_ref_buf(struct hantro_ctx *ctx, int poc, dma_addr_t addr)
 
 	/* Add a new reference buffer */
 	for (i = 0; i < NUM_REF_PICTURES; i++) {
-		if (hevc_dec->ref_bufs_poc[i] == UNUSED_REF) {
+		if (!(hevc_dec->ref_bufs_used & 1 << i)) {
 			hevc_dec->ref_bufs_used |= 1 << i;
 			hevc_dec->ref_bufs_poc[i] = poc;
 			hevc_dec->ref_bufs[i].dma = addr;
@@ -71,23 +67,6 @@ int hantro_hevc_add_ref_buf(struct hantro_ctx *ctx, int poc, dma_addr_t addr)
 	return -EINVAL;
 }
 
-void hantro_hevc_ref_remove_unused(struct hantro_ctx *ctx)
-{
-	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
-	int i;
-
-	/* Just tag buffer as unused, do not free them */
-	for (i = 0;  i < NUM_REF_PICTURES; i++) {
-		if (hevc_dec->ref_bufs_poc[i] == UNUSED_REF)
-			continue;
-
-		if (hevc_dec->ref_bufs_used & (1 << i))
-			continue;
-
-		hevc_dec->ref_bufs_poc[i] = UNUSED_REF;
-	}
-}
-
 static int tile_buffer_reallocate(struct hantro_ctx *ctx)
 {
 	struct hantro_dev *vpu = ctx->dev;
diff --git a/drivers/staging/media/hantro/hantro_hw.h b/drivers/staging/media/hantro/hantro_hw.h
index df142f31e31b..699c1efc0215 100644
--- a/drivers/staging/media/hantro/hantro_hw.h
+++ b/drivers/staging/media/hantro/hantro_hw.h
@@ -338,9 +338,9 @@ int hantro_hevc_dec_init(struct hantro_ctx *ctx);
 void hantro_hevc_dec_exit(struct hantro_ctx *ctx);
 int hantro_g2_hevc_dec_run(struct hantro_ctx *ctx);
 int hantro_hevc_dec_prepare_run(struct hantro_ctx *ctx);
+void hantro_hevc_ref_init(struct hantro_ctx *ctx);
 dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx, int poc);
 int hantro_hevc_add_ref_buf(struct hantro_ctx *ctx, int poc, dma_addr_t addr);
-void hantro_hevc_ref_remove_unused(struct hantro_ctx *ctx);
 
 static inline unsigned short hantro_vp9_num_sbs(unsigned short dimension)
 {
-- 
2.35.1



