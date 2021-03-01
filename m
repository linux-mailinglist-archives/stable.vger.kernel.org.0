Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE85C328806
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhCARcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238408AbhCAR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC4F46508A;
        Mon,  1 Mar 2021 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617463;
        bh=hSkNp1NvdvfcT7CqADL02pQ+TuBBbzb+7n0pWphzKDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPjqaku+oDlPNm5rMNJ7tHGwZnV0WoHAijuWUJN4lcdSqiFHWYh0xAqqsqxl0yGkw
         kb7q7s8JB1gQD6GE1joQ+bWeJqd/bc5TEdlZZpeVNYqlrI61ZbhKGv+Dylh9ad77jw
         pBbMokbWjtbMh22HjPxKmUZLDZir4Dk3o/NfjEHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/340] media: imx: Fix csc/scaler unregister
Date:   Mon,  1 Mar 2021 17:10:26 +0100
Message-Id: <20210301161052.361891265@linuxfoundation.org>
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

[ Upstream commit 89b14485caa4b7b2eaf70be0064f0978e68ebeee ]

The csc/scaler device private struct is released by
ipu_csc_scaler_video_device_release(), which can be called
by video_unregister_device() if there are no users
of the underlying struct video device.

Therefore, the mutex can't be held when calling
video_unregister_device() as its memory may be freed
by it, leading to a kernel oops.

Fortunately, the fix is quite simple as no locking
is needed when calling video_unregister_device(): v4l2-core
already has its own internal locking, and the structures
are also properly refcounted.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csc-scaler.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csc-scaler.c b/drivers/staging/media/imx/imx-media-csc-scaler.c
index 2b635ebf62d6a..a15d970adb983 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -866,11 +866,7 @@ void imx_media_csc_scaler_device_unregister(struct imx_media_video_dev *vdev)
 	struct ipu_csc_scaler_priv *priv = vdev_to_priv(vdev);
 	struct video_device *vfd = priv->vdev.vfd;
 
-	mutex_lock(&priv->mutex);
-
 	video_unregister_device(vfd);
-
-	mutex_unlock(&priv->mutex);
 }
 
 struct imx_media_video_dev *
-- 
2.27.0



