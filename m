Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83E6F656F
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfKJCp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbfKJCp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923F8214E0;
        Sun, 10 Nov 2019 02:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353927;
        bh=H7Djb+n3qjxbE2dVJgW6kUOuIo0sOoojYsnEGEwGFNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Grj27dbWIntNjgj74K+I5jR4G1ELH7heHYghfcgYPTMsIFncdACUEWGZBHQi/Ze3a
         QU2OP9PWZEedD9UfOKPVkUlOo8UwlU3cwFMZgAqgljVUEY4yWJdw1bAH6qPm8lD60C
         Z5OMvRlb/sytNVVgRzrT/X7m2jMvMtCclu7kHaLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 188/191] media: ov2680: fix null dereference at power on
Date:   Sat,  9 Nov 2019 21:40:10 -0500
Message-Id: <20191110024013.29782-188-sashal@kernel.org>
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

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit c45fbdf24c61a7b7a37f1b3bbd46f054637a3627 ]

Swapping the order between v4l2 subdevice registration and checking chip
id in b7a417628abf ("media: ov2680: don't register the v4l2 subdevice
before checking chip ID") makes the mode restore to use the sensor
controls before they are set, so move the mode restore call to s_power
after the handler setup for controls is done.

This remove also the need for the error code path in power on function.

Fixes: b7a417628abf ("media: ov2680: don't register the v4l2 subdevice before checking chip ID")

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 3ccd584568fb5..d8798fb714ba8 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -568,10 +568,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	if (ret < 0)
 		return ret;
 
-	ret = ov2680_mode_restore(sensor);
-	if (ret < 0)
-		goto disable;
-
 	sensor->is_enabled = true;
 
 	/* Set clock lane into LP-11 state */
@@ -580,12 +576,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	ov2680_stream_disable(sensor);
 
 	return 0;
-
-disable:
-	dev_err(dev, "failed to enable sensor: %d\n", ret);
-	ov2680_power_off(sensor);
-
-	return ret;
 }
 
 static int ov2680_s_power(struct v4l2_subdev *sd, int on)
@@ -606,6 +596,8 @@ static int ov2680_s_power(struct v4l2_subdev *sd, int on)
 		ret = v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
 		if (ret < 0)
 			return ret;
+
+		ret = ov2680_mode_restore(sensor);
 	}
 
 	return ret;
-- 
2.20.1

