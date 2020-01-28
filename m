Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33614B87B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgA1OX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgA1OX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720FA24688;
        Tue, 28 Jan 2020 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221437;
        bh=TTJ6GVWyctbFg9psBxC6ZtWRo9RWGRb4RSj8wENSv80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0FYA9GJ///Pj8WrHjVEDxolPAPCCWnlJfIIF1fugkC3Cq6VkP6B9gZizBoiCv/7I
         NcaItHd97pDGVOCapl26kYuDY7v517pqKf7GTX6ZCr+gPaK2NguBBZh1ylWO8goxW+
         tZwcARvY35zS3XxyTv+y9EkphdzapA4/npAaQU1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 223/271] media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support
Date:   Tue, 28 Jan 2020 15:06:12 +0100
Message-Id: <20200128135909.155150138@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 39034bb0c26b76a2c3abc54aa28c185f18b40c2f ]

Commit da298c6d98d5 ("[media] v4l2: replace video op g_mbus_fmt by pad
op get_fmt") converted a former ov6650_g_fmt() video operation callback
to an ov6650_get_fmt() pad operation callback.  However, the converted
function disregards a format->which flag that pad operations should
obey and always returns active frame format settings.

That can be fixed by always responding to V4L2_SUBDEV_FORMAT_TRY with
-EINVAL, or providing the response from a pad config argument, likely
updated by a former user call to V4L2_SUBDEV_FORMAT_TRY .set_fmt().
Since implementation of the latter is trivial, go for it.

Fixes: da298c6d98d5 ("[media] v4l2: replace video op g_mbus_fmt by pad op get_fmt")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/ov6650.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 3b118d45d433b..3c959e48855c3 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -526,10 +526,16 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
 	*mf = ov6650_def_fmt;
 
 	/* update media bus format code and frame size */
-	mf->width	= priv->rect.width >> priv->half_scale;
-	mf->height	= priv->rect.height >> priv->half_scale;
-	mf->code	= priv->code;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf->width = cfg->try_fmt.width;
+		mf->height = cfg->try_fmt.height;
+		mf->code = cfg->try_fmt.code;
 
+	} else {
+		mf->width = priv->rect.width >> priv->half_scale;
+		mf->height = priv->rect.height >> priv->half_scale;
+		mf->code = priv->code;
+	}
 	return 0;
 }
 
-- 
2.20.1



