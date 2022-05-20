Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458D852EA55
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 12:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244554AbiETKxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 06:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiETKxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 06:53:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D8395A0F;
        Fri, 20 May 2022 03:53:37 -0700 (PDT)
Date:   Fri, 20 May 2022 10:53:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1653044015;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h898z339vXdaMvDwxvErz5Cx4C9iW5NtRzDH7SfPXTM=;
        b=p2kYribzlcBJ8yr/BGb+2RbVIVQFhSi47x/0dV3/xDCoJvgZyovSzdhIlSNie+4McMc78u
        OBQMPqc5Dx1p0AntWy0Qn4HwaS+fcfQv8CXxV8ITbr++bSOvYk1Sj7lW5UhozFdFudWfh1
        WO6+01czG2jHGyfwowhDyCAon/g+7uWxZbTN0y9k/gsCqrQ+SAfTNPx+RtffgiGt9qYJRg
        Cs8zuO86xtwwLbq4ov2SboNaFG3ooGrm0uZcJfytCLoLKeXj6Hl0RszXIo9Sqwyb7znTGs
        HyNAZkwgHtpRGRqgi2pXVz+cSxkVA2mmeV+Il5wIk12qQg1HP+DMiecFkszg2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1653044015;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h898z339vXdaMvDwxvErz5Cx4C9iW5NtRzDH7SfPXTM=;
        b=y0jCzaOQXrgxX2ifSyPWlmLErUroByJYRxrbwUETotzyp6lKA6Ut1eEbZjB7K+d80SV9mi
        AQr52PSmoFlMohAQ==
From:   "tip-bot2 for Peter Zijlstra" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] objtool: Fix symbol creation
Cc:     Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <YoPCTEYjoPqE4ZxB@hirez.programming.kicks-ass.net>
References: <YoPCTEYjoPqE4ZxB@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Message-ID: <165304401416.4207.18016822086620544220.tip-bot2@tip-bot2>
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

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     ead165fa1042247b033afad7be4be9b815d04ade
Gitweb:        https://git.kernel.org/tip/ead165fa1042247b033afad7be4be9b815d04ade
Author:        Peter Zijlstra <peterz@infradead.org>
AuthorDate:    Tue, 17 May 2022 17:42:04 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 20 May 2022 12:42:06 +02:00

objtool: Fix symbol creation

Nathan reported objtool failing with the following messages:

  warning: objtool: no non-local symbols !?
  warning: objtool: gelf_update_symshndx: invalid section index

The problem is due to commit 4abff6d48dbc ("objtool: Fix code relocs
vs weak symbols") failing to consider the case where an object would
have no non-local symbols.

The problem that commit tries to address is adding a STB_LOCAL symbol
to the symbol table in light of the ELF spec's requirement that:

  In each symbol table, all symbols with STB_LOCAL binding preced the
  weak and global symbols.  As ``Sections'' above describes, a symbol
  table section's sh_info section header member holds the symbol table
  index for the first non-local symbol.

The approach taken is to find this first non-local symbol, move that
to the end and then re-use the freed spot to insert a new local symbol
and increment sh_info.

Except it never considered the case of object files without global
symbols and got a whole bunch of details wrong -- so many in fact that
it is a wonder it ever worked :/

Specifically:

 - It failed to re-hash the symbol on the new index, so a subsequent
   find_symbol_by_index() would not find it at the new location and a
   query for the old location would now return a non-deterministic
   choice between the old and new symbol.

 - It failed to appreciate that the GElf wrappers are not a valid disk
   format (it works because GElf is basically Elf64 and we only
   support x86_64 atm.)

 - It failed to fully appreciate how horrible the libelf API really is
   and got the gelf_update_symshndx() call pretty much completely
   wrong; with the direct consequence that if inserting a second
   STB_LOCAL symbol would require moving the same STB_GLOBAL symbol
   again it would completely come unstuck.

Write a new elf_update_symbol() function that wraps all the magic
required to update or create a new symbol at a given index.

Specifically, gelf_update_sym*() require an @ndx argument that is
relative to the @data argument; this means you have to manually
iterate the section data descriptor list and update @ndx.

Fixes: 4abff6d48dbc ("objtool: Fix code relocs vs weak symbols")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/YoPCTEYjoPqE4ZxB@hirez.programming.kicks-ass.net
---
 tools/objtool/elf.c | 198 ++++++++++++++++++++++++++++---------------
 1 file changed, 129 insertions(+), 69 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 583a3ec..7fb6720 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -374,6 +374,9 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	struct list_head *entry;
 	struct rb_node *pnode;
 
+	INIT_LIST_HEAD(&sym->pv_target);
+	sym->alias = sym;
+
 	sym->type = GELF_ST_TYPE(sym->sym.st_info);
 	sym->bind = GELF_ST_BIND(sym->sym.st_info);
 
@@ -438,8 +441,6 @@ static int read_symbols(struct elf *elf)
 			return -1;
 		}
 		memset(sym, 0, sizeof(*sym));
-		INIT_LIST_HEAD(&sym->pv_target);
-		sym->alias = sym;
 
 		sym->idx = i;
 
@@ -603,24 +604,21 @@ static void elf_dirty_reloc_sym(struct elf *elf, struct symbol *sym)
 }
 
 /*
- * Move the first global symbol, as per sh_info, into a new, higher symbol
- * index. This fees up the shndx for a new local symbol.
+ * The libelf API is terrible; gelf_update_sym*() takes a data block relative
+ * index value, *NOT* the symbol index. As such, iterate the data blocks and
+ * adjust index until it fits.
+ *
+ * If no data block is found, allow adding a new data block provided the index
+ * is only one past the end.
  */
-static int elf_move_global_symbol(struct elf *elf, struct section *symtab,
-				  struct section *symtab_shndx)
+static int elf_update_symbol(struct elf *elf, struct section *symtab,
+			     struct section *symtab_shndx, struct symbol *sym)
 {
-	Elf_Data *data, *shndx_data = NULL;
-	Elf32_Word first_non_local;
-	struct symbol *sym;
-	Elf_Scn *s;
-
-	first_non_local = symtab->sh.sh_info;
-
-	sym = find_symbol_by_index(elf, first_non_local);
-	if (!sym) {
-		WARN("no non-local symbols !?");
-		return first_non_local;
-	}
+	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
+	Elf_Data *symtab_data = NULL, *shndx_data = NULL;
+	Elf64_Xword entsize = symtab->sh.sh_entsize;
+	int max_idx, idx = sym->idx;
+	Elf_Scn *s, *t = NULL;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
@@ -628,79 +626,124 @@ static int elf_move_global_symbol(struct elf *elf, struct section *symtab,
 		return -1;
 	}
 
-	data = elf_newdata(s);
-	if (!data) {
-		WARN_ELF("elf_newdata");
-		return -1;
+	if (symtab_shndx) {
+		t = elf_getscn(elf->elf, symtab_shndx->idx);
+		if (!t) {
+			WARN_ELF("elf_getscn");
+			return -1;
+		}
 	}
 
-	data->d_buf = &sym->sym;
-	data->d_size = sizeof(sym->sym);
-	data->d_align = 1;
-	data->d_type = ELF_T_SYM;
+	for (;;) {
+		/* get next data descriptor for the relevant sections */
+		symtab_data = elf_getdata(s, symtab_data);
+		if (t)
+			shndx_data = elf_getdata(t, shndx_data);
 
-	sym->idx = symtab->sh.sh_size / sizeof(sym->sym);
-	elf_dirty_reloc_sym(elf, sym);
+		/* end-of-list */
+		if (!symtab_data) {
+			void *buf;
 
-	symtab->sh.sh_info += 1;
-	symtab->sh.sh_size += data->d_size;
-	symtab->changed = true;
+			if (idx) {
+				/* we don't do holes in symbol tables */
+				WARN("index out of range");
+				return -1;
+			}
 
-	if (symtab_shndx) {
-		s = elf_getscn(elf->elf, symtab_shndx->idx);
-		if (!s) {
-			WARN_ELF("elf_getscn");
+			/* if @idx == 0, it's the next contiguous entry, create it */
+			symtab_data = elf_newdata(s);
+			if (t)
+				shndx_data = elf_newdata(t);
+
+			buf = calloc(1, entsize);
+			if (!buf) {
+				WARN("malloc");
+				return -1;
+			}
+
+			symtab_data->d_buf = buf;
+			symtab_data->d_size = entsize;
+			symtab_data->d_align = 1;
+			symtab_data->d_type = ELF_T_SYM;
+
+			symtab->sh.sh_size += entsize;
+			symtab->changed = true;
+
+			if (t) {
+				shndx_data->d_buf = &sym->sec->idx;
+				shndx_data->d_size = sizeof(Elf32_Word);
+				shndx_data->d_align = sizeof(Elf32_Word);
+				shndx_data->d_type = ELF_T_WORD;
+
+				symtab_shndx->sh.sh_size += sizeof(Elf32_Word);
+				symtab_shndx->changed = true;
+			}
+
+			break;
+		}
+
+		/* empty blocks should not happen */
+		if (!symtab_data->d_size) {
+			WARN("zero size data");
 			return -1;
 		}
 
-		shndx_data = elf_newdata(s);
+		/* is this the right block? */
+		max_idx = symtab_data->d_size / entsize;
+		if (idx < max_idx)
+			break;
+
+		/* adjust index and try again */
+		idx -= max_idx;
+	}
+
+	/* something went side-ways */
+	if (idx < 0) {
+		WARN("negative index");
+		return -1;
+	}
+
+	/* setup extended section index magic and write the symbol */
+	if (shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) {
+		sym->sym.st_shndx = shndx;
+		if (!shndx_data)
+			shndx = 0;
+	} else {
+		sym->sym.st_shndx = SHN_XINDEX;
 		if (!shndx_data) {
-			WARN_ELF("elf_newshndx_data");
+			WARN("no .symtab_shndx");
 			return -1;
 		}
+	}
 
-		shndx_data->d_buf = &sym->sec->idx;
-		shndx_data->d_size = sizeof(Elf32_Word);
-		shndx_data->d_align = 4;
-		shndx_data->d_type = ELF_T_WORD;
-
-		symtab_shndx->sh.sh_size += 4;
-		symtab_shndx->changed = true;
+	if (!gelf_update_symshndx(symtab_data, shndx_data, idx, &sym->sym, shndx)) {
+		WARN_ELF("gelf_update_symshndx");
+		return -1;
 	}
 
-	return first_non_local;
+	return 0;
 }
 
 static struct symbol *
 elf_create_section_symbol(struct elf *elf, struct section *sec)
 {
 	struct section *symtab, *symtab_shndx;
-	Elf_Data *shndx_data = NULL;
-	struct symbol *sym;
-	Elf32_Word shndx;
+	Elf32_Word first_non_local, new_idx;
+	struct symbol *sym, *old;
 
 	symtab = find_section_by_name(elf, ".symtab");
 	if (symtab) {
 		symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-		if (symtab_shndx)
-			shndx_data = symtab_shndx->data;
 	} else {
 		WARN("no .symtab");
 		return NULL;
 	}
 
-	sym = malloc(sizeof(*sym));
+	sym = calloc(1, sizeof(*sym));
 	if (!sym) {
 		perror("malloc");
 		return NULL;
 	}
-	memset(sym, 0, sizeof(*sym));
-
-	sym->idx = elf_move_global_symbol(elf, symtab, symtab_shndx);
-	if (sym->idx < 0) {
-		WARN("elf_move_global_symbol");
-		return NULL;
-	}
 
 	sym->name = sec->name;
 	sym->sec = sec;
@@ -710,24 +753,41 @@ elf_create_section_symbol(struct elf *elf, struct section *sec)
 	// st_other 0
 	// st_value 0
 	// st_size 0
-	shndx = sec->idx;
-	if (shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) {
-		sym->sym.st_shndx = shndx;
-		if (!shndx_data)
-			shndx = 0;
-	} else {
-		sym->sym.st_shndx = SHN_XINDEX;
-		if (!shndx_data) {
-			WARN("no .symtab_shndx");
+
+	/*
+	 * Move the first global symbol, as per sh_info, into a new, higher
+	 * symbol index. This fees up a spot for a new local symbol.
+	 */
+	first_non_local = symtab->sh.sh_info;
+	new_idx = symtab->sh.sh_size / symtab->sh.sh_entsize;
+	old = find_symbol_by_index(elf, first_non_local);
+	if (old) {
+		old->idx = new_idx;
+
+		hlist_del(&old->hash);
+		elf_hash_add(symbol, &old->hash, old->idx);
+
+		elf_dirty_reloc_sym(elf, old);
+
+		if (elf_update_symbol(elf, symtab, symtab_shndx, old)) {
+			WARN("elf_update_symbol move");
 			return NULL;
 		}
+
+		new_idx = first_non_local;
 	}
 
-	if (!gelf_update_symshndx(symtab->data, shndx_data, sym->idx, &sym->sym, shndx)) {
-		WARN_ELF("gelf_update_symshndx");
+	sym->idx = new_idx;
+	if (elf_update_symbol(elf, symtab, symtab_shndx, sym)) {
+		WARN("elf_update_symbol");
 		return NULL;
 	}
 
+	/*
+	 * Either way, we added a LOCAL symbol.
+	 */
+	symtab->sh.sh_info += 1;
+
 	elf_add_symbol(elf, sym);
 
 	return sym;
