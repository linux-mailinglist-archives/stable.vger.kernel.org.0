Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BABF4AD6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbfKHMLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733173AbfKHLjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4982C20869;
        Fri,  8 Nov 2019 11:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213154;
        bh=T0NdGXpxX/JOdmUIDSeN9sirnn0R81CApny5woGcC0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbJ8+R5gI6wsjZcHxeQR0PxxS2GBLGSU3pLVxZUWMqw0Nu3uLFJhHUJqqPSgukp+a
         f2sfD/g5DVyrgSu9cxvzRVwUa9+dpEkCeSH6ZYntiMw4jm+jjlozqX7xby2KscTwO1
         DO1FkDWVtuT9MnG/DxyT7xjJShHAVVqqldJUCNRo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 061/205] media: ov772x: Disable clk on error path
Date:   Fri,  8 Nov 2019 06:35:28 -0500
Message-Id: <20191108113752.12502-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 1d18c2cd9d38ad639b2e00546b9ee638f2cef4b0 ]

If ov772x_power_on() is unable to get GPIO rstb,
the clock is left undisabled.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 7158c31d8403b..4eae5f2f7d318 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -896,6 +896,7 @@ static int ov772x_power_on(struct ov772x_priv *priv)
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->rstb_gpio)) {
 		dev_info(&client->dev, "Unable to get GPIO \"reset\"");
+		clk_disable_unprepare(priv->clk);
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
-- 
2.20.1

