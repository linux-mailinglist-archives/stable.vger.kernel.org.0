Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092FD50659
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 11:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfFXJ6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbfFXJ6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:14 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21953205ED;
        Mon, 24 Jun 2019 09:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370293;
        bh=Qjw6ANOVJSvaSzw8C/9y6XJbt021XiGCACwXsJArjPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2AAPRM7GI0wyNVYNFq86g3N7LfnsZBXW6yEMu1H2NiFtO3vCIkbmu7Drlw7dqA0F
         8zYUbIxXIDrAI5UX7pnYB0SAFKTk7B2CpRf7FCAuqp32oKpDJpURoCAWecEPwRqcaJ
         yXwFaSrfOR8hxMyshBiHDGzCVuoWZO2ODZjYcw5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allan Xavier <allan.x.xavier@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 02/51] objtool: Support per-function rodata sections
Date:   Mon, 24 Jun 2019 17:56:20 +0800
Message-Id: <20190624092306.165336854@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allan Xavier <allan.x.xavier@oracle.com>

commit 4a60aa05a0634241ce17f957bf9fb5ac1eed6576 upstream.

Add support for processing switch jump tables in objects with multiple
.rodata sections, such as those created by '-ffunction-sections' and
'-fdata-sections'.  Currently, objtool always looks in .rodata for jump
table information, which results in many "sibling call from callable
instruction with modified stack frame" warnings with objects compiled
using those flags.

The fix is comprised of three parts:

1. Flagging all .rodata sections when importing ELF information for
   easier checking later.

2. Keeping a reference to the section each relocation is from in order
   to get the list_head for the other relocations in that section.

3. Finding jump tables by following relocations to .rodata sections,
   rather than always referencing a single global .rodata section.

The patch has been tested without data sections enabled and no
differences in the resulting orc unwind information were seen.

Note that as objtool adds terminators to end of each .text section the
unwind information generated between a function+data sections build and
a normal build aren't directly comparable. Manual inspection suggests
that objtool is now generating the correct information, or at least
making more of an effort to do so than it did previously.

Signed-off-by: Allan Xavier <allan.x.xavier@oracle.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/099bdc375195c490dda04db777ee0b95d566ded1.1536325914.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/check.c |   38 ++++++++++++++++++++++++++++++++------
 tools/objtool/check.h |    4 ++--
 tools/objtool/elf.c   |    1 +
 tools/objtool/elf.h   |    3 ++-
 4 files changed, 37 insertions(+), 9 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -814,7 +814,7 @@ static int add_switch_table(struct objto
 	struct symbol *pfunc = insn->func->pfunc;
 	unsigned int prev_offset = 0;
 
-	list_for_each_entry_from(rela, &file->rodata->rela->rela_list, list) {
+	list_for_each_entry_from(rela, &table->rela_sec->rela_list, list) {
 		if (rela == next_table)
 			break;
 
@@ -904,6 +904,7 @@ static struct rela *find_switch_table(st
 {
 	struct rela *text_rela, *rodata_rela;
 	struct instruction *orig_insn = insn;
+	struct section *rodata_sec;
 	unsigned long table_offset;
 
 	/*
@@ -931,10 +932,13 @@ static struct rela *find_switch_table(st
 		/* look for a relocation which references .rodata */
 		text_rela = find_rela_by_dest_range(insn->sec, insn->offset,
 						    insn->len);
-		if (!text_rela || text_rela->sym != file->rodata->sym)
+		if (!text_rela || text_rela->sym->type != STT_SECTION ||
+		    !text_rela->sym->sec->rodata)
 			continue;
 
 		table_offset = text_rela->addend;
+		rodata_sec = text_rela->sym->sec;
+
 		if (text_rela->type == R_X86_64_PC32)
 			table_offset += 4;
 
@@ -942,10 +946,10 @@ static struct rela *find_switch_table(st
 		 * Make sure the .rodata address isn't associated with a
 		 * symbol.  gcc jump tables are anonymous data.
 		 */
-		if (find_symbol_containing(file->rodata, table_offset))
+		if (find_symbol_containing(rodata_sec, table_offset))
 			continue;
 
-		rodata_rela = find_rela_by_dest(file->rodata, table_offset);
+		rodata_rela = find_rela_by_dest(rodata_sec, table_offset);
 		if (rodata_rela) {
 			/*
 			 * Use of RIP-relative switch jumps is quite rare, and
@@ -1030,7 +1034,7 @@ static int add_switch_table_alts(struct
 	struct symbol *func;
 	int ret;
 
-	if (!file->rodata || !file->rodata->rela)
+	if (!file->rodata)
 		return 0;
 
 	for_each_sec(file, sec) {
@@ -1175,10 +1179,33 @@ static int read_retpoline_hints(struct o
 	return 0;
 }
 
+static void mark_rodata(struct objtool_file *file)
+{
+	struct section *sec;
+	bool found = false;
+
+	/*
+	 * This searches for the .rodata section or multiple .rodata.func_name
+	 * sections if -fdata-sections is being used. The .str.1.1 and .str.1.8
+	 * rodata sections are ignored as they don't contain jump tables.
+	 */
+	for_each_sec(file, sec) {
+		if (!strncmp(sec->name, ".rodata", 7) &&
+		    !strstr(sec->name, ".str1.")) {
+			sec->rodata = true;
+			found = true;
+		}
+	}
+
+	file->rodata = found;
+}
+
 static int decode_sections(struct objtool_file *file)
 {
 	int ret;
 
+	mark_rodata(file);
+
 	ret = decode_instructions(file);
 	if (ret)
 		return ret;
@@ -2150,7 +2177,6 @@ int check(const char *_objname, bool orc
 	INIT_LIST_HEAD(&file.insn_list);
 	hash_init(file.insn_hash);
 	file.whitelist = find_section_by_name(file.elf, ".discard.func_stack_frame_non_standard");
-	file.rodata = find_section_by_name(file.elf, ".rodata");
 	file.c_file = find_section_by_name(file.elf, ".comment");
 	file.ignore_unreachables = no_unreachable;
 	file.hints = false;
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -60,8 +60,8 @@ struct objtool_file {
 	struct elf *elf;
 	struct list_head insn_list;
 	DECLARE_HASHTABLE(insn_hash, 16);
-	struct section *rodata, *whitelist;
-	bool ignore_unreachables, c_file, hints;
+	struct section *whitelist;
+	bool ignore_unreachables, c_file, hints, rodata;
 };
 
 int check(const char *objname, bool orc);
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -390,6 +390,7 @@ static int read_relas(struct elf *elf)
 			rela->offset = rela->rela.r_offset;
 			symndx = GELF_R_SYM(rela->rela.r_info);
 			rela->sym = find_symbol_by_index(elf, symndx);
+			rela->rela_sec = sec;
 			if (!rela->sym) {
 				WARN("can't find rela entry symbol %d for %s",
 				     symndx, sec->name);
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -48,7 +48,7 @@ struct section {
 	char *name;
 	int idx;
 	unsigned int len;
-	bool changed, text;
+	bool changed, text, rodata;
 };
 
 struct symbol {
@@ -68,6 +68,7 @@ struct rela {
 	struct list_head list;
 	struct hlist_node hash;
 	GElf_Rela rela;
+	struct section *rela_sec;
 	struct symbol *sym;
 	unsigned int type;
 	unsigned long offset;


