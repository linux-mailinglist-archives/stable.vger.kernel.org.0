Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7941944B864
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345498AbhKIWm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345347AbhKIWkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:40:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133FD61AEF;
        Tue,  9 Nov 2021 22:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496622;
        bh=0IqvRS0IJRKnNqDAY5t3blXGq9LRZKZOmBpJ5DNEVc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YO3FiKRDJu38GGRJms/atDYj+gVqpgvW/zama0pdHxkxQ5Xm8gZdsbMEboHur3t2B
         /jf02tVx8jeZHA2bhIxlqdzgpjWnga/asZNZCJRKLitNjEgzunQVAzZBSZekOdMwB9
         n36wbXcQmR31hUTPfixm4EyyxmFqIuOwlC0m48gxZNDNr3NuBYQL+VXGOVGnzt5r0v
         gpvWAxHrx9uRO6Y4K4tiPs6w3wNyK2cogIgZEDenxDbeth2oGSj3dHvWXY7zDNWoxx
         UHtJHVvRx9Ct9nlvnCPSyaQKNYW2WY4iDMAAU81rhRxpqHjTMIGunO6lc9ft0wgQ/2
         OkbzlRzWqSzKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 21/21] powerpc/dcr: Use cmplwi instead of 3-argument cmpli
Date:   Tue,  9 Nov 2021 17:23:10 -0500
Message-Id: <20211109222311.1235686-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index e687bb2003ff0..5589fbe48bbdc 100644
--- a/arch/powerpc/sysdev/dcr-low.S
+++ b/arch/powerpc/sysdev/dcr-low.S
@@ -15,7 +15,7 @@
 #include <asm/export.h>
 
 #define DCR_ACCESS_PROLOG(table) \
-	cmpli	cr0,r3,1024;	 \
+	cmplwi	cr0,r3,1024;	 \
 	rlwinm  r3,r3,4,18,27;   \
 	lis     r5,table@h;      \
 	ori     r5,r5,table@l;   \
-- 
2.33.0

