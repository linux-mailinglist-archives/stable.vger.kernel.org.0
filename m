Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8FB328807
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhCARcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238411AbhCAR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD7061490;
        Mon,  1 Mar 2021 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617457;
        bh=6xs4B77axZ7Uh4RnVFdUwEvsanrE0uzmCdnqj8eFR0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ml1jocOT+mr2qolAoKgJW95wimzwKyMirGXq/UQ5cIMqcZ57/Qn+yAHPQr3F0gsKk
         R1ObmjD+1jX5pdjU/Ii9GJH6BaP9n3kJgRiM61Mznz0TuLkACFYoo0IRuIyBrv7GEl
         eI0SkYzY0F7FnCuFIVHSy+OZrMM4beonDgcljz5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/340] media: imx: Unregister csc/scaler only if registered
Date:   Mon,  1 Mar 2021 17:10:25 +0100
Message-Id: <20210301161052.310900079@linuxfoundation.org>
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

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit bb2216548a2b13cf2942a058b475438a7a6bb028 ]

The csc/scaler device pointer (imxmd->m2m_vdev) is assigned
after the imx media device v4l2-async probe completes,
therefore we need to check if the device is non-NULL
before trying to unregister it.

This can be the case if the non-completed imx media device
is unbinded (or the driver is removed), leading to a kernel oops.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-dev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 2c3c2adca6832..e16408af92d9c 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -53,6 +53,7 @@ static int imx6_media_probe_complete(struct v4l2_async_notifier *notifier)
 	imxmd->m2m_vdev = imx_media_csc_scaler_device_init(imxmd);
 	if (IS_ERR(imxmd->m2m_vdev)) {
 		ret = PTR_ERR(imxmd->m2m_vdev);
+		imxmd->m2m_vdev = NULL;
 		goto unlock;
 	}
 
@@ -107,10 +108,14 @@ static int imx_media_remove(struct platform_device *pdev)
 
 	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
 
+	if (imxmd->m2m_vdev) {
+		imx_media_csc_scaler_device_unregister(imxmd->m2m_vdev);
+		imxmd->m2m_vdev = NULL;
+	}
+
 	v4l2_async_notifier_unregister(&imxmd->notifier);
 	imx_media_unregister_ipu_internal_subdevs(imxmd);
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
-	imx_media_csc_scaler_device_unregister(imxmd->m2m_vdev);
 	media_device_unregister(&imxmd->md);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
 	media_device_cleanup(&imxmd->md);
-- 
2.27.0



