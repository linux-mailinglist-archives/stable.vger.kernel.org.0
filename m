Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F60645BAEA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbhKXMP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242818AbhKXMMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A386860F90;
        Wed, 24 Nov 2021 12:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755617;
        bh=iudG8ri3aafLAIe2fV+orn+ebUq8ci3wOfMOvnn/MR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDu1tDzDPErYLE2n8HM9O/3tTgDbAAxo1/hlGX/537FqtXfzil8kZ+EG2cH8vgHhI
         slbWf5vbgeWeGGRqh9rOxZmLveXKjVPvB0bnKPv3zsWCOtc10RKMnOCQvlodKhlXyU
         TnzExC0XksZHItf+lZwdnIc4GOcGrF46Ivxb6CIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 128/162] powerpc/dcr: Use cmplwi instead of 3-argument cmpli
Date:   Wed, 24 Nov 2021 12:57:11 +0100
Message-Id: <20211124115702.436823872@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit fef071be57dc43679a32d5b0e6ee176d6f12e9f2 ]

In dcr-low.S we use cmpli with three arguments, instead of four
arguments as defined in the ISA:

	cmpli	cr0,r3,1024

This appears to be a PPC440-ism, looking at the "PPC440x5 CPU Core
User’s Manual" it shows cmpli having no L field, but implied to be 0 due
to the core being 32-bit. It mentions that the ISA defines four
arguments and recommends using cmplwi.

It also corresponds to the old POWER instruction set, which had no L
field there, a reserved bit instead.

dcr-low.S is only built 32-bit, because it is only built when
DCR_NATIVE=y, which is only selected by 40x and 44x. Looking at the
generated code (with gcc/gas) we see cmplwi as expected.

Although gas is happy with the 3-argument version when building for
32-bit, the LLVM assembler is not and errors out with:

  arch/powerpc/sysdev/dcr-low.S:27:10: error: invalid operand for instruction
   cmpli 0,%r3,1024; ...
           ^

Switch to the cmplwi extended opcode, which avoids any confusion when
reading the ISA, fixes the issue with the LLVM assembler, and also means
the code could be built 64-bit in future (though that's very unlikely).

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
BugLink: https://github.com/ClangBuiltLinux/linux/issues/1419
Link: https://lore.kernel.org/r/20211014024424.528848-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/dcr-low.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/dcr-low.S b/arch/powerpc/sysdev/dcr-low.S
index d3098ef1404a2..3943d19d5f63b 100644
--- a/arch/powerpc/sysdev/dcr-low.S
+++ b/arch/powerpc/sysdev/dcr-low.S
@@ -14,7 +14,7 @@
 #include <asm/bug.h>
 
 #define DCR_ACCESS_PROLOG(table) \
-	cmpli	cr0,r3,1024;	 \
+	cmplwi	cr0,r3,1024;	 \
 	rlwinm  r3,r3,4,18,27;   \
 	lis     r5,table@h;      \
 	ori     r5,r5,table@l;   \
-- 
2.33.0



