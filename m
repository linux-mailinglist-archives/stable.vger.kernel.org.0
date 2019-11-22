Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352A41065E3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfKVFuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbfKVFuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2D22070E;
        Fri, 22 Nov 2019 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401820;
        bh=oRalRQLcvw3mDLy4hoii35OLsY/POsYuwsyEtYJ06wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/RXbXFyudwcVDMaHlK8f3+Y8RFaNLrIdjEv1N5oQGE9WoaQQV3W0doXzHMkkner6
         e4MhI+2CINsd6+TuUOozK3gZuR4Hw+yagQslWRLz7FwUcQTFv3ukeFj8plOHyAYlBc
         H34vC1unDNz2GPHJTFJ6VqeiSuURM/VM16DK4uuo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 064/219] gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB
Date:   Fri, 22 Nov 2019 00:46:36 -0500
Message-Id: <20191122054911.1750-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 412098b24f58b..8dfd8300d9c31 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -475,7 +475,7 @@ static inline int gpiod_set_consumer_name(struct gpio_desc *desc,
 
 static inline struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
-	return ERR_PTR(-EINVAL);
+	return NULL;
 }
 
 static inline int desc_to_gpio(const struct gpio_desc *desc)
-- 
2.20.1

