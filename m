Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E812E156B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgLWCVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgLWCVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1573B22248;
        Wed, 23 Dec 2020 02:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690076;
        bh=w5ONGt/8KxfidV2FLhfW7qk8ftC55R9vQyakaZ64OHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEDffGDnWkPnRQ/r7VnWON51+o50QZ6HB1W3aR7j5EpiQVa3mrImoOJsIpa5dBRJv
         lA3+hNGTLsu/7lxI9duLjMP4hBZJ0RF7rNT7mpJEXNvy2I0/t9KUPD6+7lar62taQB
         thXxtXwW7Q/1QCd+GR/PWE97SA3oUXzu4mCS7fSjxxUu/JyTUCsBSGGCnU6mkTC8Qs
         XSHF3A0pGUI/GjmIdPtwwwqVjmHECj14brPDTYrX5m6Y83VCXvC1l5J7G4IUQwCJ+q
         WMqYnr/rJIngY5I9UXltNMIGUlU2z/q0j8uzGzMC9GPn1Pyd+gcY28SQ+Daf1+pGwl
         hsX14odeyHkwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/87] mips: ar7: add missing iounmap() on error in ar7_gpio_init
Date:   Tue, 22 Dec 2020 21:19:46 -0500
Message-Id: <20201223022103.2792705-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 4eee7e9e26ee2..3ba58f980fec2 100644
--- a/arch/mips/ar7/gpio.c
+++ b/arch/mips/ar7/gpio.c
@@ -332,6 +332,7 @@ int __init ar7_gpio_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to add gpiochip\n",
 					gpch->chip.label);
+		iounmap(gpch->regs);
 		return ret;
 	}
 	printk(KERN_INFO "%s: registered %d GPIOs\n",
-- 
2.27.0

