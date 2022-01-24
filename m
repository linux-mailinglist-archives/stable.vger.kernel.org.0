Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C324998BD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352412AbiAXV3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377371AbiAXVSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:18:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C92B812A7;
        Mon, 24 Jan 2022 21:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A72C340E5;
        Mon, 24 Jan 2022 21:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059115;
        bh=zW8E6nDHYA+IOGgYE859eoZ7bTAfChWLdJJ/+NaK2gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIunj2+sdZxA66iYdpBgZ3Tz5WmqwY5TRk0Ka5d38w34UvrVKSHkOm6EQvf2T21HR
         v3FzIEEhYsDdi9tgmHrlPhZf78gTnFcQ95HdGEgrjkBkBDEWa6vyNCn8/Pdeh7W4T0
         7GQvHAii1+jziBMKTRhsnmjxI/KqwHKsBI+ue3o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0508/1039] powerpc/64s: Use EMIT_WARN_ENTRY for SRR debug warnings
Date:   Mon, 24 Jan 2022 19:38:17 +0100
Message-Id: <20220124184142.359193641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit fd1eaaaaa6864b5fb8f99880fcefb49760b8fe4e ]

When CONFIG_PPC_RFI_SRR_DEBUG=y we check the SRR values before returning
from interrupts. This is done in asm using EMIT_BUG_ENTRY, and passing
BUGFLAG_WARNING.

However that fails to create an exception table entry for the warning,
and so do_program_check() fails the exception table search and proceeds
to call _exception(), resulting in an oops like:

  Oops: Exception in kernel mode, sig: 5 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in:
  CPU: 2 PID: 1204 Comm: sigreturn_unali Tainted: P                  5.16.0-rc2-00194-g91ca3d4f77c5 #12
  NIP:  c00000000000c5b0 LR: 0000000000000000 CTR: 0000000000000000
  ...
  NIP [c00000000000c5b0] system_call_common+0x150/0x268
  LR [0000000000000000] 0x0
  Call Trace:
  [c00000000db73e10] [c00000000000c558] system_call_common+0xf8/0x268 (unreliable)
  ...
  Instruction dump:
  7cc803a6 888d0931 2c240000 4082001c 38800000 988d0931 e8810170 e8a10178
  7c9a03a6 7cbb03a6 7d7a02a6 e9810170 <7f0b6088> 7d7b02a6 e9810178 7f0b6088

We should instead use EMIT_WARN_ENTRY, which creates an exception table
entry for the warning, allowing the warning to be correctly recognised,
and the code to resume after printing the warning.

Note however that because this warning is buried deep in the interrupt
return path, we are not able to recover from it (due to MSR_RI being
clear), so we still end up in die() with an unrecoverable exception.

Fixes: 59dc5bfca0cb ("powerpc/64s: avoid reloading (H)SRR registers if they are still valid")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211221135101.2085547-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt_64.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index 894588b2381e5..4b1ff94e67eb4 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -32,21 +32,21 @@ COMPAT_SYS_CALL_TABLE:
 	ld	r12,_NIP(r1)
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
-	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
+	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	mfspr	r11,SPRN_SRR1
 	ld	r12,_MSR(r1)
 100:	tdne	r11,r12
-	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
+	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	.else
 	mfspr	r11,SPRN_HSRR0
 	ld	r12,_NIP(r1)
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
-	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
+	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	mfspr	r11,SPRN_HSRR1
 	ld	r12,_MSR(r1)
 100:	tdne	r11,r12
-	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
+	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	.endif
 #endif
 .endm
-- 
2.34.1



