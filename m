Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA1C15E7FA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404513AbgBNQRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388168AbgBNQRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB9D24691;
        Fri, 14 Feb 2020 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697056;
        bh=hLfZr2lTPwLVvls4QJKmwnrEt7LV1L6ytSfteOuLPOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpS/OumccjRzaZUIoahWD3vEq555GepqwQ6myJGNOprLPh/lSJ+n+czAkiyj+iJe+
         vDdpj3srLjSGaKQy3nzyQXKflD4X9pBl108PNWG2A/uzWZs/m5OVqFewtYneLg/1Vn
         sR2GLQldv0Jn10bFpbB9sF7/YGgCUZeKovhoK9KA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 015/186] media: i2c: mt9v032: fix enum mbus codes and frame sizes
Date:   Fri, 14 Feb 2020 11:14:24 -0500
Message-Id: <20200214161715.18113-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8a430640c85d5..1a20d0d558d3e 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -423,10 +423,12 @@ static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
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
 
@@ -434,7 +436,11 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
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

