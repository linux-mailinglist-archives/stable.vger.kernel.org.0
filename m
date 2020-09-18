Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3834126F1F9
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgIRCzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgIRCHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588A023A05;
        Fri, 18 Sep 2020 02:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394823;
        bh=hHbpTSTPz6WKT02bLRF/XYFd6t/ARAuXZH0O+Ip4sXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuFjREZpXAoUVdGoSyKUqsLlGmiZ0pE1eG+8v4SOv3YFBXPRFZa0stxMFgR8arkOf
         pxkVsY97i51RnFFGQHDiGWN98b261vbo/MidG0V4gddRaoJfxrnBD1f0WLNzZQ8yJx
         4f03Aq3MlKh8GGY1KgP0lnJrzqg4lRzfnueYSoj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 288/330] gpio: rcar: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:00:28 -0400
Message-Id: <20200918020110.2063155-288-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

