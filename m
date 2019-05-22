Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65E26BA8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbfEVT2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732239AbfEVT2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FA92173C;
        Wed, 22 May 2019 19:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553318;
        bh=5f5DsRppvtPkTd8qvN1j0+CyRm15kL/kTsabdwPlo3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUUWYNWFMhiCK4WganJkNjHIblUnKKPU2wcakVjvDJAJ+oomYP5TeZ5p2KTYjZm1R
         2VZxltOcq44RJ0NgEBqXx/HzYI/YaKIidOqAmF2aV5FOid2mjXfLw2EI0kVNBhIsYh
         ikwH5s/TErqp4BCf/iIHkwp/5j/FLQq8p/ZyPYJk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 081/244] pinctrl: pistachio: fix leaked of_node references
Date:   Wed, 22 May 2019 15:23:47 -0400
Message-Id: <20190522192630.24917-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 44a4455ac2c6b0981eace683a2b6eccf47689022 ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/pinctrl/pinctrl-pistachio.c:1422:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1360, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-pistachio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-pistachio.c b/drivers/pinctrl/pinctrl-pistachio.c
index 302190d1558d9..0d7d379e9bb80 100644
--- a/drivers/pinctrl/pinctrl-pistachio.c
+++ b/drivers/pinctrl/pinctrl-pistachio.c
@@ -1368,6 +1368,7 @@ static int pistachio_gpio_register(struct pistachio_pinctrl *pctl)
 		if (!of_find_property(child, "gpio-controller", NULL)) {
 			dev_err(pctl->dev,
 				"No gpio-controller property for bank %u\n", i);
+			of_node_put(child);
 			ret = -ENODEV;
 			goto err;
 		}
@@ -1375,6 +1376,7 @@ static int pistachio_gpio_register(struct pistachio_pinctrl *pctl)
 		irq = irq_of_parse_and_map(child, 0);
 		if (irq < 0) {
 			dev_err(pctl->dev, "No IRQ for bank %u: %d\n", i, irq);
+			of_node_put(child);
 			ret = irq;
 			goto err;
 		}
-- 
2.20.1

