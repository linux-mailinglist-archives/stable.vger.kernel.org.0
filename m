Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2490420CA8
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhJDNI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhJDNGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1DFD61A05;
        Mon,  4 Oct 2021 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352475;
        bh=EOG2kZvEI5ckZIJa9N57ESkbEfDW/dj9up0d2lJ6vt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsWo2078gUUKX+O1KqPkRbf0AOhljj/CqeAnibLrt6FoZiTxjZEtzwS/CLhVIcC10
         ld16s2mAl0BaKPZu/W4zqTX8Ds0FkplAjH5MT6RlWB732A9IOIeL0hFsmH1Qzfi2zA
         6c0RVwc46JyMYfdIwBJ+eGvqUAZyW17iVhMAX7c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/75] alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
Date:   Mon,  4 Oct 2021 14:52:09 +0200
Message-Id: <20211004125032.656821079@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
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
index 9995bed6e92e..204c4fb69ee1 100644
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
2.33.0



