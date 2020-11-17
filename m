Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD482B6285
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbgKQN3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731563AbgKQN3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEB12078E;
        Tue, 17 Nov 2020 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619759;
        bh=96sll2MtNT8gau431j6340Qmmpw4xbItvxX7Bvk4ZD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xzkt02lvVFV9MTYi1JEacYoWA32GlJorAlNdDMcp12P8I+Y7i1L3x5UmdHAwOySrz
         TEaVnnLoXWMnnZZ7/jYT3nQQFnJM06kUZ3ikGuggcJa1Sb3Nj9+qLIRhU9aXnWqWi2
         VCCnVUntWqK+7hs9Igndn/sMDQ8i3HgT2srxXDXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5.4 147/151] x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP
Date:   Tue, 17 Nov 2020 14:06:17 +0100
Message-Id: <20201117122128.578986293@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

commit 1978b3a53a74e3230cd46932b149c6e62e832e9a upstream.

On AMD CPUs which have the feature X86_FEATURE_AMD_STIBP_ALWAYS_ON,
STIBP is set to on and

  spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED

At the same time, IBPB can be set to conditional.

However, this leads to the case where it's impossible to turn on IBPB
for a process because in the PR_SPEC_DISABLE case in ib_prctl_set() the

  spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED

condition leads to a return before the task flag is set. Similarly,
ib_prctl_get() will return PR_SPEC_DISABLE even though IBPB is set to
conditional.

More generally, the following cases are possible:

1. STIBP = conditional && IBPB = on for spectre_v2_user=seccomp,ibpb
2. STIBP = on && IBPB = conditional for AMD CPUs with
   X86_FEATURE_AMD_STIBP_ALWAYS_ON

The first case functions correctly today, but only because
spectre_v2_user_ibpb isn't updated to reflect the IBPB mode.

At a high level, this change does one thing. If either STIBP or IBPB
is set to conditional, allow the prctl to change the task flag.
Also, reflect that capability when querying the state. This isn't
perfect since it doesn't take into account if only STIBP or IBPB is
unconditionally on. But it allows the conditional feature to work as
expected, without affecting the unconditional one.

 [ bp: Massage commit message and comment; space out statements for
   better readability. ]

Fixes: 21998a351512 ("x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.")
Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20201105163246.v2.1.Ifd7243cd3e2c2206a893ad0a5b9a4f19549e22c6@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/cpu/bugs.c |   52 ++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1252,6 +1252,14 @@ static int ssb_prctl_set(struct task_str
 	return 0;
 }
 
+static bool is_spec_ib_user_controlled(void)
+{
+	return spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
+		spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+		spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
+		spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP;
+}
+
 static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 {
 	switch (ctrl) {
@@ -1259,17 +1267,26 @@ static int ib_prctl_set(struct task_stru
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return 0;
-		/*
-		 * Indirect branch speculation is always disabled in strict
-		 * mode. It can neither be enabled if it was force-disabled
-		 * by a  previous prctl call.
 
+		/*
+		 * With strict mode for both IBPB and STIBP, the instruction
+		 * code paths avoid checking this task flag and instead,
+		 * unconditionally run the instruction. However, STIBP and IBPB
+		 * are independent and either can be set to conditionally
+		 * enabled regardless of the mode of the other.
+		 *
+		 * If either is set to conditional, allow the task flag to be
+		 * updated, unless it was force-disabled by a previous prctl
+		 * call. Currently, this is possible on an AMD CPU which has the
+		 * feature X86_FEATURE_AMD_STIBP_ALWAYS_ON. In this case, if the
+		 * kernel is booted with 'spectre_v2_user=seccomp', then
+		 * spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP and
+		 * spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED.
 		 */
-		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ||
+		if (!is_spec_ib_user_controlled() ||
 		    task_spec_ib_force_disable(task))
 			return -EPERM;
+
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
 		break;
@@ -1282,10 +1299,10 @@ static int ib_prctl_set(struct task_stru
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+
+		if (!is_spec_ib_user_controlled())
 			return 0;
+
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
@@ -1350,20 +1367,17 @@ static int ib_prctl_get(struct task_stru
 	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 	    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 		return PR_SPEC_ENABLE;
-	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
-		return PR_SPEC_DISABLE;
-	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
-	    spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP) {
+	else if (is_spec_ib_user_controlled()) {
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
-	} else
+	} else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		return PR_SPEC_DISABLE;
+	else
 		return PR_SPEC_NOT_AFFECTED;
 }
 


