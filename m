Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3EC28B5F1
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbgJLNTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:19:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45300 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387930AbgJLNTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 09:19:07 -0400
Date:   Mon, 12 Oct 2020 13:19:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602508744;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybWsyHyrHHAhl2S1pNVTP+xMA1alQpPGxwDhxlpgcPU=;
        b=SnMK5FcQ3wEX1+5GIIhoZul2Xnvowf4+C6EDhBFFPsHnSjqaIy1kFYFxUqCicVau5KNuAQ
        AVsjSbghmSNA/Zm9fKtYJvrzB1dWnlBnm3y46Zrmi7zU2b3Gf35UC9LLzp8lgfWYABK57U
        My340BQHvnT6W3H7VeKR1njPM8yHhYm2Ftcqb2vdt/mvypDYri1e7oM0qpgS64/Trxol+D
        jWvgV47eGNqTeCDMv3/KT2qTiZui49nvOszSQQzb3lskKyt+HhlRKsSYJQuQi73e3OanG3
        d6IIItoPJS7i2bWZPWSBib8sYM1My0cJXmtqRQOkDc+NkOQb/8GqVwx/IxqG2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602508744;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybWsyHyrHHAhl2S1pNVTP+xMA1alQpPGxwDhxlpgcPU=;
        b=f76NeblQSKqh+mY7YraJG33EArtcRjwj95AlhK+2EkHCXHXxKY2C00UHr3L3szg1G6xSfx
        QHONY6jrzBSd4wCA==
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
Message-ID: <160250874375.7002.5021989482130567145.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     20802fef73a5a98b6e8ed1c0aeca82994d835b13
Gitweb:        https://git.kernel.org/tip/20802fef73a5a98b6e8ed1c0aeca82994d835b13
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 12 Oct 2020 15:11:47 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 12 Oct 2020 15:16:56 +02:00

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
 
