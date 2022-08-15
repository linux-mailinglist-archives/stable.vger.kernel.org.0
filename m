Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B905936EB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiHOS6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244957AbiHOS4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD16B2AE16;
        Mon, 15 Aug 2022 11:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A86FB8106C;
        Mon, 15 Aug 2022 18:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05EBC433D6;
        Mon, 15 Aug 2022 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588255;
        bh=RclICDonFjO944ZHoBtWwLTYZURYZW3jTo1y4qRELnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxQ0lDzOzE3oeAB+LIUgxzFMiggdP+wC/VsTh+9TpZfvZV0YP8FUyGaoTmK5Xi7o7
         /D+YXUqqlzZpq6GLj373ijNJa6MF7NIE5REUwJ56TgGe2c6mHNRvyXKJS5ojr/eiIz
         8t/jgSgMXQ3jzBI0jBKm2wXuvrusTSERIfYWEzMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/779] media: hevc: Embedded indexes in RPS
Date:   Mon, 15 Aug 2022 19:59:48 +0200
Message-Id: <20220815180351.954446748@linuxfoundation.org>
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

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit d95a63daca85f4bca3b70e622c75586b5bf0ea5c ]

Reference Picture Set lists provide indices of short and long term
reference in DBP array.
Fix Hantro to not do a look up in DBP entries.
Make documentation more clear about it.

[hverkuil: fix typo in commit log]

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/v4l/ext-ctrls-codec.rst             |  6 ++---
 .../staging/media/hantro/hantro_g2_hevc_dec.c | 25 +++++--------------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
index 976d34445a24..f1421cf1a1b3 100644
--- a/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
+++ b/Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst
@@ -3326,15 +3326,15 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
     * - __u8
       - ``poc_st_curr_before[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
       - PocStCurrBefore as described in section 8.3.2 "Decoding process for reference
-        picture set.
+        picture set": provides the index of the short term before references in DPB array.
     * - __u8
       - ``poc_st_curr_after[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
       - PocStCurrAfter as described in section 8.3.2 "Decoding process for reference
-        picture set.
+        picture set": provides the index of the short term after references in DPB array.
     * - __u8
       - ``poc_lt_curr[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
       - PocLtCurr as described in section 8.3.2 "Decoding process for reference
-        picture set.
+        picture set": provides the index of the long term references in DPB array.
     * - __u64
       - ``flags``
       - See :ref:`Decode Parameters Flags <hevc_decode_params_flags>`
diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index e63b777d4266..87086f5c5495 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -264,24 +264,11 @@ static void set_params(struct hantro_ctx *ctx)
 	hantro_reg_write(vpu, &g2_apf_threshold, 8);
 }
 
-static int find_ref_pic_index(const struct v4l2_hevc_dpb_entry *dpb, int pic_order_cnt)
-{
-	int i;
-
-	for (i = 0; i < V4L2_HEVC_DPB_ENTRIES_NUM_MAX; i++) {
-		if (dpb[i].pic_order_cnt[0] == pic_order_cnt)
-			return i;
-	}
-
-	return 0x0;
-}
-
 static void set_ref_pic_list(struct hantro_ctx *ctx)
 {
 	const struct hantro_hevc_dec_ctrls *ctrls = &ctx->hevc_dec.ctrls;
 	struct hantro_dev *vpu = ctx->dev;
 	const struct v4l2_ctrl_hevc_decode_params *decode_params = ctrls->decode_params;
-	const struct v4l2_hevc_dpb_entry *dpb = decode_params->dpb;
 	u32 list0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX] = {};
 	u32 list1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX] = {};
 	static const struct hantro_reg ref_pic_regs0[] = {
@@ -325,11 +312,11 @@ static void set_ref_pic_list(struct hantro_ctx *ctx)
 	/* List 0 contains: short term before, short term after and long term */
 	j = 0;
 	for (i = 0; i < decode_params->num_poc_st_curr_before && j < ARRAY_SIZE(list0); i++)
-		list0[j++] = find_ref_pic_index(dpb, decode_params->poc_st_curr_before[i]);
+		list0[j++] = decode_params->poc_st_curr_before[i];
 	for (i = 0; i < decode_params->num_poc_st_curr_after && j < ARRAY_SIZE(list0); i++)
-		list0[j++] = find_ref_pic_index(dpb, decode_params->poc_st_curr_after[i]);
+		list0[j++] = decode_params->poc_st_curr_after[i];
 	for (i = 0; i < decode_params->num_poc_lt_curr && j < ARRAY_SIZE(list0); i++)
-		list0[j++] = find_ref_pic_index(dpb, decode_params->poc_lt_curr[i]);
+		list0[j++] = decode_params->poc_lt_curr[i];
 
 	/* Fill the list, copying over and over */
 	i = 0;
@@ -338,11 +325,11 @@ static void set_ref_pic_list(struct hantro_ctx *ctx)
 
 	j = 0;
 	for (i = 0; i < decode_params->num_poc_st_curr_after && j < ARRAY_SIZE(list1); i++)
-		list1[j++] = find_ref_pic_index(dpb, decode_params->poc_st_curr_after[i]);
+		list1[j++] = decode_params->poc_st_curr_after[i];
 	for (i = 0; i < decode_params->num_poc_st_curr_before && j < ARRAY_SIZE(list1); i++)
-		list1[j++] = find_ref_pic_index(dpb, decode_params->poc_st_curr_before[i]);
+		list1[j++] = decode_params->poc_st_curr_before[i];
 	for (i = 0; i < decode_params->num_poc_lt_curr && j < ARRAY_SIZE(list1); i++)
-		list1[j++] = find_ref_pic_index(dpb, decode_params->poc_lt_curr[i]);
+		list1[j++] = decode_params->poc_lt_curr[i];
 
 	i = 0;
 	while (j < ARRAY_SIZE(list1))
-- 
2.35.1



