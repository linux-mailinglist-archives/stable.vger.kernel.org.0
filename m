Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649A31196F8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfLJVJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbfLJVJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB29C2077B;
        Tue, 10 Dec 2019 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012193;
        bh=P0/PbYyyDZsUZPAxA/S55Zz6WtpgAvbR5ywx9JD0LyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIYBjoFHcAE2uhzaoxdt512OiD88B9Gr1mJW5GkXN9TXIFyNtFx2ZmDRBqs98194X
         qHemsVnTRbm6e1C3PwNvYwDd4UqjYEKn7FGMedhYVuw0me4E7Yot3x7s9vU1sj1+se
         7FxPeC0/vMK9drEopVLKMFKxX2AEWEYNYaY7dOcc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 148/350] media: ad5820: Define entity function
Date:   Tue, 10 Dec 2019 16:04:13 -0500
Message-Id: <20191210210735.9077-109-sashal@kernel.org>
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

From: Ricardo Ribalda Delgado <ribalda@kernel.org>

[ Upstream commit 801ef7c4919efba6b96b5aed1e72844ca69e26d3 ]

Without this patch, media_device_register_entity throws a warning:

dev_warn(mdev->dev,
	 "Entity type for entity %s was not initialized!\n",
	 entity->name);

Signed-off-by: Ricardo Ribalda Delgado <ribalda@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ad5820.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 925c171e77976..7a49651f4d1f2 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -309,6 +309,7 @@ static int ad5820_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
 	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	coil->subdev.internal_ops = &ad5820_internal_ops;
+	coil->subdev.entity.function = MEDIA_ENT_F_LENS;
 	strscpy(coil->subdev.name, "ad5820 focus", sizeof(coil->subdev.name));
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
-- 
2.20.1

