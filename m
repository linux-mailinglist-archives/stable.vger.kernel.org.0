Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594DFCA630
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404967AbfJCQkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404965AbfJCQkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54CAF2070B;
        Thu,  3 Oct 2019 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120851;
        bh=3J51t1zJfEomA/al1Z3i4PXwF7s1o8TPuA25Tg3ecf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQZMeZduYXQkMU9PwBju5hP467qzccEJlsAMIo+1UcQw3pyBKLnICkDmlkfEptAPD
         jVkkl0omgdOCwRcRJiwqPPAmow/kobfpL5A1u1ZZKhhj/ih+3ytYo9gADEDCqXWhzl
         bo3uvBv7OEJcGlzPF2u2rufIF1bbOyaoQ1ZemDTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 060/344] media: i2c: ov5640: Check for devm_gpiod_get_optional() error
Date:   Thu,  3 Oct 2019 17:50:25 +0200
Message-Id: <20191003154546.050354545@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



