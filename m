Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6302E3CC4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437534AbgL1OFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437532AbgL1OFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AA920731;
        Mon, 28 Dec 2020 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164285;
        bh=zm8mI4ddHeFzaIzXAhVhOv+rB86brW5E7ItdWEtwglY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBbeNJPQDldUieMFu1yM3c4U9RzhScGRS8p+9SYTeGWpnhRhT1bKo0h8VdsJHOIpb
         pEptMFjldt6qT1xqH/ILMjtskczInWZJpXC7tK6zJc+FLzPqrOM5LWgg9hsx/ImYZv
         K8Y5zv7zGRENZ8RLI3/kftSZbpsKhskgd5pxOWJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/717] media: cedrus: fix reference leak in cedrus_start_streaming
Date:   Mon, 28 Dec 2020 13:42:05 +0100
Message-Id: <20201228125027.033419120@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 940727bf22f74cbdef8de327de34c4ae565c89ea ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in cedrus_start_streaming. We should fix it.

Fixes: d5aecd289babf ("media: cedrus: Implement runtime PM")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 667b86dde1ee8..911f607d9b092 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -479,8 +479,10 @@ static int cedrus_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		ret = pm_runtime_get_sync(dev->dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_noidle(dev->dev);
 			goto err_cleanup;
+		}
 
 		if (dev->dec_ops[ctx->current_codec]->start) {
 			ret = dev->dec_ops[ctx->current_codec]->start(ctx);
-- 
2.27.0



