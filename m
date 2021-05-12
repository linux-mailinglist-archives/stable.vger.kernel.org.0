Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7837C51B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhELPiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhELP3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CB8613EB;
        Wed, 12 May 2021 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832520;
        bh=IqrkexZiYUYNlsPW7FcNADj1RgE+DvMZMMInsO/nQT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoSNjEb6A8NOaSLDC1NI8vbSQQs0WYLbrP+toN6fdWb+F0VkAl/YtO+ye1JJAU8CO
         jSmju0mMCoKCBga/ROHXCCAsm8vo6g1Wm6mnIrxBrXsaIUKpZBSsP8rtomD/uPMgh/
         rkuoiAm1u4qwTSW1p0fifPOswrzXc4RpaSxO5Pzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/530] media: i2c: imx219: Move out locking/unlocking of vflip and hflip controls from imx219_set_stream
Date:   Wed, 12 May 2021 16:47:03 +0200
Message-Id: <20210512144830.094192632@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 745d4612d2c853c00abadbf69799c8aee7f99c39 ]

Move out locking/unlocking of vflip and hflip controls from
imx219_set_stream() to the imx219_start_streaming()/
imx219_stop_streaming() respectively.

This fixes an issue in resume callback error path where streaming is
stopped and the controls are left in locked state.

Fixes: 1283b3b8f82b9 ("media: i2c: Add driver for Sony IMX219 sensor")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 0ae66091a696..9520b5dc2bc7 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -1047,8 +1047,16 @@ static int imx219_start_streaming(struct imx219 *imx219)
 		return ret;
 
 	/* set stream on register */
-	return imx219_write_reg(imx219, IMX219_REG_MODE_SELECT,
-				IMX219_REG_VALUE_08BIT, IMX219_MODE_STREAMING);
+	ret = imx219_write_reg(imx219, IMX219_REG_MODE_SELECT,
+			       IMX219_REG_VALUE_08BIT, IMX219_MODE_STREAMING);
+	if (ret)
+		return ret;
+
+	/* vflip and hflip cannot change during streaming */
+	__v4l2_ctrl_grab(imx219->vflip, true);
+	__v4l2_ctrl_grab(imx219->hflip, true);
+
+	return 0;
 }
 
 static void imx219_stop_streaming(struct imx219 *imx219)
@@ -1061,6 +1069,9 @@ static void imx219_stop_streaming(struct imx219 *imx219)
 			       IMX219_REG_VALUE_08BIT, IMX219_MODE_STANDBY);
 	if (ret)
 		dev_err(&client->dev, "%s failed to set stream\n", __func__);
+
+	__v4l2_ctrl_grab(imx219->vflip, false);
+	__v4l2_ctrl_grab(imx219->hflip, false);
 }
 
 static int imx219_set_stream(struct v4l2_subdev *sd, int enable)
@@ -1096,10 +1107,6 @@ static int imx219_set_stream(struct v4l2_subdev *sd, int enable)
 
 	imx219->streaming = enable;
 
-	/* vflip and hflip cannot change during streaming */
-	__v4l2_ctrl_grab(imx219->vflip, enable);
-	__v4l2_ctrl_grab(imx219->hflip, enable);
-
 	mutex_unlock(&imx219->mutex);
 
 	return ret;
-- 
2.30.2



