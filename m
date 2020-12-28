Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F222E3CBC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437550AbgL1OFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437532AbgL1OFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397F2206E5;
        Mon, 28 Dec 2020 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164290;
        bh=hwmcmGIyo9MKZsDK2ej6AsRvBoISgFkZALkHMfkTwKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0tiYDuVvBZJDnmU0GMBUoLZCcsU/YDy5jCvz3piCgqj24liUUPB/zwY374WCgG9k
         5O0GWktIw0/5rUZISN4BjObJ3LBGDerJULGG9zAgx5pvDk9380ZFU9z5V61E+PaGhB
         vTPikmQ7ODL1SQxVl76Xt1rlKT1PNOnNWMyoVvCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/717] media: platform: add missing put_device() call in mtk_jpeg_probe() and mtk_jpeg_remove()
Date:   Mon, 28 Dec 2020 13:42:06 +0100
Message-Id: <20201228125027.081282909@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0d72f489995bb8565f6fe30539d4504c88356a9e ]

if mtk_jpeg_clk_init() succeed, mtk_jpeg_probe() and mtk_jpeg_remove()
doesn't have a corresponding put_device(). Thus add a new helper
mtk_jpeg_clk_release() to fix it.

Fixes: b2f0d2724ba4 ("[media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 106543391c460..88a23bce569d9 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1332,6 +1332,12 @@ static void mtk_jpeg_job_timeout_work(struct work_struct *work)
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 }
+
+static inline void mtk_jpeg_clk_release(struct mtk_jpeg_dev *jpeg)
+{
+	put_device(jpeg->larb);
+}
+
 static int mtk_jpeg_probe(struct platform_device *pdev)
 {
 	struct mtk_jpeg_dev *jpeg;
@@ -1436,6 +1442,7 @@ err_m2m_init:
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 err_dev_register:
+	mtk_jpeg_clk_release(jpeg);
 
 err_clk_init:
 
@@ -1453,6 +1460,7 @@ static int mtk_jpeg_remove(struct platform_device *pdev)
 	video_device_release(jpeg->vdev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
+	mtk_jpeg_clk_release(jpeg);
 
 	return 0;
 }
-- 
2.27.0



