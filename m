Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35C1F290
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfEOMEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfEOLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABB232084F;
        Wed, 15 May 2019 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918690;
        bh=9K0RVnznWSyChC0FPTgjfB1He7nEVcXkv08C4J1qHeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLYzB5DWCd+sHK1k00ZezIGA/qZRXjK4pkAein33e7gQ63yUp+AW9mJG7JT5yDAqS
         aGPClFEh+Rvuqrqb/qxpO+VjPy1gDvbN1Ww65I+ouPlWzsmnd4T31fZatK0IJm3G8t
         YLqM3kTzFxXVUbrLpz4asqdUMMy3vIr5QuVEqHWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 228/266] x86/msr-index: Cleanup bit defines
Date:   Wed, 15 May 2019 12:55:35 +0200
Message-Id: <20190515090730.714224576@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit d8eabc37310a92df40d07c5a8afc53cebf996716 upstream.

Greg pointed out that speculation related bit defines are using (1 << N)
format instead of BIT(N). Aside of that (1 << N) is wrong as it should use
1UL at least.

Clean it up.

[ Josh Poimboeuf: Fix tools build ]

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4:
 - Drop change to x86_energy_perf_policy, which doesn't use msr-index.h here
 - Drop changes to flush MSRs which we haven't defined]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h   |   24 +++++++++++++-----------
 tools/power/x86/turbostat/Makefile |    2 +-
 2 files changed, 14 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_MSR_INDEX_H
 #define _ASM_X86_MSR_INDEX_H
 
+#include <linux/bits.h>
+
 /* CPU model specific register (MSR) numbers */
 
 /* x86-64 specific MSRs */
@@ -33,14 +35,14 @@
 
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_SPEC_CTRL		0x00000048 /* Speculation Control */
-#define SPEC_CTRL_IBRS			(1 << 0)   /* Indirect Branch Restricted Speculation */
+#define SPEC_CTRL_IBRS			BIT(0)	   /* Indirect Branch Restricted Speculation */
 #define SPEC_CTRL_STIBP_SHIFT		1	   /* Single Thread Indirect Branch Predictor (STIBP) bit */
-#define SPEC_CTRL_STIBP			(1 << SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
+#define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
-#define SPEC_CTRL_SSBD			(1 << SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
-#define PRED_CMD_IBPB			(1 << 0)   /* Indirect Branch Prediction Barrier */
+#define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
@@ -57,13 +59,13 @@
 #define MSR_MTRRcap			0x000000fe
 
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
-#define ARCH_CAP_RDCL_NO		(1 << 0)   /* Not susceptible to Meltdown */
-#define ARCH_CAP_IBRS_ALL		(1 << 1)   /* Enhanced IBRS support */
-#define ARCH_CAP_SSB_NO			(1 << 4)   /*
-						    * Not susceptible to Speculative Store Bypass
-						    * attack, so no Speculative Store Bypass
-						    * control required.
-						    */
+#define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
+#define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_SSB_NO			BIT(4)	/*
+						 * Not susceptible to Speculative Store Bypass
+						 * attack, so no Speculative Store Bypass
+						 * control required.
+						 */
 
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -8,7 +8,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 turbostat : turbostat.c
-CFLAGS +=	-Wall
+CFLAGS +=	-Wall -I../../../include
 CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/asm/msr-index.h"'
 
 %: %.c


