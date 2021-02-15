Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99FC31BCD1
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBOPgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhBOPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE9464EBA;
        Mon, 15 Feb 2021 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403051;
        bh=+VGg9ox8pUIcU5qHK1bVF2HVQW2liuHgC+/uqH4jxfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TafKx2Fh5BpwpDdCE/Tn65o6ayXA4I2qa4vggKxN/9FRwpkuuRmviDhlxzkaasZ91
         RVz6LZb5Au7c3CNcEPeQ/k7j/1Ti3immePqCId1mIaKssqcKczjHgbIHvCR7sjN0nE
         inkOAekS776jptUVvGdKYBar1LDnm92esLWUpMQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 5.10 001/104] objtool: Fix seg fault with Clang non-section symbols
Date:   Mon, 15 Feb 2021 16:26:14 +0100
Message-Id: <20210215152719.507219797@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 44f6a7c0755d8dd453c70557e11687bb080a6f21 upstream.

The Clang assembler likes to strip section symbols, which means objtool
can't reference some text code by its section.  This confuses objtool
greatly, causing it to seg fault.

The fix is similar to what was done before, for ORC reloc generation:

  e81e07244325 ("objtool: Support Clang non-section symbols in ORC generation")

Factor out that code into a common helper and use it for static call
reloc generation as well.

Reported-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://github.com/ClangBuiltLinux/linux/issues/1207
Link: https://lkml.kernel.org/r/ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c   |   11 +++++++++--
 tools/objtool/elf.c     |   26 ++++++++++++++++++++++++++
 tools/objtool/elf.h     |    2 ++
 tools/objtool/orc_gen.c |   29 +++++------------------------
 4 files changed, 42 insertions(+), 26 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -467,13 +467,20 @@ static int create_static_call_sections(s
 
 		/* populate reloc for 'addr' */
 		reloc = malloc(sizeof(*reloc));
+
 		if (!reloc) {
 			perror("malloc");
 			return -1;
 		}
 		memset(reloc, 0, sizeof(*reloc));
-		reloc->sym = insn->sec->sym;
-		reloc->addend = insn->offset;
+
+		insn_to_reloc_sym_addend(insn->sec, insn->offset, reloc);
+		if (!reloc->sym) {
+			WARN_FUNC("static call tramp: missing containing symbol",
+				  insn->sec, insn->offset);
+			return -1;
+		}
+
 		reloc->type = R_X86_64_PC32;
 		reloc->offset = idx * sizeof(struct static_call_site);
 		reloc->sec = reloc_sec;
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -262,6 +262,32 @@ struct reloc *find_reloc_by_dest(const s
 	return find_reloc_by_dest_range(elf, sec, offset, 1);
 }
 
+void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
+			      struct reloc *reloc)
+{
+	if (sec->sym) {
+		reloc->sym = sec->sym;
+		reloc->addend = offset;
+		return;
+	}
+
+	/*
+	 * The Clang assembler strips section symbols, so we have to reference
+	 * the function symbol instead:
+	 */
+	reloc->sym = find_symbol_containing(sec, offset);
+	if (!reloc->sym) {
+		/*
+		 * Hack alert.  This happens when we need to reference the NOP
+		 * pad insn immediately after the function.
+		 */
+		reloc->sym = find_symbol_containing(sec, offset - 1);
+	}
+
+	if (reloc->sym)
+		reloc->addend = offset - reloc->sym->offset;
+}
+
 static int read_sections(struct elf *elf)
 {
 	Elf_Scn *s = NULL;
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -140,6 +140,8 @@ struct reloc *find_reloc_by_dest(const s
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len);
 struct symbol *find_func_containing(struct section *sec, unsigned long offset);
+void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
+			      struct reloc *reloc);
 int elf_rebuild_reloc_section(struct elf *elf, struct section *sec);
 
 #define for_each_sec(file, sec)						\
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -105,30 +105,11 @@ static int create_orc_entry(struct elf *
 	}
 	memset(reloc, 0, sizeof(*reloc));
 
-	if (insn_sec->sym) {
-		reloc->sym = insn_sec->sym;
-		reloc->addend = insn_off;
-	} else {
-		/*
-		 * The Clang assembler doesn't produce section symbols, so we
-		 * have to reference the function symbol instead:
-		 */
-		reloc->sym = find_symbol_containing(insn_sec, insn_off);
-		if (!reloc->sym) {
-			/*
-			 * Hack alert.  This happens when we need to reference
-			 * the NOP pad insn immediately after the function.
-			 */
-			reloc->sym = find_symbol_containing(insn_sec,
-							   insn_off - 1);
-		}
-		if (!reloc->sym) {
-			WARN("missing symbol for insn at offset 0x%lx\n",
-			     insn_off);
-			return -1;
-		}
-
-		reloc->addend = insn_off - reloc->sym->offset;
+	insn_to_reloc_sym_addend(insn_sec, insn_off, reloc);
+	if (!reloc->sym) {
+		WARN("missing symbol for insn at offset 0x%lx",
+		     insn_off);
+		return -1;
 	}
 
 	reloc->type = R_X86_64_PC32;


