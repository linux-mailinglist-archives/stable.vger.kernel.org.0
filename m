Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91672E136C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgLWC3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:29:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbgLWCZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BD3123343;
        Wed, 23 Dec 2020 02:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690326;
        bh=GHzkwRB+x0w1z+Lqje1Hki/1o6nhFMA6Lqty3Byc4UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNXzboE6rFXFizGF4GmVYqXEkgC0y/J/ZiqfkN17unZQLu/t5OOyZde0m9mJO71fF
         MKqdq/XhfsuC+9oPCqfff0/qmfVfajgwo3BnYzovs3T/LPs7cY6ifLT7HmhWOidamI
         PThtGrFf++35RR6sC+gLIDEOE75oca1jnLZ8X7/mXLUYa5oU1jt0ApCMU0LzuYfRTu
         ZlRg3RRZeyAx0XHsdges0kbV09NyuBdTDeshFfh3AAmCyuzwJimw/rLNjzmOqhAAxI
         cYHhA+njwI+oMGdVeCLx6jzYzgUfrXKdHBgU4CyrxeX4O4vp9I0G2AzBT8THnDC9s4
         yZeRGY7I658YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/38] mips: ar7: add missing iounmap() on error in ar7_gpio_init
Date:   Tue, 22 Dec 2020 21:24:45 -0500
Message-Id: <20201223022516.2794471-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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
index f4930456eb8e8..f7b9c8002d1ca 100644
--- a/arch/mips/ar7/gpio.c
+++ b/arch/mips/ar7/gpio.c
@@ -339,6 +339,7 @@ int __init ar7_gpio_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to add gpiochip\n",
 					gpch->chip.label);
+		iounmap(gpch->regs);
 		return ret;
 	}
 	printk(KERN_INFO "%s: registered %d GPIOs\n",
-- 
2.27.0

