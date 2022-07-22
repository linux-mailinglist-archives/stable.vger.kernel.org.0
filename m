Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62457DDA5
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiGVJTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiGVJTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:19:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E11129C96;
        Fri, 22 Jul 2022 02:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC410B827B7;
        Fri, 22 Jul 2022 09:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EE8C341C6;
        Fri, 22 Jul 2022 09:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481202;
        bh=v7l30+D0LWtvMBq1kanEuucWSQ3qhjI9Upn4PCw1Ods=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I21ELuKxna/ggohh7lSCtC6OXkzVdA6NNKvEwsHB4jobis45TZMK6Jg9/su/vhA/C
         Qc3SKyNKGAe3bFETDnXon1Y6h6HBTM8BjMThdS1vDU838GfW7fT0CF7Q0xBtlNoqzI
         H/vzF9v83djU0qAfJKzSBFjDXgvu+MNnC9Km07AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 30/89] x86,objtool: Create .return_sites
Date:   Fri, 22 Jul 2022 11:11:04 +0200
Message-Id: <20220722091135.052490711@linuxfoundation.org>
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

commit d9e9d2300681d68a775c28de6aa6e5290ae17796 upstream.

Find all the return-thunk sites and record them in a .return_sites
section such that the kernel can undo this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: conflict fixup because of functions added to support IBT]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/x86/decode.c         |    5 ++
 tools/objtool/check.c                   |   75 ++++++++++++++++++++++++++++++++
 tools/objtool/include/objtool/arch.h    |    1 
 tools/objtool/include/objtool/elf.h     |    1 
 tools/objtool/include/objtool/objtool.h |    1 
 tools/objtool/objtool.c                 |    1 
 6 files changed, 84 insertions(+)

--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -722,3 +722,8 @@ bool arch_is_retpoline(struct symbol *sy
 {
 	return !strncmp(sym->name, "__x86_indirect_", 15);
 }
+
+bool arch_is_rethunk(struct symbol *sym)
+{
+	return !strcmp(sym->name, "__x86_return_thunk");
+}
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -654,6 +654,52 @@ static int create_retpoline_sites_sectio
 	return 0;
 }
 
+static int create_return_sites_sections(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct section *sec;
+	int idx;
+
+	sec = find_section_by_name(file->elf, ".return_sites");
+	if (sec) {
+		WARN("file already has .return_sites, skipping");
+		return 0;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->return_thunk_list, call_node)
+		idx++;
+
+	if (!idx)
+		return 0;
+
+	sec = elf_create_section(file->elf, ".return_sites", 0,
+				 sizeof(int), idx);
+	if (!sec) {
+		WARN("elf_create_section: .return_sites");
+		return -1;
+	}
+
+	idx = 0;
+	list_for_each_entry(insn, &file->return_thunk_list, call_node) {
+
+		int *site = (int *)sec->data->d_buf + idx;
+		*site = 0;
+
+		if (elf_add_reloc_to_insn(file->elf, sec,
+					  idx * sizeof(int),
+					  R_X86_64_PC32,
+					  insn->sec, insn->offset)) {
+			WARN("elf_add_reloc_to_insn: .return_sites");
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
@@ -932,6 +978,11 @@ __weak bool arch_is_retpoline(struct sym
 	return false;
 }
 
+__weak bool arch_is_rethunk(struct symbol *sym)
+{
+	return false;
+}
+
 #define NEGATIVE_RELOC	((void *)-1L)
 
 static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
@@ -1092,6 +1143,19 @@ static void add_retpoline_call(struct ob
 
 	annotate_call_site(file, insn, false);
 }
+
+static void add_return_call(struct objtool_file *file, struct instruction *insn)
+{
+	/*
+	 * Return thunk tail calls are really just returns in disguise,
+	 * so convert them accordingly.
+	 */
+	insn->type = INSN_RETURN;
+	insn->retpoline_safe = true;
+
+	list_add_tail(&insn->call_node, &file->return_thunk_list);
+}
+
 /*
  * Find the destination instructions for all jumps.
  */
@@ -1116,6 +1180,9 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->retpoline_thunk) {
 			add_retpoline_call(file, insn);
 			continue;
+		} else if (reloc->sym->return_thunk) {
+			add_return_call(file, insn);
+			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
 			add_call_dest(file, insn, reloc->sym, true);
@@ -1937,6 +2004,9 @@ static int classify_symbols(struct objto
 			if (arch_is_retpoline(func))
 				func->retpoline_thunk = true;
 
+			if (arch_is_rethunk(func))
+				func->return_thunk = true;
+
 			if (!strcmp(func->name, "__fentry__"))
 				func->fentry = true;
 
@@ -3413,6 +3483,11 @@ int check(struct objtool_file *file)
 		if (ret < 0)
 			goto out;
 		warnings += ret;
+
+		ret = create_return_sites_sections(file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
 	}
 
 	if (mcount) {
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -88,6 +88,7 @@ const char *arch_ret_insn(int len);
 int arch_decode_hint_reg(u8 sp_reg, int *base);
 
 bool arch_is_retpoline(struct symbol *sym);
+bool arch_is_rethunk(struct symbol *sym);
 
 int arch_rewrite_retpolines(struct objtool_file *file);
 
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -57,6 +57,7 @@ struct symbol {
 	u8 uaccess_safe      : 1;
 	u8 static_call_tramp : 1;
 	u8 retpoline_thunk   : 1;
+	u8 return_thunk      : 1;
 	u8 fentry            : 1;
 	u8 kcov              : 1;
 };
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -19,6 +19,7 @@ struct objtool_file {
 	struct list_head insn_list;
 	DECLARE_HASHTABLE(insn_hash, 20);
 	struct list_head retpoline_call_list;
+	struct list_head return_thunk_list;
 	struct list_head static_call_list;
 	struct list_head mcount_loc_list;
 	bool ignore_unreachables, c_file, hints, rodata;
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -126,6 +126,7 @@ struct objtool_file *objtool_open_read(c
 	INIT_LIST_HEAD(&file.insn_list);
 	hash_init(file.insn_hash);
 	INIT_LIST_HEAD(&file.retpoline_call_list);
+	INIT_LIST_HEAD(&file.return_thunk_list);
 	INIT_LIST_HEAD(&file.static_call_list);
 	INIT_LIST_HEAD(&file.mcount_loc_list);
 	file.c_file = !vmlinux && find_section_by_name(file.elf, ".comment");


