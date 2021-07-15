Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8643CA98B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242312AbhGOTHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241811AbhGOTGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AFE9613E6;
        Thu, 15 Jul 2021 19:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375752;
        bh=wJW9/bWdgGLuAi77N/GftS9RWl0VFrkxM6LNFtYqLTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S15XtuDi72S2L1UVQ40LrC0hd34b1a9Z4hTqAdjVIpvYejcKkG4kLCvA6z8G9Ubud
         MF3skfDAWFAdukdoXr3VwtPA/G/OsgJLZDwnyDRK1ZjgzZYSSS9CecBqOdONSAJ1Vd
         ZlOgdVEqBJ8xPD83hhrusZk1gygLq4ThoJsX34MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 222/242] media: i2c: ccs-core: fix pm_runtime_get_sync() usage count
Date:   Thu, 15 Jul 2021 20:39:44 +0200
Message-Id: <20210715182632.093534439@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit da3a1858c3a37c09446e1470c48352897d59d11b upstream.

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.

There is a bug at ccs_pm_get_init(): when this function returns
an error, the stream is not started, and RPM usage_count
should not be incremented. However, if the calls to
v4l2_ctrl_handler_setup() return errors, it will be kept
incremented.

At ccs_suspend() the best is to replace it by the new
pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter automatically,
in the case of errors.

Fixes: 96e3a6b92f23 ("media: smiapp: Avoid maintaining power state information")
Cc: stable@vger.kernel.org
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -1880,21 +1880,33 @@ static int ccs_pm_get_init(struct ccs_se
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
+	/*
+	 * It can't use pm_runtime_resume_and_get() here, as the driver
+	 * relies at the returned value to detect if the device was already
+	 * active or not.
+	 */
 	rval = pm_runtime_get_sync(&client->dev);
-	if (rval < 0) {
-		pm_runtime_put_noidle(&client->dev);
+	if (rval < 0)
+		goto error;
 
-		return rval;
-	} else if (!rval) {
-		rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->
-					       ctrl_handler);
-		if (rval)
-			return rval;
+	/* Device was already active, so don't set controls */
+	if (rval == 1)
+		return 0;
 
-		return v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
-	}
+	/* Restore V4L2 controls to the previously suspended device */
+	rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
+	if (rval)
+		goto error;
 
+	rval = v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
+	if (rval)
+		goto error;
+
+	/* Keep PM runtime usage_count incremented on success */
 	return 0;
+error:
+	pm_runtime_put(&client->dev);
+	return rval;
 }
 
 static int ccs_set_stream(struct v4l2_subdev *subdev, int enable)


