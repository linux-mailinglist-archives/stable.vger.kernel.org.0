Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763D9F554B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390194AbfKHTB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390188AbfKHTB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE70D21D7E;
        Fri,  8 Nov 2019 19:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239688;
        bh=ILInvjgqKHt6USRV+yI3xJFvX/OSj+lwjEbmcOh66G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hdqo7MgoGlUbip/6z7OFyKxdBdtloKVScg+LlY4AagM3l5VeVam6L2WhI6IqoIFj+
         9NDfP8dmiEjM27C3jOVeAfG1N2A4YtGTW+oLyc5DTy8MxyVHvBuiSIR6AZarjpqJto
         Urhl/zqDa4Nt8XBK05/6CP6hsTpD4nyAel0LWF/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, afzal mohammed <afzal.mohd.ma@gmail.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/79] ARM: 8926/1: v7m: remove register save to stack before svc
Date:   Fri,  8 Nov 2019 19:50:07 +0100
Message-Id: <20191108174800.916142823@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



