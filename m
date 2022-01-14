Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2084A48E840
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 11:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiANKUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 05:20:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34056 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiANKUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 05:20:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 342F9B82593;
        Fri, 14 Jan 2022 10:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D04C36AE5;
        Fri, 14 Jan 2022 10:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642155603;
        bh=H2cwqX6hP/TTryeKSioq1szTFJyrpgVKfMYJ0fjXn34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGGhrqVldk+09VVLl6OIP2pxUDg7sugmpHJA8Ski2ERPSJbT7Mh4btQfkgkaOMpze
         yLfnsXM5v++g1rSF50zz+1DKtvlaKg+oMn0D3uJptBZb8oWM5a/lgknSIyNy82IGTt
         mkpbAkSc+2tI4A3dxr1075z5Gfv3ssfWNtpeiU37xhXSpqfgnAh1BmzTI8F9Opd8a4
         QzNDZ06INZCbtk0fUZJuS7SjNiMDndPFxZfEn8GOHVeE8OCigRu4+ENNsP3vkPbyiG
         oQ61NjvLQ7vexK9/OyGQS1v8mX8RnHOjw4h192Rm0KaU4o0y13oNOymOVMOZ8KvVGG
         j9O8xzHA5t23Q==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4.y] Revert "ia64: kprobes: Use generic kretprobe trampoline handler"
Date:   Fri, 14 Jan 2022 19:19:59 +0900
Message-Id: <164215559880.1662358.1475310445318313122.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YeEhuGXr2B9r7mer@kroah.com>
References: <YeEhuGXr2B9r7mer@kroah.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 77fa5e15c933a1ec812de61ad709c00aa51e96ae.

Since the upstream commit e792ff804f49720ce003b3e4c618b5d996256a18
depends on the generic kretprobe trampoline handler, which was
introduced by commit 66ada2ccae4e ("kprobes: Add generic kretprobe
trampoline handler") but that is not ported to the stable kernel
because it is not a bugfix series.
So revert this commit to fix a build error.

NOTE: I keep commit a7fe2378454c ("ia64: kprobes: Fix to pass
correct trampoline address to the handler") on the tree, that seems
just a cleanup without the original reverted commit, but it would
be better to use dereference_function_descriptor() macro instead
of accessing descriptor's field directly.


Fixes: 77fa5e15c933 ("ia64: kprobes: Use generic kretprobe trampoline handler")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/ia64/kernel/kprobes.c |   78 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 8a223d0e4918..5d2d58644378 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -396,10 +396,83 @@ static void kretprobe_trampoline(void)
 {
 }
 
+/*
+ * At this point the target function has been tricked into
+ * returning into our trampoline.  Lookup the associated instance
+ * and then:
+ *    - call the handler function
+ *    - cleanup by marking the instance as unused
+ *    - long jump back to the original return address
+ */
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	regs->cr_iip = __kretprobe_trampoline_handler(regs,
-		dereference_function_descriptor(kretprobe_trampoline), NULL);
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =
+		dereference_function_descriptor(kretprobe_trampoline);
+
+	INIT_HLIST_HEAD(&empty_rp);
+	kretprobe_hash_lock(current, &head, &flags);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more than one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	regs->cr_iip = orig_ret_address;
+
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	kretprobe_hash_unlock(current, &flags);
+
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -412,7 +485,6 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
 	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);

