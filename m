Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB38026F370
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgIRDGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbgIRCEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C199A235FD;
        Fri, 18 Sep 2020 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394639;
        bh=16tazY5VJe08ylA+XFDUXd9D+yYNp9RB/kAuN2PirUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apEpPylLy3NJSCSRZ2OmPijoi4wUhfPSJLSz36IYwrLsxehPJVv6APxL9VWIRmJWX
         +QtfDUJBAVMC49t+5EKISdPLI3jU0LNckzgsg8+7O97mdxO2rKFlb4tHZSnCtvcQng
         fO/m20l6ghdI85t2Z6e1brz28KlhrG8UzSnNcNfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 138/330] x86/pkeys: Add check for pkey "overflow"
Date:   Thu, 17 Sep 2020 21:57:58 -0400
Message-Id: <20200918020110.2063155-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 19b137f1b3beb..2ff9b98812b76 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -4,6 +4,11 @@
 
 #define ARCH_DEFAULT_PKEY	0
 
+/*
+ * If more than 16 keys are ever supported, a thorough audit
+ * will be necessary to ensure that the types that store key
+ * numbers and masks have sufficient capacity.
+ */
 #define arch_max_pkey() (boot_cpu_has(X86_FEATURE_OSPKE) ? 16 : 1)
 
 extern int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 755eb26cbec04..735d1f1bbabc7 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -895,8 +895,6 @@ const void *get_xsave_field_ptr(int xfeature_nr)
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
-#define NR_VALID_PKRU_BITS (CONFIG_NR_PROTECTION_KEYS * 2)
-#define PKRU_VALID_MASK (NR_VALID_PKRU_BITS - 1)
 /*
  * This will go out and modify PKRU register to set the access
  * rights for @pkey to @init_val.
@@ -915,6 +913,13 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
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

