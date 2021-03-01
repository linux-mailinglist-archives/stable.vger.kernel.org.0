Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A932883A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhCARf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237786AbhCAR1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C129A65091;
        Mon,  1 Mar 2021 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617480;
        bh=lQcEmRvrmD2QEL6M2aNMWUVIztQktPHH+KfSrW734Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsF1uuNBdwktAoTEOG8/5w/Lm22HEtQgsQ7rMTe8sJCdoM6tbTyc+jPw5CTpMBasS
         oPaFLHICmtbzmaG3vtXTwKcbp6zhgvuHPq7Q7xTkwsLLStqrgyQ7GB7aOYf8q+yq47
         8Q1PTpZZLFUyCWNOokSJ7rWr5PQC2s7lcwbmJ5ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/340] media: aspeed: fix error return code in aspeed_video_setup_video()
Date:   Mon,  1 Mar 2021 17:10:32 +0100
Message-Id: <20210301161052.655101103@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 4eaaf39b9223c..e0299a7899231 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1529,12 +1529,12 @@ static int aspeed_video_setup_video(struct aspeed_video *video)
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



