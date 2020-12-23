Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145CA2E13CD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgLWCfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgLWCYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D390422A99;
        Wed, 23 Dec 2020 02:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690267;
        bh=FQoMx8/Vv+oEZVGimzEHYEgR7aO3ag5ba51QdiR6EYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCASl1P2IC0eBnZPrwrPdCXDcS/NKNj96X3q/6XSqyMI8REM1Dw3zQWm5D2mw5NJK
         v+mKfYTlLM2IchTDZ10+09XXwlaEbT7qJN6hxPi/d0NeBTPOiGg8BXG0cmrTlmtbIT
         Uj70gRYqqwCVEntkQmSJu5dk04SlVh7lgoYtqL/5oRqksGCH5N5dHimGPP4Md5kHYh
         aLPUJ0FQkju1bkWYDeYbekkcumYY3t6I75muSlgYeKu0hVTmp+59iyBmHEt2v2sCsh
         7T8k0vT5hwEzqJjxKrczkQENCvnyYhJUkFBCkx8LlXeYnn1J5nAfzldg1TGLfWlUAA
         Pe9C+rZjDWNpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/48] mips: ar7: add missing iounmap() on error in ar7_gpio_init
Date:   Tue, 22 Dec 2020 21:23:36 -0500
Message-Id: <20201223022417.2794032-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index ed5b3d297caf3..83316b5587776 100644
--- a/arch/mips/ar7/gpio.c
+++ b/arch/mips/ar7/gpio.c
@@ -331,6 +331,7 @@ int __init ar7_gpio_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to add gpiochip\n",
 					gpch->chip.label);
+		iounmap(gpch->regs);
 		return ret;
 	}
 	printk(KERN_INFO "%s: registered %d GPIOs\n",
-- 
2.27.0

