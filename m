Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F9EA0E1
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfJ3Pz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728570AbfJ3Pz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:26 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13FB21734;
        Wed, 30 Oct 2019 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450926;
        bh=ILInvjgqKHt6USRV+yI3xJFvX/OSj+lwjEbmcOh66G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEMYzks5y5htzcbpcYrKSwg5kT/MajHOiR1ji7GiC/dNdspep6TvnYl7UBaB1szcQ
         mL13Lgmhlu5wFOcul5sFA5w7NQyhpsUMxmkl8n3oFbxiwncq3DwDPD8L9ihziI6ssL
         KkHqTmF0r00ewbnHpKJj/V804GnaEgpEfXBoA/dQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     afzal mohammed <afzal.mohd.ma@gmail.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 28/38] ARM: 8926/1: v7m: remove register save to stack before svc
Date:   Wed, 30 Oct 2019 11:53:56 -0400
Message-Id: <20191030155406.10109-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: afzal mohammed <afzal.mohd.ma@gmail.com>

[ Upstream commit 2ecb287998a47cc0a766f6071f63bc185f338540 ]

r0-r3 & r12 registers are saved & restored, before & after svc
respectively. Intention was to preserve those registers across thread to
handler mode switch.

On v7-M, hardware saves the register context upon exception in AAPCS
complaint way. Restoring r0-r3 & r12 is done from stack location where
hardware saves it, not from the location on stack where these registers
were saved.

To clarify, on stm32f429 discovery board:

1. before svc, sp - 0x90009ff8
2. r0-r3,r12 saved to 0x90009ff8 - 0x9000a00b
3. upon svc, h/w decrements sp by 32 & pushes registers onto stack
4. after svc,  sp - 0x90009fd8
5. r0-r3,r12 restored from 0x90009fd8 - 0x90009feb

Above means r0-r3,r12 is not restored from the location where they are
saved, but since hardware pushes the registers onto stack, the registers
are restored correctly.

Note that during register saving to stack (step 2), it goes past
0x9000a000. And it seems, based on objdump, there are global symbols
residing there, and it perhaps can cause issues on a non-XIP Kernel
(on XIP, data section is setup later).

Based on the analysis above, manually saving registers onto stack is at
best no-op and at worst can cause data section corruption. Hence remove
storing of registers onto stack before svc.

Fixes: b70cd406d7fe ("ARM: 8671/1: V7M: Preserve registers across switch from Thread to Handler mode")
Signed-off-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-v7m.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7m.S b/arch/arm/mm/proc-v7m.S
index 59d82864c134b..9c2978c128d97 100644
--- a/arch/arm/mm/proc-v7m.S
+++ b/arch/arm/mm/proc-v7m.S
@@ -135,7 +135,6 @@ __v7m_setup_cont:
 	dsb
 	mov	r6, lr			@ save LR
 	ldr	sp, =init_thread_union + THREAD_START_SP
-	stmia	sp, {r0-r3, r12}
 	cpsie	i
 	svc	#0
 1:	cpsid	i
-- 
2.20.1

