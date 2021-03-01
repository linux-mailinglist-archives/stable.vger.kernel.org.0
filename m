Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7BB328C7A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbhCASwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240382AbhCASqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F11A6530F;
        Mon,  1 Mar 2021 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620558;
        bh=NbpzCYMIvEbZs18qLNVRxseZKiihXVcW5iCjn6/ayIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rus8od8MTp11tgnH8rqjP5ZfW6SP3sIMh/5RprMZ1XJekxv7+jQ9i1+JF5jHiTpx0
         WrUCbCfRp1gBQd4qeTRpHrsbZHNwspsJUowEkK4TwzcdZr1G7rtmGZFnVm4Sqn1Yny
         97tIh3Z04NpcCqJ/CnkS4Xx8unPXnF6yuXtWPFYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 195/775] media: imx: Unregister csc/scaler only if registered
Date:   Mon,  1 Mar 2021 17:06:03 +0100
Message-Id: <20210301161211.278407234@linuxfoundation.org>
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
index 6d2205461e565..338b8bd0bb076 100644
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



