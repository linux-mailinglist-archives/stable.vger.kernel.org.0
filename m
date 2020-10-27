Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D089D299D4E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438643AbgJ0AFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437745AbgJ0AEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0091321707;
        Tue, 27 Oct 2020 00:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757086;
        bh=gfvhf4cXfm1kfoCV7H8bBKlJtQofh/7DqlLNEQRLPXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVRtfM8hUuzLcERLvLuBkq4+R7Bwv1/+JxPaqmXylucURyQoWf3PTRh9p6T/aihw9
         SaayicOJC8tw6II/HpoiZSD9/B+uKOCrCuBGh5rZwifAIj87m0I2+qLVsjDrhpJrnn
         pe9t+cvJuITpZ0hlvSur7QkvD1zlPsuWolU8zR7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/60] ia64: kprobes: Use generic kretprobe trampoline handler
Date:   Mon, 26 Oct 2020 20:03:40 -0400
Message-Id: <20201027000415.1026364-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit e792ff804f49720ce003b3e4c618b5d996256a18 ]

Use the generic kretprobe trampoline handler. Don't use
framepointer verification.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/159870606883.1229682.12331813108378725668.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/kprobes.c | 77 +-------------------------------------
 1 file changed, 2 insertions(+), 75 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index aa41bd5cf9b77..8207b897b49dd 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -409,83 +409,9 @@ static void kretprobe_trampoline(void)
 {
 }
 
-/*
- * At this point the target function has been tricked into
- * returning into our trampoline.  Lookup the associated instance
- * and then:
- *    - call the handler function
- *    - cleanup by marking the instance as unused
- *    - long jump back to the original return address
- */
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =
-		((struct fnptr *)kretprobe_trampoline)->ip;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	kretprobe_hash_lock(current, &head, &flags);
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more than one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	regs->cr_iip = orig_ret_address;
-
-	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-
-	kretprobe_hash_unlock(current, &flags);
-
-	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
+	regs->cr_iip = __kretprobe_trampoline_handler(regs, kretprobe_trampoline, NULL);
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -498,6 +424,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
+	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
 	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
-- 
2.25.1

