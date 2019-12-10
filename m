Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CC9119A67
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfLJVHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbfLJVHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869582467E;
        Tue, 10 Dec 2019 21:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012062;
        bh=e1U3n/4kinDehhEPTfpmWkE7lwIgx8DIdsI2E/QIeww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwJmfqWSIIy2uMD4QZEz0YuzmmMD5CcCSBdeqN3Wcg4ysD3meVxS1Dd4Ox4qJ0sMK
         843DUW0PFFpjQj2NcDYi9gfNLiwYjqpc1IP6aCejA+9MXuGyW2/dK2pc9nP2xc1myD
         W1aod528e5ARwKiPnOvEiKr6H5J70CsnyOeBI1Lk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 044/350] media: ov6650: Fix stored frame format not in sync with hardware
Date:   Tue, 10 Dec 2019 16:02:29 -0500
Message-Id: <20191210210735.9077-5-sashal@kernel.org>
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

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 3143b459de4cdcce67b36827476c966e93c1cf01 ]

The driver stores frame format settings supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, those settings are updated before they are actually applied
on hardware.  If an error occurs on device update, the stored settings
my not reflect hardware state anymore and consecutive calls to
.get_fmt() may return incorrect information.  That in turn may affect
ability of a bridge device to use correct DMA transfer settings if such
incorrect informmation on active frame format returned by .get_fmt() is
used.

Assuming a failed device update means its state hasn't changed, update
frame format related settings stored in the device private structure
only after they are successfully applied so the stored values always
reflect hardware state as closely as possible.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index c6af725532585..5426fed2574ec 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -609,7 +609,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
 	}
-	priv->code = code;
 
 	if (code == MEDIA_BUS_FMT_Y8_1X8 ||
 			code == MEDIA_BUS_FMT_SBGGR8_1X8) {
@@ -635,7 +634,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_dbg(&client->dev, "max resolution: CIF\n");
 		coma_mask |= COMA_QCIF;
 	}
-	priv->half_scale = half_scale;
 
 	clkrc = CLKRC_12MHz;
 	mclk = 12000000;
@@ -653,8 +651,13 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
 	if (!ret)
 		ret = ov6650_reg_write(client, REG_CLKRC, clkrc);
-	if (!ret)
+	if (!ret) {
+		priv->half_scale = half_scale;
+
 		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
+	}
+	if (!ret)
+		priv->code = code;
 
 	if (!ret) {
 		mf->colorspace	= priv->colorspace;
-- 
2.20.1

