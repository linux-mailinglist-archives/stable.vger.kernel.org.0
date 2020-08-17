Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3C2475CC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgHQPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730300AbgHQPcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE11120709;
        Mon, 17 Aug 2020 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678330;
        bh=gfh42KL7ujKCHV4kDSr4rdAn7B6+6CS7vRDFhoN80vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqvHdJmZZGvC0uxWRSpL9q+XqJlHT/xHw9vpRRSR6BDfoaDfPO/625FnF8rxN4Fvk
         2Y9xiZ7N14HwgoF4cH9wQBMobAEeUgOPDGZ2W+4JYobWjuhOzKrmPSf108fn4F1gfb
         P/92fMMBhy447P6xk3jDDtR/I8JXgqnXYQcCVe+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 297/464] gpio: regmap: fix type clash
Date:   Mon, 17 Aug 2020 17:14:10 +0200
Message-Id: <20200817143848.033752577@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit a070bdbbb06d7787ec7844a4f1e059cf8b55205d ]

GPIO_REGMAP_ADDR_ZERO() cast to unsigned long but the actual config
parameters are unsigned int. We use unsigned int here because that is
the type which is used by the underlying regmap.

Fixes: ebe363197e52 ("gpio: add a reusable generic gpio_chip using regmap")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20200725232337.27581-1-michael@walle.cc
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/regmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/gpio/regmap.h b/include/linux/gpio/regmap.h
index 4c1e6b34e8249..ad76f3d0a6ba1 100644
--- a/include/linux/gpio/regmap.h
+++ b/include/linux/gpio/regmap.h
@@ -8,7 +8,7 @@ struct gpio_regmap;
 struct irq_domain;
 struct regmap;
 
-#define GPIO_REGMAP_ADDR_ZERO ((unsigned long)(-1))
+#define GPIO_REGMAP_ADDR_ZERO ((unsigned int)(-1))
 #define GPIO_REGMAP_ADDR(addr) ((addr) ? : GPIO_REGMAP_ADDR_ZERO)
 
 /**
-- 
2.25.1



