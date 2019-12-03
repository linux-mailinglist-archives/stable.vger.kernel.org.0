Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04E111EEA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfLCWty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729676AbfLCWtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDC22084B;
        Tue,  3 Dec 2019 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413391;
        bh=oRalRQLcvw3mDLy4hoii35OLsY/POsYuwsyEtYJ06wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhXxfRB49bTNn+mQ8cLMCuV//gZ+641UGPoikvW39BEO0e2bOVImc0UwRaE/KzEfw
         HU5BKNGGlQLcgnArXMSfbTo3ahwsiogj1HfcDuN0ra6vb1QlDYJzJpWG+B+tMXBFUg
         ex93bbjkZWXDxIcVYw52GNYwpUa1pqhESuMOIAdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/321] gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB
Date:   Tue,  3 Dec 2019 23:32:56 +0100
Message-Id: <20191203223432.875862512@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



