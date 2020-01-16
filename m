Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD313FF7B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388436AbgAPXZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388343AbgAPXZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6275E2072B;
        Thu, 16 Jan 2020 23:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217100;
        bh=0fCIg7r0nSy1mYCxL3mFwPIg7zxihoixiMqY+TwVykc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCZwGz/1cSnMtFX9Zz6Sz6DRZBAUaAQXKRy3WRg/y76eXmuBfNAjLTmA289+PQmdb
         6qRf5pgXV0EzOIyONvIwH06uiLl69Si0oF2aRr8lNENms+I7Pxm0B2nZnd6q8XSjHN
         PAjcoWPsdABUb0F1MpuB9u7Om3DnxftIdq4oM02U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 148/203] media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support
Date:   Fri, 17 Jan 2020 00:17:45 +0100
Message-Id: <20200116231757.852673933@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit 39034bb0c26b76a2c3abc54aa28c185f18b40c2f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov6650.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -528,10 +528,16 @@ static int ov6650_get_fmt(struct v4l2_su
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
 


