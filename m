Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35FF6702
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfKJDRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfKJCkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F072184C;
        Sun, 10 Nov 2019 02:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353620;
        bh=AoDNuKQXbiefCOInJ5AY2FFn7JlFLLag6G8EitqjtWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZn7h5MhahZg5ixdurmOo049YTGV3P30WiVPxOrX/AsSZ+UcjCQj5yPft1UBli6Mi
         5o95F/CmGFgU2qoG5gIJQQJNRbIKPbE33oe4CYEe7n1xmm3Tu67xMY+fQlpNaR5S1r
         yaFKaxI+BGUHDfLotC5wxud0pdg6Mn6JWLJ1zeR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 005/191] media: ov2680: don't register the v4l2 subdevice before checking chip ID
Date:   Sat,  9 Nov 2019 21:37:07 -0500
Message-Id: <20191110024013.29782-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit b7a417628abf49dae98cb80a272dc133b0e4d1a3 ]

The driver registers the v4l2 subdevice before attempting to power on the
chip and checking its ID. This means that a media device driver that it's
waiting for this subdevice to be bound, will prematurely expose its media
device node to userspace because if something goes wrong the media entity
will be cleaned up again on the ov2680 probe function.

This also simplifies the probe function error path since no initialization
is made before attempting to enable the resources or checking the chip ID.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index f753a1c333ef9..3ccd584568fb5 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1088,26 +1088,20 @@ static int ov2680_probe(struct i2c_client *client)
 
 	mutex_init(&sensor->lock);
 
-	ret = ov2680_v4l2_init(sensor);
+	ret = ov2680_check_id(sensor);
 	if (ret < 0)
 		goto lock_destroy;
 
-	ret = ov2680_check_id(sensor);
+	ret = ov2680_v4l2_init(sensor);
 	if (ret < 0)
-		goto error_cleanup;
+		goto lock_destroy;
 
 	dev_info(dev, "ov2680 init correctly\n");
 
 	return 0;
 
-error_cleanup:
-	dev_err(dev, "ov2680 init fail: %d\n", ret);
-
-	media_entity_cleanup(&sensor->sd.entity);
-	v4l2_async_unregister_subdev(&sensor->sd);
-	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
-
 lock_destroy:
+	dev_err(dev, "ov2680 init fail: %d\n", ret);
 	mutex_destroy(&sensor->lock);
 
 	return ret;
-- 
2.20.1

