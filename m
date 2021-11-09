Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A638A44B820
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345492AbhKIWkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345553AbhKIWiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 146B861B08;
        Tue,  9 Nov 2021 22:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496589;
        bh=w5Xb6WCzlZ8aPhmrZpZHwKQX/kb2t2tuhtwlxNHDG2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KowI1qtWbF5z8vso6SCzdiY8lDUcTt9G+aKeFPi536R5UDvO37AofNIejhVz1t5RB
         rG+AXt6cRJ2ODpGiTyTEeMG+ng37Ol/33G4pMGzrMxLni0OyzM+NR3euH8wfQiEZx0
         OjU/6HV72hKM0ArXCme50NvygqMzVPuYBdNwxM1KGRCqstjobjQoRTqnGQXXqffAvp
         wGe0cIJczdwzUaDysh4luxdQgBHbqRTmlOM1P9Wo/2gFVdZWI2Mdtb+9r9J/DNE1UE
         dLaeXY4mDJKBa15k56Y1NDcYI93WamVaS6tgba9nybAjZNBjfiM8WDXg1unAfbYF+K
         u7bpDaJpQRQ0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 30/30] powerpc/dcr: Use cmplwi instead of 3-argument cmpli
Date:   Tue,  9 Nov 2021 17:22:24 -0500
Message-Id: <20211109222224.1235388-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
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
index efeeb1b885a17..329b9c4ae5429 100644
--- a/arch/powerpc/sysdev/dcr-low.S
+++ b/arch/powerpc/sysdev/dcr-low.S
@@ -11,7 +11,7 @@
 #include <asm/export.h>
 
 #define DCR_ACCESS_PROLOG(table) \
-	cmpli	cr0,r3,1024;	 \
+	cmplwi	cr0,r3,1024;	 \
 	rlwinm  r3,r3,4,18,27;   \
 	lis     r5,table@h;      \
 	ori     r5,r5,table@l;   \
-- 
2.33.0

