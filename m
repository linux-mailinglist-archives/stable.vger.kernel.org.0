Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD9357DDD0
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiGVJTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiGVJSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:18:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35AB9A19;
        Fri, 22 Jul 2022 02:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 765A0CE288C;
        Fri, 22 Jul 2022 09:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BACC341C6;
        Fri, 22 Jul 2022 09:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481174;
        bh=Hfq5JVWZFJFdYcdb6JNfttuai2OJpVRJehn57pDf2JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfZwjlkZYk1zKsi6rbxW42mnYFJb0RKts38KoepU1qhQ7ZB7mv6nJZsVa8JZWydUn
         mpINobZfepcwqDw7YrEfFfJcVXFnbs8sBDb2tzh73adH+TjNOQpjvFhYUkIrdvpdpN
         dom9Utg/O5dZ5F6c+w+HjJ9ViG/LEmaU4mA1tL2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 08/89] objtool,x86: Replace alternatives with .retpoline_sites
Date:   Fri, 22 Jul 2022 11:10:42 +0200
Message-Id: <20220722091133.839712315@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S       |   14 +++
 tools/objtool/arch/x86/decode.c     |  120 --------------------------------
 tools/objtool/check.c               |  132 +++++++++++++++++++++++++-----------
 tools/objtool/elf.c                 |   84 ----------------------
 tools/objtool/include/objtool/elf.h |    1 
 tools/objtool/special.c             |    8 --
 6 files changed, 107 insertions(+), 252 deletions(-)

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
@@ -684,126 +684,6 @@ const char *arch_ret_insn(int len)
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
-	alt->cpuid = bswap_if_needed(cpuid);
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
 int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg)
 {
 	struct cfi_reg *cfa = &insn->cfi.cfa;
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -533,6 +533,52 @@ static int create_static_call_sections(s
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
 static int create_mcount_loc_sections(struct objtool_file *file)
 {
 	struct section *sec;
@@ -863,6 +909,11 @@ static void annotate_call_site(struct ob
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
@@ -1833,11 +1894,6 @@ static void mark_rodata(struct objtool_f
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
@@ -1906,15 +1962,6 @@ static int decode_sections(struct objtoo
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
 
@@ -3252,6 +3299,13 @@ int check(struct objtool_file *file)
 		goto out;
 	warnings += ret;
 
+	if (retpoline) {
+		ret = create_retpoline_sites_sections(file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
+	}
+
 	if (mcount) {
 		ret = create_mcount_loc_sections(file);
 		if (ret < 0)
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -944,90 +944,6 @@ static int elf_add_string(struct elf *el
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
-	data->d_type = ELF_T_SYM;
-
-	sym->idx = symtab->sh.sh_size / sizeof(sym->sym);
-
-	symtab->sh.sh_size += data->d_size;
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
-		symtab_shndx->sh.sh_size += 4;
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
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -143,7 +143,6 @@ int elf_write_insn(struct elf *elf, stru
 		   unsigned long offset, unsigned int len,
 		   const char *insn);
 int elf_write_reloc(struct elf *elf, struct reloc *reloc);
-struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name);
 int elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -109,14 +109,6 @@ static int get_alt_entry(struct elf *elf
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


