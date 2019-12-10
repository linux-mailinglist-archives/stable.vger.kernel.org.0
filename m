Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429DA1193D7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfLJVLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbfLJVLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9241B246B8;
        Tue, 10 Dec 2019 21:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012259;
        bh=4AT+BhJk04uH2Tcdyxf4+IP04hgHCY4zWu3WRrHazF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fziFEhL0rEKr08sgpZ/w3Ha1aiwS8uDZgXMnOyWheyn+4ZKHTE5ZFMHt2Io6mZRX5
         3ItYlQAVmcX1ztNAY5eYKyPjl2P13ve7A7pbntB/uoiK2nazvWtkzMcC5/oWF9B8Zd
         wx3sdrX1BldUpVWCqsn3XqsuqHOWcVEt3hvsFlVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 205/350] media: staging/imx: Use a shorter name for driver
Date:   Tue, 10 Dec 2019 16:05:10 -0500
Message-Id: <20191210210735.9077-166-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b33a07bc9105d..46576e32581f0 100644
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

