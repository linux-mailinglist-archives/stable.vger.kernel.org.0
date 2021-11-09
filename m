Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EBD44A0AD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhKIBEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241633AbhKIBD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B2061215;
        Tue,  9 Nov 2021 01:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419670;
        bh=a1EA5gTGciR1EIXkrUGu4uto/FG7wMENA7BFoVxUw3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mazy7RMwQ2RJ9nBQemh4GRotST0Qsx/SWZ+GjtgFOde9Otqt5em5rGwYAhqawStvf
         rVeKVUZjg91uG7qm9TgHM5XQomTakDwSZvao9+x+dQjdgSmepPl/x2gAKVUWZBpkWY
         FCGwOr9WHVRzAV6tn4np2niuw8iFh/GeDf0MbjIySBSCW5wSJQs9KFBLFpQzxcCXlw
         StY5Sm3+X/yode9PdnNMvn96SXlpNxi4Z7XLPAqpKgOwKdr9K6ELLUQLjPPKOehjrr
         aoYcgIjm6/0owobFgP2kPBcv78vo6Lkg2r5mYBqYOZ3ZfB4g1KmaTDAnIY53sNieCT
         FaZY4ePdJaq6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, alex.dewar90@gmail.com,
        colin.king@canonical.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 040/146] media: atomisp: Fix error handling in probe
Date:   Mon,  8 Nov 2021 12:43:07 -0500
Message-Id: <20211108174453.1187052-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 362ed44b4effa..e046489cd253b 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -835,7 +835,6 @@ static int lm3554_probe(struct i2c_client *client)
 	int err = 0;
 	struct lm3554 *flash;
 	unsigned int i;
-	int ret;
 
 	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
 	if (!flash)
@@ -844,7 +843,7 @@ static int lm3554_probe(struct i2c_client *client)
 	flash->pdata = lm3554_platform_data_func(client);
 	if (IS_ERR(flash->pdata)) {
 		err = PTR_ERR(flash->pdata);
-		goto fail1;
+		goto free_flash;
 	}
 
 	v4l2_i2c_subdev_init(&flash->sd, client, &lm3554_ops);
@@ -852,12 +851,12 @@ static int lm3554_probe(struct i2c_client *client)
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
@@ -866,14 +865,15 @@ static int lm3554_probe(struct i2c_client *client)
 
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
@@ -884,16 +884,27 @@ static int lm3554_probe(struct i2c_client *client)
 
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

