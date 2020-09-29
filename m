Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF527C3EC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgI2LJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgI2LJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA81C22262;
        Tue, 29 Sep 2020 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377780;
        bh=9Wr/DNObHYcXAhpRh/4Bt6/u8IKLiYEN6aWMbhJsL1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAH/9z7VEEqt1i6k77IjcMKxLVo0pz+qzGDFD5Rb1rDAa7zCleqVBWa/Crtzo/y4M
         6sff7zDjOM2VUPX5GKykwRgIZqq6vqBmpli74xL981jVNawR9cuoz5RIUNXrjyUw9r
         k8pCy67VA5dA9OpozsdHA32tUECJ4Xr4SXxcdDDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Shi <alex.shi@linux.alibaba.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 052/121] x86/pkeys: Add check for pkey "overflow"
Date:   Tue, 29 Sep 2020 12:59:56 +0200
Message-Id: <20200929105932.776070811@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



