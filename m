Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F188592CFC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiHOKUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 06:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242509AbiHOKUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 06:20:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B873A6354;
        Mon, 15 Aug 2022 03:20:45 -0700 (PDT)
Date:   Mon, 15 Aug 2022 10:20:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660558844;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGdrZ1nVudr21xNYZsrDmg+Ws1QYXP4nSvy2Q7o0lT8=;
        b=AiMOFrIGCxmphCTQ3sp6tZwJ4BJ5zmRB4WH+DKz8IZG8nREMq7tw6Vud6fMTtjpKAoBM+x
        8bzA4HAClGlPVd5hB99IgSssTmdX6L7vBSny1L6FGCpyJMP+SdM43lT8WJUx408HuT3Qro
        T63PSPCvqTCFYObT1bRwIxgEX5j4P+soDxiZaLSaBPmtYd2cXUSKqfBEMgSodCW/HzH5wf
        TRajIspjsKbLhdG27YT7ypOTsg6UOe4n0q9YSJDQBNE2c6NvLs7mzoxJaVjR0KDT5uRcaT
        2jbPw4p5ivtCSNxF0g207VGdwXax9cxt+FNfltAeBP89Ki7y6YqHDRzTJnHVug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660558844;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGdrZ1nVudr21xNYZsrDmg+Ws1QYXP4nSvy2Q7o0lT8=;
        b=uZa1sPnMQs0uk0Y+3N81g26lFphS5wFsJLSuYpXiz9SIq5Z6O6F4l+D0ldaS1+t6tO4f9j
        ouK9P0fBP5H/RXAA==
From:   "tip-bot2 for Jan Beulich" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/PAT: Have pat_enabled() properly reflect state
 when running on Xen
Cc:     Jan Beulich <jbeulich@suse.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <9385fa60-fa5d-f559-a137-6608408f88b0@suse.com>
References: <9385fa60-fa5d-f559-a137-6608408f88b0@suse.com>
MIME-Version: 1.0
Message-ID: <166055884287.401.612271624942869534.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     72cbc8f04fe2fa93443c0fcccb7ad91dfea3d9ce
Gitweb:        https://git.kernel.org/tip/72cbc8f04fe2fa93443c0fcccb7ad91dfea3d9ce
Author:        Jan Beulich <jbeulich@suse.com>
AuthorDate:    Thu, 28 Apr 2022 16:50:29 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 15 Aug 2022 10:51:23 +02:00

x86/PAT: Have pat_enabled() properly reflect state when running on Xen

After commit ID in the Fixes: tag, pat_enabled() returns false (because
of PAT initialization being suppressed in the absence of MTRRs being
announced to be available).

This has become a problem: the i915 driver now fails to initialize when
running PV on Xen (i915_gem_object_pin_map() is where I located the
induced failure), and its error handling is flaky enough to (at least
sometimes) result in a hung system.

Yet even beyond that problem the keying of the use of WC mappings to
pat_enabled() (see arch_can_pci_mmap_wc()) means that in particular
graphics frame buffer accesses would have been quite a bit less optimal
than possible.

Arrange for the function to return true in such environments, without
undermining the rest of PAT MSR management logic considering PAT to be
disabled: specifically, no writes to the PAT MSR should occur.

For the new boolean to live in .init.data, init_cache_modes() also needs
moving to .init.text (where it could/should have lived already before).

  [ bp: This is the "small fix" variant for stable. It'll get replaced
    with a proper PAT and MTRR detection split upstream but that is too
    involved for a stable backport.
    - additional touchups to commit msg. Use cpu_feature_enabled(). ]

Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com
---
 arch/x86/mm/pat/memtype.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index d5ef64d..66a209f 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -62,6 +62,7 @@
 
 static bool __read_mostly pat_bp_initialized;
 static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
+static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
 static bool __read_mostly pat_bp_enabled;
 static bool __read_mostly pat_cm_initialized;
 
@@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
 static int __init nopat(char *str)
 {
 	pat_disable("PAT support disabled via boot option.");
+	pat_force_disabled = true;
 	return 0;
 }
 early_param("nopat", nopat);
@@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 }
 
-void init_cache_modes(void)
+void __init init_cache_modes(void)
 {
 	u64 pat = 0;
 
@@ -313,6 +315,12 @@ void init_cache_modes(void)
 		 */
 		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
 		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
+	} else if (!pat_force_disabled && cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) {
+		/*
+		 * Clearly PAT is enabled underneath. Allow pat_enabled() to
+		 * reflect this.
+		 */
+		pat_bp_enabled = true;
 	}
 
 	__init_cache_modes(pat);
