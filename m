Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3383B57ED9B
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiGWJ7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbiGWJ7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C70B6E2E6;
        Sat, 23 Jul 2022 02:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDE05B82C21;
        Sat, 23 Jul 2022 09:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F87AC341C0;
        Sat, 23 Jul 2022 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570272;
        bh=6MHWoP7j5DCxR+KQoeA5JjHbHKkbd3JWJTvdKzygbME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLt91ALEGaAMfRQQ0J7SS+Uzruu/1wUdrPNDeVDpjiEdJ9G4bhltdXNntr6L6tP4Y
         O1IX5DPpkUZqdIWUd9zgLBzh1grKKud7GzmQbO69Lr66qfnOwSXOLVFDXAqfsme6Aa
         +WHHERERJZGXGNrj0wHk1Qg4zz2ANeTLG+Qg46L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 029/148] objtool: Extract elf_symbol_add()
Date:   Sat, 23 Jul 2022 11:54:01 +0200
Message-Id: <20220723095232.558086259@linuxfoundation.org>
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

commit 9a7827b7789c630c1efdb121daa42c6e77dce97f upstream.

Create a common helper to add symbols.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.003468981@infradead.org
[bwh: Backported to 5.10: rb_add() parameter order is different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/elf.c |   56 ++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -341,12 +341,39 @@ static int read_sections(struct elf *elf
 	return 0;
 }
 
+static void elf_add_symbol(struct elf *elf, struct symbol *sym)
+{
+	struct list_head *entry;
+	struct rb_node *pnode;
+
+	sym->type = GELF_ST_TYPE(sym->sym.st_info);
+	sym->bind = GELF_ST_BIND(sym->sym.st_info);
+
+	sym->offset = sym->sym.st_value;
+	sym->len = sym->sym.st_size;
+
+	rb_add(&sym->sec->symbol_tree, &sym->node, symbol_to_offset);
+	pnode = rb_prev(&sym->node);
+	if (pnode)
+		entry = &rb_entry(pnode, struct symbol, node)->list;
+	else
+		entry = &sym->sec->symbol_list;
+	list_add(&sym->list, entry);
+	elf_hash_add(elf->symbol_hash, &sym->hash, sym->idx);
+	elf_hash_add(elf->symbol_name_hash, &sym->name_hash, str_hash(sym->name));
+
+	/*
+	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
+	 * can exist within a function, confusing the sorting.
+	 */
+	if (!sym->len)
+		rb_erase(&sym->node, &sym->sec->symbol_tree);
+}
+
 static int read_symbols(struct elf *elf)
 {
 	struct section *symtab, *symtab_shndx, *sec;
 	struct symbol *sym, *pfunc;
-	struct list_head *entry;
-	struct rb_node *pnode;
 	int symbols_nr, i;
 	char *coldstr;
 	Elf_Data *shndx_data = NULL;
@@ -391,9 +418,6 @@ static int read_symbols(struct elf *elf)
 			goto err;
 		}
 
-		sym->type = GELF_ST_TYPE(sym->sym.st_info);
-		sym->bind = GELF_ST_BIND(sym->sym.st_info);
-
 		if ((sym->sym.st_shndx > SHN_UNDEF &&
 		     sym->sym.st_shndx < SHN_LORESERVE) ||
 		    (shndx_data && sym->sym.st_shndx == SHN_XINDEX)) {
@@ -406,32 +430,14 @@ static int read_symbols(struct elf *elf)
 				     sym->name);
 				goto err;
 			}
-			if (sym->type == STT_SECTION) {
+			if (GELF_ST_TYPE(sym->sym.st_info) == STT_SECTION) {
 				sym->name = sym->sec->name;
 				sym->sec->sym = sym;
 			}
 		} else
 			sym->sec = find_section_by_index(elf, 0);
 
-		sym->offset = sym->sym.st_value;
-		sym->len = sym->sym.st_size;
-
-		rb_add(&sym->sec->symbol_tree, &sym->node, symbol_to_offset);
-		pnode = rb_prev(&sym->node);
-		if (pnode)
-			entry = &rb_entry(pnode, struct symbol, node)->list;
-		else
-			entry = &sym->sec->symbol_list;
-		list_add(&sym->list, entry);
-		elf_hash_add(elf->symbol_hash, &sym->hash, sym->idx);
-		elf_hash_add(elf->symbol_name_hash, &sym->name_hash, str_hash(sym->name));
-
-		/*
-		 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
-		 * can exist within a function, confusing the sorting.
-		 */
-		if (!sym->len)
-			rb_erase(&sym->node, &sym->sec->symbol_tree);
+		elf_add_symbol(elf, sym);
 	}
 
 	if (stats)


