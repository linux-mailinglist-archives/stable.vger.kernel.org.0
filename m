Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF243A32C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhJYT4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237993AbhJYTxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F77261246;
        Mon, 25 Oct 2021 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191051;
        bh=4JPQVIHWVjf9kbAJr6+3FH509KcOpC7ie1Fmg5TEGko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLzFpgPKIFDiM5TWWt3UTZJfgMdUQOHyaWaM1zg6V0lM405P5n2JLpUnzy8O1FaZs
         zwYrx3Q0NC4KCosMjB53RU+4Gbp8ArPPK9Ao0QAWciVYSZV94Jb07C8YVkVq4/i+Wg
         E8XEt5MRX/SflC1COuOUGuQQtokdFemLYcDo31bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Forney <mforney@mforney.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 133/169] objtool: Update section header before relocations
Date:   Mon, 25 Oct 2021 21:15:14 +0200
Message-Id: <20211025191034.546980699@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Forney <mforney@mforney.org>

[ Upstream commit 86e1e054e0d2105cf32b0266cf1a64e6c26424f7 ]

The libelf implementation from elftoolchain has a safety check in
gelf_update_rel[a] to check that the data corresponds to a section
that has type SHT_REL[A] [0]. If the relocation is updated before
the section header is updated with the proper type, this check
fails.

To fix this, update the section header first, before the relocations.
Previously, the section size was calculated in elf_rebuild_reloc_section
by counting the number of entries in the reloc_list. However, we
now need the size during elf_write so instead keep a running total
and add to it for every new relocation.

[0] https://sourceforge.net/p/elftoolchain/mailman/elftoolchain-developers/thread/CAGw6cBtkZro-8wZMD2ULkwJ39J+tHtTtAWXufMjnd3cQ7XG54g@mail.gmail.com/

Signed-off-by: Michael Forney <mforney@mforney.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20210509000103.11008-2-mforney@mforney.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 46 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 6cf4c0f11906..a9c2bebd7576 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -509,6 +509,7 @@ int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
 	list_add_tail(&reloc->list, &sec->reloc->reloc_list);
 	elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
 
+	sec->reloc->sh.sh_size += sec->reloc->sh.sh_entsize;
 	sec->reloc->changed = true;
 
 	return 0;
@@ -979,26 +980,23 @@ static struct section *elf_create_reloc_section(struct elf *elf,
 	}
 }
 
-static int elf_rebuild_rel_reloc_section(struct section *sec, int nr)
+static int elf_rebuild_rel_reloc_section(struct section *sec)
 {
 	struct reloc *reloc;
-	int idx = 0, size;
+	int idx = 0;
 	void *buf;
 
 	/* Allocate a buffer for relocations */
-	size = nr * sizeof(GElf_Rel);
-	buf = malloc(size);
+	buf = malloc(sec->sh.sh_size);
 	if (!buf) {
 		perror("malloc");
 		return -1;
 	}
 
 	sec->data->d_buf = buf;
-	sec->data->d_size = size;
+	sec->data->d_size = sec->sh.sh_size;
 	sec->data->d_type = ELF_T_REL;
 
-	sec->sh.sh_size = size;
-
 	idx = 0;
 	list_for_each_entry(reloc, &sec->reloc_list, list) {
 		reloc->rel.r_offset = reloc->offset;
@@ -1013,26 +1011,23 @@ static int elf_rebuild_rel_reloc_section(struct section *sec, int nr)
 	return 0;
 }
 
-static int elf_rebuild_rela_reloc_section(struct section *sec, int nr)
+static int elf_rebuild_rela_reloc_section(struct section *sec)
 {
 	struct reloc *reloc;
-	int idx = 0, size;
+	int idx = 0;
 	void *buf;
 
 	/* Allocate a buffer for relocations with addends */
-	size = nr * sizeof(GElf_Rela);
-	buf = malloc(size);
+	buf = malloc(sec->sh.sh_size);
 	if (!buf) {
 		perror("malloc");
 		return -1;
 	}
 
 	sec->data->d_buf = buf;
-	sec->data->d_size = size;
+	sec->data->d_size = sec->sh.sh_size;
 	sec->data->d_type = ELF_T_RELA;
 
-	sec->sh.sh_size = size;
-
 	idx = 0;
 	list_for_each_entry(reloc, &sec->reloc_list, list) {
 		reloc->rela.r_offset = reloc->offset;
@@ -1050,16 +1045,9 @@ static int elf_rebuild_rela_reloc_section(struct section *sec, int nr)
 
 static int elf_rebuild_reloc_section(struct elf *elf, struct section *sec)
 {
-	struct reloc *reloc;
-	int nr;
-
-	nr = 0;
-	list_for_each_entry(reloc, &sec->reloc_list, list)
-		nr++;
-
 	switch (sec->sh.sh_type) {
-	case SHT_REL:  return elf_rebuild_rel_reloc_section(sec, nr);
-	case SHT_RELA: return elf_rebuild_rela_reloc_section(sec, nr);
+	case SHT_REL:  return elf_rebuild_rel_reloc_section(sec);
+	case SHT_RELA: return elf_rebuild_rela_reloc_section(sec);
 	default:       return -1;
 	}
 }
@@ -1119,12 +1107,6 @@ int elf_write(struct elf *elf)
 	/* Update changed relocation sections and section headers: */
 	list_for_each_entry(sec, &elf->sections, list) {
 		if (sec->changed) {
-			if (sec->base &&
-			    elf_rebuild_reloc_section(elf, sec)) {
-				WARN("elf_rebuild_reloc_section");
-				return -1;
-			}
-
 			s = elf_getscn(elf->elf, sec->idx);
 			if (!s) {
 				WARN_ELF("elf_getscn");
@@ -1135,6 +1117,12 @@ int elf_write(struct elf *elf)
 				return -1;
 			}
 
+			if (sec->base &&
+			    elf_rebuild_reloc_section(elf, sec)) {
+				WARN("elf_rebuild_reloc_section");
+				return -1;
+			}
+
 			sec->changed = false;
 			elf->changed = true;
 		}
-- 
2.33.0



