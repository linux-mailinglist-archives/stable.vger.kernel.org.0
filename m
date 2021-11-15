Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11903452707
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbhKPCOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:14:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238905AbhKORwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:52:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 221456327C;
        Mon, 15 Nov 2021 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997551;
        bh=4twShmX2km5jVfrR0tkvD+SSSd5U1TDA0VfepQG0d+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyWxJQnGhSe6LO+noE7TIkJxpD6PQr7Pofrce8+03ZC8mKcoO+2ejG4ZIV9ti/779
         AebZZaqDjA3GsMT0RTpbT7qmGqxxpFNlAwfKIaxZw/nTK6tUbji1UbZWVOpGitcJMQ
         tYHpk0LMYJZVHwzaLynWSltcIxOf3Xxk+i0rN8P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/575] media: atomisp: Fix error handling in probe
Date:   Mon, 15 Nov 2021 17:58:35 +0100
Message-Id: <20211115165350.271041627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit e16f5e39acd6d10cc63ae39bc0a77188ed828f22 ]

There were several issues with handling errors in lm3554_probe():
- Probe did not set the error code when v4l2_ctrl_handler_init() failed.
- It intermixed gotos for handling errors of v4l2_ctrl_handler_init()
  and media_entity_pads_init().
- It did not set the error code for failures of v4l2_ctrl_new_custom().
- Probe did not free resources in case of failures of
  atomisp_register_i2c_module().

The patch fixes all these issues.

Found by Linux Driver Verification project (linuxtesting.org).

Link: https://lore.kernel.org/linux-media/20210810162943.19852-1-novikov@ispras.ru
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/i2c/atomisp-lm3554.c        | 37 ++++++++++++-------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 0ab67b2aec671..8739f0874103e 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -836,7 +836,6 @@ static int lm3554_probe(struct i2c_client *client)
 	int err = 0;
 	struct lm3554 *flash;
 	unsigned int i;
-	int ret;
 
 	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
 	if (!flash)
@@ -845,7 +844,7 @@ static int lm3554_probe(struct i2c_client *client)
 	flash->pdata = lm3554_platform_data_func(client);
 	if (IS_ERR(flash->pdata)) {
 		err = PTR_ERR(flash->pdata);
-		goto fail1;
+		goto free_flash;
 	}
 
 	v4l2_i2c_subdev_init(&flash->sd, client, &lm3554_ops);
@@ -853,12 +852,12 @@ static int lm3554_probe(struct i2c_client *client)
 	flash->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	flash->mode = ATOMISP_FLASH_MODE_OFF;
 	flash->timeout = LM3554_MAX_TIMEOUT / LM3554_TIMEOUT_STEPSIZE - 1;
-	ret =
+	err =
 	    v4l2_ctrl_handler_init(&flash->ctrl_handler,
 				   ARRAY_SIZE(lm3554_controls));
-	if (ret) {
+	if (err) {
 		dev_err(&client->dev, "error initialize a ctrl_handler.\n");
-		goto fail3;
+		goto unregister_subdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lm3554_controls); i++)
@@ -867,14 +866,15 @@ static int lm3554_probe(struct i2c_client *client)
 
 	if (flash->ctrl_handler.error) {
 		dev_err(&client->dev, "ctrl_handler error.\n");
-		goto fail3;
+		err = flash->ctrl_handler.error;
+		goto free_handler;
 	}
 
 	flash->sd.ctrl_handler = &flash->ctrl_handler;
 	err = media_entity_pads_init(&flash->sd.entity, 0, NULL);
 	if (err) {
 		dev_err(&client->dev, "error initialize a media entity.\n");
-		goto fail2;
+		goto free_handler;
 	}
 
 	flash->sd.entity.function = MEDIA_ENT_F_FLASH;
@@ -885,16 +885,27 @@ static int lm3554_probe(struct i2c_client *client)
 
 	err = lm3554_gpio_init(client);
 	if (err) {
-		dev_err(&client->dev, "gpio request/direction_output fail");
-		goto fail3;
+		dev_err(&client->dev, "gpio request/direction_output fail.\n");
+		goto cleanup_media;
+	}
+
+	err = atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
+	if (err) {
+		dev_err(&client->dev, "fail to register atomisp i2c module.\n");
+		goto uninit_gpio;
 	}
-	return atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
-fail3:
+
+	return 0;
+
+uninit_gpio:
+	lm3554_gpio_uninit(client);
+cleanup_media:
 	media_entity_cleanup(&flash->sd.entity);
+free_handler:
 	v4l2_ctrl_handler_free(&flash->ctrl_handler);
-fail2:
+unregister_subdev:
 	v4l2_device_unregister_subdev(&flash->sd);
-fail1:
+free_flash:
 	kfree(flash);
 
 	return err;
-- 
2.33.0



