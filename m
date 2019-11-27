Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB710BDD1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbfK0Uxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbfK0Uxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDDF21903;
        Wed, 27 Nov 2019 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888011;
        bh=85fGGUmNc6aJLbEGpfmynlbgA0s6PvO/ENe7anqmj50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVnO6zLTICJ81hrs2Sivib1lFrnZrP+xoW4th38rD2fWwhv0k7B1c4x3jwqQEQ08e
         JGyVoC6btCIWPmQm5szn1F21mG4UBU0UbQYow3JYaatiusA6RBQSMNALdK7REO8OmU
         KoGrMib3vp5K+FsH0t3wuw1KiluR3dNZRfTyYE2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Waiman Long <longman@redhat.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Tyler Hicks <tyhicks@canonical.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 4.14 179/211] x86/speculation: Fix redundant MDS mitigation message
Date:   Wed, 27 Nov 2019 21:31:52 +0100
Message-Id: <20191127203110.723987467@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit cd5a2aa89e847bdda7b62029d94e95488d73f6b2 upstream.

Since MDS and TAA mitigations are inter-related for processors that are
affected by both vulnerabilities, the followiing confusing messages can
be printed in the kernel log:

  MDS: Vulnerable
  MDS: Mitigation: Clear CPU buffers

To avoid the first incorrect message, defer the printing of MDS
mitigation after the TAA mitigation selection has been done. However,
that has the side effect of printing TAA mitigation first before MDS
mitigation.

 [ bp: Check box is affected/mitigations are disabled first before
   printing and massage. ]

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Mark Gross <mgross@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191115161445.30809-3-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/bugs.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -39,6 +39,7 @@ static void __init spectre_v2_select_mit
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
+static void __init mds_print_mitigation(void);
 static void __init taa_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
@@ -108,6 +109,12 @@ void __init check_bugs(void)
 	mds_select_mitigation();
 	taa_select_mitigation();
 
+	/*
+	 * As MDS and TAA mitigations are inter-related, print MDS
+	 * mitigation until after TAA mitigation selection is done.
+	 */
+	mds_print_mitigation();
+
 	arch_smt_update();
 
 #ifdef CONFIG_X86_32
@@ -245,6 +252,12 @@ static void __init mds_select_mitigation
 		    (mds_nosmt || cpu_mitigations_auto_nosmt()))
 			cpu_smt_disable(false);
 	}
+}
+
+static void __init mds_print_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MDS) || cpu_mitigations_off())
+		return;
 
 	pr_info("%s\n", mds_strings[mds_mitigation]);
 }


