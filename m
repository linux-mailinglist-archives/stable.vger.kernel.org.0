Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652A7572320
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiGLSoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiGLSnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:43:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFE5D9179;
        Tue, 12 Jul 2022 11:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36199B81BBD;
        Tue, 12 Jul 2022 18:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658BEC3411E;
        Tue, 12 Jul 2022 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651313;
        bh=OPAVYdq/Nb9TUWPRrzva7ewq9dIjGGbmoWDHPMaNNOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6C3Qk0pNGV2O0OZQu5hBCQBqthr1kPfng/WddiN7WuTodvVF9OVC1IvH8HQhwdhM
         4Fv/W2mCeZg8GFsiXRYLTYSv/QXxsLdzboY3rguZ6mFX+Utv2352dAp4hxdFCM06Sb
         WgcdoQ+Y4I26U9vkZ3rnYbRbAPhUFOxQFRQ0DKIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 037/130] objtool: Fix .symtab_shndx handling for elf_create_undef_symbol()
Date:   Tue, 12 Jul 2022 20:38:03 +0200
Message-Id: <20220712183248.114403669@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 584fd3b31889852d0d6f3dd1e3d8e9619b660d2c upstream.

When an ELF object uses extended symbol section indexes (IOW it has a
.symtab_shndx section), these must be kept in sync with the regular
symbol table (.symtab).

So for every new symbol we emit, make sure to also emit a
.symtab_shndx value to keep the arrays of equal size.

Note: since we're writing an UNDEF symbol, most GElf_Sym fields will
be 0 and we can repurpose one (st_size) to host the 0 for the xshndx
value.

Fixes: 2f2f7e47f052 ("objtool: Add elf_create_undef_symbol()")
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lkml.kernel.org/r/YL3q1qFO9QIRL/BA@hirez.programming.kicks-ass.net
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/elf.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -768,7 +768,7 @@ static int elf_add_string(struct elf *el
 
 struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name)
 {
-	struct section *symtab;
+	struct section *symtab, *symtab_shndx;
 	struct symbol *sym;
 	Elf_Data *data;
 	Elf_Scn *s;
@@ -819,6 +819,29 @@ struct symbol *elf_create_undef_symbol(s
 	symtab->len += data->d_size;
 	symtab->changed = true;
 
+	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
+	if (symtab_shndx) {
+		s = elf_getscn(elf->elf, symtab_shndx->idx);
+		if (!s) {
+			WARN_ELF("elf_getscn");
+			return NULL;
+		}
+
+		data = elf_newdata(s);
+		if (!data) {
+			WARN_ELF("elf_newdata");
+			return NULL;
+		}
+
+		data->d_buf = &sym->sym.st_size; /* conveniently 0 */
+		data->d_size = sizeof(Elf32_Word);
+		data->d_align = 4;
+		data->d_type = ELF_T_WORD;
+
+		symtab_shndx->len += 4;
+		symtab_shndx->changed = true;
+	}
+
 	sym->sec = find_section_by_index(elf, 0);
 
 	elf_add_symbol(elf, sym);


