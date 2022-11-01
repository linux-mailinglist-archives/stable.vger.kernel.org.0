Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B166148C0
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKAL3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiKAL2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BDB2654;
        Tue,  1 Nov 2022 04:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C90B81CA2;
        Tue,  1 Nov 2022 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C6EC433D7;
        Tue,  1 Nov 2022 11:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302103;
        bh=iBkV3olurwTaihj0mgZ+5qn8JzNQZz0+WarGsJntArs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvCnfEnSnB3VVBNQ8LtWzSl7lo9zhWNYNMLjF/rHCCZUoqyLVnmcfz6s6B5FgAjRQ
         erfgFU6ft684fnITexQrXRpv+4HpYRoLk+WuxQkzSpw3ws2uiwSVpkzY9E2qb7vlai
         bdoUh4rT6xhNVKeYsSdZJUpk4fMTLQ38CEJCAzHP+mz5DJUlfMe4bu1R2DJpiUgBvC
         5ruWKYWDoRhjUpSr+WuzOojBjL2t0E56ZcyXFlax9DN8Xm3BpYgdLuui5hXAgUt8D5
         gJ+W3oABXwcBPVJWL7HSZuTj9hNNx05t+BT1At7zrRyxyHUdBbh23rwup5w9LLDSIy
         cdurVJDXfDSnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        kitakar@gmail.com, xiam0nd.tong@gmail.com, alan@linux.intel.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 19/34] media: atomisp: Fix locking around asd->streaming read/write
Date:   Tue,  1 Nov 2022 07:27:11 -0400
Message-Id: <20221101112726.799368-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2468083f799eb9eef7b03f48ebb9673ad5655f88 ]

For reading / writing the asd->streaming enum the following rules
should be followed:

1. Writers of streaming must hold both isp->mutex and isp->lock.
2. Readers of streaming need to hold only one of the two locks.

Not all writers where properly taking both locks this fixes this.

In the case of the readers, many readers depend on their caller
to hold isp->mutex, add asserts for this

And in the case of atomisp_css_get_dis_stat() it is called with
isp->mutex held, so there is no need to take the spinlock just
for reading the streaming value.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_cmd.c   | 32 +++++++++++++++++--
 .../media/atomisp/pci/atomisp_compat_css20.c  | 10 +++---
 .../staging/media/atomisp/pci/atomisp_fops.c  |  3 ++
 .../media/atomisp/pci/atomisp_internal.h      |  2 +-
 .../staging/media/atomisp/pci/atomisp_ioctl.c |  4 +++
 .../media/atomisp/pci/atomisp_subdev.c        |  8 ++++-
 .../media/atomisp/pci/atomisp_subdev.h        |  6 +++-
 7 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index db6465756e49..4d5c7328610f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -908,6 +908,8 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 	struct v4l2_control ctrl;
 	bool reset_wdt_timer = false;
 
+	lockdep_assert_held(&isp->mutex);
+
 	if (
 	    buf_type != IA_CSS_BUFFER_TYPE_METADATA &&
 	    buf_type != IA_CSS_BUFFER_TYPE_3A_STATISTICS &&
@@ -1307,6 +1309,9 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 	bool stream_restart[MAX_STREAM_NUM] = {0};
 	bool depth_mode = false;
 	int i, ret, depth_cnt = 0;
+	unsigned long flags;
+
+	lockdep_assert_held(&isp->mutex);
 
 	if (!isp->sw_contex.file_input)
 		atomisp_css_irq_enable(isp,
@@ -1331,7 +1336,9 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 
 		stream_restart[asd->index] = true;
 
+		spin_lock_irqsave(&isp->lock, flags);
 		asd->streaming = ATOMISP_DEVICE_STREAMING_STOPPING;
+		spin_unlock_irqrestore(&isp->lock, flags);
 
 		/* stream off sensor */
 		ret = v4l2_subdev_call(
@@ -1346,7 +1353,9 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 		css_pipe_id = atomisp_get_css_pipe_id(asd);
 		atomisp_css_stop(asd, css_pipe_id, true);
 
+		spin_lock_irqsave(&isp->lock, flags);
 		asd->streaming = ATOMISP_DEVICE_STREAMING_DISABLED;
+		spin_unlock_irqrestore(&isp->lock, flags);
 
 		asd->preview_exp_id = 1;
 		asd->postview_exp_id = 1;
@@ -1387,11 +1396,14 @@ static void __atomisp_css_recover(struct atomisp_device *isp, bool isp_timeout)
 						   IA_CSS_INPUT_MODE_BUFFERED_SENSOR);
 
 		css_pipe_id = atomisp_get_css_pipe_id(asd);
-		if (atomisp_css_start(asd, css_pipe_id, true))
+		if (atomisp_css_start(asd, css_pipe_id, true)) {
 			dev_warn(isp->dev,
 				 "start SP failed, so do not set streaming to be enable!\n");
-		else
+		} else {
+			spin_lock_irqsave(&isp->lock, flags);
 			asd->streaming = ATOMISP_DEVICE_STREAMING_ENABLED;
+			spin_unlock_irqrestore(&isp->lock, flags);
+		}
 
 		atomisp_csi2_configure(asd);
 	}
@@ -1627,6 +1639,8 @@ void atomisp_css_flush(struct atomisp_device *isp)
 {
 	int i;
 
+	lockdep_assert_held(&isp->mutex);
+
 	if (!atomisp_streaming_count(isp))
 		return;
 
@@ -4077,6 +4091,8 @@ void atomisp_handle_parameter_and_buffer(struct atomisp_video_pipe *pipe)
 	unsigned long irqflags;
 	bool need_to_enqueue_buffer = false;
 
+	lockdep_assert_held(&asd->isp->mutex);
+
 	if (!asd) {
 		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
 			__func__, pipe->vdev.name);
@@ -4170,6 +4186,8 @@ int atomisp_set_parameters(struct video_device *vdev,
 	struct atomisp_css_params *css_param = &asd->params.css_param;
 	int ret;
 
+	lockdep_assert_held(&asd->isp->mutex);
+
 	if (!asd) {
 		dev_err(pipe->isp->dev, "%s(): asd is NULL, device is %s\n",
 			__func__, vdev->name);
@@ -5604,6 +5622,8 @@ int atomisp_set_fmt(struct video_device *vdev, struct v4l2_format *f)
 	struct v4l2_subdev_fh fh;
 	int ret;
 
+	lockdep_assert_held(&isp->mutex);
+
 	if (!asd) {
 		dev_err(isp->dev, "%s(): asd is NULL, device is %s\n",
 			__func__, vdev->name);
@@ -6275,6 +6295,8 @@ int atomisp_offline_capture_configure(struct atomisp_sub_device *asd,
 {
 	struct v4l2_ctrl *c;
 
+	lockdep_assert_held(&asd->isp->mutex);
+
 	/*
 	* In case of M10MO ZSL capture case, we need to issue a separate
 	* capture request to M10MO which will output captured jpeg image
@@ -6549,6 +6571,8 @@ int atomisp_exp_id_capture(struct atomisp_sub_device *asd, int *exp_id)
 	int value = *exp_id;
 	int ret;
 
+	lockdep_assert_held(&isp->mutex);
+
 	ret = __is_raw_buffer_locked(asd, value);
 	if (ret) {
 		dev_err(isp->dev, "%s exp_id %d invalid %d.\n", __func__, value, ret);
@@ -6570,6 +6594,8 @@ int atomisp_exp_id_unlock(struct atomisp_sub_device *asd, int *exp_id)
 	int value = *exp_id;
 	int ret;
 
+	lockdep_assert_held(&isp->mutex);
+
 	ret = __clear_raw_buffer_bitmap(asd, value);
 	if (ret) {
 		dev_err(isp->dev, "%s exp_id %d invalid %d.\n", __func__, value, ret);
@@ -6605,6 +6631,8 @@ int atomisp_inject_a_fake_event(struct atomisp_sub_device *asd, int *event)
 	if (!event || asd->streaming != ATOMISP_DEVICE_STREAMING_ENABLED)
 		return -EINVAL;
 
+	lockdep_assert_held(&asd->isp->mutex);
+
 	dev_dbg(asd->isp->dev, "%s: trying to inject a fake event 0x%x\n",
 		__func__, *event);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c
index 5aa108a1724c..19ecc751d594 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c
@@ -3626,6 +3626,8 @@ int atomisp_css_get_dis_stat(struct atomisp_sub_device *asd,
 	struct atomisp_dis_buf *dis_buf;
 	unsigned long flags;
 
+	lockdep_assert_held(&isp->mutex);
+
 	if (!asd->params.dvs_stat->hor_prod.odd_real ||
 	    !asd->params.dvs_stat->hor_prod.odd_imag ||
 	    !asd->params.dvs_stat->hor_prod.even_real ||
@@ -3637,12 +3639,8 @@ int atomisp_css_get_dis_stat(struct atomisp_sub_device *asd,
 		return -EINVAL;
 
 	/* isp needs to be streaming to get DIS statistics */
-	spin_lock_irqsave(&isp->lock, flags);
-	if (asd->streaming != ATOMISP_DEVICE_STREAMING_ENABLED) {
-		spin_unlock_irqrestore(&isp->lock, flags);
+	if (asd->streaming != ATOMISP_DEVICE_STREAMING_ENABLED)
 		return -EINVAL;
-	}
-	spin_unlock_irqrestore(&isp->lock, flags);
 
 	if (atomisp_compare_dvs_grid(asd, &stats->dvs2_stat.grid_info) != 0)
 		/* If the grid info in the argument differs from the current
@@ -3827,6 +3825,8 @@ int atomisp_css_isr_thread(struct atomisp_device *isp,
 	bool reset_wdt_timer[MAX_STREAM_NUM] = {false};
 	int i;
 
+	lockdep_assert_held(&isp->mutex);
+
 	while (!ia_css_dequeue_psys_event(&current_event.event)) {
 		if (current_event.event.type ==
 		    IA_CSS_EVENT_TYPE_FW_ASSERT) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 92cbc0e263e8..d24be2341a9b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -918,6 +918,7 @@ static int atomisp_release(struct file *file)
 	struct v4l2_requestbuffers req;
 	struct v4l2_subdev_fh fh;
 	struct v4l2_rect clear_compose = {0};
+	unsigned long flags;
 	int ret = 0;
 
 	v4l2_fh_init(&fh.vfh, vdev);
@@ -1008,7 +1009,9 @@ static int atomisp_release(struct file *file)
 
 	/* clear the asd field to show this camera is not used */
 	isp->inputs[asd->input_curr].asd = NULL;
+	spin_lock_irqsave(&isp->lock, flags);
 	asd->streaming = ATOMISP_DEVICE_STREAMING_DISABLED;
+	spin_unlock_irqrestore(&isp->lock, flags);
 
 	if (atomisp_dev_users(isp))
 		goto done;
diff --git a/drivers/staging/media/atomisp/pci/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp_internal.h
index f71ab1ee6e19..b86f9bd7574c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp_internal.h
@@ -280,7 +280,7 @@ struct atomisp_device {
 
 	atomic_t wdt_work_queued;
 
-	spinlock_t lock; /* Just for streaming below */
+	spinlock_t lock; /* Protects asd[i].streaming */
 
 	bool need_gfx_throttle;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 4de01aa28fe5..44ed8aa51fdc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1925,7 +1925,9 @@ static int atomisp_streamon(struct file *file, void *fh,
 	if (ret)
 		goto out;
 
+	spin_lock_irqsave(&isp->lock, irqflags);
 	asd->streaming = ATOMISP_DEVICE_STREAMING_ENABLED;
+	spin_unlock_irqrestore(&isp->lock, irqflags);
 	atomic_set(&asd->sof_count, -1);
 	atomic_set(&asd->sequence, -1);
 	atomic_set(&asd->sequence_temp, -1);
@@ -2005,7 +2007,9 @@ static int atomisp_streamon(struct file *file, void *fh,
 	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
 			       video, s_stream, 1);
 	if (ret) {
+		spin_lock_irqsave(&isp->lock, irqflags);
 		asd->streaming = ATOMISP_DEVICE_STREAMING_DISABLED;
+		spin_unlock_irqrestore(&isp->lock, irqflags);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/staging/media/atomisp/pci/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
index 394fe6959033..5a3dd476f194 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
@@ -874,12 +874,18 @@ static int s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct atomisp_sub_device *asd = container_of(
 					     ctrl->handler, struct atomisp_sub_device, ctrl_handler);
+	unsigned int streaming;
+	unsigned long flags;
 
 	switch (ctrl->id) {
 	case V4L2_CID_RUN_MODE:
 		return __atomisp_update_run_mode(asd);
 	case V4L2_CID_DEPTH_MODE:
-		if (asd->streaming != ATOMISP_DEVICE_STREAMING_DISABLED) {
+		/* Use spinlock instead of mutex to avoid possible locking issues */
+		spin_lock_irqsave(&asd->isp->lock, flags);
+		streaming = asd->streaming;
+		spin_unlock_irqrestore(&asd->isp->lock, flags);
+		if (streaming != ATOMISP_DEVICE_STREAMING_DISABLED) {
 			dev_err(asd->isp->dev,
 				"ISP is streaming, it is not supported to change the depth mode\n");
 			return -EINVAL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp_subdev.h b/drivers/staging/media/atomisp/pci/atomisp_subdev.h
index 798a93793a9a..a955a38246cf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_subdev.h
+++ b/drivers/staging/media/atomisp/pci/atomisp_subdev.h
@@ -364,7 +364,11 @@ struct atomisp_sub_device {
 	atomic_t sequence;      /* Sequence value that is assigned to buffer. */
 	atomic_t sequence_temp;
 
-	unsigned int streaming; /* Hold both mutex and lock to change this */
+	/*
+	 * Writers of streaming must hold both isp->mutex and isp->lock.
+	 * Readers of streaming need to hold only one of the two locks.
+	 */
+	unsigned int streaming;
 	bool stream_prepared; /* whether css stream is created */
 
 	/* subdev index: will be used to show which subdev is holding the
-- 
2.35.1

