Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD852641E
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbiEMO11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381097AbiEMO0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF858506EC;
        Fri, 13 May 2022 07:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C3F16219D;
        Fri, 13 May 2022 14:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8DAC36AEC;
        Fri, 13 May 2022 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451988;
        bh=85U1WWVkHeMQrJWMsxOyN59skP9tpj5MeWFM5A12uXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z69z3oDXPD21rNW9i5pU2xdBQSPQGAePhxjHL1MhlizvNubIkg2KtoA/5NPLc35nb
         WRkITwqgnicSG/5sBtZg7Vm2LyEr3KCNf86g+8MC7GZbp5HhpQMlVmZixtDqTet+1D
         sspSucBEntU5Btet39kQCTflWgfYlUUZ4zmPy+Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Borislav Petkov <bp@alien8.de>, xen-devel@lists.xenproject.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.4 11/18] x86: xen: kvm: Gather the definition of emulate prefixes
Date:   Fri, 13 May 2022 16:23:37 +0200
Message-Id: <20220513142229.483992618@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
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

From: Masami Hiramatsu <mhiramat@kernel.org>

commit b3dc0695fa40c3b280230fb6fb7fb7a94ce28bf4 upstream.

Gather the emulate prefixes, which forcibly make the following
instruction emulated on virtualization, in one place.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: x86@kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: xen-devel@lists.xenproject.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/156777563917.25081.7286628561790289995.stgit@devnote2
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/emulate_prefix.h |   14 ++++++++++++++
 arch/x86/include/asm/xen/interface.h  |   11 ++++-------
 arch/x86/kvm/x86.c                    |    4 +++-
 3 files changed, 21 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/emulate_prefix.h

--- /dev/null
+++ b/arch/x86/include/asm/emulate_prefix.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_EMULATE_PREFIX_H
+#define _ASM_X86_EMULATE_PREFIX_H
+
+/*
+ * Virt escape sequences to trigger instruction emulation;
+ * ideally these would decode to 'whole' instruction and not destroy
+ * the instruction stream; sadly this is not true for the 'kvm' one :/
+ */
+
+#define __XEN_EMULATE_PREFIX  0x0f,0x0b,0x78,0x65,0x6e  /* ud2 ; .ascii "xen" */
+#define __KVM_EMULATE_PREFIX  0x0f,0x0b,0x6b,0x76,0x6d	/* ud2 ; .ascii "kvm" */
+
+#endif
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -379,12 +379,9 @@ struct xen_pmu_arch {
  * Prefix forces emulation of some non-trapping instructions.
  * Currently only CPUID.
  */
-#ifdef __ASSEMBLY__
-#define XEN_EMULATE_PREFIX .byte 0x0f,0x0b,0x78,0x65,0x6e ;
-#define XEN_CPUID          XEN_EMULATE_PREFIX cpuid
-#else
-#define XEN_EMULATE_PREFIX ".byte 0x0f,0x0b,0x78,0x65,0x6e ; "
-#define XEN_CPUID          XEN_EMULATE_PREFIX "cpuid"
-#endif
+#include <asm/emulate_prefix.h>
+
+#define XEN_EMULATE_PREFIX __ASM_FORM(.byte __XEN_EMULATE_PREFIX ;)
+#define XEN_CPUID          XEN_EMULATE_PREFIX __ASM_FORM(cpuid)
 
 #endif /* _ASM_X86_XEN_INTERFACE_H */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -68,6 +68,7 @@
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 #include <asm/intel_pt.h>
+#include <asm/emulate_prefix.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -5583,6 +5584,7 @@ EXPORT_SYMBOL_GPL(kvm_write_guest_virt_s
 
 int handle_ud(struct kvm_vcpu *vcpu)
 {
+	static const char kvm_emulate_prefix[] = { __KVM_EMULATE_PREFIX };
 	int emul_type = EMULTYPE_TRAP_UD;
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
@@ -5590,7 +5592,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	if (force_emulation_prefix &&
 	    kvm_read_guest_virt(vcpu, kvm_get_linear_rip(vcpu),
 				sig, sizeof(sig), &e) == 0 &&
-	    memcmp(sig, "\xf\xbkvm", sizeof(sig)) == 0) {
+	    memcmp(sig, kvm_emulate_prefix, sizeof(sig)) == 0) {
 		kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(sig));
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}


