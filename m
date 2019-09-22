Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EA2BAAA8
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbfIVT3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392822AbfIVSuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16054208C2;
        Sun, 22 Sep 2019 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178215;
        bh=3J51t1zJfEomA/al1Z3i4PXwF7s1o8TPuA25Tg3ecf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYMfmH+ZxwN/A+GO25p+04Jf5aXaqPvmItLiboNxDB9nxck02GHKcuwBrik6IsA0o
         WhMIiOZ3213OEaECRWouCFpQ1gwZOSRCcsS5yew0WZHJLJJG/uSYIJyMZ/PqW1dh/B
         EamE+jEYwKf7dostFbGE0H6Nuq6+inqnuLYxOChs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 020/185] media: i2c: ov5640: Check for devm_gpiod_get_optional() error
Date:   Sun, 22 Sep 2019 14:46:38 -0400
Message-Id: <20190922184924.32534-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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
index 759d60c6d6304..afe7920557a8f 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3022,9 +3022,14 @@ static int ov5640_probe(struct i2c_client *client,
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

