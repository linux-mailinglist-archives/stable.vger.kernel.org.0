Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016E12EC37
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbfE3DTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfE3DTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4020424839;
        Thu, 30 May 2019 03:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186348;
        bh=n0EU5+leGe+lJAsvMkP5CTo0DLy0+7c5xiTlKmyNsX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAESjz8ao4H4LgxrbL4rmSU14g/AJijhR+73sBt53SMW3P1bU0Xdg13qdLUBGy4/z
         xb0PKo1hajgC9RlWkOYwZUNSBPNwH85Pi0uaso2maXUDXnBq5yq5A1fi5X3xacxGo2
         LC8wA6Hm/nbxnZdzNPDnh8VmbK2yTChOMNHipys0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/193] pinctrl: pistachio: fix leaked of_node references
Date:   Wed, 29 May 2019 20:05:38 -0700
Message-Id: <20190530030500.659002411@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 55375b1b3cc81..b2b7e238bda97 100644
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



