Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0858F420C8B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhJDNG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235108AbhJDNFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4041F613AD;
        Mon,  4 Oct 2021 13:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352445;
        bh=sCKqQsnWyy2TMFoIwAoK9TxQENvqp67L5yhaXHcheCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3v90gkjIVGaAIIJGdW0PVSMLoXVynjfT6XLTctGbRq1gpRes2AAOpRa3FarX8a7c
         bMAfyVtFGIzb4WkKiju2aBSa8S3fpCGfjZlQ+h2wi0dbeY2jLoJ3jS/c+zk6N9M0ec
         Zo0dM8JIpBH/gNOZoGDcG1MZYp6HrNNrI0jWDpZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.14 64/75] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Mon,  4 Oct 2021 14:52:39 +0200
Message-Id: <20211004125033.684690563@linuxfoundation.org>
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

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 890cb057a46d323fd8c77ebecb6485476614cd21 upstream

Will be used in the following patch. No functional change.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/insn.h |    8 ++++----
 arch/arm/kernel/ftrace.c    |    2 +-
 arch/arm/kernel/insn.c      |   19 ++++++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/arch/arm/include/asm/insn.h
+++ b/arch/arm/include/asm/insn.h
@@ -13,18 +13,18 @@ arm_gen_nop(void)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link);
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn);
 
 static inline unsigned long
 arm_gen_branch(unsigned long pc, unsigned long addr)
 {
-	return __arm_gen_branch(pc, addr, false);
+	return __arm_gen_branch(pc, addr, false, true);
 }
 
 static inline unsigned long
-arm_gen_branch_link(unsigned long pc, unsigned long addr)
+arm_gen_branch_link(unsigned long pc, unsigned long addr, bool warn)
 {
-	return __arm_gen_branch(pc, addr, true);
+	return __arm_gen_branch(pc, addr, true, warn);
 }
 
 #endif
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -98,7 +98,7 @@ int ftrace_arch_code_modify_post_process
 
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
-	return arm_gen_branch_link(pc, addr);
+	return arm_gen_branch_link(pc, addr, true);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -3,8 +3,9 @@
 #include <linux/kernel.h>
 #include <asm/opcodes.h>
 
-static unsigned long
-__arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_thumb2(unsigned long pc,
+					     unsigned long addr, bool link,
+					     bool warn)
 {
 	unsigned long s, j1, j2, i1, i2, imm10, imm11;
 	unsigned long first, second;
@@ -12,7 +13,7 @@ __arm_gen_branch_thumb2(unsigned long pc
 
 	offset = (long)addr - (long)(pc + 4);
 	if (offset < -16777216 || offset > 16777214) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -33,8 +34,8 @@ __arm_gen_branch_thumb2(unsigned long pc
 	return __opcode_thumb32_compose(first, second);
 }
 
-static unsigned long
-__arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_arm(unsigned long pc, unsigned long addr,
+					  bool link, bool warn)
 {
 	unsigned long opcode = 0xea000000;
 	long offset;
@@ -44,7 +45,7 @@ __arm_gen_branch_arm(unsigned long pc, u
 
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -54,10 +55,10 @@ __arm_gen_branch_arm(unsigned long pc, u
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link)
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn)
 {
 	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
-		return __arm_gen_branch_thumb2(pc, addr, link);
+		return __arm_gen_branch_thumb2(pc, addr, link, warn);
 	else
-		return __arm_gen_branch_arm(pc, addr, link);
+		return __arm_gen_branch_arm(pc, addr, link, warn);
 }


