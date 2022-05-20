Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0982052EA54
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 12:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243872AbiETKxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 06:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiETKxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 06:53:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4349A7220E;
        Fri, 20 May 2022 03:53:36 -0700 (PDT)
Date:   Fri, 20 May 2022 10:53:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1653044014;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtSIFPB0YVt45I6/uLYDyp1TV30jOPmQoHnLwn/78wk=;
        b=r3/bKPz8y0DVRXN6jijN+SEFOsWsVvMFlT2Vlh8t7VL9c7AtHmtmeAd9XfIUzrWZOaLTpp
        plhLvsYLmGrwJKfEMr23tzOqy/3KkaPWym/0Ntps8hQ/Hb5VjemDHRxLH4aUniXFWmp+1m
        I1ztvsSEPgvWnzunVTvtDv8/U4i7++XsnkWpme5vJpAtkwd9sdAr+yHNH2Dtx6ZOPCRZmz
        YDsR0oc9ZSksy+ifbfn4YGTN84lbi7Sj5VbpBkgtbYtSsEeCcD4BH3Sp6tbUWmMkJOxVRN
        nGy39fgrUtuGgdm0F02BqIIFXrcyleLaxkOIh5V0zr/PRbQ4Qh63LKDz3m+nwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1653044014;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtSIFPB0YVt45I6/uLYDyp1TV30jOPmQoHnLwn/78wk=;
        b=DerLFG95QxMrCdOIFueUetI+LQ7w/LPtSdeUiFKkhSiRp3+F7jbjhtVUgYsnRLrGmn4AFh
        Mpq3qajp/6dw9EAw==
From:   "tip-bot2 for Mikulas Patocka" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] objtool: Fix objtool regression on x32 systems
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Calpine=2ELRH=2E2=2E02=2E2205161041260=2E1155?=
 =?utf-8?q?6=40file01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
References: =?utf-8?q?=3Calpine=2ELRH=2E2=2E02=2E2205161041260=2E11556?=
 =?utf-8?q?=40file01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <165304401319.4207.18392602354110557584.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     22682a07acc308ef78681572e19502ce8893c4d4
Gitweb:        https://git.kernel.org/tip/22682a07acc308ef78681572e19502ce8893c4d4
Author:        Mikulas Patocka <mpatocka@redhat.com>
AuthorDate:    Mon, 16 May 2022 11:06:36 -04:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 20 May 2022 12:45:30 +02:00

objtool: Fix objtool regression on x32 systems

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
---
 tools/objtool/check.c               |  9 +++++----
 tools/objtool/elf.c                 |  2 +-
 tools/objtool/include/objtool/elf.h |  4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2063f9f..190b2f6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -5,6 +5,7 @@
 
 #include <string.h>
 #include <stdlib.h>
+#include <inttypes.h>
 #include <sys/mman.h>
 
 #include <arch/elf.h>
@@ -561,12 +562,12 @@ static int add_dead_ends(struct objtool_file *file)
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
@@ -596,12 +597,12 @@ reachable:
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
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 7fb6720..c25e957 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -550,7 +550,7 @@ static struct section *elf_create_reloc_section(struct elf *elf,
 						int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend)
+		  unsigned int type, struct symbol *sym, s64 addend)
 {
 	struct reloc *reloc;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index de0cb2f..adebfbc 100644
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
@@ -145,7 +145,7 @@ struct elf *elf_open_read(const char *name, int flags);
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, long addend);
+		  unsigned int type, struct symbol *sym, s64 addend);
 int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
 			  unsigned long offset, unsigned int type,
 			  struct section *insn_sec, unsigned long insn_off);
