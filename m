Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC716238C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389570AbfGHPcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389559AbfGHPcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1806D216C4;
        Mon,  8 Jul 2019 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599939;
        bh=/v6DFyjTK8RJrPmYZ86thafzpngkndlV4QIRFrJJiMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUg8uPYAKTQfLQnpLZxR2/NuACObIUKTg2C8K2CPLeFMe3mPhL7jQR+I6rUl0Cnr7
         FMuamdFcfhmU3GAqq8C7i7fizge6+YBP69b5Yey9zqTBl055pqFzn+t6LqFxxQprPL
         8Pr682pXe+Ov5iG9GQybeVmchwfYVJW9UefbdoiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 39/96] gpio: pca953x: hack to fix 24 bit gpio expanders
Date:   Mon,  8 Jul 2019 17:13:11 +0200
Message-Id: <20190708150528.673731294@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3b00691cc46a4089368a008b30655a8343411715 ]

24 bit expanders use REG_ADDR_AI in combination with register addressing. This
conflicts with regmap which takes this bit as part of the register number,
i.e. a second cache entry is defined for accessed with REG_ADDR_AI being
set although on the chip it is the same register as with REG_ADDR_AI being
cleared.

The problem was introduced by

	commit b32cecb46bdc ("gpio: pca953x: Extract the register address mangling to single function")

but only became visible by

	commit 8b9f9d4dc511 ("regmap: verify if register is writeable before writing operations")

because before, the regmap size was effectively ignored and
pca953x_writeable_register() did know to ignore REG_ADDR_AI. Still, there
were two separate cache entries created.

Since the use of REG_ADDR_AI seems to be static we can work around this
issue by simply increasing the size of the regmap to cover the "virtual"
registers with REG_ADDR_AI being set. This only means that half of the
regmap buffer will be unused.

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 7e76830b3368..b6f10e56dfa0 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -306,7 +306,8 @@ static const struct regmap_config pca953x_i2c_regmap = {
 	.volatile_reg = pca953x_volatile_register,
 
 	.cache_type = REGCACHE_RBTREE,
-	.max_register = 0x7f,
+	/* REVISIT: should be 0x7f but some 24 bit chips use REG_ADDR_AI */
+	.max_register = 0xff,
 };
 
 static u8 pca953x_recalc_addr(struct pca953x_chip *chip, int reg, int off,
-- 
2.20.1



