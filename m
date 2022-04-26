Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B442251006B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiDZO32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351430AbiDZO31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC35D5C9;
        Tue, 26 Apr 2022 07:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71671617AE;
        Tue, 26 Apr 2022 14:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA6EC385AE;
        Tue, 26 Apr 2022 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650983178;
        bh=+pviJEHEPY7xSyoldMNeJDLAsyBeQND2yf9wX2ALFiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoJMmo1zksOUlWA6/FrWY0ijxv30NgpVcd+lvd8NsnieGJO1FIn7PksitNelI+6QT
         yNrkqbD0KoASj73+6V1RRyhVleUyDnqUAXqlKro/jNs/N1O1oTocoVVe9wLsGTO5IJ
         DPiVJX+reN+gUYtR0YWQ0vcJK3CO09ZHyVxbDnGd3o9JdgA9aG9SJEY7gdXZU08x6e
         K9XnzlroIhyeFRSgHk6wVWFlinSJXfJzqdTXTOsc3E+eO7G7xejOhCMN+JJY6Zg2iB
         9gZ5UMHfymxDJHjNYB4trAMa3cMWlqTQiB7mTHk6xSfUgP1FJi5hODjxH3A3qc+m+1
         1zeHl6s/uLQYA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19.y 2/3] Revert "ia64: kprobes: Use generic kretprobe trampoline handler"
Date:   Tue, 26 Apr 2022 23:26:14 +0900
Message-Id: <165098317414.1366179.8363938856817159557.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <165098315444.1366179.5950180330185498273.stgit@devnote2>
References: <165098315444.1366179.5950180330185498273.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d3380de483d55d904fb94a241406b34ed2fada7d.

Since this commit is a part of generic kretprobe trampoline
handler series, without the other patches in that series, this
causes a build error on ia64.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/ia64/kernel/kprobes.c |   77 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 8207b897b49d..aa41bd5cf9b7 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -409,9 +409,83 @@ static void kretprobe_trampoline(void)
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
-	regs->cr_iip = __kretprobe_trampoline_handler(regs, kretprobe_trampoline, NULL);
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =
+		((struct fnptr *)kretprobe_trampoline)->ip;
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
@@ -424,7 +498,6 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
 	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;

