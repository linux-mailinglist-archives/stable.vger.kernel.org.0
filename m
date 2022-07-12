Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA1857245A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiGLTAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiGLS7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:59:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05548F4223;
        Tue, 12 Jul 2022 11:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F17E3B81BAB;
        Tue, 12 Jul 2022 18:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D20C341C8;
        Tue, 12 Jul 2022 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651693;
        bh=QmO7M50m10bTkfgb27hLURl8adAuWwBCd3Rqa0fMExs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfYNreqQH9aJR9UqlSgPOgmMFFt3V735lU+WBOH0fzeLLqTgpc4LZt7NAy6Iat1nj
         awNC/rizLXYuoBOqWGZJOeOXP6+OwoyKURyjfj6HHGOhx1wd98JSkl9u5iH7US29tF
         RoUYRNDpmgt6LBGbRYVdnG5ay9xTc9QKqSNXzCXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 09/78] objtool: Introduce CFI hash
Date:   Tue, 12 Jul 2022 20:38:39 +0200
Message-Id: <20220712183239.227821072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 8b946cc38e063f0f7bb67789478c38f6d7d457c9 upstream.

Andi reported that objtool on vmlinux.o consumes more memory than his
system has, leading to horrific performance.

This is in part because we keep a struct instruction for every
instruction in the file in-memory. Shrink struct instruction by
removing the CFI state (which includes full register state) from it
and demand allocating it.

Given most instructions don't actually change CFI state, there's lots
of repetition there, so add a hash table to find previous CFI
instances.

Reduces memory consumption (and runtime) for processing an
x86_64-allyesconfig:

  pre:  4:40.84 real,   143.99 user,    44.18 sys,      30624988 mem
  post: 2:14.61 real,   108.58 user,    25.04 sys,      16396184 mem

Suggested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210624095147.756759107@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/x86/decode.c       |   20 +---
 tools/objtool/check.c                 |  154 ++++++++++++++++++++++++++++++----
 tools/objtool/include/objtool/arch.h  |    2 
 tools/objtool/include/objtool/cfi.h   |    2 
 tools/objtool/include/objtool/check.h |    2 
 tools/objtool/orc_gen.c               |   15 ++-
 6 files changed, 160 insertions(+), 35 deletions(-)

--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -684,34 +684,32 @@ const char *arch_ret_insn(int len)
 	return ret[len-1];
 }
 
-int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg)
+int arch_decode_hint_reg(u8 sp_reg, int *base)
 {
-	struct cfi_reg *cfa = &insn->cfi.cfa;
-
 	switch (sp_reg) {
 	case ORC_REG_UNDEFINED:
-		cfa->base = CFI_UNDEFINED;
+		*base = CFI_UNDEFINED;
 		break;
 	case ORC_REG_SP:
-		cfa->base = CFI_SP;
+		*base = CFI_SP;
 		break;
 	case ORC_REG_BP:
-		cfa->base = CFI_BP;
+		*base = CFI_BP;
 		break;
 	case ORC_REG_SP_INDIRECT:
-		cfa->base = CFI_SP_INDIRECT;
+		*base = CFI_SP_INDIRECT;
 		break;
 	case ORC_REG_R10:
-		cfa->base = CFI_R10;
+		*base = CFI_R10;
 		break;
 	case ORC_REG_R13:
-		cfa->base = CFI_R13;
+		*base = CFI_R13;
 		break;
 	case ORC_REG_DI:
-		cfa->base = CFI_DI;
+		*base = CFI_DI;
 		break;
 	case ORC_REG_DX:
-		cfa->base = CFI_DX;
+		*base = CFI_DX;
 		break;
 	default:
 		return -1;
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
+#include <sys/mman.h>
 
 #include <arch/elf.h>
 #include <objtool/builtin.h>
@@ -27,7 +28,11 @@ struct alternative {
 	bool skip_orig;
 };
 
-struct cfi_init_state initial_func_cfi;
+static unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
+
+static struct cfi_init_state initial_func_cfi;
+static struct cfi_state init_cfi;
+static struct cfi_state func_cfi;
 
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset)
@@ -267,6 +272,78 @@ static void init_insn_state(struct insn_
 		state->noinstr = sec->noinstr;
 }
 
+static struct cfi_state *cfi_alloc(void)
+{
+	struct cfi_state *cfi = calloc(sizeof(struct cfi_state), 1);
+	if (!cfi) {
+		WARN("calloc failed");
+		exit(1);
+	}
+	nr_cfi++;
+	return cfi;
+}
+
+static int cfi_bits;
+static struct hlist_head *cfi_hash;
+
+static inline bool cficmp(struct cfi_state *cfi1, struct cfi_state *cfi2)
+{
+	return memcmp((void *)cfi1 + sizeof(cfi1->hash),
+		      (void *)cfi2 + sizeof(cfi2->hash),
+		      sizeof(struct cfi_state) - sizeof(struct hlist_node));
+}
+
+static inline u32 cfi_key(struct cfi_state *cfi)
+{
+	return jhash((void *)cfi + sizeof(cfi->hash),
+		     sizeof(*cfi) - sizeof(cfi->hash), 0);
+}
+
+static struct cfi_state *cfi_hash_find_or_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+	struct cfi_state *obj;
+
+	hlist_for_each_entry(obj, head, hash) {
+		if (!cficmp(cfi, obj)) {
+			nr_cfi_cache++;
+			return obj;
+		}
+	}
+
+	obj = cfi_alloc();
+	*obj = *cfi;
+	hlist_add_head(&obj->hash, head);
+
+	return obj;
+}
+
+static void cfi_hash_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+
+	hlist_add_head(&cfi->hash, head);
+}
+
+static void *cfi_hash_alloc(unsigned long size)
+{
+	cfi_bits = max(10, ilog2(size));
+	cfi_hash = mmap(NULL, sizeof(struct hlist_head) << cfi_bits,
+			PROT_READ|PROT_WRITE,
+			MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (cfi_hash == (void *)-1L) {
+		WARN("mmap fail cfi_hash");
+		cfi_hash = NULL;
+	}  else if (stats) {
+		printf("cfi_bits: %d\n", cfi_bits);
+	}
+
+	return cfi_hash;
+}
+
+static unsigned long nr_insns;
+static unsigned long nr_insns_visited;
+
 /*
  * Call the arch-specific instruction decoder for all the instructions and add
  * them to the global instruction list.
@@ -277,7 +354,6 @@ static int decode_instructions(struct ob
 	struct symbol *func;
 	unsigned long offset;
 	struct instruction *insn;
-	unsigned long nr_insns = 0;
 	int ret;
 
 	for_each_sec(file, sec) {
@@ -303,7 +379,6 @@ static int decode_instructions(struct ob
 			memset(insn, 0, sizeof(*insn));
 			INIT_LIST_HEAD(&insn->alts);
 			INIT_LIST_HEAD(&insn->stack_ops);
-			init_cfi_state(&insn->cfi);
 
 			insn->sec = sec;
 			insn->offset = offset;
@@ -1239,7 +1314,6 @@ static int handle_group_alt(struct objto
 		memset(nop, 0, sizeof(*nop));
 		INIT_LIST_HEAD(&nop->alts);
 		INIT_LIST_HEAD(&nop->stack_ops);
-		init_cfi_state(&nop->cfi);
 
 		nop->sec = special_alt->new_sec;
 		nop->offset = special_alt->new_off + special_alt->new_len;
@@ -1648,10 +1722,11 @@ static void set_func_state(struct cfi_st
 
 static int read_unwind_hints(struct objtool_file *file)
 {
+	struct cfi_state cfi = init_cfi;
 	struct section *sec, *relocsec;
-	struct reloc *reloc;
 	struct unwind_hint *hint;
 	struct instruction *insn;
+	struct reloc *reloc;
 	int i;
 
 	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
@@ -1689,19 +1764,24 @@ static int read_unwind_hints(struct objt
 		insn->hint = true;
 
 		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
-			set_func_state(&insn->cfi);
+			insn->cfi = &func_cfi;
 			continue;
 		}
 
-		if (arch_decode_hint_reg(insn, hint->sp_reg)) {
+		if (insn->cfi)
+			cfi = *(insn->cfi);
+
+		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
 			WARN_FUNC("unsupported unwind_hint sp base reg %d",
 				  insn->sec, insn->offset, hint->sp_reg);
 			return -1;
 		}
 
-		insn->cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
-		insn->cfi.type = hint->type;
-		insn->cfi.end = hint->end;
+		cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
+		cfi.type = hint->type;
+		cfi.end = hint->end;
+
+		insn->cfi = cfi_hash_find_or_add(&cfi);
 	}
 
 	return 0;
@@ -2552,13 +2632,18 @@ static int propagate_alt_cfi(struct objt
 	if (!insn->alt_group)
 		return 0;
 
+	if (!insn->cfi) {
+		WARN("CFI missing");
+		return -1;
+	}
+
 	alt_cfi = insn->alt_group->cfi;
 	group_off = insn->offset - insn->alt_group->first_insn->offset;
 
 	if (!alt_cfi[group_off]) {
-		alt_cfi[group_off] = &insn->cfi;
+		alt_cfi[group_off] = insn->cfi;
 	} else {
-		if (memcmp(alt_cfi[group_off], &insn->cfi, sizeof(struct cfi_state))) {
+		if (cficmp(alt_cfi[group_off], insn->cfi)) {
 			WARN_FUNC("stack layout conflict in alternatives",
 				  insn->sec, insn->offset);
 			return -1;
@@ -2609,9 +2694,14 @@ static int handle_insn_ops(struct instru
 
 static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 {
-	struct cfi_state *cfi1 = &insn->cfi;
+	struct cfi_state *cfi1 = insn->cfi;
 	int i;
 
+	if (!cfi1) {
+		WARN("CFI missing");
+		return false;
+	}
+
 	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
 
 		WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
@@ -2796,7 +2886,7 @@ static int validate_branch(struct objtoo
 			   struct instruction *insn, struct insn_state state)
 {
 	struct alternative *alt;
-	struct instruction *next_insn;
+	struct instruction *next_insn, *prev_insn = NULL;
 	struct section *sec;
 	u8 visited;
 	int ret;
@@ -2825,15 +2915,25 @@ static int validate_branch(struct objtoo
 
 			if (insn->visited & visited)
 				return 0;
+		} else {
+			nr_insns_visited++;
 		}
 
 		if (state.noinstr)
 			state.instr += insn->instr;
 
-		if (insn->hint)
-			state.cfi = insn->cfi;
-		else
-			insn->cfi = state.cfi;
+		if (insn->hint) {
+			state.cfi = *insn->cfi;
+		} else {
+			/* XXX track if we actually changed state.cfi */
+
+			if (prev_insn && !cficmp(prev_insn->cfi, &state.cfi)) {
+				insn->cfi = prev_insn->cfi;
+				nr_cfi_reused++;
+			} else {
+				insn->cfi = cfi_hash_find_or_add(&state.cfi);
+			}
+		}
 
 		insn->visited |= visited;
 
@@ -2997,6 +3097,7 @@ static int validate_branch(struct objtoo
 			return 1;
 		}
 
+		prev_insn = insn;
 		insn = next_insn;
 	}
 
@@ -3252,10 +3353,20 @@ int check(struct objtool_file *file)
 	int ret, warnings = 0;
 
 	arch_initial_func_cfi_state(&initial_func_cfi);
+	init_cfi_state(&init_cfi);
+	init_cfi_state(&func_cfi);
+	set_func_state(&func_cfi);
+
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+		goto out;
+
+	cfi_hash_add(&init_cfi);
+	cfi_hash_add(&func_cfi);
 
 	ret = decode_sections(file);
 	if (ret < 0)
 		goto out;
+
 	warnings += ret;
 
 	if (list_empty(&file->insn_list))
@@ -3313,6 +3424,13 @@ int check(struct objtool_file *file)
 		warnings += ret;
 	}
 
+	if (stats) {
+		printf("nr_insns_visited: %ld\n", nr_insns_visited);
+		printf("nr_cfi: %ld\n", nr_cfi);
+		printf("nr_cfi_reused: %ld\n", nr_cfi_reused);
+		printf("nr_cfi_cache: %ld\n", nr_cfi_cache);
+	}
+
 out:
 	/*
 	 *  For now, don't fail the kernel build on fatal warnings.  These
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -85,7 +85,7 @@ unsigned long arch_dest_reloc_offset(int
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
 
-int arch_decode_hint_reg(struct instruction *insn, u8 sp_reg);
+int arch_decode_hint_reg(u8 sp_reg, int *base);
 
 bool arch_is_retpoline(struct symbol *sym);
 
--- a/tools/objtool/include/objtool/cfi.h
+++ b/tools/objtool/include/objtool/cfi.h
@@ -7,6 +7,7 @@
 #define _OBJTOOL_CFI_H
 
 #include <arch/cfi_regs.h>
+#include <linux/list.h>
 
 #define CFI_UNDEFINED		-1
 #define CFI_CFA			-2
@@ -24,6 +25,7 @@ struct cfi_init_state {
 };
 
 struct cfi_state {
+	struct hlist_node hash; /* must be first, cficmp() */
 	struct cfi_reg regs[CFI_NUM_REGS];
 	struct cfi_reg vals[CFI_NUM_REGS];
 	struct cfi_reg cfa;
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -59,7 +59,7 @@ struct instruction {
 	struct list_head alts;
 	struct symbol *func;
 	struct list_head stack_ops;
-	struct cfi_state cfi;
+	struct cfi_state *cfi;
 };
 
 static inline bool is_static_jump(struct instruction *insn)
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -13,13 +13,19 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi)
+static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+			  struct instruction *insn)
 {
-	struct instruction *insn = container_of(cfi, struct instruction, cfi);
 	struct cfi_reg *bp = &cfi->regs[CFI_BP];
 
 	memset(orc, 0, sizeof(*orc));
 
+	if (!cfi) {
+		orc->end = 0;
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
 	orc->end = cfi->end;
 
 	if (cfi->cfa.base == CFI_UNDEFINED) {
@@ -162,7 +168,7 @@ int orc_create(struct objtool_file *file
 			int i;
 
 			if (!alt_group) {
-				if (init_orc_entry(&orc, &insn->cfi))
+				if (init_orc_entry(&orc, insn->cfi, insn))
 					return -1;
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;
@@ -186,7 +192,8 @@ int orc_create(struct objtool_file *file
 				struct cfi_state *cfi = alt_group->cfi[i];
 				if (!cfi)
 					continue;
-				if (init_orc_entry(&orc, cfi))
+				/* errors are reported on the original insn */
+				if (init_orc_entry(&orc, cfi, insn))
 					return -1;
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;


