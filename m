Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3A857EDA2
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiGWKAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbiGWJ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4586459AF;
        Sat, 23 Jul 2022 02:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86F4BB82C1B;
        Sat, 23 Jul 2022 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82CFC341C0;
        Sat, 23 Jul 2022 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570281;
        bh=6lA7kujKxFk6fxYJsW1W21z8ns4CSf2ZVJFi6YxNeus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSIhR5XnlzNgZue0Qg0haEPBvBCZEfS+R6ciY6HUGLaglm7iRYYVXj4sbSlklkSp2
         hUZWGcWgD+qs0wzxVOzkxLUiEATqQrmQ5a5p9wPoYuwFyf6+Z3oYGkOtVsq99ZlG6E
         /xVMx7vfWn+YB8q+BEbco4WnCTZ8qhUGXbK7FgCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 032/148] objtool: Cache instruction relocs
Date:   Sat, 23 Jul 2022 11:54:04 +0200
Message-Id: <20220723095233.354758252@linuxfoundation.org>
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

commit 7bd2a600f3e9d27286bbf23c83d599e9cc7cf245 upstream.

Track the reloc of instructions in the new instruction->reloc field
to avoid having to look them up again later.

( Technically x86 instructions can have two relocations, but not jumps
  and calls, for which we're using this. )

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.195441549@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   28 ++++++++++++++++++++++------
 tools/objtool/check.h |    1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -754,6 +754,25 @@ __weak bool arch_is_retpoline(struct sym
 	return false;
 }
 
+#define NEGATIVE_RELOC	((void *)-1L)
+
+static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
+{
+	if (insn->reloc == NEGATIVE_RELOC)
+		return NULL;
+
+	if (!insn->reloc) {
+		insn->reloc = find_reloc_by_dest_range(file->elf, insn->sec,
+						       insn->offset, insn->len);
+		if (!insn->reloc) {
+			insn->reloc = NEGATIVE_RELOC;
+			return NULL;
+		}
+	}
+
+	return insn->reloc;
+}
+
 /*
  * Find the destination instructions for all jumps.
  */
@@ -768,8 +787,7 @@ static int add_jump_destinations(struct
 		if (!is_static_jump(insn))
 			continue;
 
-		reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-						 insn->offset, insn->len);
+		reloc = insn_reloc(file, insn);
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
@@ -901,8 +919,7 @@ static int add_call_destinations(struct
 		if (insn->type != INSN_CALL)
 			continue;
 
-		reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-					       insn->offset, insn->len);
+		reloc = insn_reloc(file, insn);
 		if (!reloc) {
 			dest_off = arch_jump_destination(insn);
 			insn->call_dest = find_call_destination(insn->sec, dest_off);
@@ -1085,8 +1102,7 @@ static int handle_group_alt(struct objto
 		 * alternatives code can adjust the relative offsets
 		 * accordingly.
 		 */
-		alt_reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-						   insn->offset, insn->len);
+		alt_reloc = insn_reloc(file, insn);
 		if (alt_reloc &&
 		    !arch_support_alt_relocation(special_alt, insn, alt_reloc)) {
 
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -55,6 +55,7 @@ struct instruction {
 	struct instruction *jump_dest;
 	struct instruction *first_jump_src;
 	struct reloc *jump_table;
+	struct reloc *reloc;
 	struct list_head alts;
 	struct symbol *func;
 	struct list_head stack_ops;


