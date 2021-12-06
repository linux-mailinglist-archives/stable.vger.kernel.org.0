Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E871A46A958
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350347AbhLFVRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350355AbhLFVQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:16:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E57C061359;
        Mon,  6 Dec 2021 13:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73D3BCE1411;
        Mon,  6 Dec 2021 21:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55F0C341C6;
        Mon,  6 Dec 2021 21:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825204;
        bh=ewmuxsY11nEr8SFgDbQVXcVDgcxMTM324HMwRtemalk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVxWkZ2JiM+rUYpzfw5AhoczNGCtBVMq16DbnibjhljtOQ2xAksAG0Q0sIZqJvDpL
         ajq2ZbGIUdFb06nvc0oIdM1D0b2GigOORRTRtsA0sW1ch8E390X8atcbdSdY3uGmhJ
         /aUl1q7mMZBTsaMAeFb0AXzke7Nm5FdF44R4ZLGISUqrb+BA0rE/0khyUO/o51pWru
         l18zjaR8NQcsd+rPAlqSMg/l0VjUv07X/1Ct1/IKncHLjvntRQ4WDOVNXRYouXPsoj
         qJaB1N/t4kIkiJCivxqAJkeHsLo2fd6dOr2GbSY+ztJwkh5zYvtYENe0PWavE9gw9H
         UtlA+dTuY8RoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilie Halip <ilie.halip@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, nathan@kernel.org, meted@linux.ibm.com,
        linux-s390@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 06/24] s390/test_unwind: use raw opcode instead of invalid instruction
Date:   Mon,  6 Dec 2021 16:12:11 -0500
Message-Id: <20211206211230.1660072-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilie Halip <ilie.halip@gmail.com>

[ Upstream commit 53ae7230918154d1f4281d7aa3aae9650436eadf ]

Building with clang & LLVM_IAS=1 leads to an error:
    arch/s390/lib/test_unwind.c:179:4: error: invalid register pair
                        "       mvcl    %%r1,%%r1\n"
                        ^

The test creates an invalid instruction that would trap at runtime, but the
LLVM inline assembler tries to validate it at compile time too.

Use the raw instruction opcode instead.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ilie Halip <ilie.halip@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1421
Link: https://lore.kernel.org/r/20211117174822.3632412-1-ilie.halip@gmail.com
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
[hca@linux.ibm.com: use illegal opcode, and update comment]
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/test_unwind.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
index ecf327d743a03..c0635cf787e31 100644
--- a/arch/s390/lib/test_unwind.c
+++ b/arch/s390/lib/test_unwind.c
@@ -171,10 +171,11 @@ static noinline int unwindme_func4(struct unwindme *u)
 		}
 
 		/*
-		 * trigger specification exception
+		 * Trigger operation exception; use insn notation to bypass
+		 * llvm's integrated assembler sanity checks.
 		 */
 		asm volatile(
-			"	mvcl	%%r1,%%r1\n"
+			"	.insn	e,0x0000\n"	/* illegal opcode */
 			"0:	nopr	%%r7\n"
 			EX_TABLE(0b, 0b)
 			:);
-- 
2.33.0

