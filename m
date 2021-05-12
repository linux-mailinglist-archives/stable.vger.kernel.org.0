Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C032837C8F9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhELQOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239395AbhELQH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A350E61C58;
        Wed, 12 May 2021 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833888;
        bh=1hIczK2c9Pe72dJN4nztRkRbHwsTEgqEsGcUjmlRvfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w62HN0qP7a3KqoA0Om/oHWEg1DDH2gNHHXQYKhoL5OTmcY8DCH2EuE194VFewe1F5
         asTjM4dIeuONfrmOAt0KlCgiJLA+g6/LIhWFgbFuHGSYy+wpRmWUL1g6+JP3DTUFdH
         m/yziaGBDGUdLBONcm7iMPian/czikkiLaFDAMgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 327/601] media: [next] staging: media: atomisp: fix memory leak of object flash
Date:   Wed, 12 May 2021 16:46:44 +0200
Message-Id: <20210512144838.573124127@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 6045b01dd0e3cd3759eafe7f290ed04c957500b1 ]

In the case where the call to lm3554_platform_data_func returns an
error there is a memory leak on the error return path of object
flash.  Fix this by adding an error return path that will free
flash and rename labels fail2 to fail3 and fail1 to fail2.

Link: https://lore.kernel.org/linux-media/20200902165852.201155-1-colin.king@canonical.com
Fixes: 9289cdf39992 ("staging: media: atomisp: Convert to GPIO descriptors")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/i2c/atomisp-lm3554.c        | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 7ca7378b1859..0ab67b2aec67 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -843,8 +843,10 @@ static int lm3554_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	flash->pdata = lm3554_platform_data_func(client);
-	if (IS_ERR(flash->pdata))
-		return PTR_ERR(flash->pdata);
+	if (IS_ERR(flash->pdata)) {
+		err = PTR_ERR(flash->pdata);
+		goto fail1;
+	}
 
 	v4l2_i2c_subdev_init(&flash->sd, client, &lm3554_ops);
 	flash->sd.internal_ops = &lm3554_internal_ops;
@@ -856,7 +858,7 @@ static int lm3554_probe(struct i2c_client *client)
 				   ARRAY_SIZE(lm3554_controls));
 	if (ret) {
 		dev_err(&client->dev, "error initialize a ctrl_handler.\n");
-		goto fail2;
+		goto fail3;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lm3554_controls); i++)
@@ -865,14 +867,14 @@ static int lm3554_probe(struct i2c_client *client)
 
 	if (flash->ctrl_handler.error) {
 		dev_err(&client->dev, "ctrl_handler error.\n");
-		goto fail2;
+		goto fail3;
 	}
 
 	flash->sd.ctrl_handler = &flash->ctrl_handler;
 	err = media_entity_pads_init(&flash->sd.entity, 0, NULL);
 	if (err) {
 		dev_err(&client->dev, "error initialize a media entity.\n");
-		goto fail1;
+		goto fail2;
 	}
 
 	flash->sd.entity.function = MEDIA_ENT_F_FLASH;
@@ -884,14 +886,15 @@ static int lm3554_probe(struct i2c_client *client)
 	err = lm3554_gpio_init(client);
 	if (err) {
 		dev_err(&client->dev, "gpio request/direction_output fail");
-		goto fail2;
+		goto fail3;
 	}
 	return atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
-fail2:
+fail3:
 	media_entity_cleanup(&flash->sd.entity);
 	v4l2_ctrl_handler_free(&flash->ctrl_handler);
-fail1:
+fail2:
 	v4l2_device_unregister_subdev(&flash->sd);
+fail1:
 	kfree(flash);
 
 	return err;
-- 
2.30.2



