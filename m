Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E987627C61A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgI2Llw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729305AbgI2Llp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8949206A5;
        Tue, 29 Sep 2020 11:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379705;
        bh=hHbpTSTPz6WKT02bLRF/XYFd6t/ARAuXZH0O+Ip4sXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1r+8IZucUy8Bf+KHIV0rY7I8QuFgDg9cmc0rik7uajF848XEW6YcCdDd6pnDjXax
         AjDpvCSKKvUefGInoFXXW4ZJwzf9EfRfSNiit2xgzyAsMPD0VjUperQXF+yaKqZBPH
         pqSLcH9+cFaHNKg5FpqB/rEXxSRT+RgtsVpArkj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/388] gpio: rcar: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:11 +0200
Message-Id: <20200929110024.008806976@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 6f8cd246411575703d9312888b70705c396b53a9 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20200522080839.32612-1-dinghao.liu@zju.edu.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rcar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index 187984d26f47a..f0b6c68e848e3 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -250,8 +250,10 @@ static int gpio_rcar_request(struct gpio_chip *chip, unsigned offset)
 	int error;
 
 	error = pm_runtime_get_sync(p->dev);
-	if (error < 0)
+	if (error < 0) {
+		pm_runtime_put(p->dev);
 		return error;
+	}
 
 	error = pinctrl_gpio_request(chip->base + offset);
 	if (error)
-- 
2.25.1



