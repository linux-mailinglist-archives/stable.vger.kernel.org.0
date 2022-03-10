Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24504D4AC3
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243374AbiCJOVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243921AbiCJOSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F45416922A;
        Thu, 10 Mar 2022 06:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45782B82676;
        Thu, 10 Mar 2022 14:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F60C36AE9;
        Thu, 10 Mar 2022 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921703;
        bh=ZrN6tfcrS9ZKAY3Hb7h4fgnYqO6MTLlatRmVtzqLU74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvdb8+yG2oy+R1gC1HSAa08Ih1mQIgTMWQFpmEXiVpXGGLcX17Yq38MnMB0bvL6vr
         4Bywj/xUxyS77mLfLdQjVvmV0fGZbeShXtGxKd/kFpZzy4exRg8R1Mq4kRv4W5LTGM
         9ZG8jkdsycPzdLUBWCk0/mHkPBFTf25/JIHd+Sck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 05/38] Documentation: Add swapgs description to the Spectre v1 documentation
Date:   Thu, 10 Mar 2022 15:13:18 +0100
Message-Id: <20220310140808.296536109@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 4c92057661a3412f547ede95715641d7ee16ddac upstream.

Add documentation to the Spectre document about the new swapgs variant of
Spectre v1.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/spectre.rst |   88 ++++++++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 8 deletions(-)

--- a/Documentation/hw-vuln/spectre.rst
+++ b/Documentation/hw-vuln/spectre.rst
@@ -41,10 +41,11 @@ Related CVEs
 
 The following CVE entries describe Spectre variants:
 
-   =============   =======================  =================
+   =============   =======================  ==========================
    CVE-2017-5753   Bounds check bypass      Spectre variant 1
    CVE-2017-5715   Branch target injection  Spectre variant 2
-   =============   =======================  =================
+   CVE-2019-1125   Spectre v1 swapgs        Spectre variant 1 (swapgs)
+   =============   =======================  ==========================
 
 Problem
 -------
@@ -78,6 +79,13 @@ There are some extensions of Spectre var
 over the network, see :ref:`[12] <spec_ref12>`. However such attacks
 are difficult, low bandwidth, fragile, and are considered low risk.
 
+Note that, despite "Bounds Check Bypass" name, Spectre variant 1 is not
+only about user-controlled array bounds checks.  It can affect any
+conditional checks.  The kernel entry code interrupt, exception, and NMI
+handlers all have conditional swapgs checks.  Those may be problematic
+in the context of Spectre v1, as kernel code can speculatively run with
+a user GS.
+
 Spectre variant 2 (Branch Target Injection)
 -------------------------------------------
 
@@ -132,6 +140,9 @@ not cover all possible attack vectors.
 1. A user process attacking the kernel
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
+Spectre variant 1
+~~~~~~~~~~~~~~~~~
+
    The attacker passes a parameter to the kernel via a register or
    via a known address in memory during a syscall. Such parameter may
    be used later by the kernel as an index to an array or to derive
@@ -144,7 +155,40 @@ not cover all possible attack vectors.
    potentially be influenced for Spectre attacks, new "nospec" accessor
    macros are used to prevent speculative loading of data.
 
-   Spectre variant 2 attacker can :ref:`poison <poison_btb>` the branch
+Spectre variant 1 (swapgs)
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+   An attacker can train the branch predictor to speculatively skip the
+   swapgs path for an interrupt or exception.  If they initialize
+   the GS register to a user-space value, if the swapgs is speculatively
+   skipped, subsequent GS-related percpu accesses in the speculation
+   window will be done with the attacker-controlled GS value.  This
+   could cause privileged memory to be accessed and leaked.
+
+   For example:
+
+   ::
+
+     if (coming from user space)
+         swapgs
+     mov %gs:<percpu_offset>, %reg
+     mov (%reg), %reg1
+
+   When coming from user space, the CPU can speculatively skip the
+   swapgs, and then do a speculative percpu load using the user GS
+   value.  So the user can speculatively force a read of any kernel
+   value.  If a gadget exists which uses the percpu value as an address
+   in another load/store, then the contents of the kernel value may
+   become visible via an L1 side channel attack.
+
+   A similar attack exists when coming from kernel space.  The CPU can
+   speculatively do the swapgs, causing the user GS to get used for the
+   rest of the speculative window.
+
+Spectre variant 2
+~~~~~~~~~~~~~~~~~
+
+   A spectre variant 2 attacker can :ref:`poison <poison_btb>` the branch
    target buffer (BTB) before issuing syscall to launch an attack.
    After entering the kernel, the kernel could use the poisoned branch
    target buffer on indirect jump and jump to gadget code in speculative
@@ -280,11 +324,18 @@ The sysfs file showing Spectre variant 1
 
 The possible values in this file are:
 
-  =======================================  =================================
-  'Mitigation: __user pointer sanitation'  Protection in kernel on a case by
-                                           case base with explicit pointer
-                                           sanitation.
-  =======================================  =================================
+  .. list-table::
+
+     * - 'Not affected'
+       - The processor is not vulnerable.
+     * - 'Vulnerable: __user pointer sanitization and usercopy barriers only; no swapgs barriers'
+       - The swapgs protections are disabled; otherwise it has
+         protection in the kernel on a case by case base with explicit
+         pointer sanitation and usercopy LFENCE barriers.
+     * - 'Mitigation: usercopy/swapgs barriers and __user pointer sanitization'
+       - Protection in the kernel on a case by case base with explicit
+         pointer sanitation, usercopy LFENCE barriers, and swapgs LFENCE
+         barriers.
 
 However, the protections are put in place on a case by case basis,
 and there is no guarantee that all possible attack vectors for Spectre
@@ -366,12 +417,27 @@ Turning on mitigation for Spectre varian
 1. Kernel mitigation
 ^^^^^^^^^^^^^^^^^^^^
 
+Spectre variant 1
+~~~~~~~~~~~~~~~~~
+
    For the Spectre variant 1, vulnerable kernel code (as determined
    by code audit or scanning tools) is annotated on a case by case
    basis to use nospec accessor macros for bounds clipping :ref:`[2]
    <spec_ref2>` to avoid any usable disclosure gadgets. However, it may
    not cover all attack vectors for Spectre variant 1.
 
+   Copy-from-user code has an LFENCE barrier to prevent the access_ok()
+   check from being mis-speculated.  The barrier is done by the
+   barrier_nospec() macro.
+
+   For the swapgs variant of Spectre variant 1, LFENCE barriers are
+   added to interrupt, exception and NMI entry where needed.  These
+   barriers are done by the FENCE_SWAPGS_KERNEL_ENTRY and
+   FENCE_SWAPGS_USER_ENTRY macros.
+
+Spectre variant 2
+~~~~~~~~~~~~~~~~~
+
    For Spectre variant 2 mitigation, the compiler turns indirect calls or
    jumps in the kernel into equivalent return trampolines (retpolines)
    :ref:`[3] <spec_ref3>` :ref:`[9] <spec_ref9>` to go to the target
@@ -473,6 +539,12 @@ Mitigation control on the kernel command
 Spectre variant 2 mitigation can be disabled or force enabled at the
 kernel command line.
 
+	nospectre_v1
+
+		[X86,PPC] Disable mitigations for Spectre Variant 1
+		(bounds check bypass). With this option data leaks are
+		possible in the system.
+
 	nospectre_v2
 
 		[X86] Disable all mitigations for the Spectre variant 2


