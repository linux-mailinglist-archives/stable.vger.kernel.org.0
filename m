Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DAE4916E0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344540AbiARCgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343993AbiARCeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:34:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73768C061392;
        Mon, 17 Jan 2022 18:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29E9611A5;
        Tue, 18 Jan 2022 02:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADC2C36AEB;
        Tue, 18 Jan 2022 02:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473164;
        bh=sSEVS1zk0Dl1JuiVm6zEkJ5WAzfZPSu9TTNRcXnze8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzmh1GQqo0ZPlmuD0y4VknpbTb04Nx0Q12IxhxGt7kY+VrkRQND0FZaPnI8ifhifA
         mXTsQv7TC7w12CEtYNMfirsCbegE6dZsyC5Yd8NQbuY+MVbuza6CkdEMkT0YhF8kgq
         7lX2iMFyiqb44r3y7Q9SaVUCMBOOWCHVl5yHMVyW7xjqLD28DFaKRpCMrEsZPOy1Vh
         sAMKfIPJO9SJr0fALPqOJB1bGgQ6jAlrp3gzfEabro9GcO5l8GFqohnzbR0oD4V0HT
         qe4Q9kdIwCxvOSAIQgnCNMrhTiHRoycj1Ek9BXuCdYOT6dLNASDWuQjY8I5FT4ayAu
         zn5niotRdH/0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, hverkuil-cisco@xs4all.nl,
        arnd@arndb.de, tomi.valkeinen@ideasonboard.com,
        alex.dewar90@gmail.com, alinesantanacordeiro@gmail.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        alan@linux.intel.com, peterz@infradead.org, kaixuxia@tencent.com,
        tglx@linutronix.de, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 014/188] media: atomisp: add NULL check for asd obtained from atomisp_video_pipe
Date:   Mon, 17 Jan 2022 21:28:58 -0500
Message-Id: <20220118023152.1948105-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit c10bcb13462e9cf43111d17f1e08b4bb4d4401b0 ]

This is almost a BUG report with RFC patch that just avoids kernel
oopses. Thus, prefixed with [BUG][RFC].

Here is the kernel log after running `v4l2-compliance -d /dev/video4`
with this patch applied:

	kern  :err   : [25507.580392] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.592343] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.592995] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.593685] atomisp-isp2 0000:00:03.0: atomisp_g_input(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.593719] atomisp-isp2 0000:00:03.0: atomisp_g_parm(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.593727] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	[omitting 42 same messages]
	kern  :err   : [25507.593976] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594191] atomisp-isp2 0000:00:03.0: atomisp_g_input(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594449] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	[omitting 43 same messages]
	kern  :err   : [25507.594756] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594779] atomisp-isp2 0000:00:03.0: atomisp_g_ctrl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594787] atomisp-isp2 0000:00:03.0: atomisp_s_ctrl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594803] atomisp-isp2 0000:00:03.0: atomisp_camera_g_ext_ctrls(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594880] atomisp-isp2 0000:00:03.0: atomisp_enum_fmt_cap(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.594915] atomisp-isp2 0000:00:03.0: atomisp_g_parm(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.595058] atomisp-isp2 0000:00:03.0: atomisp_try_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.595089] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.595124] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.595221] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.595241] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.601571] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.607496] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.608604] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.611988] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.617420] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.618429] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.618811] atomisp-isp2 0000:00:03.0: atomisp_g_parm(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.622193] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.627355] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.628391] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.631143] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.635813] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.636489] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.636504] atomisp-isp2 0000:00:03.0: atomisp_s_input(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.636516] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.639111] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.646152] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.646831] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.646847] atomisp-isp2 0000:00:03.0: atomisp_s_input(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.650079] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.657476] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.658741] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.658759] atomisp-isp2 0000:00:03.0: atomisp_s_input(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.658771] atomisp-isp2 0000:00:03.0: atomisp_set_fmt(): asd is NULL, device is ATOMISP ISP ACC
	kern  :err   : [25507.660959] atomisp-isp2 0000:00:03.0: can't change power state from D3cold to D0 (config space inaccessible)
	kern  :warn  : [25507.666665] isys dma store at addr(0xcd408) val(0)
	kern  :err   : [25507.667397] atomisp-isp2 0000:00:03.0: atomisp_queryctl(): asd is NULL, device is ATOMISP ISP ACC

[mchehab: fix coding style]
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_cmd.c   | 73 +++++++++++++++
 .../staging/media/atomisp/pci/atomisp_fops.c  |  6 ++
 .../staging/media/atomisp/pci/atomisp_ioctl.c | 90 +++++++++++++++++++
 3 files changed, 169 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 366161cff5602..75a531667d743 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -1715,6 +1715,12 @@ void atomisp_wdt_refresh_pipe(struct atomisp_video_pipe *pipe,
 {
 	unsigned long next;
 
+	if (!pipe->asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, pipe->vdev.name);
+		return;
+	}
+
 	if (delay != ATOMISP_WDT_KEEP_CURRENT_DELAY)
 		pipe->wdt_duration = delay;
 
@@ -1777,6 +1783,12 @@ void atomisp_wdt_refresh(struct atomisp_sub_device *asd, unsigned int delay)
 /* ISP2401 */
 void atomisp_wdt_stop_pipe(struct atomisp_video_pipe *pipe, bool sync)
 {
+	if (!pipe->asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, pipe->vdev.name);
+		return;
+	}
+
 	if (!atomisp_is_wdt_running(pipe))
 		return;
 
@@ -4109,6 +4121,12 @@ void atomisp_handle_parameter_and_buffer(struct atomisp_video_pipe *pipe)
 	unsigned long irqflags;
 	bool need_to_enqueue_buffer = false;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, pipe->vdev.name);
+		return;
+	}
+
 	if (atomisp_is_vf_pipe(pipe))
 		return;
 
@@ -4196,6 +4214,12 @@ int atomisp_set_parameters(struct video_device *vdev,
 	struct atomisp_css_params *css_param = &asd->params.css_param;
 	int ret;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (!asd->stream_env[ATOMISP_INPUT_STREAM_GENERAL].stream) {
 		dev_err(asd->isp->dev, "%s: internal error!\n", __func__);
 		return -EINVAL;
@@ -4857,6 +4881,12 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_pix_format *f,
 	int source_pad = atomisp_subdev_source_pad(vdev);
 	int ret;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (!isp->inputs[asd->input_curr].camera)
 		return -EINVAL;
 
@@ -5198,6 +5228,12 @@ static int atomisp_set_fmt_to_isp(struct video_device *vdev,
 	const struct atomisp_in_fmt_conv *fc;
 	int ret, i;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	v4l2_fh_init(&fh.vfh, vdev);
 
 	isp_sink_crop = atomisp_subdev_get_rect(
@@ -5494,6 +5530,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 				  unsigned int dvs_env_w, unsigned int dvs_env_h)
 {
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
+	struct atomisp_video_pipe *pipe = atomisp_to_video_pipe(vdev);
 	const struct atomisp_format_bridge *format;
 	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_state pad_state = {
@@ -5512,6 +5549,12 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 	struct v4l2_subdev_fh fh;
 	int ret;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	v4l2_fh_init(&fh.vfh, vdev);
 
 	stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
@@ -5602,6 +5645,12 @@ int atomisp_set_fmt(struct video_device *vdev, struct v4l2_format *f)
 	struct v4l2_subdev_fh fh;
 	int ret;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (source_pad >= ATOMISP_SUBDEV_PADS_NUM)
 		return -EINVAL;
 
@@ -6034,6 +6083,12 @@ int atomisp_set_fmt_file(struct video_device *vdev, struct v4l2_format *f)
 	struct v4l2_subdev_fh fh;
 	int ret;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	v4l2_fh_init(&fh.vfh, vdev);
 
 	dev_dbg(isp->dev, "setting fmt %ux%u 0x%x for file inject\n",
@@ -6359,6 +6414,12 @@ bool atomisp_is_vf_pipe(struct atomisp_video_pipe *pipe)
 {
 	struct atomisp_sub_device *asd = pipe->asd;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, pipe->vdev.name);
+		return false;
+	}
+
 	if (pipe == &asd->video_out_vf)
 		return true;
 
@@ -6572,6 +6633,12 @@ static int atomisp_get_pipe_id(struct atomisp_video_pipe *pipe)
 {
 	struct atomisp_sub_device *asd = pipe->asd;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, pipe->vdev.name);
+		return -EINVAL;
+	}
+
 	if (ATOMISP_USE_YUVPP(asd)) {
 		return IA_CSS_PIPE_ID_YUVPP;
 	} else if (asd->vfpp->val == ATOMISP_VFPP_DISABLE_SCALER) {
@@ -6609,6 +6676,12 @@ int atomisp_get_invalid_frame_num(struct video_device *vdev,
 	struct ia_css_pipe_info p_info;
 	int ret;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (asd->isp->inputs[asd->input_curr].camera_caps->
 	    sensor[asd->sensor_curr].stream_num > 1) {
 		/* External ISP */
diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index f82bf082aa796..02c19b92bdccb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -1171,6 +1171,12 @@ static int atomisp_mmap(struct file *file, struct vm_area_struct *vma)
 	u32 origin_size, new_size;
 	int ret;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (!(vma->vm_flags & (VM_WRITE | VM_READ)))
 		return -EACCES;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index c8a625667e81e..a57e640fbf791 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -646,6 +646,12 @@ static int atomisp_g_input(struct file *file, void *fh, unsigned int *input)
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
 	*input = asd->input_curr;
 	rt_mutex_unlock(&isp->mutex);
@@ -665,6 +671,12 @@ static int atomisp_s_input(struct file *file, void *fh, unsigned int input)
 	struct v4l2_subdev *motor;
 	int ret;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
 	if (input >= ATOM_ISP_MAX_INPUTS || input >= isp->input_cnt) {
 		dev_dbg(isp->dev, "input_cnt: %d\n", isp->input_cnt);
@@ -765,6 +777,12 @@ static int atomisp_enum_fmt_cap(struct file *file, void *fh,
 	unsigned int i, fi = 0;
 	int rval;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
 	rval = v4l2_subdev_call(isp->inputs[asd->input_curr].camera, pad,
 				enum_mbus_code, NULL, &code);
@@ -1027,6 +1045,12 @@ int __atomisp_reqbufs(struct file *file, void *fh,
 	u16 stream_id = atomisp_source_pad_to_stream_id(asd, source_pad);
 	int ret = 0, i = 0;
 
+	if (!asd) {
+		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (req->count == 0) {
 		mutex_lock(&pipe->capq.vb_lock);
 		if (!list_empty(&pipe->capq.stream))
@@ -1154,6 +1178,12 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	u32 pgnr;
 	int ret = 0;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
 	if (isp->isp_fatal_error) {
 		ret = -EIO;
@@ -1389,6 +1419,12 @@ static int atomisp_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	int ret = 0;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	rt_mutex_lock(&isp->mutex);
 
 	if (isp->isp_fatal_error) {
@@ -1640,6 +1676,12 @@ static int atomisp_streamon(struct file *file, void *fh,
 	int ret = 0;
 	unsigned long irqflags;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	dev_dbg(isp->dev, "Start stream on pad %d for asd%d\n",
 		atomisp_subdev_source_pad(vdev), asd->index);
 
@@ -1901,6 +1943,12 @@ int __atomisp_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	unsigned long flags;
 	bool first_streamoff = false;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	dev_dbg(isp->dev, "Stop stream on pad %d for asd%d\n",
 		atomisp_subdev_source_pad(vdev), asd->index);
 
@@ -2150,6 +2198,12 @@ static int atomisp_g_ctrl(struct file *file, void *fh,
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	int i, ret = -EINVAL;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < ctrls_num; i++) {
 		if (ci_v4l2_controls[i].id == control->id) {
 			ret = 0;
@@ -2229,6 +2283,12 @@ static int atomisp_s_ctrl(struct file *file, void *fh,
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 	int i, ret = -EINVAL;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < ctrls_num; i++) {
 		if (ci_v4l2_controls[i].id == control->id) {
 			ret = 0;
@@ -2310,6 +2370,12 @@ static int atomisp_queryctl(struct file *file, void *fh,
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	switch (qc->id) {
 	case V4L2_CID_FOCUS_ABSOLUTE:
 	case V4L2_CID_FOCUS_RELATIVE:
@@ -2355,6 +2421,12 @@ static int atomisp_camera_g_ext_ctrls(struct file *file, void *fh,
 	int i;
 	int ret = 0;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (!IS_ISP2401)
 		motor = isp->inputs[asd->input_curr].motor;
 	else
@@ -2466,6 +2538,12 @@ static int atomisp_camera_s_ext_ctrls(struct file *file, void *fh,
 	int i;
 	int ret = 0;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (!IS_ISP2401)
 		motor = isp->inputs[asd->input_curr].motor;
 	else
@@ -2591,6 +2669,12 @@ static int atomisp_g_parm(struct file *file, void *fh,
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	struct atomisp_device *isp = video_get_drvdata(vdev);
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		dev_err(isp->dev, "unsupported v4l2 buf type\n");
 		return -EINVAL;
@@ -2613,6 +2697,12 @@ static int atomisp_s_parm(struct file *file, void *fh,
 	int rval;
 	int fps;
 
+	if (!asd) {
+		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
+			__func__, vdev->name);
+		return -EINVAL;
+	}
+
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		dev_err(isp->dev, "unsupported v4l2 buf type\n");
 		return -EINVAL;
-- 
2.34.1

