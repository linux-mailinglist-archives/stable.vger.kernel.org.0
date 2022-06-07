Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4805541DE0
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380625AbiFGWWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385141AbiFGWVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F33265612;
        Tue,  7 Jun 2022 12:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D504ECE24B7;
        Tue,  7 Jun 2022 19:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEEEC34115;
        Tue,  7 Jun 2022 19:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629652;
        bh=OcqvoIrpHGaxqSVYLx7xboNx4qStc91n6ZMjlVtDwLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpoCk8WJdDJ4kh1TqffxOHoHDYoMyTqruGtp1wTtNqsjqqytp4JMSt9rFslQiJDG3
         uWwogecWYA36Wqn+/XINFaParrUqAaSHz5XaLMvYIcasMA6RxIWkYcWthOVkDLQSEt
         s7XZlZ5edN7aOx+Cbv5mqQUfjWaPSd5/9wNZybn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.18 717/879] objtool: Fix objtool regression on x32 systems
Date:   Tue,  7 Jun 2022 19:03:55 +0200
Message-Id: <20220607165023.666075498@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 22682a07acc308ef78681572e19502ce8893c4d4 upstream.

Commit c087c6e7b551 ("objtool: Fix type of reloc::addend") failed to
appreciate cross building from ILP32 hosts, where 'int' == 'long' and
the issue persists.

As such, use s64/int64_t/Elf64_Sxword for this field and suffer the
pain that is ISO C99 printf formats for it.

Fixes: c087c6e7b551 ("objtool: Fix type of reloc::addend")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[peterz: reword changelog, s/long long/s64/]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/alpine.LRH.2.02.2205161041260.11556@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c               |    9 +++++----
 tools/objtool/elf.c                 |    2 +-
 tools/objtool/include/objtool/elf.h |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -5,6 +5,7 @@
 
 #include <string.h>
 #include <stdlib.h>
+#include <inttypes.h>
 #include <sys/mman.h>
 
 #include <arch/elf.h>
@@ -560,12 +561,12 @@ static int add_dead_ends(struct objtool_
 		else if (reloc->addend == reloc->sym->sec->sh.sh_size) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find unreachable insn at %s+0x%lx",
+				WARN("can't find unreachable insn at %s+0x%" PRIx64,
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find unreachable insn at %s+0x%lx",
+			WARN("can't find unreachable insn at %s+0x%" PRIx64,
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
@@ -595,12 +596,12 @@ reachable:
 		else if (reloc->addend == reloc->sym->sec->sh.sh_size) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find reachable insn at %s+0x%lx",
+				WARN("can't find reachable insn at %s+0x%" PRIx64,
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find reachable insn at %s+0x%lx",
+			WARN("can't find reachable insn at %s+0x%" PRIx64,
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -546,7 +546,7 @@ static struct section *elf_create_reloc_
 						int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend)
+		  unsigned int type, struct symbol *sym, s64 addend)
 {
 	struct reloc *reloc;
 
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -73,7 +73,7 @@ struct reloc {
 	struct symbol *sym;
 	unsigned long offset;
 	unsigned int type;
-	long addend;
+	s64 addend;
 	int idx;
 	bool jump_table_start;
 };
@@ -135,7 +135,7 @@ struct elf *elf_open_read(const char *na
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend);
+		  unsigned int type, struct symbol *sym, s64 addend);
 int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
 			  unsigned long offset, unsigned int type,
 			  struct section *insn_sec, unsigned long insn_off);


