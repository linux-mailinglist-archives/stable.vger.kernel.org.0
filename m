Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE01018AB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfKSF10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbfKSF10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63718208C3;
        Tue, 19 Nov 2019 05:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141245;
        bh=T0NdGXpxX/JOdmUIDSeN9sirnn0R81CApny5woGcC0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlEVFV7G7ePPShmyS8IyH+BymWNtUNChaqrjfFBgRv6EAASq59m0Nzc0+eq9KtR+s
         H6n9dy4c3hom5esHCA4IrTWKr/up+qT0h1wE3nUkruwBCxK7DZXOVnV1HtWgPAsyG2
         Y76y5vW6RG3XjcINiY4NCCwMRX+omIqRDF+TruEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/422] media: ov772x: Disable clk on error path
Date:   Tue, 19 Nov 2019 06:14:50 +0100
Message-Id: <20191119051405.369484596@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



