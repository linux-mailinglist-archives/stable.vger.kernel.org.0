Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAE55723DF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiGLSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiGLSya (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28FCDB2E0;
        Tue, 12 Jul 2022 11:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9310A60C93;
        Tue, 12 Jul 2022 18:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23DEC3411C;
        Tue, 12 Jul 2022 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651559;
        bh=mhfFvQtBEybVbqarS8ueWbYRtpojy7GFRiJPB7rBpNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GseVcq3CpEMn6OoHbi4Gfk5/7+UWzSg2DdJjABcWzpvhn3HdZC0M6UYjwZEoy2CK0
         AKUhFfaSyCAESmCBUISgbZpk/odp2bMo7ikh7AZzEm1irrFXhNGHqO3Klft/ShdCQ+
         Jx6ONYgXXfpOI6SWT0uF8nZ2moYKv589JjTDeHZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 073/130] objtool: Fix type of reloc::addend
Date:   Tue, 12 Jul 2022 20:38:39 +0200
Message-Id: <20220712183249.838939751@linuxfoundation.org>
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

commit c087c6e7b551b7f208c0b852304f044954cf2bb3 upstream.

Elf{32,64}_Rela::r_addend is of type: Elf{32,64}_Sword, that means
that our reloc::addend needs to be long or face tuncation issues when
we do elf_rebuild_reloc_section():

  - 107:  48 b8 00 00 00 00 00 00 00 00   movabs $0x0,%rax        109: R_X86_64_64        level4_kernel_pgt+0x80000067
  + 107:  48 b8 00 00 00 00 00 00 00 00   movabs $0x0,%rax        109: R_X86_64_64        level4_kernel_pgt-0x7fffff99

Fixes: 627fce14809b ("objtool: Add ORC unwind table generation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20220419203807.596871927@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    8 ++++----
 tools/objtool/elf.c   |    2 +-
 tools/objtool/elf.h   |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -467,12 +467,12 @@ static int add_dead_ends(struct objtool_
 		else if (reloc->addend == reloc->sym->sec->len) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find unreachable insn at %s+0x%x",
+				WARN("can't find unreachable insn at %s+0x%lx",
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find unreachable insn at %s+0x%x",
+			WARN("can't find unreachable insn at %s+0x%lx",
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
@@ -502,12 +502,12 @@ reachable:
 		else if (reloc->addend == reloc->sym->sec->len) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find reachable insn at %s+0x%x",
+				WARN("can't find reachable insn at %s+0x%lx",
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find reachable insn at %s+0x%x",
+			WARN("can't find reachable insn at %s+0x%lx",
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -509,7 +509,7 @@ static struct section *elf_create_reloc_
 						int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, int addend)
+		  unsigned int type, struct symbol *sym, long addend)
 {
 	struct reloc *reloc;
 
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -73,7 +73,7 @@ struct reloc {
 	struct symbol *sym;
 	unsigned long offset;
 	unsigned int type;
-	int addend;
+	long addend;
 	int idx;
 	bool jump_table_start;
 };
@@ -127,7 +127,7 @@ struct elf *elf_open_read(const char *na
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, int addend);
+		  unsigned int type, struct symbol *sym, long addend);
 int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
 			  unsigned long offset, unsigned int type,
 			  struct section *insn_sec, unsigned long insn_off);


