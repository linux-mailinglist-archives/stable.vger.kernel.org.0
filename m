Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96CE16786D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgBUIsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:48:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbgBUHqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:46:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E002208C4;
        Fri, 21 Feb 2020 07:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271202;
        bh=c7JCE0FUS+3bdwXpx4DK8SQXjElF8rXBOwR4c3H51RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO8mCzjn9na203pNXUOrvWMDANOWe+f/Ptdqon0ZAw2uTBBxf8J1xDgxPOLOO0/mP
         NjON7K6Ow1At9dKjAuhPnWFxPjkHW/NGqEeZsZU7jqBH4RokrnqiAlK9VmIzzX4el6
         YtnFoLcPBdLQAKBK/Q+8SnIwONHC2hMjjqZiXBFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenyou Yang <wenyou.yang@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 040/399] media: i2c: mt9v032: fix enum mbus codes and frame sizes
Date:   Fri, 21 Feb 2020 08:36:05 +0100
Message-Id: <20200221072406.249690333@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 1451d5ae351d938a0ab1677498c893f17b9ee21d ]

This driver supports both the mt9v032 (color) and the mt9v022 (mono)
sensors. Depending on which sensor is used, the format from the sensor is
different. The format.code inside the dev struct holds this information.
The enum mbus and enum frame sizes need to take into account both type of
sensors, not just the color one. To solve this, use the format.code in
these functions instead of the hardcoded bayer color format (which is only
used for mt9v032).

[Sakari Ailus: rewrapped commit message]

Suggested-by: Wenyou Yang <wenyou.yang@microchip.com>
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9v032.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 4b9b98cf6674c..5bd3ae82992f3 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -428,10 +428,12 @@ static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
+	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
+
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	code->code = mt9v032->format.code;
 	return 0;
 }
 
@@ -439,7 +441,11 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index >= 3 || fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
+
+	if (fse->index >= 3)
+		return -EINVAL;
+	if (mt9v032->format.code != fse->code)
 		return -EINVAL;
 
 	fse->min_width = MT9V032_WINDOW_WIDTH_DEF / (1 << fse->index);
-- 
2.20.1



