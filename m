Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6B69696
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387827AbfGOOFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388176AbfGOOFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:42 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A177217D9;
        Mon, 15 Jul 2019 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199541;
        bh=2gzpnHJpu2UxoceTvfn/3W2fb5i1A+gYyHKP7Gi/5d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBsv12tb0FKGpm4PfjaAGQ2w1Sf2HOwUZATdycO6XyTov1jQlWs05PzED4IGGDWXt
         z66XitBTdofhUItImPeLrwf660HaknjpeH0lMB459GzdCQTFrDHCCJPrLeLPwoCY+1
         ActOHzA0/PphchI3CtLaSlwIXE16u1Y12mrp+MaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 037/219] media: vim2m: fix two double-free issues
Date:   Mon, 15 Jul 2019 10:00:38 -0400
Message-Id: <20190715140341.6443-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 20059cbbf981ca954be56f7963ae494d18e2dda1 ]

vim2m_device_release() will be called by video_unregister_device() to release
various objects.

There are two double-free issue,
1. dev->m2m_dev will be freed twice in error_m2m path/vim2m_device_release
2. the error_v4l2 and error_free path in vim2m_probe() will release
   same objects, since vim2m_device_release has done.

Fixes: ea6c7e34f3b2 ("media: vim2m: replace devm_kzalloc by kzalloc")

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index dd47821fc661..240327d2a3ad 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1355,7 +1355,7 @@ static int vim2m_probe(struct platform_device *pdev)
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto error_m2m;
+		goto error_dev;
 	}
 
 	ret = media_device_register(&dev->mdev);
@@ -1369,11 +1369,11 @@ static int vim2m_probe(struct platform_device *pdev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-error_m2m:
-	v4l2_m2m_release(dev->m2m_dev);
 #endif
 error_dev:
 	video_unregister_device(&dev->vfd);
+	/* vim2m_device_release called by video_unregister_device to release various objects */
+	return ret;
 error_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
 error_free:
-- 
2.20.1

