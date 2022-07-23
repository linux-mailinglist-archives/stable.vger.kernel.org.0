Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3830357EDA0
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiGWKAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiGWJ7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A20D46DBE;
        Sat, 23 Jul 2022 02:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBBE5611D2;
        Sat, 23 Jul 2022 09:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA70BC341C0;
        Sat, 23 Jul 2022 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570278;
        bh=e0PJ8wVXvSLi9INMnCS5SUkzghqk01lL5LYSFqqqh1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pgyvPmZ9fL62VolOlvfBStIPf1vCUnSFX6O2zNYuo8o0Q6Un8o36/IUBXhHyzsU1
         lA8rm3HP8pSyEJ2w8Y1tsYq3r03mp0q43Y7VvrZ3RJtUg3ULUbk8ekDFP1Et1kch7w
         GBsOhSiShmaATOgwjs5HZoZcb/fhH3x/A26iCLLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 031/148] objtool: Keep track of retpoline call sites
Date:   Sat, 23 Jul 2022 11:54:03 +0200
Message-Id: <20220723095233.088016764@linuxfoundation.org>
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

commit 43d5430ad74ef5156353af7aec352426ec7a8e57 upstream.

Provide infrastructure for architectures to rewrite/augment compiler
generated retpoline calls. Similar to what we do for static_call()s,
keep track of the instructions that are retpoline calls.

Use the same list_head, since a retpoline call cannot also be a
static_call.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.130805730@infradead.org
[bwh: Backported to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch.h    |    2 ++
 tools/objtool/check.c   |   34 +++++++++++++++++++++++++++++-----
 tools/objtool/check.h   |    2 +-
 tools/objtool/objtool.c |    1 +
 tools/objtool/objtool.h |    1 +
 5 files changed, 34 insertions(+), 6 deletions(-)

--- a/tools/objtool/arch.h
+++ b/tools/objtool/arch.h
@@ -88,4 +88,6 @@ int arch_decode_hint_reg(struct instruct
 
 bool arch_is_retpoline(struct symbol *sym);
 
+int arch_rewrite_retpolines(struct objtool_file *file);
+
 #endif /* _ARCH_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -451,7 +451,7 @@ static int create_static_call_sections(s
 		return 0;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->static_call_list, static_call_node)
+	list_for_each_entry(insn, &file->static_call_list, call_node)
 		idx++;
 
 	sec = elf_create_section(file->elf, ".static_call_sites", SHF_WRITE,
@@ -460,7 +460,7 @@ static int create_static_call_sections(s
 		return -1;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->static_call_list, static_call_node) {
+	list_for_each_entry(insn, &file->static_call_list, call_node) {
 
 		site = (struct static_call_site *)sec->data->d_buf + idx;
 		memset(site, 0, sizeof(struct static_call_site));
@@ -786,13 +786,16 @@ static int add_jump_destinations(struct
 			else
 				insn->type = INSN_JUMP_DYNAMIC_CONDITIONAL;
 
+			list_add_tail(&insn->call_node,
+				      &file->retpoline_call_list);
+
 			insn->retpoline_safe = true;
 			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
 			insn->call_dest = reloc->sym;
 			if (insn->call_dest->static_call_tramp) {
-				list_add_tail(&insn->static_call_node,
+				list_add_tail(&insn->call_node,
 					      &file->static_call_list);
 			}
 			continue;
@@ -854,7 +857,7 @@ static int add_jump_destinations(struct
 				/* internal sibling call (without reloc) */
 				insn->call_dest = insn->jump_dest->func;
 				if (insn->call_dest->static_call_tramp) {
-					list_add_tail(&insn->static_call_node,
+					list_add_tail(&insn->call_node,
 						      &file->static_call_list);
 				}
 			}
@@ -938,6 +941,9 @@ static int add_call_destinations(struct
 			insn->type = INSN_CALL_DYNAMIC;
 			insn->retpoline_safe = true;
 
+			list_add_tail(&insn->call_node,
+				      &file->retpoline_call_list);
+
 			remove_insn_ops(insn);
 			continue;
 
@@ -945,7 +951,7 @@ static int add_call_destinations(struct
 			insn->call_dest = reloc->sym;
 
 		if (insn->call_dest && insn->call_dest->static_call_tramp) {
-			list_add_tail(&insn->static_call_node,
+			list_add_tail(&insn->call_node,
 				      &file->static_call_list);
 		}
 
@@ -1655,6 +1661,11 @@ static void mark_rodata(struct objtool_f
 	file->rodata = found;
 }
 
+__weak int arch_rewrite_retpolines(struct objtool_file *file)
+{
+	return 0;
+}
+
 static int decode_sections(struct objtool_file *file)
 {
 	int ret;
@@ -1683,6 +1694,10 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
+	/*
+	 * Must be before add_special_section_alts() as that depends on
+	 * jump_dest being set.
+	 */
 	ret = add_jump_destinations(file);
 	if (ret)
 		return ret;
@@ -1719,6 +1734,15 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
+	/*
+	 * Must be after add_special_section_alts(), since this will emit
+	 * alternatives. Must be after add_{jump,call}_destination(), since
+	 * those create the call insn lists.
+	 */
+	ret = arch_rewrite_retpolines(file);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -39,7 +39,7 @@ struct alt_group {
 struct instruction {
 	struct list_head list;
 	struct hlist_node hash;
-	struct list_head static_call_node;
+	struct list_head call_node;
 	struct section *sec;
 	unsigned long offset;
 	unsigned int len;
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -61,6 +61,7 @@ struct objtool_file *objtool_open_read(c
 
 	INIT_LIST_HEAD(&file.insn_list);
 	hash_init(file.insn_hash);
+	INIT_LIST_HEAD(&file.retpoline_call_list);
 	INIT_LIST_HEAD(&file.static_call_list);
 	file.c_file = !vmlinux && find_section_by_name(file.elf, ".comment");
 	file.ignore_unreachables = no_unreachable;
--- a/tools/objtool/objtool.h
+++ b/tools/objtool/objtool.h
@@ -18,6 +18,7 @@ struct objtool_file {
 	struct elf *elf;
 	struct list_head insn_list;
 	DECLARE_HASHTABLE(insn_hash, 20);
+	struct list_head retpoline_call_list;
 	struct list_head static_call_list;
 	bool ignore_unreachables, c_file, hints, rodata;
 };


