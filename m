Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418C713E099
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgAPQo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgAPQo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EA62073A;
        Thu, 16 Jan 2020 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193065;
        bh=3Bu9Xt7gsNO1n4q+DjARvNjjlYwsFVTl5s/dPAEKF4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCStoFXwZ6G1NZkIWYMgQ0RQr36K8QzKPTn8irrhXcdPUCsVq4puUURI1wFF+tNJ7
         NgAvThgOoE9omhOSVPAhEUbgfv+VzFlw7cjTZg2+YveQKiCYme8zyS5Gpo6MI324y+
         pAWK0HWBh3hU1DmcmN9KfFfkX1JfBtL5/ONp1+tA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 017/205] media: ov6650: Fix default format not applied on device probe
Date:   Thu, 16 Jan 2020 11:39:52 -0500
Message-Id: <20200116164300.6705-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 5439fa9263cb293e41168bc03711ec18c4f11cba ]

It is not clear what pixel format is actually configured in hardware on
reset.  MEDIA_BUS_FMT_YUYV8_2X8, assumed on device probe since the
driver was intiially submitted, is for sure not the one.

Fix it by explicitly applying a known, driver default frame format just
after initial device reset.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index bbf15644e989..af482620f94a 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -877,6 +877,11 @@ static int ov6650_video_probe(struct v4l2_subdev *sd)
 	ret = ov6650_reset(client);
 	if (!ret)
 		ret = ov6650_prog_dflt(client);
+	if (!ret) {
+		struct v4l2_mbus_framefmt mf = ov6650_def_fmt;
+
+		ret = ov6650_s_fmt(sd, &mf);
+	}
 	if (!ret)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
@@ -1031,8 +1036,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.top	  = DEF_VSTRT << 1;
 	priv->rect.width  = W_CIF;
 	priv->rect.height = H_CIF;
-	priv->half_scale  = false;
-	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	/* Hardware default frame interval */
 	priv->tpf.numerator   = GET_CLKRC_DIV(DEF_CLKRC);
-- 
2.20.1

