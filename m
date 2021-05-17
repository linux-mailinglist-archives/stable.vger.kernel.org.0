Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9DF3835C0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243847AbhEQPYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244666AbhEQPVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66CD661C91;
        Mon, 17 May 2021 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262080;
        bh=SszRPVGUxvCf8F0XMBRaHAJA7OrsDzb5CH7hIPePVd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9roauv9vkfBe6Uukaq2cM8hvbT/1HCZvkwJqRH2BJ2QbXxglCieogJgvBWULCq59
         HE9CQA1nTA7TuV+nF37BuP4bdBjPn7miOSrSH44yIDoA7A9/zTp0ltGZAm4Hu3t3X2
         1t83VYLBDyDpZfSIHokTx5iUWnYGmx9FAYfIhY4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Stanley <joel@jms.id.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 134/141] ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
Date:   Mon, 17 May 2021 16:03:06 +0200
Message-Id: <20210517140247.329237638@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit fc2933c133744305236793025b00c2f7d258b687 upstream

Commit

  149a3ffe62b9dbc3 ("9012/1: move device tree mapping out of linear region")

created a permanent, read-only section mapping of the device tree blob
provided by the firmware, and added a set of macros to get the base and
size of the virtually mapped FDT based on the physical address. However,
while the mapping code uses the SECTION_SIZE macro correctly, the macros
use PMD_SIZE instead, which means something entirely different on ARM when
using short descriptors, and is therefore not the right quantity to use
here. So replace PMD_SIZE with SECTION_SIZE. While at it, change the names
of the macro and its parameter to clarify that it returns the virtual
address of the start of the FDT, based on the physical address in memory.

Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/memory.h |    6 +++---
 arch/arm/kernel/setup.c       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -68,8 +68,8 @@
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
 #define FDT_FIXED_BASE		UL(0xff800000)
-#define FDT_FIXED_SIZE		(2 * PMD_SIZE)
-#define FDT_VIRT_ADDR(physaddr)	((void *)(FDT_FIXED_BASE | (physaddr) % PMD_SIZE))
+#define FDT_FIXED_SIZE		(2 * SECTION_SIZE)
+#define FDT_VIRT_BASE(physbase)	((void *)(FDT_FIXED_BASE | (physbase) % SECTION_SIZE))
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
@@ -111,7 +111,7 @@ extern unsigned long vectors_base;
 #define MODULES_VADDR		PAGE_OFFSET
 
 #define XIP_VIRT_ADDR(physaddr)  (physaddr)
-#define FDT_VIRT_ADDR(physaddr)  ((void *)(physaddr))
+#define FDT_VIRT_BASE(physbase)  ((void *)(physbase))
 
 #endif /* !CONFIG_MMU */
 
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1080,7 +1080,7 @@ void __init setup_arch(char **cmdline_p)
 	void *atags_vaddr = NULL;
 
 	if (__atags_pointer)
-		atags_vaddr = FDT_VIRT_ADDR(__atags_pointer);
+		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
 	setup_processor();
 	if (atags_vaddr) {


