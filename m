Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0E1455831
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 10:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbhKRJnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:43:41 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:47629 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245237AbhKRJnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 04:43:10 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Hvvsh0CFtz9sSc;
        Thu, 18 Nov 2021 10:40:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5zKoQQlQXv6t; Thu, 18 Nov 2021 10:40:07 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Hvvsg6Pjgz9sSD;
        Thu, 18 Nov 2021 10:40:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B49D18B7E0;
        Thu, 18 Nov 2021 10:40:07 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id U2lzmI56qWFz; Thu, 18 Nov 2021 10:40:07 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.203.31])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6F5E78B7CA;
        Thu, 18 Nov 2021 10:40:07 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 1AI9ducX122988
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 10:39:56 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 1AI9dskd122980;
        Thu, 18 Nov 2021 10:39:54 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/32: Fix hardlockup on vmap stack overflow
Date:   Thu, 18 Nov 2021 10:39:53 +0100
Message-Id: <ce30364fb7ccda489272af4a1612b6aa147e1d23.1637227521.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1637228389; l=1336; s=20211009; h=from:subject:message-id; bh=/FtuluvJts3chyFFop3qggivUoP6VglfwFD043ogEPk=; b=whNTRzRhj3L0G2IEE03aJFvvaPox5SQuwWmf24H1cSCzFF3yjiW0NwRQqsmWl6V7K1bQ1QHTVXmX K68QJjAsCbtIwFWBElEOJbr4rIEUsAZlf3a03I4KB+WdYkXd8M10
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the commit c118c7303ad5 ("powerpc/32: Fix vmap stack - Do not
activate MMU before reading task struct") a vmap stack overflow
results in a hard lockup. This is because emergency_ctx is still
addressed with its virtual address allthough data MMU is not active
anymore at that time.

Fix it by using a physical address instead.

Fixes: c118c7303ad5 ("powerpc/32: Fix vmap stack - Do not activate MMU before reading task struct")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/kernel/head_32.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
index 6b1ec9e3541b..349c4a820231 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -202,11 +202,11 @@ _ASM_NOKPROBE_SYMBOL(\name\()_virt)
 	mfspr	r1, SPRN_SPRG_THREAD
 	lwz	r1, TASK_CPU - THREAD(r1)
 	slwi	r1, r1, 3
-	addis	r1, r1, emergency_ctx@ha
+	addis	r1, r1, emergency_ctx-PAGE_OFFSET@ha
 #else
-	lis	r1, emergency_ctx@ha
+	lis	r1, emergency_ctx-PAGE_OFFSET@ha
 #endif
-	lwz	r1, emergency_ctx@l(r1)
+	lwz	r1, emergency_ctx-PAGE_OFFSET@l(r1)
 	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
 	EXCEPTION_PROLOG_2 0 vmap_stack_overflow
 	prepare_transfer_to_handler
-- 
2.33.1

