Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1DD5722D2
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiGLSkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiGLSka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F71EC08E9;
        Tue, 12 Jul 2022 11:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9B061AC9;
        Tue, 12 Jul 2022 18:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2D1C3411C;
        Tue, 12 Jul 2022 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651225;
        bh=tB83HSTYttxr8QeYTHDKAIaxQNlUjPWiBjASejzuzWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKqJQHGlQua2SW7zr42G595XELoWjF2C2LblBRkDnQvqPZo1v2UhTl8CuFs3CoJYn
         qtA+wdRrhksUxCdC595+BCOUndsJ+lnKFg7sibu2FQ0/hV5T4hriJCph9TrLeIgpFI
         XHpxfqYihJi+qz51AO1I+RxCqU8uFQzRfvstR0zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 004/130] objtool: Add alt_group struct
Date:   Tue, 12 Jul 2022 20:37:30 +0200
Message-Id: <20220712183246.587871640@linuxfoundation.org>
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

commit b23cc71c62747f2e4c3e56138872cf47e1294f8a upstream.

Create a new struct associated with each group of alternatives
instructions.  This will help with the removal of fake jumps, and more
importantly with adding support for stack layout changes in
alternatives.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   29 +++++++++++++++++++++++------
 tools/objtool/check.h |   13 ++++++++++++-
 2 files changed, 35 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1012,20 +1012,28 @@ static int handle_group_alt(struct objto
 			    struct instruction *orig_insn,
 			    struct instruction **new_insn)
 {
-	static unsigned int alt_group_next_index = 1;
 	struct instruction *last_orig_insn, *last_new_insn, *insn, *fake_jump = NULL;
-	unsigned int alt_group = alt_group_next_index++;
+	struct alt_group *orig_alt_group, *new_alt_group;
 	unsigned long dest_off;
 
+
+	orig_alt_group = malloc(sizeof(*orig_alt_group));
+	if (!orig_alt_group) {
+		WARN("malloc failed");
+		return -1;
+	}
 	last_orig_insn = NULL;
 	insn = orig_insn;
 	sec_for_each_insn_from(file, insn) {
 		if (insn->offset >= special_alt->orig_off + special_alt->orig_len)
 			break;
 
-		insn->alt_group = alt_group;
+		insn->alt_group = orig_alt_group;
 		last_orig_insn = insn;
 	}
+	orig_alt_group->orig_group = NULL;
+	orig_alt_group->first_insn = orig_insn;
+	orig_alt_group->last_insn = last_orig_insn;
 
 	if (next_insn_same_sec(file, last_orig_insn)) {
 		fake_jump = malloc(sizeof(*fake_jump));
@@ -1056,8 +1064,13 @@ static int handle_group_alt(struct objto
 		return 0;
 	}
 
+	new_alt_group = malloc(sizeof(*new_alt_group));
+	if (!new_alt_group) {
+		WARN("malloc failed");
+		return -1;
+	}
+
 	last_new_insn = NULL;
-	alt_group = alt_group_next_index++;
 	insn = *new_insn;
 	sec_for_each_insn_from(file, insn) {
 		struct reloc *alt_reloc;
@@ -1069,7 +1082,7 @@ static int handle_group_alt(struct objto
 
 		insn->ignore = orig_insn->ignore_alts;
 		insn->func = orig_insn->func;
-		insn->alt_group = alt_group;
+		insn->alt_group = new_alt_group;
 
 		/*
 		 * Since alternative replacement code is copy/pasted by the
@@ -1118,6 +1131,10 @@ static int handle_group_alt(struct objto
 		return -1;
 	}
 
+	new_alt_group->orig_group = orig_alt_group;
+	new_alt_group->first_insn = *new_insn;
+	new_alt_group->last_insn = last_new_insn;
+
 	if (fake_jump)
 		list_add(&fake_jump->list, &last_new_insn->list);
 
@@ -2440,7 +2457,7 @@ static int validate_return(struct symbol
 static void fill_alternative_cfi(struct objtool_file *file, struct instruction *insn)
 {
 	struct instruction *first_insn = insn;
-	int alt_group = insn->alt_group;
+	struct alt_group *alt_group = insn->alt_group;
 
 	sec_for_each_insn_continue(file, insn) {
 		if (insn->alt_group != alt_group)
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -19,6 +19,17 @@ struct insn_state {
 	s8 instr;
 };
 
+struct alt_group {
+	/*
+	 * Pointer from a replacement group to the original group.  NULL if it
+	 * *is* the original group.
+	 */
+	struct alt_group *orig_group;
+
+	/* First and last instructions in the group */
+	struct instruction *first_insn, *last_insn;
+};
+
 struct instruction {
 	struct list_head list;
 	struct hlist_node hash;
@@ -34,7 +45,7 @@ struct instruction {
 	s8 instr;
 	u8 visited;
 	u8 ret_offset;
-	int alt_group;
+	struct alt_group *alt_group;
 	struct symbol *call_dest;
 	struct instruction *jump_dest;
 	struct instruction *first_jump_src;


