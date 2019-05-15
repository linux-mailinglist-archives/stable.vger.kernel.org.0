Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C155E1F281
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfEOLL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbfEOLL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D93221473;
        Wed, 15 May 2019 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918684;
        bh=1O5XAIKcgkmvxRMEoezlXrFLzM3tRA3WT9bCo5hJLeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWTO+Z+XK7eGSZ9NNvYFBpfk7by+0bc1tpAaMvnSDcDJmqtxng6ICG7wDMZmLTaC3
         5s5nbnWtxKCbZpjmhRXxwMqak1xnUlUBhbsa3KPJCoUHQ3SOtk0Jqkz+U3o4tMbt60
         yK4mX/O7KcqTA4XKY4dDLu53DCmE654JQzulPiOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 226/266] x86/speculation: Provide IBPB always command line options
Date:   Wed, 15 May 2019 12:55:33 +0200
Message-Id: <20190515090730.644770059@linuxfoundation.org>
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

commit 55a974021ec952ee460dc31ca08722158639de72 upstream.

Provide the possibility to enable IBPB always in combination with 'prctl'
and 'seccomp'.

Add the extra command line options and rework the IBPB selection to
evaluate the command instead of the mode selected by the STIPB switch case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185006.144047038@linutronix.de
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |   12 ++++++++++++
 arch/x86/kernel/cpu/bugs.c          |   34 +++++++++++++++++++++++-----------
 2 files changed, 35 insertions(+), 11 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3651,11 +3651,23 @@ bytes respectively. Such letter suffixes
 				  per thread.  The mitigation control state
 				  is inherited on fork.
 
+			prctl,ibpb
+				- Like "prctl" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different user
+				  space processes.
+
 			seccomp
 				- Same as "prctl" above, but all seccomp
 				  threads will enable the mitigation unless
 				  they explicitly opt out.
 
+			seccomp,ibpb
+				- Like "seccomp" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different
+				  user space processes.
+
 			auto    - Kernel selects the mitigation depending on
 				  the available CPU features and vulnerability.
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -245,7 +245,9 @@ enum spectre_v2_user_cmd {
 	SPECTRE_V2_USER_CMD_AUTO,
 	SPECTRE_V2_USER_CMD_FORCE,
 	SPECTRE_V2_USER_CMD_PRCTL,
+	SPECTRE_V2_USER_CMD_PRCTL_IBPB,
 	SPECTRE_V2_USER_CMD_SECCOMP,
+	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,
 };
 
 static const char * const spectre_v2_user_strings[] = {
@@ -260,11 +262,13 @@ static const struct {
 	enum spectre_v2_user_cmd	cmd;
 	bool				secure;
 } v2_user_options[] __initdata = {
-	{ "auto",	SPECTRE_V2_USER_CMD_AUTO,	false },
-	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
-	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
-	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
-	{ "seccomp",	SPECTRE_V2_USER_CMD_SECCOMP,	false },
+	{ "auto",		SPECTRE_V2_USER_CMD_AUTO,		false },
+	{ "off",		SPECTRE_V2_USER_CMD_NONE,		false },
+	{ "on",			SPECTRE_V2_USER_CMD_FORCE,		true  },
+	{ "prctl",		SPECTRE_V2_USER_CMD_PRCTL,		false },
+	{ "prctl,ibpb",		SPECTRE_V2_USER_CMD_PRCTL_IBPB,		false },
+	{ "seccomp",		SPECTRE_V2_USER_CMD_SECCOMP,		false },
+	{ "seccomp,ibpb",	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -310,6 +314,7 @@ spectre_v2_user_select_mitigation(enum s
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
+	enum spectre_v2_user_cmd cmd;
 
 	if (!boot_cpu_has(X86_FEATURE_IBPB) && !boot_cpu_has(X86_FEATURE_STIBP))
 		return;
@@ -317,17 +322,20 @@ spectre_v2_user_select_mitigation(enum s
 	if (!IS_ENABLED(CONFIG_SMP))
 		smt_possible = false;
 
-	switch (spectre_v2_parse_user_cmdline(v2_cmd)) {
+	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
 	case SPECTRE_V2_USER_CMD_FORCE:
 		mode = SPECTRE_V2_USER_STRICT;
 		break;
 	case SPECTRE_V2_USER_CMD_PRCTL:
+	case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
 		mode = SPECTRE_V2_USER_PRCTL;
 		break;
 	case SPECTRE_V2_USER_CMD_AUTO:
 	case SPECTRE_V2_USER_CMD_SECCOMP:
+	case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
 		if (IS_ENABLED(CONFIG_SECCOMP))
 			mode = SPECTRE_V2_USER_SECCOMP;
 		else
@@ -339,12 +347,15 @@ spectre_v2_user_select_mitigation(enum s
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
 
-		switch (mode) {
-		case SPECTRE_V2_USER_STRICT:
+		switch (cmd) {
+		case SPECTRE_V2_USER_CMD_FORCE:
+		case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
+		case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
-		case SPECTRE_V2_USER_PRCTL:
-		case SPECTRE_V2_USER_SECCOMP:
+		case SPECTRE_V2_USER_CMD_PRCTL:
+		case SPECTRE_V2_USER_CMD_AUTO:
+		case SPECTRE_V2_USER_CMD_SECCOMP:
 			static_branch_enable(&switch_mm_cond_ibpb);
 			break;
 		default:
@@ -352,7 +363,8 @@ spectre_v2_user_select_mitigation(enum s
 		}
 
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
-			mode == SPECTRE_V2_USER_STRICT ? "always-on" : "conditional");
+			static_key_enabled(&switch_mm_always_ibpb) ?
+			"always-on" : "conditional");
 	}
 
 	/* If enhanced IBRS is enabled no STIPB required */


