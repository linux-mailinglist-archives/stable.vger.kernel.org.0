Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0815940CB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiHOVJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347966AbiHOVHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C44A2D1ED;
        Mon, 15 Aug 2022 12:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12BAACE1087;
        Mon, 15 Aug 2022 19:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1816CC433D6;
        Mon, 15 Aug 2022 19:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591027;
        bh=FARaVPvRMXStF/MY3YQIh2YsGGkPGTewGxsp8JT6BLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKSuebbdCDpG/L6A32kPWEL+0quW9rmFS0v414egat5bd8krIV/FYdaLsWzgl0tZ6
         OjDlgT0hdp5iYZJ/b7bStKKuIa1afylE1bERK2bO1TMDse5krgIqfn+boqDwinyNhH
         x35tipVvVLL1xqNHSj/gH4yOzNte8E2drJ3VL9f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0431/1095] media: amphion: defer setting last_buffer_dequeued until resolution changes are processed
Date:   Mon, 15 Aug 2022 19:57:10 +0200
Message-Id: <20220815180447.528837559@linuxfoundation.org>
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

[ Upstream commit afba6e20801ad9a2f863c52c21e609e021269d83 ]

Don't set last_buffer_dequeued during dynamic resolution change,
otherwise it may be cleared in handling resolution change,
as streamoff may be called in dynamic resolution change.

Normally, this does not happen.
But we encounter a special testcase,
User issue V4L2_DEC_CMD_STOP after enqueue one buffer
that only contains codec config header, but not any frame data.
So VPU report the parsed resolution, then report the eos event.

So driver should notify user to handle resolution change first,
after it's handled, set the last_buffer_dequeued.
then the user can exit decoding normally.

Otherwise the user may be stalled.

Fixes: 6de8d628df6ef ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c     | 36 ++++++++++++++---------
 drivers/media/platform/amphion/vpu_v4l2.c |  2 +-
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index c0dfede11ab7..a91f88fdb5ef 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -174,16 +174,6 @@ static int vdec_ctrl_init(struct vpu_inst *inst)
 	return 0;
 }
 
-static void vdec_set_last_buffer_dequeued(struct vpu_inst *inst)
-{
-	struct vdec_t *vdec = inst->priv;
-
-	if (vdec->eos_received) {
-		if (!vpu_set_last_buffer_dequeued(inst))
-			vdec->eos_received--;
-	}
-}
-
 static void vdec_handle_resolution_change(struct vpu_inst *inst)
 {
 	struct vdec_t *vdec = inst->priv;
@@ -230,6 +220,21 @@ static int vdec_update_state(struct vpu_inst *inst, enum vpu_codec_state state,
 	return 0;
 }
 
+static void vdec_set_last_buffer_dequeued(struct vpu_inst *inst)
+{
+	struct vdec_t *vdec = inst->priv;
+
+	if (inst->state == VPU_CODEC_STATE_DYAMIC_RESOLUTION_CHANGE)
+		return;
+
+	if (vdec->eos_received) {
+		if (!vpu_set_last_buffer_dequeued(inst)) {
+			vdec->eos_received--;
+			vdec_update_state(inst, VPU_CODEC_STATE_DRAIN, 0);
+		}
+	}
+}
+
 static int vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
 	strscpy(cap->driver, "amphion-vpu", sizeof(cap->driver));
@@ -489,6 +494,8 @@ static int vdec_drain(struct vpu_inst *inst)
 
 static int vdec_cmd_start(struct vpu_inst *inst)
 {
+	struct vdec_t *vdec = inst->priv;
+
 	switch (inst->state) {
 	case VPU_CODEC_STATE_STARTED:
 	case VPU_CODEC_STATE_DRAIN:
@@ -499,6 +506,8 @@ static int vdec_cmd_start(struct vpu_inst *inst)
 		break;
 	}
 	vpu_process_capture_buffer(inst);
+	if (vdec->eos_received)
+		vdec_set_last_buffer_dequeued(inst);
 	return 0;
 }
 
@@ -1188,7 +1197,6 @@ static void vdec_event_eos(struct vpu_inst *inst)
 	vdec->eos_received++;
 	vdec->fixed_fmt = false;
 	inst->min_buffer_cap = VDEC_MIN_BUFFER_CAP;
-	vdec_update_state(inst, VPU_CODEC_STATE_DRAIN, 0);
 	vdec_set_last_buffer_dequeued(inst);
 	vpu_inst_unlock(inst);
 }
@@ -1470,10 +1478,10 @@ static int vdec_stop_session(struct vpu_inst *inst, u32 type)
 		vdec_update_state(inst, VPU_CODEC_STATE_SEEK, 0);
 		vdec->drain = 0;
 	} else {
-		if (inst->state != VPU_CODEC_STATE_DYAMIC_RESOLUTION_CHANGE)
+		if (inst->state != VPU_CODEC_STATE_DYAMIC_RESOLUTION_CHANGE) {
 			vdec_abort(inst);
-
-		vdec->eos_received = 0;
+			vdec->eos_received = 0;
+		}
 		vdec_clear_slots(inst);
 	}
 
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 4183a3994d30..5584b3848107 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -440,8 +440,8 @@ static int vpu_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 		  fmt->sizeimage[1], fmt->bytesperline[1],
 		  fmt->sizeimage[2], fmt->bytesperline[2],
 		  q->num_buffers);
-	ret = call_vop(inst, start, q->type);
 	vb2_clear_last_buffer_dequeued(q);
+	ret = call_vop(inst, start, q->type);
 	if (ret)
 		vpu_vb2_buffers_return(inst, q->type, VB2_BUF_STATE_QUEUED);
 
-- 
2.35.1



