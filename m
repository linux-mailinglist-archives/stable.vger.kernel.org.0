Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFD106B61
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfKVKnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbfKVKnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B95205C9;
        Fri, 22 Nov 2019 10:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419427;
        bh=pVwVyxF2N9wnorQ5Bgsg+Gc9P53KWGzWUXl79vsexVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQJhvRlMu/JUst4VDlLjb6/Hp37gfDowrse8vMGaNY14OmYnbMKQCa43fp6XQMlaQ
         L4k0infZz8v+POadT0QtzszRVpMl5j0a3RhGafx2Q8BJQeyL57NuNoZt+2u9kfuDfk
         H5p3fLUjgbhhDWGJjx6KGWZflTDOcIjs7iwg5Ntc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Whitehead <tedheadster@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/222] x86/CPU: Use correct macros for Cyrix calls
Date:   Fri, 22 Nov 2019 11:27:27 +0100
Message-Id: <20191122100911.032076915@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Whitehead <tedheadster@gmail.com>

[ Upstream commit 03b099bdcdf7125d4a63dc9ddeefdd454e05123d ]

There are comments in processor-cyrix.h advising you to _not_ make calls
using the deprecated macros in this style:

  setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);

This is because it expands the macro into a non-functioning calling
sequence. The calling order must be:

  outb(CX86_CCR2, 0x22);
  inb(0x23);

>From the comments:

 * When using the old macros a line like
 *   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
 * gets expanded to:
 *  do {
 *    outb((CX86_CCR2), 0x22);
 *    outb((({
 *        outb((CX86_CCR2), 0x22);
 *        inb(0x23);
 *    }) | 0x88), 0x23);
 *  } while (0);

The new macros fix this problem, so use them instead.

Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jia Zhang <qianyue.zj@alibaba-inc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20180921212041.13096-2-tedheadster@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cyrix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 311d0fad17e6b..a4f6e0ec4ba0f 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -434,7 +434,7 @@ static void cyrix_identify(struct cpuinfo_x86 *c)
 			/* enable MAPEN  */
 			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
 			/* enable cpuid  */
-			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);
+			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);
 			/* disable MAPEN */
 			setCx86(CX86_CCR3, ccr3);
 			local_irq_restore(flags);
-- 
2.20.1



