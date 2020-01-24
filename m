Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D2A14800F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389422AbgAXLHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389382AbgAXLHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:20 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A5320663;
        Fri, 24 Jan 2020 11:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864040;
        bh=0Vmmz/P/NKBqwv4ewIyT/SUF6hQ2OF6SKqx4rTyDV4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1dI26QkxbDfIDJikJvvlwz87UlAxDHnuYvka4af2nOXWO0ycsxJOnfz0AgUQwC37
         oyNIR9tEbPm05ksnrSwOofserm0f2zoroaXJHmMc+tcXe6FmZWCIuVOms1RNa4GF8j
         cofMtNNhQC3emPj5uKoHSNhUS0zyXp8z1fpD0ff4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/639] media: tw9910: Unregister subdevice with v4l2-async
Date:   Fri, 24 Jan 2020 10:25:11 +0100
Message-Id: <20200124093104.921622772@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 341fe1d301f587c930509f6b9153436b957f649c ]

As the tw9910 subdevice is registered through the v4l2-async framework,
use the v4l2-async provided function to register it.

Fixes: 7b20f325a566 ("media: i2c: tw9910: Remove soc_camera dependencies")

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tw9910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index a54548cc42857..c7321a70e3ed0 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -1000,7 +1000,7 @@ static int tw9910_remove(struct i2c_client *client)
 	if (priv->pdn_gpio)
 		gpiod_put(priv->pdn_gpio);
 	clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 
 	return 0;
 }
-- 
2.20.1



