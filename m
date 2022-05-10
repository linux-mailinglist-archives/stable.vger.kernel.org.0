Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF815219A6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiEJNuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244646AbiEJNqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:54 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CE816A244;
        Tue, 10 May 2022 06:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652189509; x=1683725509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/jlcjyqHJJuyQxaME83nVeMauiezhLHJNpjQ1y9lQkI=;
  b=VWpQLELEF/G7CE0nH8+rjYQrtpcHT+2WfqFs+S9ZiAAA/t40vJpCp4kn
   n/5G4QyMqU0uKgnkMatyLgwMiF6SE/nEp/pHId23u69KCG5vGezi53Yz8
   S7ocn0TxWWYEPOaYjwSJ+FaJahc8t/tHi5bpVfFW4ea/5xN8uQRc5CWww
   I=;
X-IronPort-AV: E=Sophos;i="5.91,214,1647302400"; 
   d="scan'208";a="196877995"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 10 May 2022 13:31:36 +0000
Received: from EX13D08EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 3037C80C1F;
        Tue, 10 May 2022 13:31:26 +0000 (UTC)
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 10 May 2022 13:31:09 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Tue, 10 May 2022 13:31:08 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 1F08041131; Tue, 10 May 2022 13:31:08 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>, <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        <xen-devel@lists.xenproject.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Maximilian Heyne <mheyne@amazon.de>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 2/4] x86: xen: kvm: Gather the definition of emulate prefixes
Date:   Tue, 10 May 2022 13:30:31 +0000
Message-ID: <20220510133036.46767-3-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510133036.46767-1-mheyne@amazon.de>
References: <20220510133036.46767-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit b3dc0695fa40c3b280230fb6fb7fb7a94ce28bf4 upstream

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
Cc: stable@vger.kernel.org # 5.4.x
---
 arch/x86/include/asm/emulate_prefix.h | 14 ++++++++++++++
 arch/x86/include/asm/xen/interface.h  | 11 ++++-------
 arch/x86/kvm/x86.c                    |  4 +++-
 3 files changed, 21 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/emulate_prefix.h

diff --git a/arch/x86/include/asm/emulate_prefix.h b/arch/x86/include/asm/emulate_prefix.h
new file mode 100644
index 000000000000..70f5b98a5286
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
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 62ca03ef5c65..9139b3e86316 100644
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f7dfa5aa42d..6dd77e426889 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -68,6 +68,7 @@
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 #include <asm/intel_pt.h>
+#include <asm/emulate_prefix.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -5583,6 +5584,7 @@ EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
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
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



