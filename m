Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D257235A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiGLSoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiGLSoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37562D6CF3;
        Tue, 12 Jul 2022 11:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1D561ACA;
        Tue, 12 Jul 2022 18:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B8DC3411C;
        Tue, 12 Jul 2022 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651327;
        bh=edXK0hiq1Nl4cx9AKafrgyyFNZRfcBMbs6qOf68SPA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ustfw0JmfWC7ec+/S+bwqXKiAr22c/askS7O+fCjeOvlI8eRpP/5dn8I3PslUkKnk
         LRK2rB4E6+mwkBpafCmdc0CvpzO3sdJ4Aug8tDe29DMyagfSqWhiUe6xAH6r1ffC6O
         8pNBU6N+AUHAKNl1h7lYs+7jfExuS6ZFMJIAsU3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 012/130] x86/alternative: Support not-feature
Date:   Tue, 12 Jul 2022 20:37:38 +0200
Message-Id: <20220712183246.963713915@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit dda7bb76484978316bb412a353789ebc5901de36 upstream.

Add support for alternative patching for the case a feature is not
present on the current CPU. For users of ALTERNATIVE() and friends, an
inverted feature is specified by applying the ALT_NOT() macro to it,
e.g.:

  ALTERNATIVE(old, new, ALT_NOT(feature));

Committer note:

The decision to encode the NOT-bit in the feature bit itself is because
a future change which would make objtool generate such alternative
calls, would keep the code in objtool itself fairly simple.

Also, this allows for the alternative macros to support the NOT feature
without having to change them.

Finally, the u16 cpuid member encoding the X86_FEATURE_ flags is not an
ABI so if more bits are needed, cpuid itself can be enlarged or a flags
field can be added to struct alt_instr after having considered the size
growth in either cases.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210311142319.4723-6-jgross@suse.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    3 +++
 arch/x86/kernel/alternative.c      |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -6,6 +6,9 @@
 #include <linux/stringify.h>
 #include <asm/asm.h>
 
+#define ALTINSTR_FLAG_INV	(1 << 15)
+#define ALT_NOT(feat)		((feat) | ALTINSTR_FLAG_INV)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/stddef.h>
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -388,21 +388,31 @@ void __init_or_module noinline apply_alt
 	 */
 	for (a = start; a < end; a++) {
 		int insn_buff_sz = 0;
+		/* Mask away "NOT" flag bit for feature to test. */
+		u16 feature = a->cpuid & ~ALTINSTR_FLAG_INV;
 
 		instr = (u8 *)&a->instr_offset + a->instr_offset;
 		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->instrlen > sizeof(insn_buff));
-		BUG_ON(a->cpuid >= (NCAPINTS + NBUGINTS) * 32);
-		if (!boot_cpu_has(a->cpuid)) {
+		BUG_ON(feature >= (NCAPINTS + NBUGINTS) * 32);
+
+		/*
+		 * Patch if either:
+		 * - feature is present
+		 * - feature not present but ALTINSTR_FLAG_INV is set to mean,
+		 *   patch if feature is *NOT* present.
+		 */
+		if (!boot_cpu_has(feature) == !(a->cpuid & ALTINSTR_FLAG_INV)) {
 			if (a->padlen > 1)
 				optimize_nops(a, instr);
 
 			continue;
 		}
 
-		DPRINTK("feat: %d*32+%d, old: (%pS (%px) len: %d), repl: (%px, len: %d), pad: %d",
-			a->cpuid >> 5,
-			a->cpuid & 0x1f,
+		DPRINTK("feat: %s%d*32+%d, old: (%pS (%px) len: %d), repl: (%px, len: %d), pad: %d",
+			(a->cpuid & ALTINSTR_FLAG_INV) ? "!" : "",
+			feature >> 5,
+			feature & 0x1f,
 			instr, instr, a->instrlen,
 			replacement, a->replacementlen, a->padlen);
 


