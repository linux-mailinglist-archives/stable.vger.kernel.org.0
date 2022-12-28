Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B07657B94
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiL1PXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiL1PXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B713FB7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 673FC6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790D2C433EF;
        Wed, 28 Dec 2022 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240988;
        bh=5HQacZ2qBZ7VSrqJ4yUk8JobCyX07jK7Rhb5tvtgnwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmWnAQK5SphDIvj/P0YEMfcXUyNIo7WxcZR1GIbE+pkHtbrJ4Ik9ZPDmUMYmYAqMW
         atOvf/u9ssycJHryxOteL1i7rx1gFSRHr2XCchNwrtUCdBGsLb7CQrKaKzG7RTbJEw
         GMtY+nx+HZ2WSACJgaGJiqJNEgvzmkA9cPxZ5mhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0227/1073] media: amphion: reset instance if its aborted before codec header parsed
Date:   Wed, 28 Dec 2022 15:30:15 +0100
Message-Id: <20221228144334.190654482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 3984ea32e83bcad06b4b034ddd4b0a934c1b2f91 ]

there is hardware limitation that if it's aborted before
the first codec header parsed, the codec may be stalled
unless we do reset codec.

and drop the source change event if it's triggered after reset.

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index feb75dc204de..84c90ce265f2 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -753,6 +753,9 @@ static bool vdec_check_source_change(struct vpu_inst *inst)
 	if (!inst->fh.m2m_ctx)
 		return false;
 
+	if (vdec->reset_codec)
+		return false;
+
 	if (!vb2_is_streaming(v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx)))
 		return true;
 	fmt = vpu_helper_find_format(inst, inst->cap_format.type, vdec->codec_info.pixfmt);
@@ -1088,7 +1091,8 @@ static void vdec_event_seq_hdr(struct vpu_inst *inst, struct vpu_dec_codec_info
 		vdec->seq_tag = vdec->codec_info.tag;
 		if (vdec->is_source_changed) {
 			vdec_update_state(inst, VPU_CODEC_STATE_DYAMIC_RESOLUTION_CHANGE, 0);
-			vpu_notify_source_change(inst);
+			vdec->source_change++;
+			vdec_handle_resolution_change(inst);
 			vdec->is_source_changed = false;
 		}
 	}
@@ -1335,6 +1339,8 @@ static void vdec_abort(struct vpu_inst *inst)
 		  vdec->decoded_frame_count,
 		  vdec->display_frame_count,
 		  vdec->sequence);
+	if (!vdec->seq_hdr_found)
+		vdec->reset_codec = true;
 	vdec->params.end_flag = 0;
 	vdec->drain = 0;
 	vdec->params.frame_count = 0;
@@ -1342,6 +1348,7 @@ static void vdec_abort(struct vpu_inst *inst)
 	vdec->display_frame_count = 0;
 	vdec->sequence = 0;
 	vdec->aborting = false;
+	inst->extra_size = 0;
 }
 
 static void vdec_stop(struct vpu_inst *inst, bool free)
@@ -1464,8 +1471,7 @@ static int vdec_start_session(struct vpu_inst *inst, u32 type)
 	}
 
 	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (inst->state == VPU_CODEC_STATE_SEEK)
-			vdec_update_state(inst, vdec->state, 1);
+		vdec_update_state(inst, vdec->state, 1);
 		vdec->eos_received = 0;
 		vpu_process_output_buffer(inst);
 	} else {
@@ -1629,6 +1635,7 @@ static int vdec_open(struct file *file)
 		return ret;
 
 	vdec->fixed_fmt = false;
+	vdec->state = VPU_CODEC_STATE_ACTIVE;
 	inst->min_buffer_cap = VDEC_MIN_BUFFER_CAP;
 	inst->min_buffer_out = VDEC_MIN_BUFFER_OUT;
 	vdec_init(file);
-- 
2.35.1



