Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21295941A0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244121AbiHOVJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347921AbiHOVHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991D452DEB;
        Mon, 15 Aug 2022 12:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527E8B8107A;
        Mon, 15 Aug 2022 19:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FE8C433D6;
        Mon, 15 Aug 2022 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590999;
        bh=I4ETvaEm4sUKUXphFN714e6JCy6rpYt8iACWLUxC0qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFaloL8DuvdgEx9iEm25KZ1N7ekLMmdhUC62riCoPFtjRmZUfp+UkTmOURY0ZDD2h
         2awwPDn4qsBi4Rkpq4cMLQaL2UP0wkeRRKqjfq+04JPsAmJvJmHySdPt6Ys+/Hs7tM
         renudEWXQF2TtxWU28J9zw/R3f6YOrHJzzEi9Xi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0440/1095] media: amphion: only insert the first sequence startcode for vc1l format
Date:   Mon, 15 Aug 2022 19:57:19 +0200
Message-Id: <20220815180447.856313194@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit e670f5d672ef3d00b0b8c69eff09a019e6dd4ef9 ]

For format V4L2_PIX_FMT_VC1_ANNEX_L,
the amphion vpu requires driver to help insert some custom startcode
before sequence and frame.
but only the first sequence startcode is needed,
the extra startcode will cause decoding error.
So after seek, we don't need to insert the sequence startcode.

In other words, for V4L2_PIX_FMT_VC1_ANNEX_L,
the vpu doesn't support dynamic resolution change.

Fixes: 145e936380edb ("media: amphion: implement malone decoder rpc interface")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c       | 2 +-
 drivers/media/platform/amphion/vpu.h        | 1 +
 drivers/media/platform/amphion/vpu_malone.c | 2 ++
 drivers/media/platform/amphion/vpu_rpc.h    | 7 ++++++-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index dd7ea23902c0..36450a2e85c9 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -105,7 +105,6 @@ static const struct vpu_format vdec_formats[] = {
 		.pixfmt = V4L2_PIX_FMT_VC1_ANNEX_L,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-		.flags = V4L2_FMT_FLAG_DYN_RESOLUTION
 	},
 	{
 		.pixfmt = V4L2_PIX_FMT_MPEG2,
@@ -735,6 +734,7 @@ static void vdec_stop_done(struct vpu_inst *inst)
 	vdec->eos_received = 0;
 	vdec->is_source_changed = false;
 	vdec->source_change = 0;
+	inst->total_input_count = 0;
 	vpu_inst_unlock(inst);
 }
 
diff --git a/drivers/media/platform/amphion/vpu.h b/drivers/media/platform/amphion/vpu.h
index e56b96a7e5d3..f914de6ed81e 100644
--- a/drivers/media/platform/amphion/vpu.h
+++ b/drivers/media/platform/amphion/vpu.h
@@ -258,6 +258,7 @@ struct vpu_inst {
 	struct vpu_format cap_format;
 	u32 min_buffer_cap;
 	u32 min_buffer_out;
+	u32 total_input_count;
 
 	struct v4l2_rect crop;
 	u32 colorspace;
diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index 5ca8afb60afc..7f591805c48c 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1296,6 +1296,8 @@ static int vpu_malone_insert_scode_vc1_l_seq(struct malone_scode_t *scode)
 	int size = 0;
 	u8 rcv_seqhdr[MALONE_VC1_RCV_SEQ_HEADER_LEN];
 
+	if (scode->inst->total_input_count)
+		return 0;
 	scode->need_data = 0;
 
 	ret = vpu_malone_insert_scode_seq(scode, MALONE_CODEC_ID_VC1_SIMPLE, sizeof(rcv_seqhdr));
diff --git a/drivers/media/platform/amphion/vpu_rpc.h b/drivers/media/platform/amphion/vpu_rpc.h
index 25119e5e807e..7eb6f01e6ab5 100644
--- a/drivers/media/platform/amphion/vpu_rpc.h
+++ b/drivers/media/platform/amphion/vpu_rpc.h
@@ -312,11 +312,16 @@ static inline int vpu_iface_input_frame(struct vpu_inst *inst,
 					struct vb2_buffer *vb)
 {
 	struct vpu_iface_ops *ops = vpu_core_get_iface(inst->core);
+	int ret;
 
 	if (!ops || !ops->input_frame)
 		return -EINVAL;
 
-	return ops->input_frame(inst->core->iface, inst, vb);
+	ret = ops->input_frame(inst->core->iface, inst, vb);
+	if (ret < 0)
+		return ret;
+	inst->total_input_count++;
+	return ret;
 }
 
 static inline int vpu_iface_config_memory_resource(struct vpu_inst *inst,
-- 
2.35.1



