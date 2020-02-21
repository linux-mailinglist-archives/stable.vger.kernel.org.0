Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A51673F2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbgBUIRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbgBUIRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:17:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3EE24670;
        Fri, 21 Feb 2020 08:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273028;
        bh=Vpm/cz36dyRSQNVKx2X+LFRPRQifTpcBfMITrEp7/fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy+4A5uHOuo8d4qkbXWqLl0pfcq9GTjyFuRpqF8DL9QfJEMXJ+QeAqVPnbOe3ONlB
         VKLPjs6torDg6SVtR2/vWsXpvykG7pKyqqciqZ/CPEsF4FCpK5+/yDTcYvKO/Et249
         k3KDl49tnzH5vIgXfW3BR2aI4SNgszIx804+B0NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenyou Yang <wenyou.yang@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/191] media: i2c: mt9v032: fix enum mbus codes and frame sizes
Date:   Fri, 21 Feb 2020 08:39:54 +0100
Message-Id: <20200221072253.725612874@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index f74730d24d8fe..04788692c9ff4 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -431,10 +431,12 @@ static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
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
 
@@ -442,7 +444,11 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
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



