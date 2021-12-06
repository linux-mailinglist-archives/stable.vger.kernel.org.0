Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3484946A9B9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbhLFVTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47962 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350954AbhLFVTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:19:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8217CE185C;
        Mon,  6 Dec 2021 21:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CF1C341C6;
        Mon,  6 Dec 2021 21:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825349;
        bh=CtcKASc9UMnknSvliK8E7YX1Ljqy0C2xHCE6Xh0Ics8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL2CzDCOx1kS7dquvVh1H2GJx7AIIWg9YHwPMpmVimpB+X9Y4KtQ6T0z/btBs4Z9g
         BtaYqFZDNyh7otyphtv+C9DD9uytmvZUJ90Sp/VsTIV1mS+IowBcfSVP0YIf2cMex4
         x7mwDpsP9WcGkz6FhDSfQZCudVQpKEpr+HFiFS5st612qF5lEBJujjYy+iYId9xMXg
         6TYlOCT5tueEfH64D6vlQ1c5sXLT0tQDBYSJbJmCEaIe5+wl+xWoWDYnKEPabNAW73
         FsJGWiOd2rl5ZNVtGVXMccRvSP/foaXJbRiQApdbY1OiYr6SPoRIi/JU+iWRIYkGo0
         6izF6nJGS4vgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilie Halip <ilie.halip@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, nathan@kernel.org, svens@linux.ibm.com,
        iii@linux.ibm.com, meted@linux.ibm.com, linux-s390@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 03/15] s390/test_unwind: use raw opcode instead of invalid instruction
Date:   Mon,  6 Dec 2021 16:15:03 -0500
Message-Id: <20211206211520.1660478-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index 6bad84c372dcb..b0b67e6d1f6e2 100644
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

