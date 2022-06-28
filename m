Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5634455E76D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbiF1OoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 10:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiF1OoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 10:44:06 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5986C2CDF0;
        Tue, 28 Jun 2022 07:44:04 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4LXS5s52D1z9tS9;
        Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qwEg0otRXnJ0; Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4LXS5s4DTHz9tS5;
        Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 81BC98B787;
        Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 2tY5ei-4Xxwn; Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.232.132])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4CE348B765;
        Tue, 28 Jun 2022 16:44:01 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 25SEhpji2927453
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 16:43:51 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 25SEhnbD2927421;
        Tue, 28 Jun 2022 16:43:49 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
Date:   Tue, 28 Jun 2022 16:43:35 +0200
Message-Id: <0c33b96317811edf691e81698aaee8fa45ec3449.1656427391.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1656427414; l=1247; s=20211009; h=from:subject:message-id; bh=ifo0bnPDj6AxZwjI6HQHIwja6hG48ZAS1d00mjOTv94=; b=LI5KoZ/TMmHMpVg8pCjmo4Vpb+Xn5NN0gCK6ZEJKijwGWqmqeibnbdg6FPrjleVAsDQezxIeq29Z C9/0gHlRCMV30QkQu9yMGSnizGvmtbLuTF6Uyk8MfEDrWkNQ1IAM
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On FSL_BOOK3E, _PAGE_RW is defined with two bits, one for user and one
for supervisor. As soon as one of the two bits is set, the page has
to be display as RW. But the way it is implemented today requires both
bits to be set in order to display it as RW.

Instead of display RW when _PAGE_RW bits are set and R otherwise,
reverse the logic and display R when _PAGE_RW bits are all 0 and
RW otherwise.

This change has no impact on other platforms as _PAGE_RW is a single
bit on all of them.

Fixes: 8eb07b187000 ("powerpc/mm: Dump linux pagetables")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/mm/ptdump/shared.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
index 03607ab90c66..f884760ca5cf 100644
--- a/arch/powerpc/mm/ptdump/shared.c
+++ b/arch/powerpc/mm/ptdump/shared.c
@@ -17,9 +17,9 @@ static const struct flag_info flag_array[] = {
 		.clear	= "    ",
 	}, {
 		.mask	= _PAGE_RW,
-		.val	= _PAGE_RW,
-		.set	= "rw",
-		.clear	= "r ",
+		.val	= 0,
+		.set	= "r ",
+		.clear	= "rw",
 	}, {
 		.mask	= _PAGE_EXEC,
 		.val	= _PAGE_EXEC,
-- 
2.36.1

