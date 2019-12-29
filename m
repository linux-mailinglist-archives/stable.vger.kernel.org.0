Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8937512C813
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbfL2Rul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731922AbfL2Rul (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AA6207FD;
        Sun, 29 Dec 2019 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641840;
        bh=UQVBqdez+252ZswhVCLPUiiQMOUu5N1qj7XTgAdg38M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA8CdYJzfvQWgqAjhM8Cpvd5ZB8C8P60SHh8iC8pn8yIzmkqcEaiY+Y+Z/86v5sh6
         I9/8OvOE4xPMM+L09nvWO4RbhOnJp6BqB/PZOZbo0+wsCHhLRqTUQXK9I8IugOcZ9q
         U8VIby5NG4tYUQx6PiXbGsVDoK/Neg0AAtBrcZVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/434] media: staging/imx: Use a shorter name for driver
Date:   Sun, 29 Dec 2019 18:24:44 +0100
Message-Id: <20191229172717.214349931@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit ce22c6f242b6d7b5e0318da2c92b5b00b5bbc698 ]

Currently v4l2-compliance tool returns the following output:

Compliance test for imx-media-captu device /dev/video0:

Driver Info:
        Driver name      : imx-media-captu
        Card type        : imx-media-capture
...

The driver name string is limited to 16 characters, so provide
a shorter name so that we can have a better output.

While at it, use the same shorter name for driver and card.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-capture.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b33a07bc9105..46576e32581f 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -26,6 +26,8 @@
 #include <media/imx.h>
 #include "imx-media.h"
 
+#define IMX_CAPTURE_NAME "imx-capture"
+
 struct capture_priv {
 	struct imx_media_video_dev vdev;
 
@@ -69,8 +71,8 @@ static int vidioc_querycap(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 
-	strscpy(cap->driver, "imx-media-capture", sizeof(cap->driver));
-	strscpy(cap->card, "imx-media-capture", sizeof(cap->card));
+	strscpy(cap->driver, IMX_CAPTURE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, IMX_CAPTURE_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", priv->src_sd->name);
 
-- 
2.20.1



