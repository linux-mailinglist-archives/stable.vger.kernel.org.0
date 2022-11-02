Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D2A615940
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKBDHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKBDGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:06:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4E1240A6
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80096B82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B350C433D6;
        Wed,  2 Nov 2022 03:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358409;
        bh=gt93VVhlqfwsACc1YTeSJmuuQTL4WhfoBFfyJQrNiHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0WkyjPLLpt5RoJ94UTASl5qiqrxDH8M7sLki/12WBcaQnL3XIEcN9VB6qN1hp+oe
         8K/IISvxN1HIGM7l2F+D2BNVVfnL+r6d1OHDWcaK4TQdFh8FjTi3ib/Ur/djEehZlu
         rKGQmeHjv+HkS+LBGX5PbLBjOZ1D6e49suCD9m3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/132] media: vivid: s_fbuf: add more sanity checks
Date:   Wed,  2 Nov 2022 03:33:19 +0100
Message-Id: <20221102022102.073601501@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit f8bcaf714abfc94818dff8c0db84d750433984f4 ]

VIDIOC_S_FBUF is by definition a scary ioctl, which is why only root
can use it. But at least check if the framebuffer parameters match that
of one of the framebuffer created by vivid, and reject anything else.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: ef834f7836ec ([media] vivid: add the video capture and output parts)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c | 22 +++++++++++++++++++
 drivers/media/test-drivers/vivid/vivid-core.h |  2 ++
 .../media/test-drivers/vivid/vivid-vid-cap.c  |  9 +++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index d2bd2653cf54..e7cc70a92683 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -330,6 +330,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
 	return vivid_vid_out_g_fbuf(file, fh, a);
 }
 
+/*
+ * Only support the framebuffer of one of the vivid instances.
+ * Anything else is rejected.
+ */
+bool vivid_validate_fb(const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev;
+	int i;
+
+	for (i = 0; i < n_devs; i++) {
+		dev = vivid_devs[i];
+		if (!dev || !dev->video_pbase)
+			continue;
+		if ((unsigned long)a->base == dev->video_pbase &&
+		    a->fmt.width <= dev->display_width &&
+		    a->fmt.height <= dev->display_height &&
+		    a->fmt.bytesperline <= dev->display_byte_stride)
+			return true;
+	}
+	return false;
+}
+
 static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
 {
 	struct video_device *vdev = video_devdata(file);
diff --git a/drivers/media/test-drivers/vivid/vivid-core.h b/drivers/media/test-drivers/vivid/vivid-core.h
index 1e3c4f5a9413..7ceaf9bac2f0 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.h
+++ b/drivers/media/test-drivers/vivid/vivid-core.h
@@ -610,4 +610,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..c9eb28b3a03d 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1272,7 +1272,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
-	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+	if (a->fmt.bytesperline > a->fmt.sizeimage / a->fmt.height)
+		return -EINVAL;
+
+	/*
+	 * Only support the framebuffer of one of the vivid instances.
+	 * Anything else is rejected.
+	 */
+	if (!vivid_validate_fb(a))
 		return -EINVAL;
 
 	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
-- 
2.35.1



