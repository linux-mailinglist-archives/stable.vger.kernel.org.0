Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64DA2A1670
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgJaLph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgJaLpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B093D20731;
        Sat, 31 Oct 2020 11:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144736;
        bh=trhU/I+jaGbe4B9RjSg/wW722Vyb82+U182jwnzq44A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcXeWUDQN9ixgF/bRzqAuCRaRdXYWaYytXQaom1zi6sYPhiyv5CeC6zkG2/dUne/J
         CTfxHzOVe6v8TgJqSmP8zaL5MzT7juuyxoyBecuyQxl/3w8j39JHeKcVQrm7yyFwda
         7LxzJ1Pgd0Sm/hloYEE9R3khmEFoKRwlHb9C1L8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.9 54/74] x86/traps: Fix #DE Oops message regression
Date:   Sat, 31 Oct 2020 12:36:36 +0100
Message-Id: <20201031113502.619758674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 5f1ec1fd32252af5130dac23b5542e8e66fe0bcb upstream.

The conversion of #DE to the idtentry mechanism introduced a change in the
Ooops message which confuses tools which parse crash information in dmesg.

Remove the underscore from 'divide_error' to restore previous behaviour.

Fixes: 9d06c4027f21 ("x86/entry: Convert Divide Error to IDTENTRY")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/CACT4Y+bTZFkuZd7+bPArowOv-7Die+WZpfOWnEO_Wgs3U59+oA@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -195,7 +195,7 @@ static __always_inline void __user *erro
 
 DEFINE_IDTENTRY(exc_divide_error)
 {
-	do_error_trap(regs, 0, "divide_error", X86_TRAP_DE, SIGFPE,
+	do_error_trap(regs, 0, "divide error", X86_TRAP_DE, SIGFPE,
 		      FPE_INTDIV, error_get_trap_addr(regs));
 }
 


