Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988C34356EB
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhJUAX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhJUAXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67B13611CC;
        Thu, 21 Oct 2021 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775660;
        bh=4JPQVIHWVjf9kbAJr6+3FH509KcOpC7ie1Fmg5TEGko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCekbrWFH+OMfmr/rTX9vP1I9eKoUjdtNME6wbgWqTvX/29yrdwVidB4LqPffEzKQ
         9DDfjsnHnmCSDemLi5eqoACs7VHotLdYt6HsuCSvGcwLMLv3Zgl1nk3JGZ8Mw5ZaAC
         i0zmfKGR5xCVgz4oiG7RbcxwHc/4XXWHyjrjSZgxd4zkioaws3wanrO642lsb3/5mu
         pKG4oSfWHZpsB2FFidLXuo5qko+dJB8BKVCWv5NyyZxC+bcoXdjNn6Q1QXNQiGGBKT
         1gz38/eAlOnP73ZG8dVM3isjEoT/oqUxrV8BnCOYVWl4AUOiInBIed574Xx7a6ZdnL
         kfHA4tI+xkUdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Forney <mforney@mforney.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org
Subject: [PATCH AUTOSEL 5.14 09/26] objtool: Update section header before relocations
Date:   Wed, 20 Oct 2021 20:20:06 -0400
Message-Id: <20211021002023.1128949-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

