Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D52F55F4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfKHTFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731327AbfKHTFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA33A21D7B;
        Fri,  8 Nov 2019 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239953;
        bh=bvGk2PFPjcyhGJhlCfWTtMGwXqeLi/+EaaoNSMmvMW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqCuyFAupjauEVWPoh0hCSk5JAlnSwT9aYN6fc7wAiXjuIkbiQ5XAOLzPaXCVgPlX
         dl62WAGR8QcR1habuSIP5Tb1OJN0Uf62VSGxtSF+tO1+AkrwaByr28BNo8Aj+dRpj3
         s1USxJWm9LzH8uoL0hX1UNGMRvnj5XyabaCcPtGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 039/140] ARM: 8908/1: add __always_inline to functions called from __get_user_check()
Date:   Fri,  8 Nov 2019 19:49:27 +0100
Message-Id: <20191108174907.870917431@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 851140ab0d083c78e5723a8b1cbd258f567a7aff ]

KernelCI reports that bcm2835_defconfig is no longer booting since
commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly") (https://lkml.org/lkml/2019/9/26/825).

I also received a regression report from Nicolas Saenz Julienne
(https://lkml.org/lkml/2019/9/27/263).

This problem has cropped up on bcm2835_defconfig because it enables
CONFIG_CC_OPTIMIZE_FOR_SIZE. The compiler tends to prefer not inlining
functions with -Os. I was able to reproduce it with other boards and
defconfig files by manually enabling CONFIG_CC_OPTIMIZE_FOR_SIZE.

The __get_user_check() specifically uses r0, r1, r2 registers.
So, uaccess_save_and_enable() and uaccess_restore() must be inlined.
Otherwise, those register assignments would be entirely dropped,
according to my analysis of the disassembly.

Prior to commit 9012d011660e ("compiler: allow all arches to enable
CONFIG_OPTIMIZE_INLINING"), the 'inline' marker was always enough for
inlining functions, except on x86.

Since that commit, all architectures can enable CONFIG_OPTIMIZE_INLINING.
So, __always_inline is now the only guaranteed way of forcible inlining.

I added __always_inline to 4 functions in the call-graph from the
__get_user_check() macro.

Fixes: 9012d011660e ("compiler: allow all arches to enable CONFIG_OPTIMIZE_INLINING")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Reported-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/domain.h  | 8 ++++----
 arch/arm/include/asm/uaccess.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index 567dbede4785c..f1d0a7807cd0e 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -82,7 +82,7 @@
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_CPU_CP15_MMU
-static inline unsigned int get_domain(void)
+static __always_inline unsigned int get_domain(void)
 {
 	unsigned int domain;
 
@@ -94,7 +94,7 @@ static inline unsigned int get_domain(void)
 	return domain;
 }
 
-static inline void set_domain(unsigned val)
+static __always_inline void set_domain(unsigned int val)
 {
 	asm volatile(
 	"mcr	p15, 0, %0, c3, c0	@ set domain"
@@ -102,12 +102,12 @@ static inline void set_domain(unsigned val)
 	isb();
 }
 #else
-static inline unsigned int get_domain(void)
+static __always_inline unsigned int get_domain(void)
 {
 	return 0;
 }
 
-static inline void set_domain(unsigned val)
+static __always_inline void set_domain(unsigned int val)
 {
 }
 #endif
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 303248e5b990f..98c6b91be4a8a 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -22,7 +22,7 @@
  * perform such accesses (eg, via list poison values) which could then
  * be exploited for priviledge escalation.
  */
-static inline unsigned int uaccess_save_and_enable(void)
+static __always_inline unsigned int uaccess_save_and_enable(void)
 {
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
 	unsigned int old_domain = get_domain();
@@ -37,7 +37,7 @@ static inline unsigned int uaccess_save_and_enable(void)
 #endif
 }
 
-static inline void uaccess_restore(unsigned int flags)
+static __always_inline void uaccess_restore(unsigned int flags)
 {
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
 	/* Restore the user access mask */
-- 
2.20.1



