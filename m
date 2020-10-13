Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4A28D339
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 19:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJMRlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 13:41:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53386 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJMRlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 13:41:22 -0400
Date:   Tue, 13 Oct 2020 17:41:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602610880;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMpEN2mv7qdA1jR5W9jZ0sYICRq/vzVTpwFzTeEn8MA=;
        b=IkLi6Vx18NVu9WcjO6EOcpZJiH1Ac7aGntJXdK4znnubglcPyzFbUPI604G231lPEJDLqM
        c44J+E1Lb11qRkW+BcfNLcrf47x687YT87VUT8Wo4gon8/G9dU4xVQZSFyniBuc7n6M3Oh
        u/k3sMNY1+9xeDgpT03+NMhbQuDAFEWWur7IpPbWvyPFUkuUoidzyJ3eUBkC+PI28yyDAq
        LivFGUXKvjOH/dYfaO1/B4+G/Gr0xCg1d/wuSJ4eh0TA9Offesoiv8urljwA8hWDZjWecp
        xcUqownXHsGBEqtCnn6gAMMDV/ZGYzj0jOCTn0XVKaKmzfIOXiQpc1yLaa/JBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602610880;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMpEN2mv7qdA1jR5W9jZ0sYICRq/vzVTpwFzTeEn8MA=;
        b=G4QcCB4l3LYdfGGhhCOqAnnNMB1L893kkVEaZrc0/x19EbarlRliR0Tz9QwGEiEEUAZgYH
        yM5xQ9NiJ2LCSVAw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/traps: Fix #DE Oops message regression
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CACT4Y+bTZFkuZd7+bPArowOv-7Die+WZpfOWnEO_Wgs3U59+oA@mail.gmail.com>
References: <CACT4Y+bTZFkuZd7+bPArowOv-7Die+WZpfOWnEO_Wgs3U59+oA@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <160261087970.7002.5363547782831704972.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5f1ec1fd32252af5130dac23b5542e8e66fe0bcb
Gitweb:        https://git.kernel.org/tip/5f1ec1fd32252af5130dac23b5542e8e66fe0bcb
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 12 Oct 2020 15:11:47 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 13 Oct 2020 19:17:33 +02:00

x86/traps: Fix #DE Oops message regression

The conversion of #DE to the idtentry mechanism introduced a change in the
Ooops message which confuses tools which parse crash information in dmesg.

Remove the underscore from 'divide_error' to restore previous behaviour.

Fixes: 9d06c4027f21 ("x86/entry: Convert Divide Error to IDTENTRY")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/CACT4Y+bTZFkuZd7+bPArowOv-7Die+WZpfOWnEO_Wgs3U59+oA@mail.gmail.com
---
 arch/x86/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 81a2fb7..316ce1c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -195,7 +195,7 @@ static __always_inline void __user *error_get_trap_addr(struct pt_regs *regs)
 
 DEFINE_IDTENTRY(exc_divide_error)
 {
-	do_error_trap(regs, 0, "divide_error", X86_TRAP_DE, SIGFPE,
+	do_error_trap(regs, 0, "divide error", X86_TRAP_DE, SIGFPE,
 		      FPE_INTDIV, error_get_trap_addr(regs));
 }
 
