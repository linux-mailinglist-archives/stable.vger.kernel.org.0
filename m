Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A230552640E
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380748AbiEMO1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381106AbiEMO0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1FE50B02;
        Fri, 13 May 2022 07:26:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 238D2B8307B;
        Fri, 13 May 2022 14:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51036C34100;
        Fri, 13 May 2022 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451991;
        bh=0C1cmO61Qt6CWllfe71gI5XVVBFSNf2m2kyZRF4iiWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/gOHPrsmHmQ9IgCarEV10qPdGKt3nqPlxqY04cerC2lHLbfz4DTNT6Q9HT1yYIMI
         DcEQ9LlYAQYhA4E2pu9IKB4z/SeNVOCI1Wt36jtljXQEYmjpy8qdVCQ2q19vrFziyS
         dnLt1VwR8GS5DFrWi8aC1pgrkZ1tREdTYCk/k1S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>, xen-devel@lists.xenproject.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.4 12/18] x86: xen: insn: Decode Xen and KVM emulate-prefix signature
Date:   Fri, 13 May 2022 16:23:38 +0200
Message-Id: <20220513142229.512910493@linuxfoundation.org>
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

commit 4d65adfcd1196818659d3bd9b42dccab291e1751 upstream.

Decode Xen and KVM's emulate-prefix signature by x86 insn decoder.
It is called "prefix" but actually not x86 instruction prefix, so
this adds insn.emulate_prefix_size field instead of reusing
insn.prefixes.

If x86 decoder finds a special sequence of instructions of
XEN_EMULATE_PREFIX and 'ud2a; .ascii "kvm"', it just counts the
length, set insn.emulate_prefix_size and fold it with the next
instruction. In other words, the signature and the next instruction
is treated as a single instruction.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: x86@kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: xen-devel@lists.xenproject.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: https://lkml.kernel.org/r/156777564986.25081.4964537658500952557.stgit@devnote2
[mheyne: resolved contextual conflict in tools/objtools/sync-check.sh]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn.h                 |    6 ++++
 arch/x86/lib/insn.c                         |   34 ++++++++++++++++++++++++++++
 tools/arch/x86/include/asm/emulate_prefix.h |   14 +++++++++++
 tools/arch/x86/include/asm/insn.h           |    6 ++++
 tools/arch/x86/lib/insn.c                   |   34 ++++++++++++++++++++++++++++
 tools/objtool/sync-check.sh                 |    3 +-
 tools/perf/check-headers.sh                 |    3 +-
 7 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/emulate_prefix.h

--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -45,6 +45,7 @@ struct insn {
 		struct insn_field immediate2;	/* for 64bit imm or seg16 */
 	};
 
+	int	emulate_prefix_size;
 	insn_attr_t attr;
 	unsigned char opnd_bytes;
 	unsigned char addr_bytes;
@@ -128,6 +129,11 @@ static inline int insn_is_evex(struct in
 	return (insn->vex_prefix.nbytes == 4);
 }
 
+static inline int insn_has_emulate_prefix(struct insn *insn)
+{
+	return !!insn->emulate_prefix_size;
+}
+
 /* Ensure this instruction is decoded completely */
 static inline int insn_complete(struct insn *insn)
 {
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -13,6 +13,8 @@
 #include <asm/inat.h>
 #include <asm/insn.h>
 
+#include <asm/emulate_prefix.h>
+
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
@@ -58,6 +60,36 @@ void insn_init(struct insn *insn, const
 		insn->addr_bytes = 4;
 }
 
+static const insn_byte_t xen_prefix[] = { __XEN_EMULATE_PREFIX };
+static const insn_byte_t kvm_prefix[] = { __KVM_EMULATE_PREFIX };
+
+static int __insn_get_emulate_prefix(struct insn *insn,
+				     const insn_byte_t *prefix, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (peek_nbyte_next(insn_byte_t, insn, i) != prefix[i])
+			goto err_out;
+	}
+
+	insn->emulate_prefix_size = len;
+	insn->next_byte += len;
+
+	return 1;
+
+err_out:
+	return 0;
+}
+
+static void insn_get_emulate_prefix(struct insn *insn)
+{
+	if (__insn_get_emulate_prefix(insn, xen_prefix, sizeof(xen_prefix)))
+		return;
+
+	__insn_get_emulate_prefix(insn, kvm_prefix, sizeof(kvm_prefix));
+}
+
 /**
  * insn_get_prefixes - scan x86 instruction prefix bytes
  * @insn:	&struct insn containing instruction
@@ -76,6 +108,8 @@ void insn_get_prefixes(struct insn *insn
 	if (prefixes->got)
 		return;
 
+	insn_get_emulate_prefix(insn);
+
 	nb = 0;
 	lb = 0;
 	b = peek_next(insn_byte_t, insn);
--- /dev/null
+++ b/tools/arch/x86/include/asm/emulate_prefix.h
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
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -45,6 +45,7 @@ struct insn {
 		struct insn_field immediate2;	/* for 64bit imm or seg16 */
 	};
 
+	int	emulate_prefix_size;
 	insn_attr_t attr;
 	unsigned char opnd_bytes;
 	unsigned char addr_bytes;
@@ -128,6 +129,11 @@ static inline int insn_is_evex(struct in
 	return (insn->vex_prefix.nbytes == 4);
 }
 
+static inline int insn_has_emulate_prefix(struct insn *insn)
+{
+	return !!insn->emulate_prefix_size;
+}
+
 /* Ensure this instruction is decoded completely */
 static inline int insn_complete(struct insn *insn)
 {
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -13,6 +13,8 @@
 #include "../include/asm/inat.h"
 #include "../include/asm/insn.h"
 
+#include "../include/asm/emulate_prefix.h"
+
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
@@ -58,6 +60,36 @@ void insn_init(struct insn *insn, const
 		insn->addr_bytes = 4;
 }
 
+static const insn_byte_t xen_prefix[] = { __XEN_EMULATE_PREFIX };
+static const insn_byte_t kvm_prefix[] = { __KVM_EMULATE_PREFIX };
+
+static int __insn_get_emulate_prefix(struct insn *insn,
+				     const insn_byte_t *prefix, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (peek_nbyte_next(insn_byte_t, insn, i) != prefix[i])
+			goto err_out;
+	}
+
+	insn->emulate_prefix_size = len;
+	insn->next_byte += len;
+
+	return 1;
+
+err_out:
+	return 0;
+}
+
+static void insn_get_emulate_prefix(struct insn *insn)
+{
+	if (__insn_get_emulate_prefix(insn, xen_prefix, sizeof(xen_prefix)))
+		return;
+
+	__insn_get_emulate_prefix(insn, kvm_prefix, sizeof(kvm_prefix));
+}
+
 /**
  * insn_get_prefixes - scan x86 instruction prefix bytes
  * @insn:	&struct insn containing instruction
@@ -76,6 +108,8 @@ void insn_get_prefixes(struct insn *insn
 	if (prefixes->got)
 		return;
 
+	insn_get_emulate_prefix(insn);
+
 	nb = 0;
 	lb = 0;
 	b = peek_next(insn_byte_t, insn);
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -4,6 +4,7 @@
 FILES='
 arch/x86/include/asm/inat_types.h
 arch/x86/include/asm/orc_types.h
+arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
 '
@@ -46,4 +47,4 @@ done
 check arch/x86/include/asm/inat.h     '-I "^#include [\"<]\(asm/\)*inat_types.h[\">]"'
 check arch/x86/include/asm/insn.h     '-I "^#include [\"<]\(asm/\)*inat.h[\">]"'
 check arch/x86/lib/inat.c             '-I "^#include [\"<]\(../include/\)*asm/insn.h[\">]"'
-check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]"'
+check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]" -I "^#include [\"<]\(../include/\)*asm/emulate_prefix.h[\">]"'
--- a/tools/perf/check-headers.sh
+++ b/tools/perf/check-headers.sh
@@ -28,6 +28,7 @@ arch/x86/include/asm/disabled-features.h
 arch/x86/include/asm/required-features.h
 arch/x86/include/asm/cpufeatures.h
 arch/x86/include/asm/inat_types.h
+arch/x86/include/asm/emulate_prefix.h
 arch/x86/include/uapi/asm/prctl.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
@@ -116,7 +117,7 @@ check lib/ctype.c		      '-I "^EXPORT_SY
 check arch/x86/include/asm/inat.h     '-I "^#include [\"<]\(asm/\)*inat_types.h[\">]"'
 check arch/x86/include/asm/insn.h     '-I "^#include [\"<]\(asm/\)*inat.h[\">]"'
 check arch/x86/lib/inat.c	      '-I "^#include [\"<]\(../include/\)*asm/insn.h[\">]"'
-check arch/x86/lib/insn.c	      '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]"'
+check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]" -I "^#include [\"<]\(../include/\)*asm/emulate_prefix.h[\">]"'
 
 # diff non-symmetric files
 check_2 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl arch/x86/entry/syscalls/syscall_64.tbl


