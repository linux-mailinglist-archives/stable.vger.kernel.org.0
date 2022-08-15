Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948165940C5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiHOVKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348056AbiHOVIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4FF2B1A4;
        Mon, 15 Aug 2022 12:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BB0660F6A;
        Mon, 15 Aug 2022 19:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35716C433C1;
        Mon, 15 Aug 2022 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591089;
        bh=lrqtO/qAylreAQQN93DQ6b/hetCpqzJ51B53ZBouAzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4nmJ4+5s3Q7P6eMvZvhnHATbTQDh/lPRdI+ulnaNQRKrmeg7TE5RSRUwYbXE54wc
         S+7HhnWd2aQLSZviQP3wVNeQWlRmqpa17vjQrxUGhr+P5UHIkkiaGRE60atxX0bXEQ
         +jhzWYmiwUYOctr4Ja/EWN5aKfWrOpA9fkBM0r58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0438/1095] media: amphion: decoder copy timestamp from output to capture
Date:   Mon, 15 Aug 2022 19:57:17 +0200
Message-Id: <20220815180447.766847875@linuxfoundation.org>
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

[ Upstream commit a4dca209f23470f20b61b40cca417a5bf6ea8533 ]

copy the timestamp using the helper function
V4L2_BUF_FLAG_TIMESTAMP_COPY

To implement this, driver will keep the output buffer until it's
decoded, in previous, driver will return the output buffer immediately
after copying data to stream buffer.

After that, there is no need to make a workaround for poll function.
driver can use v4l2_m2m_fop_poll directly.
Also, driver don't need to keep a input threshold
as the buffer count is up to only 32.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c       | 76 ++++++++-------------
 drivers/media/platform/amphion/vpu_malone.c |  2 +-
 drivers/media/platform/amphion/vpu_v4l2.c   | 56 +++++++++++++++
 drivers/media/platform/amphion/vpu_v4l2.h   |  3 +
 4 files changed, 87 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index a91f88fdb5ef..052a60189c13 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -26,8 +26,8 @@
 #include "vpu_cmds.h"
 #include "vpu_rpc.h"
 
-#define VDEC_FRAME_DEPTH		256
 #define VDEC_MIN_BUFFER_CAP		8
+#define VDEC_MIN_BUFFER_OUT		8
 
 struct vdec_fs_info {
 	char name[8];
@@ -63,8 +63,6 @@ struct vdec_t {
 	bool is_source_changed;
 	u32 source_change;
 	u32 drain;
-	u32 ts_pre_count;
-	u32 frame_depth;
 };
 
 static const struct vpu_format vdec_formats[] = {
@@ -475,7 +473,7 @@ static int vdec_drain(struct vpu_inst *inst)
 	if (!vdec->drain)
 		return 0;
 
-	if (v4l2_m2m_num_src_bufs_ready(inst->fh.m2m_ctx))
+	if (!vpu_is_source_empty(inst))
 		return 0;
 
 	if (!vdec->params.frame_count) {
@@ -598,11 +596,8 @@ static bool vdec_check_ready(struct vpu_inst *inst, unsigned int type)
 {
 	struct vdec_t *vdec = inst->priv;
 
-	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (vdec->ts_pre_count >= vdec->frame_depth)
-			return false;
+	if (V4L2_TYPE_IS_OUTPUT(type))
 		return true;
-	}
 
 	if (vdec->req_frame_count)
 		return true;
@@ -610,12 +605,21 @@ static bool vdec_check_ready(struct vpu_inst *inst, unsigned int type)
 	return false;
 }
 
+static struct vb2_v4l2_buffer *vdec_get_src_buffer(struct vpu_inst *inst, u32 count)
+{
+	if (count > 1)
+		vpu_skip_frame(inst, count - 1);
+
+	return vpu_next_src_buf(inst);
+}
+
 static int vdec_frame_decoded(struct vpu_inst *inst, void *arg)
 {
 	struct vdec_t *vdec = inst->priv;
 	struct vpu_dec_pic_info *info = arg;
 	struct vpu_vb2_buffer *vpu_buf;
 	struct vb2_v4l2_buffer *vbuf;
+	struct vb2_v4l2_buffer *src_buf;
 	int ret = 0;
 
 	if (!info || info->id >= ARRAY_SIZE(vdec->slots))
@@ -629,14 +633,21 @@ static int vdec_frame_decoded(struct vpu_inst *inst, void *arg)
 		goto exit;
 	}
 	vbuf = &vpu_buf->m2m_buf.vb;
+	src_buf = vdec_get_src_buffer(inst, info->consumed_count);
+	if (src_buf) {
+		v4l2_m2m_buf_copy_metadata(src_buf, vbuf, true);
+		if (info->consumed_count) {
+			v4l2_m2m_src_buf_remove(inst->fh.m2m_ctx);
+			vpu_set_buffer_state(src_buf, VPU_BUF_STATE_IDLE);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+		} else {
+			vpu_set_buffer_state(src_buf, VPU_BUF_STATE_DECODED);
+		}
+	}
 	if (vpu_get_buffer_state(vbuf) == VPU_BUF_STATE_DECODED)
 		dev_info(inst->dev, "[%d] buf[%d] has been decoded\n", inst->id, info->id);
 	vpu_set_buffer_state(vbuf, VPU_BUF_STATE_DECODED);
 	vdec->decoded_frame_count++;
-	if (vdec->ts_pre_count >= info->consumed_count)
-		vdec->ts_pre_count -= info->consumed_count;
-	else
-		vdec->ts_pre_count = 0;
 exit:
 	vpu_inst_unlock(inst);
 
@@ -692,10 +703,9 @@ static void vdec_buf_done(struct vpu_inst *inst, struct vpu_frame_info *frame)
 	vpu_set_buffer_state(vbuf, VPU_BUF_STATE_READY);
 	vb2_set_plane_payload(&vbuf->vb2_buf, 0, inst->cap_format.sizeimage[0]);
 	vb2_set_plane_payload(&vbuf->vb2_buf, 1, inst->cap_format.sizeimage[1]);
-	vbuf->vb2_buf.timestamp = frame->timestamp;
 	vbuf->field = inst->cap_format.field;
 	vbuf->sequence = sequence;
-	dev_dbg(inst->dev, "[%d][OUTPUT TS]%32lld\n", inst->id, frame->timestamp);
+	dev_dbg(inst->dev, "[%d][OUTPUT TS]%32lld\n", inst->id, vbuf->vb2_buf.timestamp);
 
 	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
 	vpu_inst_lock(inst);
@@ -717,7 +727,6 @@ static void vdec_stop_done(struct vpu_inst *inst)
 	vdec->fixed_fmt = false;
 	vdec->params.end_flag = 0;
 	vdec->drain = 0;
-	vdec->ts_pre_count = 0;
 	vdec->params.frame_count = 0;
 	vdec->decoded_frame_count = 0;
 	vdec->display_frame_count = 0;
@@ -1252,18 +1261,14 @@ static int vdec_process_output(struct vpu_inst *inst, struct vb2_buffer *vb)
 	if (free_space < vb2_get_plane_payload(vb, 0) + 0x40000)
 		return -ENOMEM;
 
+	vpu_set_buffer_state(vbuf, VPU_BUF_STATE_INUSE);
 	ret = vpu_iface_input_frame(inst, vb);
 	if (ret < 0)
 		return -ENOMEM;
 
 	dev_dbg(inst->dev, "[%d][INPUT  TS]%32lld\n", inst->id, vb->timestamp);
-	vdec->ts_pre_count++;
 	vdec->params.frame_count++;
 
-	v4l2_m2m_src_buf_remove_by_buf(inst->fh.m2m_ctx, vbuf);
-	vpu_set_buffer_state(vbuf, VPU_BUF_STATE_IDLE);
-	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
-
 	if (vdec->drain)
 		vdec_drain(inst);
 
@@ -1326,7 +1331,6 @@ static void vdec_abort(struct vpu_inst *inst)
 		  vdec->sequence);
 	vdec->params.end_flag = 0;
 	vdec->drain = 0;
-	vdec->ts_pre_count = 0;
 	vdec->params.frame_count = 0;
 	vdec->decoded_frame_count = 0;
 	vdec->display_frame_count = 0;
@@ -1533,10 +1537,6 @@ static int vdec_get_debug_info(struct vpu_inst *inst, char *str, u32 size, u32 i
 				vdec->drain, vdec->eos_received, vdec->source_change);
 		break;
 	case 8:
-		num = scnprintf(str, size, "ts_pre_count = %d, frame_depth = %d\n",
-				vdec->ts_pre_count, vdec->frame_depth);
-		break;
-	case 9:
 		num = scnprintf(str, size, "fps = %d/%d\n",
 				vdec->codec_info.frame_rate.numerator,
 				vdec->codec_info.frame_rate.denominator);
@@ -1570,12 +1570,8 @@ static struct vpu_inst_ops vdec_inst_ops = {
 static void vdec_init(struct file *file)
 {
 	struct vpu_inst *inst = to_inst(file);
-	struct vdec_t *vdec;
 	struct v4l2_format f;
 
-	vdec = inst->priv;
-	vdec->frame_depth = VDEC_FRAME_DEPTH;
-
 	memset(&f, 0, sizeof(f));
 	f.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_H264;
@@ -1620,36 +1616,18 @@ static int vdec_open(struct file *file)
 
 	vdec->fixed_fmt = false;
 	inst->min_buffer_cap = VDEC_MIN_BUFFER_CAP;
+	inst->min_buffer_out = VDEC_MIN_BUFFER_OUT;
 	vdec_init(file);
 
 	return 0;
 }
 
-static __poll_t vdec_poll(struct file *file, poll_table *wait)
-{
-	struct vpu_inst *inst = to_inst(file);
-	struct vb2_queue *src_q, *dst_q;
-	__poll_t ret;
-
-	ret = v4l2_m2m_fop_poll(file, wait);
-	src_q = v4l2_m2m_get_src_vq(inst->fh.m2m_ctx);
-	dst_q = v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx);
-	if (vb2_is_streaming(src_q) && !vb2_is_streaming(dst_q))
-		ret &= (~EPOLLERR);
-	if (!src_q->error && !dst_q->error &&
-	    (vb2_is_streaming(src_q) && list_empty(&src_q->queued_list)) &&
-	    (vb2_is_streaming(dst_q) && list_empty(&dst_q->queued_list)))
-		ret &= (~EPOLLERR);
-
-	return ret;
-}
-
 static const struct v4l2_file_operations vdec_fops = {
 	.owner = THIS_MODULE,
 	.open = vdec_open,
 	.release = vpu_v4l2_close,
 	.unlocked_ioctl = video_ioctl2,
-	.poll = vdec_poll,
+	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
 };
 
diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index d91be0ece961..5ca8afb60afc 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1558,7 +1558,7 @@ int vpu_malone_input_frame(struct vpu_shared_addr *shared,
 	 * merge the data to next frame
 	 */
 	vbuf = to_vb2_v4l2_buffer(vb);
-	if (vpu_vb_is_codecconfig(vbuf) && (s64)vb->timestamp < 0) {
+	if (vpu_vb_is_codecconfig(vbuf)) {
 		inst->extra_size += size;
 		return 0;
 	}
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 5584b3848107..0f3726c80967 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -127,6 +127,19 @@ int vpu_set_last_buffer_dequeued(struct vpu_inst *inst)
 	return 0;
 }
 
+bool vpu_is_source_empty(struct vpu_inst *inst)
+{
+	struct v4l2_m2m_buffer *buf = NULL;
+
+	if (!inst->fh.m2m_ctx)
+		return true;
+	v4l2_m2m_for_each_src_buf(inst->fh.m2m_ctx, buf) {
+		if (vpu_get_buffer_state(&buf->vb) == VPU_BUF_STATE_IDLE)
+			return false;
+	}
+	return true;
+}
+
 const struct vpu_format *vpu_try_fmt_common(struct vpu_inst *inst, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
@@ -234,6 +247,49 @@ int vpu_process_capture_buffer(struct vpu_inst *inst)
 	return call_vop(inst, process_capture, &vbuf->vb2_buf);
 }
 
+struct vb2_v4l2_buffer *vpu_next_src_buf(struct vpu_inst *inst)
+{
+	struct vb2_v4l2_buffer *src_buf = v4l2_m2m_next_src_buf(inst->fh.m2m_ctx);
+
+	if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
+		return NULL;
+
+	while (vpu_vb_is_codecconfig(src_buf)) {
+		v4l2_m2m_src_buf_remove(inst->fh.m2m_ctx);
+		vpu_set_buffer_state(src_buf, VPU_BUF_STATE_IDLE);
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+
+		src_buf = v4l2_m2m_next_src_buf(inst->fh.m2m_ctx);
+		if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
+			return NULL;
+	}
+
+	return src_buf;
+}
+
+void vpu_skip_frame(struct vpu_inst *inst, int count)
+{
+	struct vb2_v4l2_buffer *src_buf;
+	enum vb2_buffer_state state;
+	int i = 0;
+
+	if (count <= 0)
+		return;
+
+	while (i < count) {
+		src_buf = v4l2_m2m_src_buf_remove(inst->fh.m2m_ctx);
+		if (!src_buf || vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_IDLE)
+			return;
+		if (vpu_get_buffer_state(src_buf) == VPU_BUF_STATE_DECODED)
+			state = VB2_BUF_STATE_DONE;
+		else
+			state = VB2_BUF_STATE_ERROR;
+		i++;
+		vpu_set_buffer_state(src_buf, VPU_BUF_STATE_IDLE);
+		v4l2_m2m_buf_done(src_buf, state);
+	}
+}
+
 struct vb2_v4l2_buffer *vpu_find_buf_by_sequence(struct vpu_inst *inst, u32 type, u32 sequence)
 {
 	struct v4l2_m2m_buffer *buf = NULL;
diff --git a/drivers/media/platform/amphion/vpu_v4l2.h b/drivers/media/platform/amphion/vpu_v4l2.h
index 90fa7ea67495..795ca33a6a50 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.h
+++ b/drivers/media/platform/amphion/vpu_v4l2.h
@@ -19,6 +19,8 @@ int vpu_v4l2_close(struct file *file);
 const struct vpu_format *vpu_try_fmt_common(struct vpu_inst *inst, struct v4l2_format *f);
 int vpu_process_output_buffer(struct vpu_inst *inst);
 int vpu_process_capture_buffer(struct vpu_inst *inst);
+struct vb2_v4l2_buffer *vpu_next_src_buf(struct vpu_inst *inst);
+void vpu_skip_frame(struct vpu_inst *inst, int count);
 struct vb2_v4l2_buffer *vpu_find_buf_by_sequence(struct vpu_inst *inst, u32 type, u32 sequence);
 struct vb2_v4l2_buffer *vpu_find_buf_by_idx(struct vpu_inst *inst, u32 type, u32 idx);
 void vpu_v4l2_set_error(struct vpu_inst *inst);
@@ -27,6 +29,7 @@ int vpu_notify_source_change(struct vpu_inst *inst);
 int vpu_set_last_buffer_dequeued(struct vpu_inst *inst);
 void vpu_vb2_buffers_return(struct vpu_inst *inst, unsigned int type, enum vb2_buffer_state state);
 int vpu_get_num_buffers(struct vpu_inst *inst, u32 type);
+bool vpu_is_source_empty(struct vpu_inst *inst);
 
 dma_addr_t vpu_get_vb_phy_addr(struct vb2_buffer *vb, u32 plane_no);
 unsigned int vpu_get_vb_length(struct vb2_buffer *vb, u32 plane_no);
-- 
2.35.1



