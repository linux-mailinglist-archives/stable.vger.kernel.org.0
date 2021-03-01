Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001E0328A0F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhCASLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhCASEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:04:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31A264E5F;
        Mon,  1 Mar 2021 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620663;
        bh=hABkrZe6wCI8WU49Dfb5/wFF2YPEA9dR+iG/8nJO9D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI+/l5PLEhwiMEwro4pTL1nY+r93Gzr5p2XmOW7jmMCDjSAz7Zlc5giFlvklqK5NZ
         bcNictFn9XJvWc7xabHpPc0nOoHLjT0VvBifetgkZ5kZIKAvalBILBwuvu7AyzpTvV
         bxioPo5QNK7JWtyiOrtav5GmrbK8YmHXDpGHHDVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 204/775] media: aspeed: fix error return code in aspeed_video_setup_video()
Date:   Mon,  1 Mar 2021 17:06:12 +0100
Message-Id: <20210301161211.722243364@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit d497fcdab02996a4510d5dd0d743447c737c317a ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index c46a79eace98b..f2c4dadd6a0eb 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1551,12 +1551,12 @@ static int aspeed_video_setup_video(struct aspeed_video *video)
 			       V4L2_JPEG_CHROMA_SUBSAMPLING_420, mask,
 			       V4L2_JPEG_CHROMA_SUBSAMPLING_444);
 
-	if (video->ctrl_handler.error) {
+	rc = video->ctrl_handler.error;
+	if (rc) {
 		v4l2_ctrl_handler_free(&video->ctrl_handler);
 		v4l2_device_unregister(v4l2_dev);
 
-		dev_err(video->dev, "Failed to init controls: %d\n",
-			video->ctrl_handler.error);
+		dev_err(video->dev, "Failed to init controls: %d\n", rc);
 		return rc;
 	}
 
-- 
2.27.0



