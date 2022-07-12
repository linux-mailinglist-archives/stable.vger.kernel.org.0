Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C403572441
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiGLS6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiGLS6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:58:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE0CEDB7D;
        Tue, 12 Jul 2022 11:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFFFF60C93;
        Tue, 12 Jul 2022 18:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0EAC3411C;
        Tue, 12 Jul 2022 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651651;
        bh=hff1j457xnb18OdE/bo9iM0uQJtV9b7GJETPm1tbrBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0rfgEZZrRqqDMLUZjoPIRM9lD9kAm8StDQnlCrq1rCGUzm2S8oXqmNcu71WPalaB
         +XI57YmJatluzUqZVsftNllKmThRMxEdMS2flPTaokTas+xe2zBU+7aX5172S8LNrq
         GZAc2YdHobumEJDq8ta4GpD+FuNChyQIJTAQ60CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 05/78] objtool: Classify symbols
Date:   Tue, 12 Jul 2022 20:38:35 +0200
Message-Id: <20220712183239.060622006@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c               |   34 ++++++++++++++++++++++------------
 tools/objtool/include/objtool/elf.h |    7 +++++--
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -859,8 +859,7 @@ static void add_call_dest(struct objtool
 	 * so they need a little help, NOP out any KCOV calls from noinstr
 	 * text.
 	 */
-	if (insn->sec->noinstr &&
-	    !strncmp(insn->call_dest->name, "__sanitizer_cov_", 16)) {
+	if (insn->sec->noinstr && insn->call_dest->kcov) {
 		if (reloc) {
 			reloc->type = R_NONE;
 			elf_write_reloc(file->elf, reloc);
@@ -884,7 +883,7 @@ static void add_call_dest(struct objtool
 		}
 	}
 
-	if (mcount && !strcmp(insn->call_dest->name, "__fentry__")) {
+	if (mcount && insn->call_dest->fentry) {
 		if (sibling)
 			WARN_FUNC("Tail call to __fentry__ !?!?", insn->sec, insn->offset);
 
@@ -934,7 +933,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (arch_is_retpoline(reloc->sym)) {
+		} else if (reloc->sym->retpoline_thunk) {
 			/*
 			 * Retpoline jumps are really dynamic jumps in
 			 * disguise, so convert them accordingly.
@@ -1075,7 +1074,7 @@ static int add_call_destinations(struct
 
 			add_call_dest(file, insn, dest, false);
 
-		} else if (arch_is_retpoline(reloc->sym)) {
+		} else if (reloc->sym->retpoline_thunk) {
 			/*
 			 * Retpoline calls are really dynamic calls in
 			 * disguise, so convert them accordingly.
@@ -1759,17 +1758,28 @@ static int read_intra_function_calls(str
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
 
@@ -1831,7 +1841,7 @@ static int decode_sections(struct objtoo
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = read_static_call_tramps(file);
+	ret = classify_symbols(file);
 	if (ret)
 		return ret;
 
@@ -1889,9 +1899,9 @@ static int decode_sections(struct objtoo
 
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
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -54,8 +54,11 @@ struct symbol {
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


