Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CFD57EDC4
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiGWKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237939AbiGWKB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:01:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F4F61D48;
        Sat, 23 Jul 2022 02:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 773F6611BF;
        Sat, 23 Jul 2022 09:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C742C341C0;
        Sat, 23 Jul 2022 09:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570323;
        bh=YK9+XOi9SbioXxUkEVO0zL8ub18V/83umVoV5u7euKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEgiZguqLqA3dI1W/jKy09C9XvXs5ro2yRNDt7zwFo1my9H8uf2k4m1HyxIP5tat7
         UeeH6iacXB6lJ6JEglQcbxIzApOIBG3N83ywDDUvsb4ti6Ei2Ogk+cfZmI2dAhupSd
         fChCWRuArhkc7tR2zCL9RuscEb8Ea2vICWgKimjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 049/148] objtool,x86: Replace alternatives with .retpoline_sites
Date:   Sat, 23 Jul 2022 11:54:21 +0200
Message-Id: <20220723095238.041412869@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 134ab5bd1883312d7a4b3033b05c6b5a1bb8889b upstream.

Instead of writing complete alternatives, simply provide a list of all
the retpoline thunk calls. Then the kernel is free to do with them as
it pleases. Simpler code all-round.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120309.850007165@infradead.org
[cascardo: fixed conflict because of missing
 8b946cc38e063f0f7bb67789478c38f6d7d457c9]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10: deleted functions had slightly different code]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S   |   14 ++++
 tools/objtool/arch/x86/decode.c |  120 ------------------------------------
 tools/objtool/check.c           |  132 ++++++++++++++++++++++++++++------------
 tools/objtool/elf.c             |   83 -------------------------
 tools/objtool/elf.h             |    1 
 tools/objtool/special.c         |    8 --
 6 files changed, 107 insertions(+), 251 deletions(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -272,6 +272,20 @@ SECTIONS
 		__parainstructions_end = .;
 	}
 
+#ifdef CONFIG_RETPOLINE
+	/*
+	 * List of instructions that call/jmp/jcc to retpoline thunks
+	 * __x86_indirect_thunk_*(). These instructions can be patched along
+	 * with alternatives, after which the section can be freed.
+	 */
+	. = ALIGN(8);
+	.retpoline_sites : AT(ADDR(.retpoline_sites) - LOAD_OFFSET) {
+		__retpoline_sites = .;
+		*(.retpoline_sites)
+		__retpoline_sites_end = .;
+	}
+#endif
+
 	/*
 	 * struct alt_inst entries. From the header (alternative.h):
 	 * "Alternative instructions for different CPU types or capabilities"
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -606,126 +606,6 @@ const char *arch_ret_insn(int len)
 	return ret[len-1];
 }
 
-/* asm/alternative.h ? */
-
-#define ALTINSTR_FLAG_INV	(1 << 15)
-#define ALT_NOT(feat)		((feat) | ALTINSTR_FLAG_INV)
-
-struct alt_instr {
-	s32 instr_offset;	/* original instruction */
-	s32 repl_offset;	/* offset to replacement instruction */
-	u16 cpuid;		/* cpuid bit set for replacement */
-	u8  instrlen;		/* length of original instruction */
-	u8  replacementlen;	/* length of new instruction */
-} __packed;
-
-static int elf_add_alternative(struct elf *elf,
-			       struct instruction *orig, struct symbol *sym,
-			       int cpuid, u8 orig_len, u8 repl_len)
-{
-	const int size = sizeof(struct alt_instr);
-	struct alt_instr *alt;
-	struct section *sec;
-	Elf_Scn *s;
-
-	sec = find_section_by_name(elf, ".altinstructions");
-	if (!sec) {
-		sec = elf_create_section(elf, ".altinstructions",
-					 SHF_ALLOC, 0, 0);
-
-		if (!sec) {
-			WARN_ELF("elf_create_section");
-			return -1;
-		}
-	}
-
-	s = elf_getscn(elf->elf, sec->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return -1;
-	}
-
-	sec->data = elf_newdata(s);
-	if (!sec->data) {
-		WARN_ELF("elf_newdata");
-		return -1;
-	}
-
-	sec->data->d_size = size;
-	sec->data->d_align = 1;
-
-	alt = sec->data->d_buf = malloc(size);
-	if (!sec->data->d_buf) {
-		perror("malloc");
-		return -1;
-	}
-	memset(sec->data->d_buf, 0, size);
-
-	if (elf_add_reloc_to_insn(elf, sec, sec->sh.sh_size,
-				  R_X86_64_PC32, orig->sec, orig->offset)) {
-		WARN("elf_create_reloc: alt_instr::instr_offset");
-		return -1;
-	}
-
-	if (elf_add_reloc(elf, sec, sec->sh.sh_size + 4,
-			  R_X86_64_PC32, sym, 0)) {
-		WARN("elf_create_reloc: alt_instr::repl_offset");
-		return -1;
-	}
-
-	alt->cpuid = cpuid;
-	alt->instrlen = orig_len;
-	alt->replacementlen = repl_len;
-
-	sec->sh.sh_size += size;
-	sec->changed = true;
-
-	return 0;
-}
-
-#define X86_FEATURE_RETPOLINE                ( 7*32+12)
-
-int arch_rewrite_retpolines(struct objtool_file *file)
-{
-	struct instruction *insn;
-	struct reloc *reloc;
-	struct symbol *sym;
-	char name[32] = "";
-
-	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
-
-		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC)
-			continue;
-
-		if (!strcmp(insn->sec->name, ".text.__x86.indirect_thunk"))
-			continue;
-
-		reloc = insn->reloc;
-
-		sprintf(name, "__x86_indirect_alt_%s_%s",
-			insn->type == INSN_JUMP_DYNAMIC ? "jmp" : "call",
-			reloc->sym->name + 21);
-
-		sym = find_symbol_by_name(file->elf, name);
-		if (!sym) {
-			sym = elf_create_undef_symbol(file->elf, name);
-			if (!sym) {
-				WARN("elf_create_undef_symbol");
-				return -1;
-			}
-		}
-
-		if (elf_add_alternative(file->elf, insn, sym,
-					ALT_NOT(X86_FEATURE_RETPOLINE), 5, 5)) {
-			WARN("elf_add_alternative");
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
 int arch_decode_hint_reg(u8 sp_reg, int *base)
 {
 	switch (sp_reg) {
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -606,6 +606,52 @@ static int create_static_call_sections(s
 	return 0;
 }
 
+static int create_retpoline_sites_sections(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct section *sec;
+	int idx;
+
+	sec = find_section_by_name(file->elf, ".retpoline_sites");
+	if (sec) {
+		WARN("file already has .retpoline_sites, skipping");
+		return 0;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->retpoline_call_list, call_node)
+		idx++;
+
+	if (!idx)
+		return 0;
+
+	sec = elf_create_section(file->elf, ".retpoline_sites", 0,
+				 sizeof(int), idx);
+	if (!sec) {
+		WARN("elf_create_section: .retpoline_sites");
+		return -1;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
+
+		int *site = (int *)sec->data->d_buf + idx;
+		*site = 0;
+
+		if (elf_add_reloc_to_insn(file->elf, sec,
+					  idx * sizeof(int),
+					  R_X86_64_PC32,
+					  insn->sec, insn->offset)) {
+			WARN("elf_add_reloc_to_insn: .retpoline_sites");
+			return -1;
+		}
+
+		idx++;
+	}
+
+	return 0;
+}
+
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -893,6 +939,11 @@ static void annotate_call_site(struct ob
 		return;
 	}
 
+	if (sym->retpoline_thunk) {
+		list_add_tail(&insn->call_node, &file->retpoline_call_list);
+		return;
+	}
+
 	/*
 	 * Many compilers cannot disable KCOV with a function attribute
 	 * so they need a little help, NOP out any KCOV calls from noinstr
@@ -933,6 +984,39 @@ static void add_call_dest(struct objtool
 	annotate_call_site(file, insn, sibling);
 }
 
+static void add_retpoline_call(struct objtool_file *file, struct instruction *insn)
+{
+	/*
+	 * Retpoline calls/jumps are really dynamic calls/jumps in disguise,
+	 * so convert them accordingly.
+	 */
+	switch (insn->type) {
+	case INSN_CALL:
+		insn->type = INSN_CALL_DYNAMIC;
+		break;
+	case INSN_JUMP_UNCONDITIONAL:
+		insn->type = INSN_JUMP_DYNAMIC;
+		break;
+	case INSN_JUMP_CONDITIONAL:
+		insn->type = INSN_JUMP_DYNAMIC_CONDITIONAL;
+		break;
+	default:
+		return;
+	}
+
+	insn->retpoline_safe = true;
+
+	/*
+	 * Whatever stack impact regular CALLs have, should be undone
+	 * by the RETURN of the called function.
+	 *
+	 * Annotated intra-function calls retain the stack_ops but
+	 * are converted to JUMP, see read_intra_function_calls().
+	 */
+	remove_insn_ops(insn);
+
+	annotate_call_site(file, insn, false);
+}
 /*
  * Find the destination instructions for all jumps.
  */
@@ -955,19 +1039,7 @@ static int add_jump_destinations(struct
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
 		} else if (reloc->sym->retpoline_thunk) {
-			/*
-			 * Retpoline jumps are really dynamic jumps in
-			 * disguise, so convert them accordingly.
-			 */
-			if (insn->type == INSN_JUMP_UNCONDITIONAL)
-				insn->type = INSN_JUMP_DYNAMIC;
-			else
-				insn->type = INSN_JUMP_DYNAMIC_CONDITIONAL;
-
-			list_add_tail(&insn->call_node,
-				      &file->retpoline_call_list);
-
-			insn->retpoline_safe = true;
+			add_retpoline_call(file, insn);
 			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
@@ -1096,18 +1168,7 @@ static int add_call_destinations(struct
 			add_call_dest(file, insn, dest, false);
 
 		} else if (reloc->sym->retpoline_thunk) {
-			/*
-			 * Retpoline calls are really dynamic calls in
-			 * disguise, so convert them accordingly.
-			 */
-			insn->type = INSN_CALL_DYNAMIC;
-			insn->retpoline_safe = true;
-
-			list_add_tail(&insn->call_node,
-				      &file->retpoline_call_list);
-
-			remove_insn_ops(insn);
-			continue;
+			add_retpoline_call(file, insn);
 
 		} else
 			add_call_dest(file, insn, reloc->sym, false);
@@ -1806,11 +1867,6 @@ static void mark_rodata(struct objtool_f
 	file->rodata = found;
 }
 
-__weak int arch_rewrite_retpolines(struct objtool_file *file)
-{
-	return 0;
-}
-
 static int decode_sections(struct objtool_file *file)
 {
 	int ret;
@@ -1879,15 +1935,6 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	/*
-	 * Must be after add_special_section_alts(), since this will emit
-	 * alternatives. Must be after add_{jump,call}_destination(), since
-	 * those create the call insn lists.
-	 */
-	ret = arch_rewrite_retpolines(file);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -3159,6 +3206,13 @@ int check(struct objtool_file *file)
 		goto out;
 	warnings += ret;
 
+	if (retpoline) {
+		ret = create_retpoline_sites_sections(file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
+	}
+
 	if (stats) {
 		printf("nr_insns_visited: %ld\n", nr_insns_visited);
 		printf("nr_cfi: %ld\n", nr_cfi);
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -766,89 +766,6 @@ static int elf_add_string(struct elf *el
 	return len;
 }
 
-struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name)
-{
-	struct section *symtab, *symtab_shndx;
-	struct symbol *sym;
-	Elf_Data *data;
-	Elf_Scn *s;
-
-	sym = malloc(sizeof(*sym));
-	if (!sym) {
-		perror("malloc");
-		return NULL;
-	}
-	memset(sym, 0, sizeof(*sym));
-
-	sym->name = strdup(name);
-
-	sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
-	if (sym->sym.st_name == -1)
-		return NULL;
-
-	sym->sym.st_info = GELF_ST_INFO(STB_GLOBAL, STT_NOTYPE);
-	// st_other 0
-	// st_shndx 0
-	// st_value 0
-	// st_size 0
-
-	symtab = find_section_by_name(elf, ".symtab");
-	if (!symtab) {
-		WARN("can't find .symtab");
-		return NULL;
-	}
-
-	s = elf_getscn(elf->elf, symtab->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return NULL;
-	}
-
-	data = elf_newdata(s);
-	if (!data) {
-		WARN_ELF("elf_newdata");
-		return NULL;
-	}
-
-	data->d_buf = &sym->sym;
-	data->d_size = sizeof(sym->sym);
-	data->d_align = 1;
-
-	sym->idx = symtab->len / sizeof(sym->sym);
-
-	symtab->len += data->d_size;
-	symtab->changed = true;
-
-	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-	if (symtab_shndx) {
-		s = elf_getscn(elf->elf, symtab_shndx->idx);
-		if (!s) {
-			WARN_ELF("elf_getscn");
-			return NULL;
-		}
-
-		data = elf_newdata(s);
-		if (!data) {
-			WARN_ELF("elf_newdata");
-			return NULL;
-		}
-
-		data->d_buf = &sym->sym.st_size; /* conveniently 0 */
-		data->d_size = sizeof(Elf32_Word);
-		data->d_align = 4;
-		data->d_type = ELF_T_WORD;
-
-		symtab_shndx->len += 4;
-		symtab_shndx->changed = true;
-	}
-
-	sym->sec = find_section_by_index(elf, 0);
-
-	elf_add_symbol(elf, sym);
-
-	return sym;
-}
-
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   unsigned int sh_flags, size_t entsize, int nr)
 {
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -136,7 +136,6 @@ int elf_write_insn(struct elf *elf, stru
 		   unsigned long offset, unsigned int len,
 		   const char *insn);
 int elf_write_reloc(struct elf *elf, struct reloc *reloc);
-struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name);
 int elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -105,14 +105,6 @@ static int get_alt_entry(struct elf *elf
 			return -1;
 		}
 
-		/*
-		 * Skip retpoline .altinstr_replacement... we already rewrite the
-		 * instructions for retpolines anyway, see arch_is_retpoline()
-		 * usage in add_{call,jump}_destinations().
-		 */
-		if (arch_is_retpoline(new_reloc->sym))
-			return 1;
-
 		reloc_to_sec_off(new_reloc, &alt->new_sec, &alt->new_off);
 
 		/* _ASM_EXTABLE_EX hack */


