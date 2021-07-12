Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91BB3C4D0E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbhGLHLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243942AbhGLHKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA2C61369;
        Mon, 12 Jul 2021 07:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073532;
        bh=E5BnYOzIC2rS0Shxh1oJ1QRMJjd/fLnsEcaEPllvfao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8qYgBlxhBEZE9GaACv70W2I/bRG8uvadGkRXs/oDvM1vGpJZcSkFjq9eQPWAuABo
         cLTKgFiqgxu/ubshU3lp8bqKPqI67jn1Aki8/lRLPanBwWk6DaVe7IIBPrUA/gf9bb
         RxoqIzXACU4JDyYWa9hkqfSUxayQmKFAF+mZfuUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 275/700] media: exynos4-is: Fix a use after free in isp_video_release
Date:   Mon, 12 Jul 2021 08:05:58 +0200
Message-Id: <20210712061005.516375969@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 01fe904c9afd26e79c1f73aa0ca2e3d785e5e319 ]

In isp_video_release, file->private_data is freed via
_vb2_fop_release()->v4l2_fh_release(). But the freed
file->private_data is still used in v4l2_fh_is_singular_file()
->v4l2_fh_is_singular(file->private_data), which is a use
after free bug.

My patch uses a variable 'is_singular_file' to avoid the uaf.
v3: https://lore.kernel.org/patchwork/patch/1419058/

Fixes: 34947b8aebe3f ("[media] exynos4-is: Add the FIMC-IS ISP capture DMA driver")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 8d9dc597deaa..83688a7982f7 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -305,17 +305,20 @@ static int isp_video_release(struct file *file)
 	struct fimc_is_video *ivc = &isp->video_capture;
 	struct media_entity *entity = &ivc->ve.vdev.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
+	bool is_singular_file;
 
 	mutex_lock(&isp->video_lock);
 
-	if (v4l2_fh_is_singular_file(file) && ivc->streaming) {
+	is_singular_file = v4l2_fh_is_singular_file(file);
+
+	if (is_singular_file && ivc->streaming) {
 		media_pipeline_stop(entity);
 		ivc->streaming = 0;
 	}
 
 	_vb2_fop_release(file, NULL);
 
-	if (v4l2_fh_is_singular_file(file)) {
+	if (is_singular_file) {
 		fimc_pipeline_call(&ivc->ve, close);
 
 		mutex_lock(&mdev->graph_mutex);
-- 
2.30.2



