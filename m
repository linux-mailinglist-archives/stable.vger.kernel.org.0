Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967CA26EE49
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgIRC1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgIRCPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E92623888;
        Fri, 18 Sep 2020 02:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395345;
        bh=9Wr/DNObHYcXAhpRh/4Bt6/u8IKLiYEN6aWMbhJsL1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHBqEmfL+rUx3vxlyx+sL7CwnNkVucE0y8jgztb/6HJGQxaGcxaVxCJPLz/fWK0Wz
         Tm0PQIjjgC7CdrmE1vFYiMrXXOBPceJBDCbRqwZz60lnNeULh4R4QWchC2qUqR0J69
         2nJO+qmYMzLDuXG2qEjnNEhLax5a3x6D/2X3G8pc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 41/90] x86/pkeys: Add check for pkey "overflow"
Date:   Thu, 17 Sep 2020 22:14:06 -0400
Message-Id: <20200918021455.2067301-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 16171bffc829272d5e6014bad48f680cb50943d9 ]

Alex Shi reported the pkey macros above arch_set_user_pkey_access()
to be unused.  They are unused, and even refer to a nonexistent
CONFIG option.

But, they might have served a good use, which was to ensure that
the code does not try to set values that would not fit in the
PKRU register.  As it stands, a too-large 'pkey' value would
be likely to silently overflow the u32 new_pkru_bits.

Add a check to look for overflows.  Also add a comment to remind
any future developer to closely examine the types used to store
pkey values if arch_max_pkey() ever changes.

This boots and passes the x86 pkey selftests.

Reported-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200122165346.AD4DA150@viggo.jf.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pkeys.h | 5 +++++
 arch/x86/kernel/fpu/xstate.c | 9 +++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index c50d6dcf4a227..4e7273e176cb7 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -3,6 +3,11 @@
 
 #define ARCH_DEFAULT_PKEY	0
 
+/*
+ * If more than 16 keys are ever supported, a thorough audit
+ * will be necessary to ensure that the types that store key
+ * numbers and masks have sufficient capacity.
+ */
 #define arch_max_pkey() (boot_cpu_has(X86_FEATURE_OSPKE) ? 16 : 1)
 
 extern int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e9d7f461b7fa5..dbd396c913488 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -871,8 +871,6 @@ const void *get_xsave_field_ptr(int xsave_state)
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
-#define NR_VALID_PKRU_BITS (CONFIG_NR_PROTECTION_KEYS * 2)
-#define PKRU_VALID_MASK (NR_VALID_PKRU_BITS - 1)
 /*
  * This will go out and modify PKRU register to set the access
  * rights for @pkey to @init_val.
@@ -891,6 +889,13 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 	if (!boot_cpu_has(X86_FEATURE_OSPKE))
 		return -EINVAL;
 
+	/*
+	 * This code should only be called with valid 'pkey'
+	 * values originating from in-kernel users.  Complain
+	 * if a bad value is observed.
+	 */
+	WARN_ON_ONCE(pkey >= arch_max_pkey());
+
 	/* Set the bits we need in PKRU:  */
 	if (init_val & PKEY_DISABLE_ACCESS)
 		new_pkru_bits |= PKRU_AD_BIT;
-- 
2.25.1

