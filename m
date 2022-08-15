Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0CC593715
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244530AbiHOS5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244935AbiHOS4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABC72C100;
        Mon, 15 Aug 2022 11:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E59B81074;
        Mon, 15 Aug 2022 18:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EBDC433D7;
        Mon, 15 Aug 2022 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588243;
        bh=KPIT0rX4vehbcxwhw9hn4GDvpctrofJn58SXiBI/FTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWOVqqxxNkpa3VNm8qTIzlldeCellNfWov39s8vRuoSEbBGJ83ZRiQBbTethCuv2r
         PIRz+suQsTf0LSF3BPkKKY45uFgJY8REL5DSZapjVJQ9cWa57iOBost8oE1MK1M6Xs
         oBqxpTm/dBxirFeusHUhR48mMfPDs8Hg1jyBdU7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/779] media: cedrus: h265: Fix flag name
Date:   Mon, 15 Aug 2022 19:59:45 +0200
Message-Id: <20220815180351.852340263@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 104a70e1d0bcef28db13c4192b8729086089651c ]

Bit 21 in register 0x24 (slice header info 1) actually represents
negated version of low delay flag. This can be seen in vendor Cedar
library source code. While this flag is not part of the standard, it can
be found in reference HEVC implementation.

Fix macro name and change it to flag.

Fixes: 86caab29da78 ("media: cedrus: Add HEVC/H.265 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 4 +++-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h | 3 +--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index 754942ecf064..f2cec43fd1f0 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -495,7 +495,6 @@ static void cedrus_h265_setup(struct cedrus_ctx *ctx,
 
 	reg = VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_TC_OFFSET_DIV2(slice_params->slice_tc_offset_div2) |
 	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_BETA_OFFSET_DIV2(slice_params->slice_beta_offset_div2) |
-	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_POC_BIGEST_IN_RPS_ST(decode_params->num_poc_st_curr_after == 0) |
 	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CR_QP_OFFSET(slice_params->slice_cr_qp_offset) |
 	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CB_QP_OFFSET(slice_params->slice_cb_qp_offset) |
 	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_QP_DELTA(slice_params->slice_qp_delta);
@@ -508,6 +507,9 @@ static void cedrus_h265_setup(struct cedrus_ctx *ctx,
 				V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED,
 				slice_params->flags);
 
+	if (decode_params->num_poc_st_curr_after == 0)
+		reg |= VE_DEC_H265_DEC_SLICE_HDR_INFO1_FLAG_SLICE_NOT_LOW_DELAY;
+
 	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO1, reg);
 
 	chroma_log2_weight_denom = pred_weight_table->luma_log2_weight_denom +
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index 92ace87c1c7d..5f34e3670289 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -377,13 +377,12 @@
 
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_FLAG_SLICE_DEBLOCKING_FILTER_DISABLED BIT(23)
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED BIT(22)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_FLAG_SLICE_NOT_LOW_DELAY BIT(21)
 
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_TC_OFFSET_DIV2(v) \
 	SHIFT_AND_MASK_BITS(v, 31, 28)
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_BETA_OFFSET_DIV2(v) \
 	SHIFT_AND_MASK_BITS(v, 27, 24)
-#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_POC_BIGEST_IN_RPS_ST(v) \
-	((v) ? BIT(21) : 0)
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CR_QP_OFFSET(v) \
 	SHIFT_AND_MASK_BITS(v, 20, 16)
 #define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CB_QP_OFFSET(v) \
-- 
2.35.1



