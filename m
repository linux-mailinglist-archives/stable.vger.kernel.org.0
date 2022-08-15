Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0A9594740
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbiHOX4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355444AbiHOXwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D811695AE2;
        Mon, 15 Aug 2022 13:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D501E60F9F;
        Mon, 15 Aug 2022 20:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CFBC433C1;
        Mon, 15 Aug 2022 20:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594619;
        bh=TMDXt7jtDWdicJEzEyNkxrX+6SxG2YI30o1x7P3pwRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWAgvWB0X2Mq08kSaMemthiYQ/ywv4MLea8moKrfrFG47YWj9cRsbpXkvqQCCMMgx
         Od/qUEiQV0sHZTxbyDsH+IERjyHF1LYySX2mgv14at/i6CStpY2GgKNanjspJ7HaKa
         AZ2/J/Z4sBEaztezUaTuICj2g7EmscQLE60cwxqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0505/1157] media: cedrus: h265: Fix logic for not low delay flag
Date:   Mon, 15 Aug 2022 19:57:41 +0200
Message-Id: <20220815180459.897601855@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit f1a413902aa71044b6ec41265e5e28ebaf29a9ce ]

Now that we know real purpose of "not low delay" flag, logic for
applying this flag should be fixed too. According to vendor and
reference implementation, low delay is signaled when POC of current
frame is lower than POC of at least one reference of a slice.

Implement mentioned logic and invert it to conform to flag meaning. Also
don't apply flag for I frames. They don't have any reference.

This fixes decoding of 3 reference bitstreams.

Fixes: 86caab29da78 ("media: cedrus: Add HEVC/H.265 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/sunxi/cedrus/cedrus_h265.c  | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index c26e515d64c9..2f6404fccd5a 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -301,6 +301,31 @@ static void cedrus_h265_write_scaling_list(struct cedrus_ctx *ctx,
 		}
 }
 
+static int cedrus_h265_is_low_delay(struct cedrus_run *run)
+{
+	const struct v4l2_ctrl_hevc_slice_params *slice_params;
+	const struct v4l2_hevc_dpb_entry *dpb;
+	s32 poc;
+	int i;
+
+	slice_params = run->h265.slice_params;
+	poc = run->h265.decode_params->pic_order_cnt_val;
+	dpb = run->h265.decode_params->dpb;
+
+	for (i = 0; i < slice_params->num_ref_idx_l0_active_minus1 + 1; i++)
+		if (dpb[slice_params->ref_idx_l0[i]].pic_order_cnt_val > poc)
+			return 1;
+
+	if (slice_params->slice_type != V4L2_HEVC_SLICE_TYPE_B)
+		return 0;
+
+	for (i = 0; i < slice_params->num_ref_idx_l1_active_minus1 + 1; i++)
+		if (dpb[slice_params->ref_idx_l1[i]].pic_order_cnt_val > poc)
+			return 1;
+
+	return 0;
+}
+
 static void cedrus_h265_setup(struct cedrus_ctx *ctx,
 			      struct cedrus_run *run)
 {
@@ -571,7 +596,7 @@ static void cedrus_h265_setup(struct cedrus_ctx *ctx,
 				V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED,
 				slice_params->flags);
 
-	if (decode_params->num_poc_st_curr_after == 0)
+	if (slice_params->slice_type != V4L2_HEVC_SLICE_TYPE_I && !cedrus_h265_is_low_delay(run))
 		reg |= VE_DEC_H265_DEC_SLICE_HDR_INFO1_FLAG_SLICE_NOT_LOW_DELAY;
 
 	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO1, reg);
-- 
2.35.1



