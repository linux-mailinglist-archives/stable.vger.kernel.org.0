Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F8451FB9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244958AbhKPApF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343788AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF2A63389;
        Mon, 15 Nov 2021 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001966;
        bh=B/RBgyIizFpmnrWav/raWcYVtb+T/iruKTsAOiXU1VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3EB2A2tmZEN7AwvOfF5G3JUOnAeK5eQa0y6r9K+Xaj6i+hZ2i78Ajk5O/Urthy1X
         KErOckJR7dveywcdJQt/z96DX2RvVjc89ZSskgMnp3XEn1355/RMuaef/8PCaL5jpJ
         shznofcxmL3AhL9GytXQ/EC/Z8DhXUSM8ckU35Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/917] media: sun6i-csi: Allow the video device to be open multiple times
Date:   Mon, 15 Nov 2021 17:58:04 +0100
Message-Id: <20211115165441.959177736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit 8ed852834683ebe064157e069af8dfb41cad6403 ]

Previously it was possible, but a recent fix for uninitialized
`ret` variable broke this behavior.

v4l2_fh_is_singular_file() check is there just to determine
whether the power needs to be enabled, and it's not a failure
if it returns false.

Fixes: ba9139116bc0 ("media: sun6i-csi: add a missing return code")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index 07b2161392d21..5ba3e29f794fd 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -467,7 +467,7 @@ static const struct v4l2_ioctl_ops sun6i_video_ioctl_ops = {
 static int sun6i_video_open(struct file *file)
 {
 	struct sun6i_video *video = video_drvdata(file);
-	int ret;
+	int ret = 0;
 
 	if (mutex_lock_interruptible(&video->lock))
 		return -ERESTARTSYS;
@@ -481,10 +481,8 @@ static int sun6i_video_open(struct file *file)
 		goto fh_release;
 
 	/* check if already powered */
-	if (!v4l2_fh_is_singular_file(file)) {
-		ret = -EBUSY;
+	if (!v4l2_fh_is_singular_file(file))
 		goto unlock;
-	}
 
 	ret = sun6i_csi_set_power(video->csi, true);
 	if (ret < 0)
-- 
2.33.0



