Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E039A243AA
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfETWum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44681 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfETWum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id n134so11493305lfn.11;
        Mon, 20 May 2019 15:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P30mKGNYzEwwORkljdWrVwBMZDmQwY8fRFIDFMiJ+i8=;
        b=eiYPRFsKoISjjcP9nlSF7Am6vIhWAz/5h/ogEd/yTpXkt16liUDXSgMeD4816JpX4Q
         Pi2wLL86uP8BatO8N7VSihnKY5ZPIHQUK2s3IZpFpG5kYKcOTJsqYurkI/qkqjgTZSQ8
         bY+tQ3xFNCxaj31zx1mJU4s7YxndZ8EC2q95OrgCqufJmraOVHxWEe+VIYSHVGFPaN7B
         evYk3MhVFYAQg7A0WpP6CGR2hHHqH3zbYeAOq6Yz4UYnl9S/Bght+s5v/8zqZYBrw647
         reqzGhhdwPzwptDQsvnFHaf3SSCPdX7inRa9tybE/t3ewp+ZcBz+CZZCtYLWsWPmtWt0
         3JVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P30mKGNYzEwwORkljdWrVwBMZDmQwY8fRFIDFMiJ+i8=;
        b=Fv8nzMaVAvD91mHOX5qkc3a6gv7eVd1VGFYPzR+a6kRlhHfncMVaRAlbYUYqwuBe2z
         LfdyRyD8NZno6eb1dMBUADTBIX+xEBRSAg7hw8wE1X2bpchmb0R2e89lGp08wPCnXlQB
         5ptYHwx3L6pn1g3Y34LMyMa6I9NPKXjloUcBug5zZgzDLeLHG26Km3vd/q5KMQbUzYLg
         8Yo1Ex8aQnEUq3ny7vekI2syidmRMI9/e/J2y7oyll/jJfAjFKIqWpTfYonw0GsC4OpM
         wWaiTAXeewYm7ZrlMf0iDimMqxq1ZyYwalw3Qiz8QvSHbXci3J09OBwknaCdK94DinMG
         eZ1g==
X-Gm-Message-State: APjAAAUCtz7ts0sWObfHCVY25vStF+QBMr3VcuRFQkxl1Pr9NKZPC7UE
        uHDue4WJVd9REQGnGvqCr6U=
X-Google-Smtp-Source: APXvYqyUbiYn+DhB6NIAjPMq18MpPCT27WxKnLT42HUJydEBbQnSOWxV5o5GSLB6Az2NKKssjG/LOQ==
X-Received: by 2002:a19:c517:: with SMTP id w23mr21346602lfe.73.1558392639691;
        Mon, 20 May 2019 15:50:39 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:39 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 8/9] media: ov6650: Fix stored frame format not in sync with hardware
Date:   Tue, 21 May 2019 00:50:06 +0200
Message-Id: <20190520225007.2308-9-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver stores frame format settings supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, those settings are updated before they are actually applied
on hardware.  If an error occurs on device update, the stored settings
my not reflect hardware state anymore and consecutive calls to
.get_fmt() may return incorrect information.  That in turn may affect
ability of a bridge device to use correct DMA transfer settings if such
incorrect informmation on active frame format returned by .get_fmt() is
used.

Assuming a failed device update mean its state hasn't changed, update
frame format related settings stored in the device private structure
only after they are successfully applied so the stored values always
reflect hardware state as closely as possible.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index b199332f62d7..65d43390dbeb 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -630,7 +630,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
 	}
-	priv->code = code;
 
 	if (code == MEDIA_BUS_FMT_Y8_1X8 ||
 			code == MEDIA_BUS_FMT_SBGGR8_1X8) {
@@ -651,7 +650,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		dev_dbg(&client->dev, "max resolution: CIF\n");
 		coma_mask |= COMA_QCIF;
 	}
-	priv->half_scale = half_scale;
 
 	clkrc = CLKRC_12MHz;
 	mclk = 12000000;
@@ -669,8 +667,13 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
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
 
 	return ret;
 }
-- 
2.21.0

