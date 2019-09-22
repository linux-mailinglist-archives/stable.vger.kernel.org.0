Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E73BA949
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfIVTNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438594AbfIVS5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250D521A4A;
        Sun, 22 Sep 2019 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178655;
        bh=VBJNM2vTUgCaLDng6wOKnNX5G5DEU3d89JMapHsEbvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/6DnBcibGJDRp0f69bkev8otdYUrFHq4UBPJFyMgsldX1mHseKnUv8bhe3M+Eeya
         tVGrlu5cRw99BisJUqwMUkYox5aUUBWc0OrM+1UpiyK7CDq/PUCGnA+LeVeSfpIfyP
         InMeJvKbho9EKb1zNHJOox3Hx0MxFzdt7uAos798=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/89] media: i2c: ov5640: Check for devm_gpiod_get_optional() error
Date:   Sun, 22 Sep 2019 14:55:58 -0400
Message-Id: <20190922185717.3412-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 8791a102ce579346cea9d2f911afef1c1985213c ]

The power down and reset GPIO are optional, but the return value
from devm_gpiod_get_optional() needs to be checked and propagated
in the case of error, so that probe deferral can work.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index acf5c8a55bbd2..69f564b0837a7 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2261,9 +2261,14 @@ static int ov5640_probe(struct i2c_client *client,
 	/* request optional power down pin */
 	sensor->pwdn_gpio = devm_gpiod_get_optional(dev, "powerdown",
 						    GPIOD_OUT_HIGH);
+	if (IS_ERR(sensor->pwdn_gpio))
+		return PTR_ERR(sensor->pwdn_gpio);
+
 	/* request optional reset pin */
 	sensor->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
+	if (IS_ERR(sensor->reset_gpio))
+		return PTR_ERR(sensor->reset_gpio);
 
 	v4l2_i2c_subdev_init(&sensor->sd, client, &ov5640_subdev_ops);
 
-- 
2.20.1

