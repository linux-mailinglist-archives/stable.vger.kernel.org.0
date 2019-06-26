Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA256098
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfFZDnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfFZDm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:42:58 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C92C21655;
        Wed, 26 Jun 2019 03:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520577;
        bh=l4wRp0ciZsdiP8bdq+krdoTNEqZRrCAe8x8ByEs1JDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsEO1GsDeK7aGxCPC/nqo31EXl+JeSukNeQD+PKE88kVUZrnlgA8ifaH9fZhu6ySS
         r1KkBQ/OCgzhm0tN71vSFRUwSLh1WKyrL3jrPzvsfPdXCwA/vu8A95kOHI8Vk2qviV
         ExQrauKHSne3NEfmTP1r8XdjBpYWgimhiEyjp+8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 35/51] gpio: pca953x: hack to fix 24 bit gpio expanders
Date:   Tue, 25 Jun 2019 23:40:51 -0400
Message-Id: <20190626034117.23247-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

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

