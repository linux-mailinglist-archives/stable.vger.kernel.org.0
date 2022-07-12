Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786A157246B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiGLS6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiGLS6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AC5DD236;
        Tue, 12 Jul 2022 11:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8756B81BAC;
        Tue, 12 Jul 2022 18:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FA3C3411C;
        Tue, 12 Jul 2022 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651654;
        bh=6/pAjNrYduXQcYk5rPNhzoaKv6P80lxhDM57Mcardm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPRVtdF80iwVzA6XC+oSKSS0HHjXDYNni0if3QLegYg6ZQPNNo6fyJ8u3pAZBrpf9
         jx61JbI5+Lti/yRXlR88i3dNdqzYoWcvtydGO/6CoEvURyHRqGA9KFiuW4zQm3yzyD
         QAOC9HrUWecknr/PcBPKjZ+OucOXfOnI/WZDnNgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 06/78] objtool: Explicitly avoid self modifying code in .altinstr_replacement
Date:   Tue, 12 Jul 2022 20:38:36 +0200
Message-Id: <20220712183239.097913627@linuxfoundation.org>
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

commit dd003edeffa3cb87bc9862582004f405d77d7670 upstream.

Assume ALTERNATIVE()s know what they're doing and do not change, or
cause to change, instructions in .altinstr_replacement sections.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120309.722511775@infradead.org
[cascardo: context adjustment]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -840,18 +840,27 @@ static void remove_insn_ops(struct instr
 	}
 }
 
-static void add_call_dest(struct objtool_file *file, struct instruction *insn,
-			  struct symbol *dest, bool sibling)
+static void annotate_call_site(struct objtool_file *file,
+			       struct instruction *insn, bool sibling)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
+	struct symbol *sym = insn->call_dest;
 
-	insn->call_dest = dest;
-	if (!dest)
+	if (!sym)
+		sym = reloc->sym;
+
+	/*
+	 * Alternative replacement code is just template code which is
+	 * sometimes copied to the original instruction. For now, don't
+	 * annotate it. (In the future we might consider annotating the
+	 * original instruction if/when it ever makes sense to do so.)
+	 */
+	if (!strcmp(insn->sec->name, ".altinstr_replacement"))
 		return;
 
-	if (insn->call_dest->static_call_tramp) {
-		list_add_tail(&insn->call_node,
-			      &file->static_call_list);
+	if (sym->static_call_tramp) {
+		list_add_tail(&insn->call_node, &file->static_call_list);
+		return;
 	}
 
 	/*
@@ -859,7 +868,7 @@ static void add_call_dest(struct objtool
 	 * so they need a little help, NOP out any KCOV calls from noinstr
 	 * text.
 	 */
-	if (insn->sec->noinstr && insn->call_dest->kcov) {
+	if (insn->sec->noinstr && sym->kcov) {
 		if (reloc) {
 			reloc->type = R_NONE;
 			elf_write_reloc(file->elf, reloc);
@@ -881,9 +890,11 @@ static void add_call_dest(struct objtool
 			 */
 			insn->retpoline_safe = true;
 		}
+
+		return;
 	}
 
-	if (mcount && insn->call_dest->fentry) {
+	if (mcount && sym->fentry) {
 		if (sibling)
 			WARN_FUNC("Tail call to __fentry__ !?!?", insn->sec, insn->offset);
 
@@ -898,9 +909,17 @@ static void add_call_dest(struct objtool
 
 		insn->type = INSN_NOP;
 
-		list_add_tail(&insn->mcount_loc_node,
-			      &file->mcount_loc_list);
+		list_add_tail(&insn->mcount_loc_node, &file->mcount_loc_list);
+		return;
 	}
+}
+
+static void add_call_dest(struct objtool_file *file, struct instruction *insn,
+			  struct symbol *dest, bool sibling)
+{
+	insn->call_dest = dest;
+	if (!dest)
+		return;
 
 	/*
 	 * Whatever stack impact regular CALLs have, should be undone
@@ -910,6 +929,8 @@ static void add_call_dest(struct objtool
 	 * are converted to JUMP, see read_intra_function_calls().
 	 */
 	remove_insn_ops(insn);
+
+	annotate_call_site(file, insn, sibling);
 }
 
 /*


