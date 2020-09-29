Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC427C51E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgI2La7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbgI2L3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DF623A63;
        Tue, 29 Sep 2020 11:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378639;
        bh=OOeHGkTyHf/xxJPobnQ823AgM3ilCrmnscfvk67GYOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeRsO/5a0ErEyORxOd9xzKgGJJ8iTS5pIJeJO0yIRTFNwiqqqB9N++SLVb8oajFvr
         IDlmrAOvN/Eq+OzEjRxq0KIrCCAp8irn2We4Q9VBLfYuDrc8cbfejByuR65rdeiHHe
         upcLf24ankRONwexGPAsBS8Cok9jgBE5AGD3ek+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/245] media: staging/imx: Missing assignment in imx_media_capture_device_register()
Date:   Tue, 29 Sep 2020 12:58:57 +0200
Message-Id: <20200929105951.178054998@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ef0ed05dcef8a74178a8b480cce23a377b1de2b8 ]

There was supposed to be a "ret = " assignment here, otherwise the
error handling on the next line won't work.

Fixes: 64b5a49df486 ("[media] media: imx: Add Capture Device Interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 256039ce561e6..81a3370551dbc 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -678,7 +678,7 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
 	/* setup default format */
 	fmt_src.pad = priv->src_sd_pad;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt_src);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt_src);
 	if (ret) {
 		v4l2_err(sd, "failed to get src_sd format\n");
 		goto unreg;
-- 
2.25.1



