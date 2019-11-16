Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3815FEC44
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 13:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfKPMZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 07:25:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45368 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfKPMZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 07:25:36 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iVx8h-0002om-T0; Sat, 16 Nov 2019 13:25:20 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 86FDB1C1923;
        Sat, 16 Nov 2019 13:25:19 +0100 (CET)
Date:   Sat, 16 Nov 2019 12:25:19 -0000
From:   "tip-bot2 for Waiman Long" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/pti] x86/speculation: Fix incorrect MDS/TAA mitigation status
Cc:     Waiman Long <longman@redhat.com>, Borislav Petkov <bp@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        <stable@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Tyler Hicks <tyhicks@canonical.com>, "x86-ml" <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191115161445.30809-2-longman@redhat.com>
References: <20191115161445.30809-2-longman@redhat.com>
MIME-Version: 1.0
Message-ID: <157390711950.12247.3359773169258462200.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/pti branch of tip:

Commit-ID:     64870ed1b12e235cfca3f6c6da75b542c973ff78
Gitweb:        https://git.kernel.org/tip/64870ed1b12e235cfca3f6c6da75b542c973ff78
Author:        Waiman Long <longman@redhat.com>
AuthorDate:    Fri, 15 Nov 2019 11:14:44 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 16 Nov 2019 13:17:49 +01:00

x86/speculation: Fix incorrect MDS/TAA mitigation status

For MDS vulnerable processors with TSX support, enabling either MDS or
TAA mitigations will enable the use of VERW to flush internal processor
buffers at the right code path. IOW, they are either both mitigated
or both not. However, if the command line options are inconsistent,
the vulnerabilites sysfs files may not report the mitigation status
correctly.

For example, with only the "mds=off" option:

  vulnerabilities/mds:Vulnerable; SMT vulnerable
  vulnerabilities/tsx_async_abort:Mitigation: Clear CPU buffers; SMT vulnerable

The mds vulnerabilities file has wrong status in this case. Similarly,
the taa vulnerability file will be wrong with mds mitigation on, but
taa off.

Change taa_select_mitigation() to sync up the two mitigation status
and have them turned off if both "mds=off" and "tsx_async_abort=off"
are present.

Update documentation to emphasize the fact that both "mds=off" and
"tsx_async_abort=off" have to be specified together for processors that
are affected by both TAA and MDS to be effective.

 [ bp: Massage and add kernel-parameters.txt change too. ]

Fixes: 1b42f017415b ("x86/speculation/taa: Add mitigation for TSX Async Abort")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-doc@vger.kernel.org
Cc: Mark Gross <mgross@linux.intel.com>
Cc: <stable@vger.kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191115161445.30809-2-longman@redhat.com
---
 Documentation/admin-guide/hw-vuln/mds.rst             |  7 ++--
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst |  5 ++-
 Documentation/admin-guide/kernel-parameters.txt       | 11 ++++++-
 arch/x86/kernel/cpu/bugs.c                            | 17 ++++++++--
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/mds.rst b/Documentation/admin-guide/hw-vuln/mds.rst
index e3a796c..2d19c9f 100644
--- a/Documentation/admin-guide/hw-vuln/mds.rst
+++ b/Documentation/admin-guide/hw-vuln/mds.rst
@@ -265,8 +265,11 @@ time with the option "mds=". The valid arguments for this option are:
 
   ============  =============================================================
 
-Not specifying this option is equivalent to "mds=full".
-
+Not specifying this option is equivalent to "mds=full". For processors
+that are affected by both TAA (TSX Asynchronous Abort) and MDS,
+specifying just "mds=off" without an accompanying "tsx_async_abort=off"
+will have no effect as the same mitigation is used for both
+vulnerabilities.
 
 Mitigation selection guide
 --------------------------
diff --git a/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst b/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
index fddbd75..af6865b 100644
--- a/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
+++ b/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
@@ -174,7 +174,10 @@ the option "tsx_async_abort=". The valid arguments for this option are:
                 CPU is not vulnerable to cross-thread TAA attacks.
   ============  =============================================================
 
-Not specifying this option is equivalent to "tsx_async_abort=full".
+Not specifying this option is equivalent to "tsx_async_abort=full". For
+processors that are affected by both TAA and MDS, specifying just
+"tsx_async_abort=off" without an accompanying "mds=off" will have no
+effect as the same mitigation is used for both vulnerabilities.
 
 The kernel command line also allows to control the TSX feature using the
 parameter "tsx=" on CPUs which support TSX control. MSR_IA32_TSX_CTRL is used
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8dee8f6..9983ac7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2473,6 +2473,12 @@
 				     SMT on vulnerable CPUs
 			off        - Unconditionally disable MDS mitigation
 
+			On TAA-affected machines, mds=off can be prevented by
+			an active TAA mitigation as both vulnerabilities are
+			mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify tsx_async_abort=off
+			too.
+
 			Not specifying this option is equivalent to
 			mds=full.
 
@@ -4931,6 +4937,11 @@
 				     vulnerable to cross-thread TAA attacks.
 			off        - Unconditionally disable TAA mitigation
 
+			On MDS-affected machines, tsx_async_abort=off can be
+			prevented by an active MDS mitigation as both vulnerabilities
+			are mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify mds=off too.
+
 			Not specifying this option is equivalent to
 			tsx_async_abort=full.  On CPUs which are MDS affected
 			and deploy MDS mitigation, TAA mitigation is not
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4c7b0fa..cb513ea 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -304,8 +304,12 @@ static void __init taa_select_mitigation(void)
 		return;
 	}
 
-	/* TAA mitigation is turned off on the cmdline (tsx_async_abort=off) */
-	if (taa_mitigation == TAA_MITIGATION_OFF)
+	/*
+	 * TAA mitigation via VERW is turned off if both
+	 * tsx_async_abort=off and mds=off are specified.
+	 */
+	if (taa_mitigation == TAA_MITIGATION_OFF &&
+	    mds_mitigation == MDS_MITIGATION_OFF)
 		goto out;
 
 	if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
@@ -339,6 +343,15 @@ static void __init taa_select_mitigation(void)
 	if (taa_nosmt || cpu_mitigations_auto_nosmt())
 		cpu_smt_disable(false);
 
+	/*
+	 * Update MDS mitigation, if necessary, as the mds_user_clear is
+	 * now enabled for TAA mitigation.
+	 */
+	if (mds_mitigation == MDS_MITIGATION_OFF &&
+	    boot_cpu_has_bug(X86_BUG_MDS)) {
+		mds_mitigation = MDS_MITIGATION_FULL;
+		mds_select_mitigation();
+	}
 out:
 	pr_info("%s\n", taa_strings[taa_mitigation]);
 }
