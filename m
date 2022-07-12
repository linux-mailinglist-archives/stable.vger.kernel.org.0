Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E79957249F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiGLTFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiGLTEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E68F6817;
        Tue, 12 Jul 2022 11:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 763C16090C;
        Tue, 12 Jul 2022 18:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B6C3411C;
        Tue, 12 Jul 2022 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651808;
        bh=GmoR2mgymS7PNBJn8KE2yJSFe1yUZVFHMA3o6gXpjbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNM20K/r2jcY4WOJAOasrePhHLTNqKlTNrZiiKWoM4DPLVfLpLRUSuUOK8XVBQdfl
         9s09XTqxJ8dYIVV15+UMu7sH68fBJSS5ezh0Efgik9skj1qMcdflNtl+pugDNWNNnL
         TeH7XXVsmbLIRvcySj/iVpsqzYibQ5qxZY367M78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 64/78] objtool: Re-add UNWIND_HINT_{SAVE_RESTORE}
Date:   Tue, 12 Jul 2022 20:39:34 +0200
Message-Id: <20220712183241.470882743@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 8faea26e611189e933ea2281975ff4dc7c1106b6 upstream.

Commit

  c536ed2fffd5 ("objtool: Remove SAVE/RESTORE hints")

removed the save/restore unwind hints because they were no longer
needed. Now they're going to be needed again so re-add them.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/unwind_hints.h   |   12 ++++++++--
 include/linux/objtool.h               |    6 +++--
 tools/include/linux/objtool.h         |    6 +++--
 tools/objtool/check.c                 |   40 ++++++++++++++++++++++++++++++++++
 tools/objtool/include/objtool/check.h |    1 
 5 files changed, 59 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -8,11 +8,11 @@
 #ifdef __ASSEMBLY__
 
 .macro UNWIND_HINT_EMPTY
-	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
+	UNWIND_HINT type=UNWIND_HINT_TYPE_CALL end=1
 .endm
 
 .macro UNWIND_HINT_ENTRY
-	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_ENTRY end=1
+	UNWIND_HINT type=UNWIND_HINT_TYPE_ENTRY end=1
 .endm
 
 .macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0
@@ -56,6 +56,14 @@
 	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=8 type=UNWIND_HINT_TYPE_FUNC
 .endm
 
+.macro UNWIND_HINT_SAVE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_SAVE
+.endm
+
+.macro UNWIND_HINT_RESTORE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_RESTORE
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_UNWIND_HINTS_H */
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -40,6 +40,8 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
 #define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
 
 #ifdef CONFIG_STACK_VALIDATION
 
@@ -102,7 +104,7 @@ struct unwind_hint {
  * the debuginfo as necessary.  It will also warn if it sees any
  * inconsistencies.
  */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .Lunwind_hint_ip_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
@@ -132,7 +134,7 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD(func)
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -40,6 +40,8 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
 #define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
 
 #ifdef CONFIG_STACK_VALIDATION
 
@@ -102,7 +104,7 @@ struct unwind_hint {
  * the debuginfo as necessary.  It will also warn if it sees any
  * inconsistencies.
  */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .Lunwind_hint_ip_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
@@ -132,7 +134,7 @@ struct unwind_hint {
 #define STACK_FRAME_NON_STANDARD(func)
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 end=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1847,6 +1847,17 @@ static int read_unwind_hints(struct objt
 
 		insn->hint = true;
 
+		if (hint->type == UNWIND_HINT_TYPE_SAVE) {
+			insn->hint = false;
+			insn->save = true;
+			continue;
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_RESTORE) {
+			insn->restore = true;
+			continue;
+		}
+
 		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
@@ -3025,6 +3036,35 @@ static int validate_branch(struct objtoo
 			state.instr += insn->instr;
 
 		if (insn->hint) {
+			if (insn->restore) {
+				struct instruction *save_insn, *i;
+
+				i = insn;
+				save_insn = NULL;
+
+				sym_for_each_insn_continue_reverse(file, func, i) {
+					if (i->save) {
+						save_insn = i;
+						break;
+					}
+				}
+
+				if (!save_insn) {
+					WARN_FUNC("no corresponding CFI save for CFI restore",
+						  sec, insn->offset);
+					return 1;
+				}
+
+				if (!save_insn->visited) {
+					WARN_FUNC("objtool isn't smart enough to handle this CFI save/restore combo",
+						  sec, insn->offset);
+					return 1;
+				}
+
+				insn->cfi = save_insn->cfi;
+				nr_cfi_reused++;
+			}
+
 			state.cfi = *insn->cfi;
 		} else {
 			/* XXX track if we actually changed state.cfi */
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -47,6 +47,7 @@ struct instruction {
 	unsigned long immediate;
 	bool dead_end, ignore, ignore_alts;
 	bool hint;
+	bool save, restore;
 	bool retpoline_safe;
 	bool entry;
 	s8 instr;


