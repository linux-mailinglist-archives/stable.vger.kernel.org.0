Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448FD106306
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfKVGH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfKVGBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157AD20714;
        Fri, 22 Nov 2019 06:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402510;
        bh=qiar1VaVBvPmu92UC81QiJx1uqOjg2HjOpaJCa2CW2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JItR1sLLEdQxc9toUSCQYHHFRWCBbfLwY+MQ5I9zs4IjOKXot0CUYTPF2hK21ua2u
         ImKhdHYmq58poEg5Ac6X6GoECsEGnDae6TDh2R2sG1Qxhl+xeC0wTOtMuYYBHBhATl
         NZFf2d38g+3McH9zb10gikc5AT56ORWh7Yu5mZbo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 20/91] gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB
Date:   Fri, 22 Nov 2019 01:00:18 -0500
Message-Id: <20191122060129.4239-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c5510b8dafce5f3f5a039c9b262ebcae0092c462 ]

If CONFIG_GPOILIB is not set, the stub of gpio_to_desc() should return
the same type of error as regular version: NULL.  All the callers
compare the return value of gpio_to_desc() against NULL, so returned
ERR_PTR would be treated as non-error case leading to dereferencing of
error value.

Fixes: 79a9becda894 ("gpiolib: export descriptor-based GPIO interface")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index fb0fde686cb1f..4a9838feb0866 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -398,7 +398,7 @@ static inline int gpiod_to_irq(const struct gpio_desc *desc)
 
 static inline struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
-	return ERR_PTR(-EINVAL);
+	return NULL;
 }
 
 static inline int desc_to_gpio(const struct gpio_desc *desc)
-- 
2.20.1

