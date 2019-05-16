Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E26A120C6C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfEPQEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42450 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zA-Cf; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Pu-S2; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kees Cook" <keescook@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Jon Masters" <jcm@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Casey Schaufler" <casey.schaufler@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.133180850@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 45/86] x86/speculation: Mark string arrays const
 correctly
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 8770709f411763884535662744a3786a1806afd3 upstream.

checkpatch.pl muttered when reshuffling the code:
 WARNING: static const char * array should probably be static const char * const

Fix up all the string arrays.

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
Link: https://lkml.kernel.org/r/20181125185004.800018931@linutronix.de
[bwh: Backported to 3.16: drop the part for KVM mitigation modes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -290,7 +290,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_RETPOLINE_AMD,
 };
 
-static const char *spectre_v2_strings[] = {
+static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE_MINIMAL]		= "Vulnerable: Minimal generic ASM retpoline",
 	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
@@ -536,7 +536,7 @@ enum ssb_mitigation_cmd {
 	SPEC_STORE_BYPASS_CMD_SECCOMP,
 };
 
-static const char *ssb_strings[] = {
+static const char * const ssb_strings[] = {
 	[SPEC_STORE_BYPASS_NONE]	= "Vulnerable",
 	[SPEC_STORE_BYPASS_DISABLE]	= "Mitigation: Speculative Store Bypass disabled",
 	[SPEC_STORE_BYPASS_PRCTL]	= "Mitigation: Speculative Store Bypass disabled via prctl",

