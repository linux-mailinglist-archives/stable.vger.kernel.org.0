Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93417572348
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiGLSpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiGLSo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5985CDABAB;
        Tue, 12 Jul 2022 11:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA2DF61AD2;
        Tue, 12 Jul 2022 18:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBEBC341D0;
        Tue, 12 Jul 2022 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651343;
        bh=KOPBfmIxu9SkTNKcXX0nwvznMmnj5WtPQ0BxdN1yLmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PptCVk9+l2dstg2j5TXkXLJNJdDCEmTnQgKZNG20h0EivWtcoCNw9sOmiJhLihfUr
         4gAiB4RDsMflkkRDKoAm+V7tOgIs/k2QJ5qSWKXa5ERAkhokdUTi7SFMezsP2vencn
         ZmsDpeg9OzSNKkRspCO8/gUqK9KnT0tY3m9K3wug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 007/130] objtool: Assume only ELF functions do sibling calls
Date:   Tue, 12 Jul 2022 20:37:33 +0200
Message-Id: <20220712183246.727242541@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit ecf11ba4d066fe527586c6edd6ca68457ca55cf4 upstream.

There's an inconsistency in how sibling calls are detected in
non-function asm code, depending on the scope of the object.  If the
target code is external to the object, objtool considers it a sibling
call.  If the target code is internal but not a function, objtool
*doesn't* consider it a sibling call.

This can cause some inconsistencies between per-object and vmlinux.o
validation.

Instead, assume only ELF functions can do sibling calls.  This generally
matches existing reality, and makes sibling call validation consistent
between vmlinux.o and per-object.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/0e9ab6f3628cc7bf3bde7aa6762d54d7df19ad78.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -109,15 +109,20 @@ static struct instruction *prev_insn_sam
 
 static bool is_sibling_call(struct instruction *insn)
 {
+	/*
+	 * Assume only ELF functions can make sibling calls.  This ensures
+	 * sibling call detection consistency between vmlinux.o and individual
+	 * objects.
+	 */
+	if (!insn->func)
+		return false;
+
 	/* An indirect jump is either a sibling call or a jump to a table. */
 	if (insn->type == INSN_JUMP_DYNAMIC)
 		return list_empty(&insn->alts);
 
-	if (!is_static_jump(insn))
-		return false;
-
 	/* add_jump_destinations() sets insn->call_dest for sibling calls. */
-	return !!insn->call_dest;
+	return (is_static_jump(insn) && insn->call_dest);
 }
 
 /*
@@ -788,7 +793,7 @@ static int add_jump_destinations(struct
 			continue;
 
 		reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-					       insn->offset, insn->len);
+						 insn->offset, insn->len);
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
@@ -808,18 +813,21 @@ static int add_jump_destinations(struct
 
 			insn->retpoline_safe = true;
 			continue;
-		} else if (reloc->sym->sec->idx) {
-			dest_sec = reloc->sym->sec;
-			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc->addend);
-		} else {
-			/* external sibling call */
+		} else if (insn->func) {
+			/* internal or external sibling call (with reloc) */
 			insn->call_dest = reloc->sym;
 			if (insn->call_dest->static_call_tramp) {
 				list_add_tail(&insn->static_call_node,
 					      &file->static_call_list);
 			}
 			continue;
+		} else if (reloc->sym->sec->idx) {
+			dest_sec = reloc->sym->sec;
+			dest_off = reloc->sym->sym.st_value +
+				   arch_dest_reloc_offset(reloc->addend);
+		} else {
+			/* non-func asm code jumping to another file */
+			continue;
 		}
 
 		insn->jump_dest = find_insn(file, dest_sec, dest_off);
@@ -868,7 +876,7 @@ static int add_jump_destinations(struct
 			} else if (insn->jump_dest->func->pfunc != insn->func->pfunc &&
 				   insn->jump_dest->offset == insn->jump_dest->func->offset) {
 
-				/* internal sibling call */
+				/* internal sibling call (without reloc) */
 				insn->call_dest = insn->jump_dest->func;
 				if (insn->call_dest->static_call_tramp) {
 					list_add_tail(&insn->static_call_node,
@@ -2570,7 +2578,7 @@ static int validate_branch(struct objtoo
 
 		case INSN_JUMP_CONDITIONAL:
 		case INSN_JUMP_UNCONDITIONAL:
-			if (func && is_sibling_call(insn)) {
+			if (is_sibling_call(insn)) {
 				ret = validate_sibling_call(insn, &state);
 				if (ret)
 					return ret;
@@ -2592,7 +2600,7 @@ static int validate_branch(struct objtoo
 
 		case INSN_JUMP_DYNAMIC:
 		case INSN_JUMP_DYNAMIC_CONDITIONAL:
-			if (func && is_sibling_call(insn)) {
+			if (is_sibling_call(insn)) {
 				ret = validate_sibling_call(insn, &state);
 				if (ret)
 					return ret;


