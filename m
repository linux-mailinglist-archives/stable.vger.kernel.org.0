Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADAB328C6D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbhCASwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240255AbhCASpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:45:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29DDA6530D;
        Mon,  1 Mar 2021 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620560;
        bh=dgWkJBRcXmlasYdpr6OICrMX8AOjg3N83L5+6TgI04I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvHOMZe7SdQ0C4QfhYVWTdfnZKWLPMwgLSh1oZ/UiAt8uX6FcxwiNh/0k8uCAhYa8
         hFRlkwcnIukO+A6CizjzzhTgn4g/geC7zxGYTOaRAlqGoOeTG86yofJ5iXPDNDU+Qa
         tNJI86qBvZpXMhTRICAK6O/NPXovTft8a7xIESEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 196/775] media: imx: Fix csc/scaler unregister
Date:   Mon,  1 Mar 2021 17:06:04 +0100
Message-Id: <20210301161211.329855459@linuxfoundation.org>
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
index fab1155a5958c..63a0204502a8b 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -869,11 +869,7 @@ void imx_media_csc_scaler_device_unregister(struct imx_media_video_dev *vdev)
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



