Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41E257ED66
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiGWJ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiGWJ4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D10D3207C;
        Sat, 23 Jul 2022 02:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD73B82C1B;
        Sat, 23 Jul 2022 09:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5EFC341C0;
        Sat, 23 Jul 2022 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570194;
        bh=tB83HSTYttxr8QeYTHDKAIaxQNlUjPWiBjASejzuzWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhCz+2yS29EZ1nuIXGkT0BT4nPr1dHz5IMyPDnzT6f5WZaywXL6o1bswKVa56/a5J
         PMcdysnJ5z9zQJ+ikEocEbHW5CJcqKm0Fc3bKlpdfN0i5gZVPvPWzZjOZXUv1P7kxt
         YgSO1WT/GPtwoZoQj3s6DV0P06LQ7fsQJYUIs0zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 004/148] objtool: Add alt_group struct
Date:   Sat, 23 Jul 2022 11:53:36 +0200
Message-Id: <20220723095225.568104100@linuxfoundation.org>
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


