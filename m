Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFCD4156BC
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbhIWDnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239345AbhIWDlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2348B61269;
        Thu, 23 Sep 2021 03:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368395;
        bh=6OpNLIh5qoUJSgqMjgmB+ylCYdLOhWxi8d4xb6iEfDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMOX9GcefXkMiiWRTPVPoXWpe7hw2crV0R+BDvPySc+qxqpQkaMg1abtov8GIWxka
         LMu8xWIcX7b11DzOmz8g1pTljqoZEdBRoFLboUuJgR/h28v5S9W07/Gn6aR+rBXCDo
         umyO/pKXffIQb4s75FBEhIxrGB7zOQuUuSJQeg3/APn6fMS9xH3Vp1r+00eqOnEXcC
         nGXAJYfKLLCIBEgQ1U9tOhCJCJGh23N5fRxq1bntWJM5hSyM2YnXaJhYE58O/y6Yxv
         t950vhs+7z8yolHgmgjRmcoiYtka5oOKx0+C1qZjngxRWi3qOnXQGdx+zh94sB06/o
         /oQQb21pNAvFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        akpm@linux-foundation.org, geert@linux-m68k.org, david@redhat.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/15] alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
Date:   Wed, 22 Sep 2021 23:39:27 -0400
Message-Id: <20210923033929.1421446-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033929.1421446-1-sashal@kernel.org>
References: <20210923033929.1421446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 35a3f4ef0ab543daa1725b0c963eb8c05e3376f8 ]

Some drivers pass a pointer to volatile data to virt_to_bus() and
virt_to_phys(), and that works fine.  One exception is alpha.  This
results in a number of compile errors such as

  drivers/net/wan/lmc/lmc_main.c: In function 'lmc_softreset':
  drivers/net/wan/lmc/lmc_main.c:1782:50: error:
	passing argument 1 of 'virt_to_bus' discards 'volatile'
	qualifier from pointer target type

  drivers/atm/ambassador.c: In function 'do_loader_command':
  drivers/atm/ambassador.c:1747:58: error:
	passing argument 1 of 'virt_to_bus' discards 'volatile'
	qualifier from pointer target type

Declare the parameter of virt_to_phys and virt_to_bus as pointer to
volatile to fix the problem.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/io.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 0bba9e991189..d4eab4f20249 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -61,7 +61,7 @@ extern inline void set_hae(unsigned long new_hae)
  * Change virtual addresses to physical addresses and vv.
  */
 #ifdef USE_48_BIT_KSEG
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return (unsigned long)address - IDENT_ADDR;
 }
@@ -71,7 +71,7 @@ static inline void * phys_to_virt(unsigned long address)
 	return (void *) (address + IDENT_ADDR);
 }
 #else
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
         unsigned long phys = (unsigned long)address;
 
@@ -112,7 +112,7 @@ static inline dma_addr_t __deprecated isa_page_to_bus(struct page *page)
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long __deprecated virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(volatile void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
-- 
2.30.2

