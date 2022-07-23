Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A900257ED9A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbiGWJ7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbiGWJ7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:59:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55460474D8;
        Sat, 23 Jul 2022 02:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FC4B82C1B;
        Sat, 23 Jul 2022 09:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E7BC341C0;
        Sat, 23 Jul 2022 09:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570269;
        bh=LpGgRFhrdCtmBrJ1+C5WSb3c5uJQUargm8UG6qofKak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNd2ovEjuqFfKSei/9WpL/YprXfvZx+61oWyq5dzeNKpPKTQYBFuSEnLJM8+jMtp7
         761uvtKN5itxTvol2BkAj4D5FMSCOPcSCpwiJ0lj028Jf2Ok88EmVC4KpytOrZtvQX
         aiC77QpD9KkfJpavH+MdJBS7iL/cwEb8oFy13p1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 028/148] objtool: Extract elf_strtab_concat()
Date:   Sat, 23 Jul 2022 11:54:00 +0200
Message-Id: <20220723095232.278686983@linuxfoundation.org>
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

commit 417a4dc91e559f92404c2544f785b02ce75784c3 upstream.

Create a common helper to append strings to a strtab.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.941474004@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/elf.c |   60 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -724,13 +724,48 @@ err:
 	return NULL;
 }
 
+static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
+{
+	Elf_Data *data;
+	Elf_Scn *s;
+	int len;
+
+	if (!strtab)
+		strtab = find_section_by_name(elf, ".strtab");
+	if (!strtab) {
+		WARN("can't find .strtab section");
+		return -1;
+	}
+
+	s = elf_getscn(elf->elf, strtab->idx);
+	if (!s) {
+		WARN_ELF("elf_getscn");
+		return -1;
+	}
+
+	data = elf_newdata(s);
+	if (!data) {
+		WARN_ELF("elf_newdata");
+		return -1;
+	}
+
+	data->d_buf = str;
+	data->d_size = strlen(str) + 1;
+	data->d_align = 1;
+
+	len = strtab->len;
+	strtab->len += data->d_size;
+	strtab->changed = true;
+
+	return len;
+}
+
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   unsigned int sh_flags, size_t entsize, int nr)
 {
 	struct section *sec, *shstrtab;
 	size_t size = entsize * nr;
 	Elf_Scn *s;
-	Elf_Data *data;
 
 	sec = malloc(sizeof(*sec));
 	if (!sec) {
@@ -787,7 +822,6 @@ struct section *elf_create_section(struc
 	sec->sh.sh_addralign = 1;
 	sec->sh.sh_flags = SHF_ALLOC | sh_flags;
 
-
 	/* Add section name to .shstrtab (or .strtab for Clang) */
 	shstrtab = find_section_by_name(elf, ".shstrtab");
 	if (!shstrtab)
@@ -796,27 +830,9 @@ struct section *elf_create_section(struc
 		WARN("can't find .shstrtab or .strtab section");
 		return NULL;
 	}
-
-	s = elf_getscn(elf->elf, shstrtab->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return NULL;
-	}
-
-	data = elf_newdata(s);
-	if (!data) {
-		WARN_ELF("elf_newdata");
+	sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
+	if (sec->sh.sh_name == -1)
 		return NULL;
-	}
-
-	data->d_buf = sec->name;
-	data->d_size = strlen(name) + 1;
-	data->d_align = 1;
-
-	sec->sh.sh_name = shstrtab->len;
-
-	shstrtab->len += strlen(name) + 1;
-	shstrtab->changed = true;
 
 	list_add_tail(&sec->list, &elf->sections);
 	elf_hash_add(elf->section_hash, &sec->hash, sec->idx);


