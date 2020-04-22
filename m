Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DC91B3E3C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgDVK0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbgDVK0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970D62071E;
        Wed, 22 Apr 2020 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551195;
        bh=14d0vipBRsRPlRsQS2dkebED6wLV/m2MRXuuwhWQ9Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQNvwXhbjVP1hpv73X8xYr56HpSTRNENhEigDzs4OFZkcxW6fjwN0eOJbCcVyuCJ2
         13n/Gw9ONF6PKPUIdonnG1CZ02oV15+IkQOYWdij/TFGhBHPy8VeTs9YiKQZBFoadE
         hooWYa9Rr0cbtWY9ewVU7Gidtp9qpt561lkJT1ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Chongzhi <chongzhi.lcz@alibaba-inc.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 139/166] csky: Fixup init_fpu compile warning with __init
Date:   Wed, 22 Apr 2020 11:57:46 +0200
Message-Id: <20200422095103.540531498@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 12879bda3c2a974b7e4fe199a9c21f0c5f6bca04 ]

WARNING: vmlinux.o(.text+0x2366): Section mismatch in reference from the
function csky_start_secondary() to the function .init.text:init_fpu()

The function csky_start_secondary() references
the function __init init_fpu().
This is often because csky_start_secondary lacks a __init
annotation or the annotation of init_fpu is wrong.

Reported-by: Lu Chongzhi <chongzhi.lcz@alibaba-inc.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv2/fpu.c         | 5 -----
 arch/csky/abiv2/inc/abi/fpu.h | 3 ++-
 arch/csky/kernel/smp.c        | 3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/csky/abiv2/fpu.c b/arch/csky/abiv2/fpu.c
index 86d187d4e5af1..5acc5c2e544e1 100644
--- a/arch/csky/abiv2/fpu.c
+++ b/arch/csky/abiv2/fpu.c
@@ -10,11 +10,6 @@
 #define MTCR_DIST	0xC0006420
 #define MFCR_DIST	0xC0006020
 
-void __init init_fpu(void)
-{
-	mtcr("cr<1, 2>", 0);
-}
-
 /*
  * fpu_libc_helper() is to help libc to excute:
  *  - mfcr %a, cr<1, 2>
diff --git a/arch/csky/abiv2/inc/abi/fpu.h b/arch/csky/abiv2/inc/abi/fpu.h
index 22ca3cf2794a1..09e2700a36936 100644
--- a/arch/csky/abiv2/inc/abi/fpu.h
+++ b/arch/csky/abiv2/inc/abi/fpu.h
@@ -9,7 +9,8 @@
 
 int fpu_libc_helper(struct pt_regs *regs);
 void fpu_fpe(struct pt_regs *regs);
-void __init init_fpu(void);
+
+static inline void init_fpu(void) { mtcr("cr<1, 2>", 0); }
 
 void save_to_user_fp(struct user_fp *user_fp);
 void restore_from_user_fp(struct user_fp *user_fp);
diff --git a/arch/csky/kernel/smp.c b/arch/csky/kernel/smp.c
index de61feb4b6df2..b5c5bc3afeb5c 100644
--- a/arch/csky/kernel/smp.c
+++ b/arch/csky/kernel/smp.c
@@ -22,6 +22,9 @@
 #include <asm/sections.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
+#ifdef CONFIG_CPU_HAS_FPU
+#include <abi/fpu.h>
+#endif
 
 struct ipi_data_struct {
 	unsigned long bits ____cacheline_aligned;
-- 
2.20.1



