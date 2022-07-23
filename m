Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C557ED62
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiGWJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiGWJ4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6013FD1F;
        Sat, 23 Jul 2022 02:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7418F6116A;
        Sat, 23 Jul 2022 09:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D016C341C0;
        Sat, 23 Jul 2022 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570191;
        bh=7IGIX27Y9atr+FIz4Nekvn8paVwSfv/7bUB0/eaOZqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka1AhHqK85xW4IPooEidIpsQv0+z1q9aCNlfaOpB2nGcb/ssRbyR5Me+njUPmX8IA
         2zHUm0mp/nK4rL+kwqnB0ejhNNpIUezEcDOdwJP3+DFbiRBhM97Jdozq3EmKMOXIX6
         p1KY1YnK0FUfwxUZZgjWPuNWNaAFtE3NMDPcRpZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 003/148] objtool: Refactor ORC section generation
Date:   Sat, 23 Jul 2022 11:53:35 +0200
Message-Id: <20220723095225.313623463@linuxfoundation.org>
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

commit ab4e0744e99b87e1a223e89fc3c9ae44f727c9a6 upstream.

Decouple ORC entries from instructions.  This simplifies the
control/data flow, and is going to make it easier to support alternative
instructions which change the stack layout.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/Makefile      |    4 
 tools/objtool/arch.h        |    4 
 tools/objtool/builtin-orc.c |    6 
 tools/objtool/check.h       |    3 
 tools/objtool/objtool.h     |    3 
 tools/objtool/orc_gen.c     |  274 ++++++++++++++++++++++----------------------
 tools/objtool/weak.c        |    7 -
 7 files changed, 141 insertions(+), 160 deletions(-)

--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -46,10 +46,6 @@ ifeq ($(SRCARCH),x86)
 	SUBCMD_ORC := y
 endif
 
-ifeq ($(SUBCMD_ORC),y)
-	CFLAGS += -DINSN_USE_ORC
-endif
-
 export SUBCMD_CHECK SUBCMD_ORC
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
--- a/tools/objtool/arch.h
+++ b/tools/objtool/arch.h
@@ -11,10 +11,6 @@
 #include "objtool.h"
 #include "cfi.h"
 
-#ifdef INSN_USE_ORC
-#include <asm/orc_types.h>
-#endif
-
 enum insn_type {
 	INSN_JUMP_CONDITIONAL,
 	INSN_JUMP_UNCONDITIONAL,
--- a/tools/objtool/builtin-orc.c
+++ b/tools/objtool/builtin-orc.c
@@ -51,11 +51,7 @@ int cmd_orc(int argc, const char **argv)
 		if (list_empty(&file->insn_list))
 			return 0;
 
-		ret = create_orc(file);
-		if (ret)
-			return ret;
-
-		ret = create_orc_sections(file);
+		ret = orc_create(file);
 		if (ret)
 			return ret;
 
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -43,9 +43,6 @@ struct instruction {
 	struct symbol *func;
 	struct list_head stack_ops;
 	struct cfi_state cfi;
-#ifdef INSN_USE_ORC
-	struct orc_entry orc;
-#endif
 };
 
 static inline bool is_static_jump(struct instruction *insn)
--- a/tools/objtool/objtool.h
+++ b/tools/objtool/objtool.h
@@ -26,7 +26,6 @@ struct objtool_file *objtool_open_read(c
 
 int check(struct objtool_file *file);
 int orc_dump(const char *objname);
-int create_orc(struct objtool_file *file);
-int create_orc_sections(struct objtool_file *file);
+int orc_create(struct objtool_file *file);
 
 #endif /* _OBJTOOL_H */
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -12,89 +12,84 @@
 #include "check.h"
 #include "warn.h"
 
-int create_orc(struct objtool_file *file)
+static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi)
 {
-	struct instruction *insn;
+	struct instruction *insn = container_of(cfi, struct instruction, cfi);
+	struct cfi_reg *bp = &cfi->regs[CFI_BP];
 
-	for_each_insn(file, insn) {
-		struct orc_entry *orc = &insn->orc;
-		struct cfi_reg *cfa = &insn->cfi.cfa;
-		struct cfi_reg *bp = &insn->cfi.regs[CFI_BP];
+	memset(orc, 0, sizeof(*orc));
 
-		if (!insn->sec->text)
-			continue;
-
-		orc->end = insn->cfi.end;
-
-		if (cfa->base == CFI_UNDEFINED) {
-			orc->sp_reg = ORC_REG_UNDEFINED;
-			continue;
-		}
-
-		switch (cfa->base) {
-		case CFI_SP:
-			orc->sp_reg = ORC_REG_SP;
-			break;
-		case CFI_SP_INDIRECT:
-			orc->sp_reg = ORC_REG_SP_INDIRECT;
-			break;
-		case CFI_BP:
-			orc->sp_reg = ORC_REG_BP;
-			break;
-		case CFI_BP_INDIRECT:
-			orc->sp_reg = ORC_REG_BP_INDIRECT;
-			break;
-		case CFI_R10:
-			orc->sp_reg = ORC_REG_R10;
-			break;
-		case CFI_R13:
-			orc->sp_reg = ORC_REG_R13;
-			break;
-		case CFI_DI:
-			orc->sp_reg = ORC_REG_DI;
-			break;
-		case CFI_DX:
-			orc->sp_reg = ORC_REG_DX;
-			break;
-		default:
-			WARN_FUNC("unknown CFA base reg %d",
-				  insn->sec, insn->offset, cfa->base);
-			return -1;
-		}
+	orc->end = cfi->end;
 
-		switch(bp->base) {
-		case CFI_UNDEFINED:
-			orc->bp_reg = ORC_REG_UNDEFINED;
-			break;
-		case CFI_CFA:
-			orc->bp_reg = ORC_REG_PREV_SP;
-			break;
-		case CFI_BP:
-			orc->bp_reg = ORC_REG_BP;
-			break;
-		default:
-			WARN_FUNC("unknown BP base reg %d",
-				  insn->sec, insn->offset, bp->base);
-			return -1;
-		}
+	if (cfi->cfa.base == CFI_UNDEFINED) {
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
+	switch (cfi->cfa.base) {
+	case CFI_SP:
+		orc->sp_reg = ORC_REG_SP;
+		break;
+	case CFI_SP_INDIRECT:
+		orc->sp_reg = ORC_REG_SP_INDIRECT;
+		break;
+	case CFI_BP:
+		orc->sp_reg = ORC_REG_BP;
+		break;
+	case CFI_BP_INDIRECT:
+		orc->sp_reg = ORC_REG_BP_INDIRECT;
+		break;
+	case CFI_R10:
+		orc->sp_reg = ORC_REG_R10;
+		break;
+	case CFI_R13:
+		orc->sp_reg = ORC_REG_R13;
+		break;
+	case CFI_DI:
+		orc->sp_reg = ORC_REG_DI;
+		break;
+	case CFI_DX:
+		orc->sp_reg = ORC_REG_DX;
+		break;
+	default:
+		WARN_FUNC("unknown CFA base reg %d",
+			  insn->sec, insn->offset, cfi->cfa.base);
+		return -1;
+	}
 
-		orc->sp_offset = cfa->offset;
-		orc->bp_offset = bp->offset;
-		orc->type = insn->cfi.type;
+	switch (bp->base) {
+	case CFI_UNDEFINED:
+		orc->bp_reg = ORC_REG_UNDEFINED;
+		break;
+	case CFI_CFA:
+		orc->bp_reg = ORC_REG_PREV_SP;
+		break;
+	case CFI_BP:
+		orc->bp_reg = ORC_REG_BP;
+		break;
+	default:
+		WARN_FUNC("unknown BP base reg %d",
+			  insn->sec, insn->offset, bp->base);
+		return -1;
 	}
 
+	orc->sp_offset = cfi->cfa.offset;
+	orc->bp_offset = bp->offset;
+	orc->type = cfi->type;
+
 	return 0;
 }
 
-static int create_orc_entry(struct elf *elf, struct section *u_sec, struct section *ip_relocsec,
-				unsigned int idx, struct section *insn_sec,
-				unsigned long insn_off, struct orc_entry *o)
+static int write_orc_entry(struct elf *elf, struct section *orc_sec,
+			   struct section *ip_rsec, unsigned int idx,
+			   struct section *insn_sec, unsigned long insn_off,
+			   struct orc_entry *o)
 {
 	struct orc_entry *orc;
 	struct reloc *reloc;
 
 	/* populate ORC data */
-	orc = (struct orc_entry *)u_sec->data->d_buf + idx;
+	orc = (struct orc_entry *)orc_sec->data->d_buf + idx;
 	memcpy(orc, o, sizeof(*orc));
 
 	/* populate reloc for ip */
@@ -114,102 +109,109 @@ static int create_orc_entry(struct elf *
 
 	reloc->type = R_X86_64_PC32;
 	reloc->offset = idx * sizeof(int);
-	reloc->sec = ip_relocsec;
+	reloc->sec = ip_rsec;
 
 	elf_add_reloc(elf, reloc);
 
 	return 0;
 }
 
-int create_orc_sections(struct objtool_file *file)
+struct orc_list_entry {
+	struct list_head list;
+	struct orc_entry orc;
+	struct section *insn_sec;
+	unsigned long insn_off;
+};
+
+static int orc_list_add(struct list_head *orc_list, struct orc_entry *orc,
+			struct section *sec, unsigned long offset)
+{
+	struct orc_list_entry *entry = malloc(sizeof(*entry));
+
+	if (!entry) {
+		WARN("malloc failed");
+		return -1;
+	}
+
+	entry->orc	= *orc;
+	entry->insn_sec = sec;
+	entry->insn_off = offset;
+
+	list_add_tail(&entry->list, orc_list);
+	return 0;
+}
+
+int orc_create(struct objtool_file *file)
 {
-	struct instruction *insn, *prev_insn;
-	struct section *sec, *u_sec, *ip_relocsec;
-	unsigned int idx;
+	struct section *sec, *ip_rsec, *orc_sec;
+	unsigned int nr = 0, idx = 0;
+	struct orc_list_entry *entry;
+	struct list_head orc_list;
 
-	struct orc_entry empty = {
-		.sp_reg = ORC_REG_UNDEFINED,
+	struct orc_entry null = {
+		.sp_reg  = ORC_REG_UNDEFINED,
 		.bp_reg  = ORC_REG_UNDEFINED,
 		.type    = UNWIND_HINT_TYPE_CALL,
 	};
 
-	sec = find_section_by_name(file->elf, ".orc_unwind");
-	if (sec) {
-		WARN("file already has .orc_unwind section, skipping");
-		return -1;
-	}
-
-	/* count the number of needed orcs */
-	idx = 0;
+	/* Build a deduplicated list of ORC entries: */
+	INIT_LIST_HEAD(&orc_list);
 	for_each_sec(file, sec) {
+		struct orc_entry orc, prev_orc = {0};
+		struct instruction *insn;
+		bool empty = true;
+
 		if (!sec->text)
 			continue;
 
-		prev_insn = NULL;
 		sec_for_each_insn(file, sec, insn) {
-			if (!prev_insn ||
-			    memcmp(&insn->orc, &prev_insn->orc,
-				   sizeof(struct orc_entry))) {
-				idx++;
-			}
-			prev_insn = insn;
+			if (init_orc_entry(&orc, &insn->cfi))
+				return -1;
+			if (!memcmp(&prev_orc, &orc, sizeof(orc)))
+				continue;
+			if (orc_list_add(&orc_list, &orc, sec, insn->offset))
+				return -1;
+			nr++;
+			prev_orc = orc;
+			empty = false;
 		}
 
-		/* section terminator */
-		if (prev_insn)
-			idx++;
+		/* Add a section terminator */
+		if (!empty) {
+			orc_list_add(&orc_list, &null, sec, sec->len);
+			nr++;
+		}
 	}
-	if (!idx)
-		return -1;
+	if (!nr)
+		return 0;
 
+	/* Create .orc_unwind, .orc_unwind_ip and .rela.orc_unwind_ip sections: */
+	sec = find_section_by_name(file->elf, ".orc_unwind");
+	if (sec) {
+		WARN("file already has .orc_unwind section, skipping");
+		return -1;
+	}
+	orc_sec = elf_create_section(file->elf, ".orc_unwind", 0,
+				     sizeof(struct orc_entry), nr);
+	if (!orc_sec)
+		return -1;
 
-	/* create .orc_unwind_ip and .rela.orc_unwind_ip sections */
-	sec = elf_create_section(file->elf, ".orc_unwind_ip", 0, sizeof(int), idx);
+	sec = elf_create_section(file->elf, ".orc_unwind_ip", 0, sizeof(int), nr);
 	if (!sec)
 		return -1;
-
-	ip_relocsec = elf_create_reloc_section(file->elf, sec, SHT_RELA);
-	if (!ip_relocsec)
+	ip_rsec = elf_create_reloc_section(file->elf, sec, SHT_RELA);
+	if (!ip_rsec)
 		return -1;
 
-	/* create .orc_unwind section */
-	u_sec = elf_create_section(file->elf, ".orc_unwind", 0,
-				   sizeof(struct orc_entry), idx);
-
-	/* populate sections */
-	idx = 0;
-	for_each_sec(file, sec) {
-		if (!sec->text)
-			continue;
-
-		prev_insn = NULL;
-		sec_for_each_insn(file, sec, insn) {
-			if (!prev_insn || memcmp(&insn->orc, &prev_insn->orc,
-						 sizeof(struct orc_entry))) {
-
-				if (create_orc_entry(file->elf, u_sec, ip_relocsec, idx,
-						     insn->sec, insn->offset,
-						     &insn->orc))
-					return -1;
-
-				idx++;
-			}
-			prev_insn = insn;
-		}
-
-		/* section terminator */
-		if (prev_insn) {
-			if (create_orc_entry(file->elf, u_sec, ip_relocsec, idx,
-					     prev_insn->sec,
-					     prev_insn->offset + prev_insn->len,
-					     &empty))
-				return -1;
-
-			idx++;
-		}
+	/* Write ORC entries to sections: */
+	list_for_each_entry(entry, &orc_list, list) {
+		if (write_orc_entry(file->elf, orc_sec, ip_rsec, idx++,
+				    entry->insn_sec, entry->insn_off,
+				    &entry->orc))
+			return -1;
 	}
 
-	if (elf_rebuild_reloc_section(file->elf, ip_relocsec))
+	if (elf_rebuild_reloc_section(file->elf, ip_rsec))
 		return -1;
 
 	return 0;
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -25,12 +25,7 @@ int __weak orc_dump(const char *_objname
 	UNSUPPORTED("orc");
 }
 
-int __weak create_orc(struct objtool_file *file)
-{
-	UNSUPPORTED("orc");
-}
-
-int __weak create_orc_sections(struct objtool_file *file)
+int __weak orc_create(struct objtool_file *file)
 {
 	UNSUPPORTED("orc");
 }


