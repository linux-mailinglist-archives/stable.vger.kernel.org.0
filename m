Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBF237C8F0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhELQN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239390AbhELQH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA7D61D1B;
        Wed, 12 May 2021 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833880;
        bh=OmJ4TvJBoQB/WEBS8DulLTxmNKPaVlRzbj6sCd80PWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVWYxArRFwXgqCS1PkClpKKUlej7tjNkRzYfwr3kviJ0HBP+FUBRdnEjItpyV8Jw1
         ACaq6uoXRjfPYWuAThbuuuPQsEJ81b7S+6mvXDTZ/4m4NKYZd0gDZs/CEQ7dALVrO7
         bGyMSpRkHEICKSN0tZoKYh6YrGlhHI10MTmXzjIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 324/601] media: platform: sunxi: sun6i-csi: fix error return code of sun6i_video_start_streaming()
Date:   Wed, 12 May 2021 16:46:41 +0200
Message-Id: <20210512144838.480000482@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit f3d384e36630e2a552d874e422835606d9cf230a ]

When sun6i_video_remote_subdev() returns NULL to subdev, no error return
code of sun6i_video_start_streaming() is assigned.
To fix this bug, ret is assigned with -EINVAL in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Fixes: 5cc7522d8965 ("media: sun6i: Add support for Allwinner CSI V3s")
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index b55de9ab64d8..3181d0781b61 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -151,8 +151,10 @@ static int sun6i_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	subdev = sun6i_video_remote_subdev(video, NULL);
-	if (!subdev)
+	if (!subdev) {
+		ret = -EINVAL;
 		goto stop_media_pipeline;
+	}
 
 	config.pixelformat = video->fmt.fmt.pix.pixelformat;
 	config.code = video->mbus_code;
-- 
2.30.2



