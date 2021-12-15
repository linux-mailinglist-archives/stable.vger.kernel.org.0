Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7534A475F08
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbhLOR0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbhLORZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21C7C061747;
        Wed, 15 Dec 2021 09:25:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C0B619F3;
        Wed, 15 Dec 2021 17:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C165C36AE3;
        Wed, 15 Dec 2021 17:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589116;
        bh=CtcKASc9UMnknSvliK8E7YX1Ljqy0C2xHCE6Xh0Ics8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7ZOZoPqJf2OnBdaZSo0bY2sL1bYTWn4n0Z0UVNRfN8ouLZL3gKhhU4YO2pQJwbR0
         KQYHfWIJ2cqSKIY6bIAuyKi94aETbwhMqUgRl+dNGP5tWJzXdT+inX1Gjk8wzCCTh5
         AzkrIXshVFXkqxl5N3PIzI0by0S8vQpRdNwoEMDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/33] s390/test_unwind: use raw opcode instead of invalid instruction
Date:   Wed, 15 Dec 2021 18:21:02 +0100
Message-Id: <20211215172024.937266268@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



