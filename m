Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A305722E4
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiGLSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiGLSlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39332D7B86;
        Tue, 12 Jul 2022 11:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E9C61ACE;
        Tue, 12 Jul 2022 18:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B46C3411C;
        Tue, 12 Jul 2022 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651278;
        bh=P8MOob0Am9dbWMK9nvqs5Mo/UzNxM2C3QOR3rxgRsAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8mqfG1G+CvwcIk1lcSkS/nWpH5gzO5UGkoJCMtefjTv1FRGwA9yC2PZ5BKUuYAYn
         RUPWuambYAlxbF/Vex0CW5TG40hD2MCtSRka/aB7LbjcamgEUtFKd/4km5udOzJE0L
         G0mRiITwqPdUpcOOJlymsQuN7B0TDCn+p6hYifNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 027/130] objtool: Create reloc sections implicitly
Date:   Tue, 12 Jul 2022 20:37:53 +0200
Message-Id: <20220712183247.639584442@linuxfoundation.org>
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

commit d0c5c4cc73da0b05b0d9e5f833f2d859e1b45f8e upstream.

Have elf_add_reloc() create the relocation section implicitly.

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151259.880174448@infradead.org
[bwh: Backported to 5.10: drop changes in create_mcount_loc_sections()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c   |    3 ---
 tools/objtool/elf.c     |    9 ++++++++-
 tools/objtool/elf.h     |    1 -
 tools/objtool/orc_gen.c |    2 --
 4 files changed, 8 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -459,9 +459,6 @@ static int create_static_call_sections(s
 	if (!sec)
 		return -1;
 
-	if (!elf_create_reloc_section(file->elf, sec, SHT_RELA))
-		return -1;
-
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, static_call_node) {
 
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -498,11 +498,18 @@ err:
 	return -1;
 }
 
+static struct section *elf_create_reloc_section(struct elf *elf,
+						struct section *base,
+						int reltype);
+
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
 		  unsigned int type, struct symbol *sym, int addend)
 {
 	struct reloc *reloc;
 
+	if (!sec->reloc && !elf_create_reloc_section(elf, sec, SHT_RELA))
+		return -1;
+
 	reloc = malloc(sizeof(*reloc));
 	if (!reloc) {
 		perror("malloc");
@@ -880,7 +887,7 @@ static struct section *elf_create_rela_r
 	return sec;
 }
 
-struct section *elf_create_reloc_section(struct elf *elf,
+static struct section *elf_create_reloc_section(struct elf *elf,
 					 struct section *base,
 					 int reltype)
 {
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -122,7 +122,6 @@ static inline u32 reloc_hash(struct relo
 
 struct elf *elf_open_read(const char *name, int flags);
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
-struct section *elf_create_reloc_section(struct elf *elf, struct section *base, int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
 		  unsigned int type, struct symbol *sym, int addend);
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -222,8 +222,6 @@ int orc_create(struct objtool_file *file
 	sec = elf_create_section(file->elf, ".orc_unwind_ip", 0, sizeof(int), nr);
 	if (!sec)
 		return -1;
-	if (!elf_create_reloc_section(file->elf, sec, SHT_RELA))
-		return -1;
 
 	/* Write ORC entries to sections: */
 	list_for_each_entry(entry, &orc_list, list) {


