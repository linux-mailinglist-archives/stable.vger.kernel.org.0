Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D910147D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfKSFeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbfKSFeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C13020672;
        Tue, 19 Nov 2019 05:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141664;
        bh=AoDNuKQXbiefCOInJ5AY2FFn7JlFLLag6G8EitqjtWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlczYe6Ia8RLDPLBiR06A9Ljr1LmCBXQv2AN+h/gCxFsswEJCkfDze4kT/RFYyDqQ
         W8fE2Qfajl3Uh3S54pmQkrScKa7BJMxDWTV1HTyC3gtcXtcxxeZkPaZzt3i/nqH4cW
         2kED4+9LA3Cw6UAaNsbf+M/0yXDa9AX99ltuT56M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/422] media: ov2680: dont register the v4l2 subdevice before checking chip ID
Date:   Tue, 19 Nov 2019 06:17:16 +0100
Message-Id: <20191119051414.531599519@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



