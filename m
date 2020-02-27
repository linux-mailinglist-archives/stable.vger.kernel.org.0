Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932861728B7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgB0Tfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:35:40 -0500
Received: from www.linuxtv.org ([130.149.80.248]:32952 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbgB0Tfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 14:35:40 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j7Ouu-00Cs4F-14; Thu, 27 Feb 2020 19:33:52 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 27 Feb 2020 15:40:59 +0000
Subject: [git:media_tree/master] media: venus: cache vb payload to be used by clock scaling
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j7Ouu-00Cs4F-14@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: cache vb payload to be used by clock scaling
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Thu Feb 13 10:55:14 2020 +0100

Instead of iterate over previously queued buffers in clock
scaling code do cache the payload in instance context structure
for later use when calculating new clock rate.

This will avoid to use spin locks during buffer list iteration
in clock_scaling.

This fixes following kernel Oops:

 Unable to handle kernel paging request at virtual address deacfffffffffd6c
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 [deacfffffffffd6c] address between user and kernel address ranges
 Internal error: Oops: 96000004 [#1] PREEMPT SMP
 CPU: 7 PID: 5763 Comm: V4L2DecoderThre Tainted: G S      W         5.4.11 #8
 pstate: 20400009 (nzCv daif +PAN -UAO)
 pc : load_scale_v4+0x4c/0x2bc [venus_core]
 lr : session_process_buf+0x18c/0x1c0 [venus_core]
 sp : ffffffc01376b8d0
 x29: ffffffc01376b8d0 x28: ffffff80cf1b0220
 x27: ffffffc01376bba0 x26: ffffffd8f562b2d8
 x25: ffffff80cf1b0220 x24: 0000000000000005
 x23: ffffffd8f5620d98 x22: ffffff80ca01c800
 x21: ffffff80cf1b0000 x20: ffffff8149490080
 x19: ffffff8174b2c010 x18: 0000000000000000
 x17: 0000000000000000 x16: ffffffd96ee3a0dc
 x15: 0000000000000026 x14: 0000000000000026
 x13: 00000000000055ac x12: 0000000000000001
 x11: deacfffffffffd6c x10: dead000000000100
 x9 : ffffff80ca01cf28 x8 : 0000000000000026
 x7 : 0000000000000000 x6 : ffffff80cdd899c0
 x5 : ffffff80cdd899c0 x4 : 0000000000000008
 x3 : ffffff80ca01cf28 x2 : ffffff80ca01cf28
 x1 : ffffff80d47ffc00 x0 : ffffff80cf1b0000
 Call trace:
  load_scale_v4+0x4c/0x2bc [venus_core]
  session_process_buf+0x18c/0x1c0 [venus_core]
  venus_helper_vb2_buf_queue+0x7c/0xf0 [venus_core]
  __enqueue_in_driver+0xe4/0xfc [videobuf2_common]
  vb2_core_qbuf+0x15c/0x338 [videobuf2_common]
  vb2_qbuf+0x78/0xb8 [videobuf2_v4l2]
  v4l2_m2m_qbuf+0x80/0xf8 [v4l2_mem2mem]
  v4l2_m2m_ioctl_qbuf+0x2c/0x38 [v4l2_mem2mem]
  v4l_qbuf+0x48/0x58
  __video_do_ioctl+0x2b0/0x39c
  video_usercopy+0x394/0x710
  video_ioctl2+0x38/0x48
  v4l2_ioctl+0x6c/0x80
  do_video_ioctl+0xb00/0x2874
  v4l2_compat_ioctl32+0x5c/0xcc
  __se_compat_sys_ioctl+0x100/0x2074
  __arm64_compat_sys_ioctl+0x20/0x2c
  el0_svc_common+0xa4/0x154
  el0_svc_compat_handler+0x2c/0x38
  el0_svc_compat+0x8/0x10
 Code: eb0a013f 54000200 aa1f03e8 d10e514b (b940016c)
 ---[ end trace e11304b46552e0b9 ]---

Fixes: c0e284ccfeda ("media: venus: Update clock scaling")

Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/core.h    |  1 +
 drivers/media/platform/qcom/venus/helpers.c | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 11585fb3cae3..2f661af7f873 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -344,6 +344,7 @@ struct venus_inst {
 	unsigned int subscriptions;
 	int buf_count;
 	struct venus_ts_metadata tss[VIDEO_MAX_FRAME];
+	unsigned long payloads[VIDEO_MAX_FRAME];
 	u64 fps;
 	struct v4l2_fract timeperframe;
 	const struct venus_format *fmt_out;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index a172f1ac0b35..32f8fb8d7f33 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -544,18 +544,13 @@ static int scale_clocks_v4(struct venus_inst *inst)
 	struct venus_core *core = inst->core;
 	const struct freq_tbl *table = core->res->freq_tbl;
 	unsigned int num_rows = core->res->freq_tbl_size;
-	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
 	struct device *dev = core->dev;
 	unsigned long freq = 0, freq_core1 = 0, freq_core2 = 0;
 	unsigned long filled_len = 0;
-	struct venus_buffer *buf, *n;
-	struct vb2_buffer *vb;
 	int i, ret;
 
-	v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
-		vb = &buf->vb.vb2_buf;
-		filled_len = max(filled_len, vb2_get_plane_payload(vb, 0));
-	}
+	for (i = 0; i < inst->num_input_bufs; i++)
+		filled_len = max(filled_len, inst->payloads[i]);
 
 	if (inst->session_type == VIDC_SESSION_TYPE_DEC && !filled_len)
 		return 0;
@@ -1289,6 +1284,15 @@ int venus_helper_vb2_buf_prepare(struct vb2_buffer *vb)
 }
 EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_prepare);
 
+static void cache_payload(struct venus_inst *inst, struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	unsigned int idx = vbuf->vb2_buf.index;
+
+	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->payloads[idx] = vb2_get_plane_payload(vb, 0);
+}
+
 void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -1300,6 +1304,8 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 
 	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
 
+	cache_payload(inst, vb);
+
 	if (inst->session_type == VIDC_SESSION_TYPE_ENC &&
 	    !(inst->streamon_out && inst->streamon_cap))
 		goto unlock;
