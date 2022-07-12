Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEEB5723B7
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiGLSue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiGLStv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:49:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B4BD9175;
        Tue, 12 Jul 2022 11:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BF8B81BBC;
        Tue, 12 Jul 2022 18:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1A9C3411C;
        Tue, 12 Jul 2022 18:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651440;
        bh=tKSV3e90dPUNedIPkdfEv0/qdUpBA/3raO94IT2xlr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxCxbUuI+WiY7Zzqy7Sh+MXlxHJ2m95hE3GHWxV7zIAD3ey37snlY4dZumjLEOK/9
         UydLj2jj0k7OgEuveKj67MURB0EA8p3TQLCt0x2SjvppSM8wycJ8qRsI2DtUw1nyIW
         zFGeFrjqy/055sxuHtPZzYedl8QVgeU7hnRPThjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 046/130] objtool: Handle __sanitize_cov*() tail calls
Date:   Tue, 12 Jul 2022 20:38:12 +0200
Message-Id: <20220712183248.538941958@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

commit f56dae88a81fded66adf2bea9922d1d98d1da14f upstream.

Turns out the compilers also generate tail calls to __sanitize_cov*(),
make sure to also patch those out in noinstr code.

Fixes: 0f1441b44e82 ("objtool: Fix noinstr vs KCOV")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20210624095147.818783799@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
[bwh: Backported to 5.10:
 - objtool doesn't have any mcount handling
 - Write the NOPs as hex literals since we can't use <asm/nops.h>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch.h            |    1 
 tools/objtool/arch/x86/decode.c |   20 ++++++
 tools/objtool/check.c           |  123 +++++++++++++++++++++-------------------
 3 files changed, 86 insertions(+), 58 deletions(-)

--- a/tools/objtool/arch.h
+++ b/tools/objtool/arch.h
@@ -83,6 +83,7 @@ unsigned long arch_jump_destination(stru
 unsigned long arch_dest_reloc_offset(int addend);
 
 const char *arch_nop_insn(int len);
+const char *arch_ret_insn(int len);
 
 int arch_decode_hint_reg(u8 sp_reg, int *base);
 
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -586,6 +586,26 @@ const char *arch_nop_insn(int len)
 	return nops[len-1];
 }
 
+#define BYTE_RET	0xC3
+
+const char *arch_ret_insn(int len)
+{
+	static const char ret[5][5] = {
+		{ BYTE_RET },
+		{ BYTE_RET, 0x90 },
+		{ BYTE_RET, 0x66, 0x90 },
+		{ BYTE_RET, 0x0f, 0x1f, 0x00 },
+		{ BYTE_RET, 0x0f, 0x1f, 0x40, 0x00 },
+	};
+
+	if (len < 1 || len > 5) {
+		WARN("invalid RET size: %d\n", len);
+		return NULL;
+	}
+
+	return ret[len-1];
+}
+
 /* asm/alternative.h ? */
 
 #define ALTINSTR_FLAG_INV	(1 << 15)
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -860,6 +860,60 @@ static struct reloc *insn_reloc(struct o
 	return insn->reloc;
 }
 
+static void remove_insn_ops(struct instruction *insn)
+{
+	struct stack_op *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, &insn->stack_ops, list) {
+		list_del(&op->list);
+		free(op);
+	}
+}
+
+static void add_call_dest(struct objtool_file *file, struct instruction *insn,
+			  struct symbol *dest, bool sibling)
+{
+	struct reloc *reloc = insn_reloc(file, insn);
+
+	insn->call_dest = dest;
+	if (!dest)
+		return;
+
+	if (insn->call_dest->static_call_tramp) {
+		list_add_tail(&insn->call_node,
+			      &file->static_call_list);
+	}
+
+	/*
+	 * Many compilers cannot disable KCOV with a function attribute
+	 * so they need a little help, NOP out any KCOV calls from noinstr
+	 * text.
+	 */
+	if (insn->sec->noinstr &&
+	    !strncmp(insn->call_dest->name, "__sanitizer_cov_", 16)) {
+		if (reloc) {
+			reloc->type = R_NONE;
+			elf_write_reloc(file->elf, reloc);
+		}
+
+		elf_write_insn(file->elf, insn->sec,
+			       insn->offset, insn->len,
+			       sibling ? arch_ret_insn(insn->len)
+			               : arch_nop_insn(insn->len));
+
+		insn->type = sibling ? INSN_RETURN : INSN_NOP;
+	}
+
+	/*
+	 * Whatever stack impact regular CALLs have, should be undone
+	 * by the RETURN of the called function.
+	 *
+	 * Annotated intra-function calls retain the stack_ops but
+	 * are converted to JUMP, see read_intra_function_calls().
+	 */
+	remove_insn_ops(insn);
+}
+
 /*
  * Find the destination instructions for all jumps.
  */
@@ -898,11 +952,7 @@ static int add_jump_destinations(struct
 			continue;
 		} else if (insn->func) {
 			/* internal or external sibling call (with reloc) */
-			insn->call_dest = reloc->sym;
-			if (insn->call_dest->static_call_tramp) {
-				list_add_tail(&insn->call_node,
-					      &file->static_call_list);
-			}
+			add_call_dest(file, insn, reloc->sym, true);
 			continue;
 		} else if (reloc->sym->sec->idx) {
 			dest_sec = reloc->sym->sec;
@@ -958,13 +1008,8 @@ static int add_jump_destinations(struct
 
 			} else if (insn->jump_dest->func->pfunc != insn->func->pfunc &&
 				   insn->jump_dest->offset == insn->jump_dest->func->offset) {
-
 				/* internal sibling call (without reloc) */
-				insn->call_dest = insn->jump_dest->func;
-				if (insn->call_dest->static_call_tramp) {
-					list_add_tail(&insn->call_node,
-						      &file->static_call_list);
-				}
+				add_call_dest(file, insn, insn->jump_dest->func, true);
 			}
 		}
 	}
@@ -972,16 +1017,6 @@ static int add_jump_destinations(struct
 	return 0;
 }
 
-static void remove_insn_ops(struct instruction *insn)
-{
-	struct stack_op *op, *tmp;
-
-	list_for_each_entry_safe(op, tmp, &insn->stack_ops, list) {
-		list_del(&op->list);
-		free(op);
-	}
-}
-
 static struct symbol *find_call_destination(struct section *sec, unsigned long offset)
 {
 	struct symbol *call_dest;
@@ -1000,6 +1035,7 @@ static int add_call_destinations(struct
 {
 	struct instruction *insn;
 	unsigned long dest_off;
+	struct symbol *dest;
 	struct reloc *reloc;
 
 	for_each_insn(file, insn) {
@@ -1009,7 +1045,9 @@ static int add_call_destinations(struct
 		reloc = insn_reloc(file, insn);
 		if (!reloc) {
 			dest_off = arch_jump_destination(insn);
-			insn->call_dest = find_call_destination(insn->sec, dest_off);
+			dest = find_call_destination(insn->sec, dest_off);
+
+			add_call_dest(file, insn, dest, false);
 
 			if (insn->ignore)
 				continue;
@@ -1027,9 +1065,8 @@ static int add_call_destinations(struct
 
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-			insn->call_dest = find_call_destination(reloc->sym->sec,
-								dest_off);
-			if (!insn->call_dest) {
+			dest = find_call_destination(reloc->sym->sec, dest_off);
+			if (!dest) {
 				WARN_FUNC("can't find call dest symbol at %s+0x%lx",
 					  insn->sec, insn->offset,
 					  reloc->sym->sec->name,
@@ -1037,6 +1074,8 @@ static int add_call_destinations(struct
 				return -1;
 			}
 
+			add_call_dest(file, insn, dest, false);
+
 		} else if (arch_is_retpoline(reloc->sym)) {
 			/*
 			 * Retpoline calls are really dynamic calls in
@@ -1052,39 +1091,7 @@ static int add_call_destinations(struct
 			continue;
 
 		} else
-			insn->call_dest = reloc->sym;
-
-		if (insn->call_dest && insn->call_dest->static_call_tramp) {
-			list_add_tail(&insn->call_node,
-				      &file->static_call_list);
-		}
-
-		/*
-		 * Many compilers cannot disable KCOV with a function attribute
-		 * so they need a little help, NOP out any KCOV calls from noinstr
-		 * text.
-		 */
-		if (insn->sec->noinstr &&
-		    !strncmp(insn->call_dest->name, "__sanitizer_cov_", 16)) {
-			if (reloc) {
-				reloc->type = R_NONE;
-				elf_write_reloc(file->elf, reloc);
-			}
-
-			elf_write_insn(file->elf, insn->sec,
-				       insn->offset, insn->len,
-				       arch_nop_insn(insn->len));
-			insn->type = INSN_NOP;
-		}
-
-		/*
-		 * Whatever stack impact regular CALLs have, should be undone
-		 * by the RETURN of the called function.
-		 *
-		 * Annotated intra-function calls retain the stack_ops but
-		 * are converted to JUMP, see read_intra_function_calls().
-		 */
-		remove_insn_ops(insn);
+			add_call_dest(file, insn, reloc->sym, false);
 	}
 
 	return 0;


