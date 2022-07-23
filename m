Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283BE57EDB1
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbiGWKBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiGWKAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:00:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F7C774B7;
        Sat, 23 Jul 2022 02:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B64BCE0DBE;
        Sat, 23 Jul 2022 09:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D53C341C0;
        Sat, 23 Jul 2022 09:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570295;
        bh=P8df0VZgaba5kE5vIVSyLhZJRZN76d9+sQs8YKCUaeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u98AwpspS2bGKTe9C7RbO1xLFhLhj01cIFU39h8GXZuZWuFNJ3LbOcflnEEstTyy2
         7+yss9dv/3FWHTwr2DYKA+Vm4ScZqrawY2iiFf0hx1cWFMrESYegAmQwQ5Rc2jqYhe
         5Z3WmYn603EpLlyXsEtJSnpQoZ/eJdyigEK7ThAU=
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
Subject: [PATCH 5.10 047/148] objtool: Classify symbols
Date:   Sat, 23 Jul 2022 11:54:19 +0200
Message-Id: <20220723095237.497630005@linuxfoundation.org>
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

commit 1739c66eb7bd5f27f1b69a5a26e10e8327d1e136 upstream.

In order to avoid calling str*cmp() on symbol names, over and over, do
them all once upfront and store the result.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120309.658539311@infradead.org
[cascardo: no pv_target on struct symbol, because of missing
 db2b0c5d7b6f19b3c2cab08c531b65342eb5252b]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10: objtool doesn't have any mcount handling]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   32 +++++++++++++++++++++-----------
 tools/objtool/elf.h   |    7 +++++--
 2 files changed, 26 insertions(+), 13 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -889,8 +889,7 @@ static void add_call_dest(struct objtool
 	 * so they need a little help, NOP out any KCOV calls from noinstr
 	 * text.
 	 */
-	if (insn->sec->noinstr &&
-	    !strncmp(insn->call_dest->name, "__sanitizer_cov_", 16)) {
+	if (insn->sec->noinstr && insn->call_dest->kcov) {
 		if (reloc) {
 			reloc->type = R_NONE;
 			elf_write_reloc(file->elf, reloc);
@@ -935,7 +934,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (arch_is_retpoline(reloc->sym)) {
+		} else if (reloc->sym->retpoline_thunk) {
 			/*
 			 * Retpoline jumps are really dynamic jumps in
 			 * disguise, so convert them accordingly.
@@ -1076,7 +1075,7 @@ static int add_call_destinations(struct
 
 			add_call_dest(file, insn, dest, false);
 
-		} else if (arch_is_retpoline(reloc->sym)) {
+		} else if (reloc->sym->retpoline_thunk) {
 			/*
 			 * Retpoline calls are really dynamic calls in
 			 * disguise, so convert them accordingly.
@@ -1733,17 +1732,28 @@ static int read_intra_function_calls(str
 	return 0;
 }
 
-static int read_static_call_tramps(struct objtool_file *file)
+static int classify_symbols(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
 
 	for_each_sec(file, sec) {
 		list_for_each_entry(func, &sec->symbol_list, list) {
-			if (func->bind == STB_GLOBAL &&
-			    !strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
+			if (func->bind != STB_GLOBAL)
+				continue;
+
+			if (!strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
 				     strlen(STATIC_CALL_TRAMP_PREFIX_STR)))
 				func->static_call_tramp = true;
+
+			if (arch_is_retpoline(func))
+				func->retpoline_thunk = true;
+
+			if (!strcmp(func->name, "__fentry__"))
+				func->fentry = true;
+
+			if (!strncmp(func->name, "__sanitizer_cov_", 16))
+				func->kcov = true;
 		}
 	}
 
@@ -1805,7 +1815,7 @@ static int decode_sections(struct objtoo
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = read_static_call_tramps(file);
+	ret = classify_symbols(file);
 	if (ret)
 		return ret;
 
@@ -1863,9 +1873,9 @@ static int decode_sections(struct objtoo
 
 static bool is_fentry_call(struct instruction *insn)
 {
-	if (insn->type == INSN_CALL && insn->call_dest &&
-	    insn->call_dest->type == STT_NOTYPE &&
-	    !strcmp(insn->call_dest->name, "__fentry__"))
+	if (insn->type == INSN_CALL &&
+	    insn->call_dest &&
+	    insn->call_dest->fentry)
 		return true;
 
 	return false;
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -55,8 +55,11 @@ struct symbol {
 	unsigned long offset;
 	unsigned int len;
 	struct symbol *pfunc, *cfunc, *alias;
-	bool uaccess_safe;
-	bool static_call_tramp;
+	u8 uaccess_safe      : 1;
+	u8 static_call_tramp : 1;
+	u8 retpoline_thunk   : 1;
+	u8 fentry            : 1;
+	u8 kcov              : 1;
 };
 
 struct reloc {


