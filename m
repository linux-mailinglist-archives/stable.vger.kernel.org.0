Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF25723DB
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiGLSyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbiGLSxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:53:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE93E7AFA;
        Tue, 12 Jul 2022 11:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35C7460A5A;
        Tue, 12 Jul 2022 18:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381DBC3411C;
        Tue, 12 Jul 2022 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651527;
        bh=djZlPbfcpfDt9G8q/aQbamH/xyggUYAi64L1vsv26VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqsWIhEbIr3Y3p0NuoY+CfocaLMRErUZ0dxe66oHJImaRPjCgXd5R1MT+IXmWBBlL
         hwLqhNLnzJQXwaFktxNL+yRdZuz/RGTX8x/apNJEiFz8qDa6+1eEqRDKdJDBpw73QZ
         R04SfGNlUtPKfm3ixSDq+DUHTNvyHiI9x3XzRTt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 076/130] objtool: Fix objtool regression on x32 systems
Date:   Tue, 12 Jul 2022 20:38:42 +0200
Message-Id: <20220712183249.966947589@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    9 +++++----
 tools/objtool/elf.c   |    2 +-
 tools/objtool/elf.h   |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -5,6 +5,7 @@
 
 #include <string.h>
 #include <stdlib.h>
+#include <inttypes.h>
 #include <sys/mman.h>
 
 #include "builtin.h"
@@ -467,12 +468,12 @@ static int add_dead_ends(struct objtool_
 		else if (reloc->addend == reloc->sym->sec->len) {
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
@@ -502,12 +503,12 @@ reachable:
 		else if (reloc->addend == reloc->sym->sec->len) {
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
@@ -510,7 +510,7 @@ static struct section *elf_create_reloc_
 						int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend)
+		  unsigned int type, struct symbol *sym, s64 addend)
 {
 	struct reloc *reloc;
 
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -73,7 +73,7 @@ struct reloc {
 	struct symbol *sym;
 	unsigned long offset;
 	unsigned int type;
-	long addend;
+	s64 addend;
 	int idx;
 	bool jump_table_start;
 };
@@ -127,7 +127,7 @@ struct elf *elf_open_read(const char *na
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend);
+		  unsigned int type, struct symbol *sym, s64 addend);
 int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
 			  unsigned long offset, unsigned int type,
 			  struct section *insn_sec, unsigned long insn_off);


