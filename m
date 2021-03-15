Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F354533BAB0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhCOOKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234635AbhCOOEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF2A264EE3;
        Mon, 15 Mar 2021 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817077;
        bh=5gBcwOLFuIb3qSYWTghwAo8YrGPi2BXQ9tvkKU8XT9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DU+bPJSq7pOGn4qf8F/v1/hbJ74JmhMQvdFv6VfjcZvC7rLFuRtXCn751UfZqKl0Y
         bS1vo03UWNZ9I2QvEhappP+hVtUOu8r2zp/fN7sF/ZtFl23Fzdmso7OV8RslHPVzMW
         uboOonBKQVzGMlskzg1FGSqtyxIvaMsgKHD+Lsgc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.11 288/306] x86/sev-es: Check regs->sp is trusted before adjusting #VC IST stack
Date:   Mon, 15 Mar 2021 14:55:51 +0100
Message-Id: <20210315135517.422810187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joerg Roedel <jroedel@suse.de>

commit 545ac14c16b5dbd909d5a90ddf5b5a629a40fa94 upstream.

The code in the NMI handler to adjust the #VC handler IST stack is
needed in case an NMI hits when the #VC handler is still using its IST
stack.

But the check for this condition also needs to look if the regs->sp
value is trusted, meaning it was not set by user-space. Extend the check
to not use regs->sp when the NMI interrupted user-space code or the
SYSCALL gap.

Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-3-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -121,8 +121,18 @@ static void __init setup_vc_stacks(int c
 	cea_set_pte((void *)vaddr, pa, PAGE_KERNEL);
 }
 
-static __always_inline bool on_vc_stack(unsigned long sp)
+static __always_inline bool on_vc_stack(struct pt_regs *regs)
 {
+	unsigned long sp = regs->sp;
+
+	/* User-mode RSP is not trusted */
+	if (user_mode(regs))
+		return false;
+
+	/* SYSCALL gap still has user-mode RSP */
+	if (ip_within_syscall_gap(regs))
+		return false;
+
 	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
 }
 
@@ -144,7 +154,7 @@ void noinstr __sev_es_ist_enter(struct p
 	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
 
 	/* Make room on the IST stack */
-	if (on_vc_stack(regs->sp))
+	if (on_vc_stack(regs))
 		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
 	else
 		new_ist = old_ist - sizeof(old_ist);


