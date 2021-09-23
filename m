Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9BA41568F
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbhIWDmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239323AbhIWDk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D678161019;
        Thu, 23 Sep 2021 03:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368366;
        bh=NEAgUUSzlJUqdeFK87dMG3tLB0BpfhYItVhUx82VOp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQy5qRbXlOXly2GpDoiI0qlAuGdtt0nWAncGeQ0kxzyIm13JwwDUwUTvxuiyReuYm
         NA1h/4VQluwezadQZb1JP+Y/NSig+K4oebDgIKsyQGKPxjv8tsyOiYzgglu3ShIZMK
         yCQVh0EGCCabgZvH/TQ2MTENANAcH+Fm2jRCrY64dcOsgb3mo4pPM/R2QRYwx5gSpc
         pIzSfaeg9uB6S3/Hk5VgvTLFQkHiiE6Eirf34yPjnWGgDLJ8nDnDtI7kjZpfhUhhFA
         WLQemv6XzaEnjSYXPbk1ZNFkcq2qP1g0pYaqaDPjoznwoFugofY+ggtLA1dupYRGLK
         0SV+8nJnMKRTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        akpm@linux-foundation.org, geert@linux-m68k.org, david@redhat.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/19] alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
Date:   Wed, 22 Sep 2021 23:38:51 -0400
Message-Id: <20210923033853.1421193-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 103270d5a9fc..66a384a4ddba 100644
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
 
@@ -107,7 +107,7 @@ static inline void * phys_to_virt(unsigned long address)
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long __deprecated virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(volatile void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
-- 
2.30.2

