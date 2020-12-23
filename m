Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE82F2E16FE
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgLWDEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbgLWCTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3CE223341;
        Wed, 23 Dec 2020 02:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689917;
        bh=I7LqFMNCjfFmLfJCVKzzcGtnmG3sTxorI68QB658CFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWPg/adnh+3H/z0f4oZ1i/SxTAIXbA+V/r11qyhxKGOCWGhjICZXwSwNxmaDVKwcy
         a9mc14lyXTVk0KMU00YQ7Xtsj7voFLSkS/n7gTo0WxC4QN3J5ceE4QuBqzNJmOBdkQ
         82Vxdn3iV0Vw4/CIWTvbeep/h3a+tPxQbgLlcSlNHaeHnTi0izJ9wIyWxFJtXPloE7
         R1NKeKkULpmkSSHmNDOZTRtXGBc82sjn5o/1diZv706D2inGzrpFQYGYh1RplDDJSG
         MVfAAnedibizaxNVS9SFWM0KlXC+FwdNIALUcXM8KkEJYiaFLvwGJ5xh2UhVeS4vb/
         EISL8R2nHgfcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 018/130] mips: ar7: add missing iounmap() on error in ar7_gpio_init
Date:   Tue, 22 Dec 2020 21:16:21 -0500
Message-Id: <20201223021813.2791612-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 5a5aa912f687204d50455d0db36f94dd8de601c2 ]

Add the missing iounmap() of gpch->regs before return from
ar7_gpio_init() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ar7/gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/ar7/gpio.c b/arch/mips/ar7/gpio.c
index 2292e55c12e23..b7ad7a3ecb6d7 100644
--- a/arch/mips/ar7/gpio.c
+++ b/arch/mips/ar7/gpio.c
@@ -319,6 +319,7 @@ int __init ar7_gpio_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to add gpiochip\n",
 					gpch->chip.label);
+		iounmap(gpch->regs);
 		return ret;
 	}
 	printk(KERN_INFO "%s: registered %d GPIOs\n",
-- 
2.27.0

