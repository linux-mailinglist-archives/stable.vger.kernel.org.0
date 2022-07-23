Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E6557ED9F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbiGWKAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiGWJ7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F8F48E85;
        Sat, 23 Jul 2022 02:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7298B82C20;
        Sat, 23 Jul 2022 09:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2273FC341C0;
        Sat, 23 Jul 2022 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570275;
        bh=VvU/1RP84JrPAl0/5+ZpTqj7LWQ1cv8/7kvVC/IdFmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7X+Fs+0BYLdwudha8JdcsD78HC1ZQOWGFLFHgryQL0WSGhMzP23LIf2JEFRVOZAG
         7/jzbSFJU4qBFxC1JO7AhNuh9TAmWgFjU0f3LIZXNNjdiuXC/P8chMr954OUk9PSWJ
         SBm1u1iY4Su+oFzE5FCyirW/8LLMVtXpoq3egM0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 030/148] objtool: Add elf_create_undef_symbol()
Date:   Sat, 23 Jul 2022 11:54:02 +0200
Message-Id: <20220723095232.840946456@linuxfoundation.org>
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

commit 2f2f7e47f0525cbaad5dd9675fd9d8aa8da12046 upstream.

Allow objtool to create undefined symbols; this allows creating
relocations to symbols not currently in the symbol table.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.064743095@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/elf.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/objtool/elf.h |    1 
 2 files changed, 61 insertions(+)

--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -766,6 +766,66 @@ static int elf_add_string(struct elf *el
 	return len;
 }
 
+struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name)
+{
+	struct section *symtab;
+	struct symbol *sym;
+	Elf_Data *data;
+	Elf_Scn *s;
+
+	sym = malloc(sizeof(*sym));
+	if (!sym) {
+		perror("malloc");
+		return NULL;
+	}
+	memset(sym, 0, sizeof(*sym));
+
+	sym->name = strdup(name);
+
+	sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
+	if (sym->sym.st_name == -1)
+		return NULL;
+
+	sym->sym.st_info = GELF_ST_INFO(STB_GLOBAL, STT_NOTYPE);
+	// st_other 0
+	// st_shndx 0
+	// st_value 0
+	// st_size 0
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		WARN("can't find .symtab");
+		return NULL;
+	}
+
+	s = elf_getscn(elf->elf, symtab->idx);
+	if (!s) {
+		WARN_ELF("elf_getscn");
+		return NULL;
+	}
+
+	data = elf_newdata(s);
+	if (!data) {
+		WARN_ELF("elf_newdata");
+		return NULL;
+	}
+
+	data->d_buf = &sym->sym;
+	data->d_size = sizeof(sym->sym);
+	data->d_align = 1;
+
+	sym->idx = symtab->len / sizeof(sym->sym);
+
+	symtab->len += data->d_size;
+	symtab->changed = true;
+
+	sym->sec = find_section_by_index(elf, 0);
+
+	elf_add_symbol(elf, sym);
+
+	return sym;
+}
+
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   unsigned int sh_flags, size_t entsize, int nr)
 {
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -133,6 +133,7 @@ int elf_write_insn(struct elf *elf, stru
 		   unsigned long offset, unsigned int len,
 		   const char *insn);
 int elf_write_reloc(struct elf *elf, struct reloc *reloc);
+struct symbol *elf_create_undef_symbol(struct elf *elf, const char *name);
 int elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 


