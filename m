Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA584916C7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiARCg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbiARCdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:33:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AA89B81239;
        Tue, 18 Jan 2022 02:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3933CC36AE3;
        Tue, 18 Jan 2022 02:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473181;
        bh=WFuBHMiwPiqGN8h6F2lk8mHWQKZUX7p3wTbJ0W2u8d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBwbDjZtojj6KN9MKkZr42B/UDAmjs23EbWhhEzWjF16pttBVGuwwCQRCg1mV8IGC
         9gC0nq49pXwhe5MLi3jWjJDIQq8Oy8i4p9ZF2raW6sE6SqmtsjJcFkuWpaNoeKSJRf
         d/mbORL9FRt2RGSlFtioBwJmUBf/fzlTvRpvW1EJpSOFaomoWjwoaC04vcVhUgZUsN
         6FTxbBqHqeoFe8ThLlY8wzbrSWJiY5zEGZRVLWhTXDIHu94rJsZgI6aVsZs9jLzvCU
         PXXfdfi0SxfaOxurMH6N2mCvK0pUwHFApQfFmfLlDHQTnn4Iv0uPElCHc/4dNluWPQ
         fWgsXnnQlVA9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        hverkuil-cisco@xs4all.nl, sakari.ailus@linux.intel.com,
        arnd@arndb.de, alan@linux.intel.com,
        tomi.valkeinen@ideasonboard.com, alinesantanacordeiro@gmail.com,
        dan.carpenter@oracle.com, yangyingliang@huawei.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 016/188] media: atomisp: set per-device's default mode
Date:   Mon, 17 Jan 2022 21:29:00 -0500
Message-Id: <20220118023152.1948105-16-sashal@kernel.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 2c45e343c581091835c9047ed5298518aa133163 ]

The atomisp driver originally used the s_parm command to
initialize the run_mode type to the driver. So, before start
setting up the streaming, s_parm should be called.

So, even having 5 "normal" video devices, one meant to be used
for each type, the run_mode was actually selected when
s_parm is called.

Without setting the run mode, applications that don't call
VIDIOC_SET_PARM with a custom atomisp parameters won't work, as
the pipeline won't be set:

	atomisp-isp2 0000:00:03.0: can't create streams
	atomisp-isp2 0000:00:03.0: __get_frame_info 1600x1200 (padded to 0) returned -22

However, commit 8a7c5594c020 ("media: v4l2-ioctl: clear fields in s_parm")
broke support for it, with a good reason, as drivers shoudn't be
extending the API for their own purposes.

So, as an step to allow generic apps to use this driver, put
the device's run_mode in preview after open.

After this patch, using v4l2grab starts to work on preview
mode (/dev/video2):

	$ v4l2grab -f YUYV -x 1600 -y 1200 -d /dev/video2 -n 1 -u
	$ feh out000.pnm

So, let's just setup the default run_mode that each video devnode
should assume, setting it at open() time.

Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c  |  5 +++++
 .../staging/media/atomisp/pci/atomisp_subdev.c    | 15 ++++++++++-----
 .../staging/media/atomisp/pci/atomisp_subdev.h    |  3 +++
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c  |  4 +++-
 drivers/staging/media/atomisp/pci/atomisp_v4l2.h  |  3 ++-
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 02c19b92bdccb..18fff47bd25d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -877,6 +877,11 @@ static int atomisp_open(struct file *file)
 	else
 		pipe->users++;
 	rt_mutex_unlock(&isp->mutex);
+
+	/* Ensure that a mode is set */
+	if (asd)
+		v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode);
+
 	return 0;
 
 css_error:
diff --git a/drivers/staging/media/atomisp/pci/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
index 12f22ad007c73..ffaf11e0b0ad8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
@@ -1164,23 +1164,28 @@ static int isp_subdev_init_entities(struct atomisp_sub_device *asd)
 
 	atomisp_init_acc_pipe(asd, &asd->video_acc);
 
-	ret = atomisp_video_init(&asd->video_in, "MEMORY");
+	ret = atomisp_video_init(&asd->video_in, "MEMORY",
+				 ATOMISP_RUN_MODE_SDV);
 	if (ret < 0)
 		return ret;
 
-	ret = atomisp_video_init(&asd->video_out_capture, "CAPTURE");
+	ret = atomisp_video_init(&asd->video_out_capture, "CAPTURE",
+				 ATOMISP_RUN_MODE_STILL_CAPTURE);
 	if (ret < 0)
 		return ret;
 
-	ret = atomisp_video_init(&asd->video_out_vf, "VIEWFINDER");
+	ret = atomisp_video_init(&asd->video_out_vf, "VIEWFINDER",
+				 ATOMISP_RUN_MODE_CONTINUOUS_CAPTURE);
 	if (ret < 0)
 		return ret;
 
-	ret = atomisp_video_init(&asd->video_out_preview, "PREVIEW");
+	ret = atomisp_video_init(&asd->video_out_preview, "PREVIEW",
+				 ATOMISP_RUN_MODE_PREVIEW);
 	if (ret < 0)
 		return ret;
 
-	ret = atomisp_video_init(&asd->video_out_video_capture, "VIDEO");
+	ret = atomisp_video_init(&asd->video_out_video_capture, "VIDEO",
+				 ATOMISP_RUN_MODE_VIDEO);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp_subdev.h b/drivers/staging/media/atomisp/pci/atomisp_subdev.h
index d6fcfab6352d7..a8d210ea5f8be 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_subdev.h
+++ b/drivers/staging/media/atomisp/pci/atomisp_subdev.h
@@ -81,6 +81,9 @@ struct atomisp_video_pipe {
 	/* the link list to store per_frame parameters */
 	struct list_head per_frame_params;
 
+	/* Store here the initial run mode */
+	unsigned int default_run_mode;
+
 	unsigned int buffers_in_css;
 
 	/* irq_lock is used to protect video buffer state change operations and
diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index 1e324f1f656e5..b16f969f85afb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -447,7 +447,8 @@ const struct atomisp_dfs_config dfs_config_cht_soc = {
 	.dfs_table_size = ARRAY_SIZE(dfs_rules_cht_soc),
 };
 
-int atomisp_video_init(struct atomisp_video_pipe *video, const char *name)
+int atomisp_video_init(struct atomisp_video_pipe *video, const char *name,
+		       unsigned int run_mode)
 {
 	int ret;
 	const char *direction;
@@ -478,6 +479,7 @@ int atomisp_video_init(struct atomisp_video_pipe *video, const char *name)
 		 "ATOMISP ISP %s %s", name, direction);
 	video->vdev.release = video_device_release_empty;
 	video_set_drvdata(&video->vdev, video->isp);
+	video->default_run_mode = run_mode;
 
 	return 0;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.h b/drivers/staging/media/atomisp/pci/atomisp_v4l2.h
index 81bb356b81720..72611b8286a4a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.h
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.h
@@ -27,7 +27,8 @@ struct v4l2_device;
 struct atomisp_device;
 struct firmware;
 
-int atomisp_video_init(struct atomisp_video_pipe *video, const char *name);
+int atomisp_video_init(struct atomisp_video_pipe *video, const char *name,
+		       unsigned int run_mode);
 void atomisp_acc_init(struct atomisp_acc_pipe *video, const char *name);
 void atomisp_video_unregister(struct atomisp_video_pipe *video);
 void atomisp_acc_unregister(struct atomisp_acc_pipe *video);
-- 
2.34.1

