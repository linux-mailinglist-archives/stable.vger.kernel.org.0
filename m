Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EF010BAC5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfK0VGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbfK0VG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE14A2080F;
        Wed, 27 Nov 2019 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888787;
        bh=+1owT5ab5x+CU8TcWONskHf6Fca/rC+NpVhtxJEsRo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVnoJFekv+LanBOioJFbeq4k78eWyIeBWlyJjKTg35nK09/ERYGVAJ2+Xx2t2liOe
         T6r36BTjjx703bTOxOydqiRmrubF0ytdJW5shVeX2tOw41EO2gyiCo9PquuWoeUR0w
         4xXTC8sp6LothiEFXvx4q+vyiubZRrN1NeCmkXlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Tyler Hicks <tyhicks@canonical.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 4.19 268/306] x86/speculation: Fix incorrect MDS/TAA mitigation status
Date:   Wed, 27 Nov 2019 21:31:58 +0100
Message-Id: <20191127203134.410002838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191115161445.30809-2-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/hw-vuln/mds.rst             |    7 +++++--
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst |    5 ++++-
 Documentation/admin-guide/kernel-parameters.txt       |   11 +++++++++++
 arch/x86/kernel/cpu/bugs.c                            |   17 +++++++++++++++--
 4 files changed, 35 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/mds.rst
+++ b/Documentation/admin-guide/hw-vuln/mds.rst
@@ -265,8 +265,11 @@ time with the option "mds=". The valid a
 
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
--- a/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
+++ b/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
@@ -174,7 +174,10 @@ the option "tsx_async_abort=". The valid
                 CPU is not vulnerable to cross-thread TAA attacks.
   ============  =============================================================
 
-Not specifying this option is equivalent to "tsx_async_abort=full".
+Not specifying this option is equivalent to "tsx_async_abort=full". For
+processors that are affected by both TAA and MDS, specifying just
+"tsx_async_abort=off" without an accompanying "mds=off" will have no
+effect as the same mitigation is used for both vulnerabilities.
 
 The kernel command line also allows to control the TSX feature using the
 parameter "tsx=" on CPUs which support TSX control. MSR_IA32_TSX_CTRL is used
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2359,6 +2359,12 @@
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
 
@@ -4773,6 +4779,11 @@
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
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -304,8 +304,12 @@ static void __init taa_select_mitigation
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
@@ -339,6 +343,15 @@ static void __init taa_select_mitigation
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


