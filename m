Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728B72E4275
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439358AbgL1PXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436619AbgL1OBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB192064B;
        Mon, 28 Dec 2020 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164076;
        bh=78DGMlegYay+NAmrbGiq7DLAKwscd8kCXZYlTG2YNqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEaMgNjbOL/ZMVOw+367qun4nw2BlCIrFRAACBPR0HwCbzQvdz4sQPgsYqKKRdALQ
         mBM119B6r4smi8wSGut5cnu63SrI5v4MohlOZ9DTNjQ4MbfXmJBYqxrsKatcEZjBrJ
         mJz9KeNFxBkeWh3fAiTApi/6OTDV2uO17s3UteuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/717] pinctrl: core: Add missing #ifdef CONFIG_GPIOLIB
Date:   Mon, 28 Dec 2020 13:40:50 +0100
Message-Id: <20201228125023.485376911@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit b507cb92477ad85902783a183c5ce01d16296687 ]

To fix the following build warnings when CONFIG_GPIOLIB=n.

drivers/pinctrl/core.c:1607:20: warning: unused variable 'chip' [-Wunused-variable]
 1608 |  struct gpio_chip *chip;
      |                    ^~~~
drivers/pinctrl/core.c:1606:15: warning: unused variable 'gpio_num' [-Wunused-variable]
 1607 |  unsigned int gpio_num;
      |               ^~~~~~~~
drivers/pinctrl/core.c:1605:29: warning: unused variable 'range' [-Wunused-variable]
 1606 |  struct pinctrl_gpio_range *range;
      |                             ^~~~~

Fixes: f1b206cf7c57 ("pinctrl: core: print gpio in pins debugfs file")
Signed-off-by: He Zhe <zhe.he@windriver.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20201028103921.22486-1-zhe.he@windriver.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 3663d87f51a01..9fc4433fece4f 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1602,9 +1602,11 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 	struct pinctrl_dev *pctldev = s->private;
 	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
 	unsigned i, pin;
+#ifdef CONFIG_GPIOLIB
 	struct pinctrl_gpio_range *range;
 	unsigned int gpio_num;
 	struct gpio_chip *chip;
+#endif
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
 
-- 
2.27.0



