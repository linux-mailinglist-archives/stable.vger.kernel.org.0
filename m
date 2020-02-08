Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC48A1565EC
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgBHSaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:30:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35118 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728033AbgBHSaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:30:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fe-1g; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CRH-D2; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Borislav Petkov" <bp@suse.de>, "x86-ml" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Mark Gross" <mgross@linux.intel.com>, linux-doc@vger.kernel.org,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>,
        "Waiman Long" <longman@redhat.com>
Date:   Sat, 08 Feb 2020 18:20:36 +0000
Message-ID: <lsq.1581185940.817819654@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 097/148] x86/speculation: Fix incorrect MDS/TAA
 mitigation status
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 64870ed1b12e235cfca3f6c6da75b542c973ff78 upstream.

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
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191115161445.30809-2-longman@redhat.com
[bwh: Backported to 3.16: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/hw-vuln/mds.rst             |  7 +++++--
 Documentation/hw-vuln/tsx_async_abort.rst |  5 ++++-
 Documentation/kernel-parameters.txt       | 11 +++++++++++
 arch/x86/kernel/cpu/bugs.c                | 17 +++++++++++++++--
 4 files changed, 35 insertions(+), 5 deletions(-)

--- a/Documentation/hw-vuln/mds.rst
+++ b/Documentation/hw-vuln/mds.rst
@@ -262,8 +262,11 @@ time with the option "mds=". The valid a
 
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
--- a/Documentation/hw-vuln/tsx_async_abort.rst
+++ b/Documentation/hw-vuln/tsx_async_abort.rst
@@ -169,7 +169,10 @@ the option "tsx_async_abort=". The valid
                 systems will have no effect.
   ============  =============================================================
 
-Not specifying this option is equivalent to "tsx_async_abort=full".
+Not specifying this option is equivalent to "tsx_async_abort=full". For
+processors that are affected by both TAA and MDS, specifying just
+"tsx_async_abort=off" without an accompanying "mds=off" will have no
+effect as the same mitigation is used for both vulnerabilities.
 
 The kernel command line also allows to control the TSX feature using the
 parameter "tsx=" on CPUs which support TSX control. MSR_IA32_TSX_CTRL is used
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1793,6 +1793,12 @@ bytes respectively. Such letter suffixes
 			full    - Enable MDS mitigation on vulnerable CPUs
 			off     - Unconditionally disable MDS mitigation
 
+			On TAA-affected machines, mds=off can be prevented by
+			an active TAA mitigation as both vulnerabilities are
+			mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify tsx_async_abort=off
+			too.
+
 			Not specifying this option is equivalent to
 			mds=full.
 
@@ -3634,6 +3640,11 @@ bytes respectively. Such letter suffixes
 
 			off        - Unconditionally disable TAA mitigation
 
+			On MDS-affected machines, tsx_async_abort=off can be
+			prevented by an active MDS mitigation as both vulnerabilities
+			are mitigated with the same mechanism so in order to disable
+			this mitigation, you need to specify mds=off too.
+
 			Not specifying this option is equivalent to
 			tsx_async_abort=full.  On CPUs which are MDS affected
 			and deploy MDS mitigation, TAA mitigation is not
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -349,8 +349,12 @@ static void __init taa_select_mitigation
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
@@ -381,6 +385,15 @@ static void __init taa_select_mitigation
 	 */
 	static_branch_enable(&mds_user_clear);
 
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

