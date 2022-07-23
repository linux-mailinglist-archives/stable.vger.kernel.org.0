Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20357EDDF
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiGWKD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237984AbiGWKDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:03:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AD18AB09;
        Sat, 23 Jul 2022 02:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2959FCE0DBE;
        Sat, 23 Jul 2022 09:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F5AC341C0;
        Sat, 23 Jul 2022 09:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570355;
        bh=b4lPAu6TIYBuJvohHsBAYnRu4yFmScVttnEgCBbUYFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeEAPTGZAHiw/D/G50afSWGdRyQsAwDowupN8hjN4fNVsJNhYuJAnAHmAy3xRgx/I
         WgiRd5WwllDq12dTLoK7y5x5SzeSpZ+IV455YrqZ5dNVdYVBUb2A63f+WZG4MUGjv9
         uFDYj/9epltV5F//86tMeCqS9qwtLDSuMQii0uAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 048/148] objtool: Explicitly avoid self modifying code in .altinstr_replacement
Date:   Sat, 23 Jul 2022 11:54:20 +0200
Message-Id: <20220723095237.747602693@linuxfoundation.org>
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
[bwh: Backported to 5.10: objtool doesn't have any mcount handling]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -870,18 +870,27 @@ static void remove_insn_ops(struct instr
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
@@ -889,7 +898,7 @@ static void add_call_dest(struct objtool
 	 * so they need a little help, NOP out any KCOV calls from noinstr
 	 * text.
 	 */
-	if (insn->sec->noinstr && insn->call_dest->kcov) {
+	if (insn->sec->noinstr && sym->kcov) {
 		if (reloc) {
 			reloc->type = R_NONE;
 			elf_write_reloc(file->elf, reloc);
@@ -901,7 +910,16 @@ static void add_call_dest(struct objtool
 			               : arch_nop_insn(insn->len));
 
 		insn->type = sibling ? INSN_RETURN : INSN_NOP;
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
@@ -911,6 +929,8 @@ static void add_call_dest(struct objtool
 	 * are converted to JUMP, see read_intra_function_calls().
 	 */
 	remove_insn_ops(insn);
+
+	annotate_call_site(file, insn, sibling);
 }
 
 /*


