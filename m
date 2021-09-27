Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7176F419B51
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhI0RRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236754AbhI0RP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 972116124B;
        Mon, 27 Sep 2021 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762657;
        bh=myyxd2V9y0Dfcs0g7zwvpgghRb1GZxgWn80eyErC/go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0BmIb10rOj/cMDU2ZKXbc9qcoAl85bsrOdcpoa8bfaf2mmxaONhFKNh1dW+0ttf6
         TRm5t1aawsJ4WqxcVge7zIkmY9o1r9Ft1WulhrVwBDD2Qvk5SSSGAzEh0ofwqHvDC6
         g57dQ8oAHsmd8nIz94p7bp6gGxxcDVIht3PYd+Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/103] alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
Date:   Mon, 27 Sep 2021 19:03:07 +0200
Message-Id: <20210927170229.049222382@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1f6a909d1fa5..7bc2f444a89a 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -60,7 +60,7 @@ extern inline void set_hae(unsigned long new_hae)
  * Change virtual addresses to physical addresses and vv.
  */
 #ifdef USE_48_BIT_KSEG
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return (unsigned long)address - IDENT_ADDR;
 }
@@ -70,7 +70,7 @@ static inline void * phys_to_virt(unsigned long address)
 	return (void *) (address + IDENT_ADDR);
 }
 #else
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
         unsigned long phys = (unsigned long)address;
 
@@ -106,7 +106,7 @@ static inline void * phys_to_virt(unsigned long address)
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long __deprecated virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(volatile void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
-- 
2.33.0



