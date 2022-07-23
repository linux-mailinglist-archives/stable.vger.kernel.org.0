Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED6057ED95
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiGWJ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237491AbiGWJ64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:58:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239416D54E;
        Sat, 23 Jul 2022 02:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D921611CD;
        Sat, 23 Jul 2022 09:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F17C341C0;
        Sat, 23 Jul 2022 09:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570264;
        bh=7ChS9UM2HIV8mnaiUuB29BJ3uVL/4KUef/DVQmisIbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yonSjfIl80ygtUpv8A6M7geDETFphxmA5tsdT9r4ZyxUeHmKcbkrjTaNGygDpgmRB
         quf3Ttwn/6DIC38UMtAqojNDVFdZt7PpD/tiL7aguUWMAMI+JaQkKWqYuLzOB/dqVa
         UDGCftjH1T8uhCtWKtC+45lvCyhFEcT9yhg+smEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 026/148] objtool: Add elf_create_reloc() helper
Date:   Sat, 23 Jul 2022 11:53:58 +0200
Message-Id: <20220723095231.747365666@linuxfoundation.org>
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

commit ef47cc01cb4abcd760d8ac66b9361d6ade4d0846 upstream.

We have 4 instances of adding a relocation. Create a common helper
to avoid growing even more.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.817438847@infradead.org
[bwh: Backported to 5.10: drop changes in create_mcount_loc_sections()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c   |   43 +++++-------------------
 tools/objtool/elf.c     |   86 +++++++++++++++++++++++++++++++-----------------
 tools/objtool/elf.h     |   10 +++--
 tools/objtool/orc_gen.c |   30 +++-------------
 4 files changed, 79 insertions(+), 90 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -433,8 +433,7 @@ reachable:
 
 static int create_static_call_sections(struct objtool_file *file)
 {
-	struct section *sec, *reloc_sec;
-	struct reloc *reloc;
+	struct section *sec;
 	struct static_call_site *site;
 	struct instruction *insn;
 	struct symbol *key_sym;
@@ -460,8 +459,7 @@ static int create_static_call_sections(s
 	if (!sec)
 		return -1;
 
-	reloc_sec = elf_create_reloc_section(file->elf, sec, SHT_RELA);
-	if (!reloc_sec)
+	if (!elf_create_reloc_section(file->elf, sec, SHT_RELA))
 		return -1;
 
 	idx = 0;
@@ -471,25 +469,11 @@ static int create_static_call_sections(s
 		memset(site, 0, sizeof(struct static_call_site));
 
 		/* populate reloc for 'addr' */
-		reloc = malloc(sizeof(*reloc));
-
-		if (!reloc) {
-			perror("malloc");
+		if (elf_add_reloc_to_insn(file->elf, sec,
+					  idx * sizeof(struct static_call_site),
+					  R_X86_64_PC32,
+					  insn->sec, insn->offset))
 			return -1;
-		}
-		memset(reloc, 0, sizeof(*reloc));
-
-		insn_to_reloc_sym_addend(insn->sec, insn->offset, reloc);
-		if (!reloc->sym) {
-			WARN_FUNC("static call tramp: missing containing symbol",
-				  insn->sec, insn->offset);
-			return -1;
-		}
-
-		reloc->type = R_X86_64_PC32;
-		reloc->offset = idx * sizeof(struct static_call_site);
-		reloc->sec = reloc_sec;
-		elf_add_reloc(file->elf, reloc);
 
 		/* find key symbol */
 		key_name = strdup(insn->call_dest->name);
@@ -526,18 +510,11 @@ static int create_static_call_sections(s
 		free(key_name);
 
 		/* populate reloc for 'key' */
-		reloc = malloc(sizeof(*reloc));
-		if (!reloc) {
-			perror("malloc");
+		if (elf_add_reloc(file->elf, sec,
+				  idx * sizeof(struct static_call_site) + 4,
+				  R_X86_64_PC32, key_sym,
+				  is_sibling_call(insn) * STATIC_CALL_SITE_TAIL))
 			return -1;
-		}
-		memset(reloc, 0, sizeof(*reloc));
-		reloc->sym = key_sym;
-		reloc->addend = is_sibling_call(insn) ? STATIC_CALL_SITE_TAIL : 0;
-		reloc->type = R_X86_64_PC32;
-		reloc->offset = idx * sizeof(struct static_call_site) + 4;
-		reloc->sec = reloc_sec;
-		elf_add_reloc(file->elf, reloc);
 
 		idx++;
 	}
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -262,32 +262,6 @@ struct reloc *find_reloc_by_dest(const s
 	return find_reloc_by_dest_range(elf, sec, offset, 1);
 }
 
-void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
-			      struct reloc *reloc)
-{
-	if (sec->sym) {
-		reloc->sym = sec->sym;
-		reloc->addend = offset;
-		return;
-	}
-
-	/*
-	 * The Clang assembler strips section symbols, so we have to reference
-	 * the function symbol instead:
-	 */
-	reloc->sym = find_symbol_containing(sec, offset);
-	if (!reloc->sym) {
-		/*
-		 * Hack alert.  This happens when we need to reference the NOP
-		 * pad insn immediately after the function.
-		 */
-		reloc->sym = find_symbol_containing(sec, offset - 1);
-	}
-
-	if (reloc->sym)
-		reloc->addend = offset - reloc->sym->offset;
-}
-
 static int read_sections(struct elf *elf)
 {
 	Elf_Scn *s = NULL;
@@ -524,14 +498,66 @@ err:
 	return -1;
 }
 
-void elf_add_reloc(struct elf *elf, struct reloc *reloc)
+int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
+		  unsigned int type, struct symbol *sym, int addend)
 {
-	struct section *sec = reloc->sec;
+	struct reloc *reloc;
 
-	list_add_tail(&reloc->list, &sec->reloc_list);
+	reloc = malloc(sizeof(*reloc));
+	if (!reloc) {
+		perror("malloc");
+		return -1;
+	}
+	memset(reloc, 0, sizeof(*reloc));
+
+	reloc->sec = sec->reloc;
+	reloc->offset = offset;
+	reloc->type = type;
+	reloc->sym = sym;
+	reloc->addend = addend;
+
+	list_add_tail(&reloc->list, &sec->reloc->reloc_list);
 	elf_hash_add(elf->reloc_hash, &reloc->hash, reloc_hash(reloc));
 
-	sec->changed = true;
+	sec->reloc->changed = true;
+
+	return 0;
+}
+
+int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
+			  unsigned long offset, unsigned int type,
+			  struct section *insn_sec, unsigned long insn_off)
+{
+	struct symbol *sym;
+	int addend;
+
+	if (insn_sec->sym) {
+		sym = insn_sec->sym;
+		addend = insn_off;
+
+	} else {
+		/*
+		 * The Clang assembler strips section symbols, so we have to
+		 * reference the function symbol instead:
+		 */
+		sym = find_symbol_containing(insn_sec, insn_off);
+		if (!sym) {
+			/*
+			 * Hack alert.  This happens when we need to reference
+			 * the NOP pad insn immediately after the function.
+			 */
+			sym = find_symbol_containing(insn_sec, insn_off - 1);
+		}
+
+		if (!sym) {
+			WARN("can't find symbol containing %s+0x%lx", insn_sec->name, insn_off);
+			return -1;
+		}
+
+		addend = insn_off - sym->offset;
+	}
+
+	return elf_add_reloc(elf, sec, offset, type, sym, addend);
 }
 
 static int read_rel_reloc(struct section *sec, int i, struct reloc *reloc, unsigned int *symndx)
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -123,7 +123,13 @@ static inline u32 reloc_hash(struct relo
 struct elf *elf_open_read(const char *name, int flags);
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 struct section *elf_create_reloc_section(struct elf *elf, struct section *base, int reltype);
-void elf_add_reloc(struct elf *elf, struct reloc *reloc);
+
+int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
+		  unsigned int type, struct symbol *sym, int addend);
+int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
+			  unsigned long offset, unsigned int type,
+			  struct section *insn_sec, unsigned long insn_off);
+
 int elf_write_insn(struct elf *elf, struct section *sec,
 		   unsigned long offset, unsigned int len,
 		   const char *insn);
@@ -140,8 +146,6 @@ struct reloc *find_reloc_by_dest(const s
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len);
 struct symbol *find_func_containing(struct section *sec, unsigned long offset);
-void insn_to_reloc_sym_addend(struct section *sec, unsigned long offset,
-			      struct reloc *reloc);
 
 #define for_each_sec(file, sec)						\
 	list_for_each_entry(sec, &file->elf->sections, list)
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -81,37 +81,20 @@ static int init_orc_entry(struct orc_ent
 }
 
 static int write_orc_entry(struct elf *elf, struct section *orc_sec,
-			   struct section *ip_rsec, unsigned int idx,
+			   struct section *ip_sec, unsigned int idx,
 			   struct section *insn_sec, unsigned long insn_off,
 			   struct orc_entry *o)
 {
 	struct orc_entry *orc;
-	struct reloc *reloc;
 
 	/* populate ORC data */
 	orc = (struct orc_entry *)orc_sec->data->d_buf + idx;
 	memcpy(orc, o, sizeof(*orc));
 
 	/* populate reloc for ip */
-	reloc = malloc(sizeof(*reloc));
-	if (!reloc) {
-		perror("malloc");
+	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_X86_64_PC32,
+				  insn_sec, insn_off))
 		return -1;
-	}
-	memset(reloc, 0, sizeof(*reloc));
-
-	insn_to_reloc_sym_addend(insn_sec, insn_off, reloc);
-	if (!reloc->sym) {
-		WARN("missing symbol for insn at offset 0x%lx",
-		     insn_off);
-		return -1;
-	}
-
-	reloc->type = R_X86_64_PC32;
-	reloc->offset = idx * sizeof(int);
-	reloc->sec = ip_rsec;
-
-	elf_add_reloc(elf, reloc);
 
 	return 0;
 }
@@ -150,7 +133,7 @@ static unsigned long alt_group_len(struc
 
 int orc_create(struct objtool_file *file)
 {
-	struct section *sec, *ip_rsec, *orc_sec;
+	struct section *sec, *orc_sec;
 	unsigned int nr = 0, idx = 0;
 	struct orc_list_entry *entry;
 	struct list_head orc_list;
@@ -239,13 +222,12 @@ int orc_create(struct objtool_file *file
 	sec = elf_create_section(file->elf, ".orc_unwind_ip", 0, sizeof(int), nr);
 	if (!sec)
 		return -1;
-	ip_rsec = elf_create_reloc_section(file->elf, sec, SHT_RELA);
-	if (!ip_rsec)
+	if (!elf_create_reloc_section(file->elf, sec, SHT_RELA))
 		return -1;
 
 	/* Write ORC entries to sections: */
 	list_for_each_entry(entry, &orc_list, list) {
-		if (write_orc_entry(file->elf, orc_sec, ip_rsec, idx++,
+		if (write_orc_entry(file->elf, orc_sec, sec, idx++,
 				    entry->insn_sec, entry->insn_off,
 				    &entry->orc))
 			return -1;


