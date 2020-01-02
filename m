Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7256D12EFB5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgABW2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgABW2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:28:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01B3F21835;
        Thu,  2 Jan 2020 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004121;
        bh=kjRuJZ4zkqTaPLb6Mcyl6g1KSYaK54CVS5pfTHJB3jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SSvHrEatQQ5JBy58jWBA2MYdEjsxBc85gN/DSacoUpihy/6ruyg7olc7gA4hFGTK
         AVC9vDnVt2/+y2779TacEvcijf2G1R6XN23VnWmCwGk+hcAhcehA01MKdwRMAtE1bg
         Pu/tJerQnrGgxm0qRcL80C/fw9sMiDjvR1GMd9ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/171] media: ov6650: Fix stored frame format not in sync with hardware
Date:   Thu,  2 Jan 2020 23:05:50 +0100
Message-Id: <20200102220549.705666599@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/media/i2c/soc_camera/ov6650.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index fc187c5aeb1e..7a119466f973 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -612,7 +612,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
 	}
-	priv->code = code;
 
 	if (code == MEDIA_BUS_FMT_Y8_1X8 ||
 			code == MEDIA_BUS_FMT_SBGGR8_1X8) {
@@ -638,7 +637,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_dbg(&client->dev, "max resolution: CIF\n");
 		coma_mask |= COMA_QCIF;
 	}
-	priv->half_scale = half_scale;
 
 	if (sense) {
 		if (sense->master_clock == 8000000) {
@@ -678,8 +676,13 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
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



