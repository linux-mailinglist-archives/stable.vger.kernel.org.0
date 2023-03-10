Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8556B4128
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCJNuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjCJNuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:50:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF05EB8BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88AF6B822B7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5283C433EF;
        Fri, 10 Mar 2023 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456200;
        bh=o1/uZuPE36cV9dBwMATo8RhQg0LXbBsq+HQEVEOUa/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTVGoDlxo/qt9q3C/c0uxJwf1QrkSdr+X3o6cFlMj7xXflBU5/rD6attSwyW59R6T
         90G/vEPuwykbkKAy+5ABF0CsuAIe5M2t//8wEqH5KCshpOO61lQpEFBbyjgUoJOkaU
         NbwLnwgqJIdEs8zthOBCES0YqQOc2fi/KMsDhwWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 4.14 115/193] x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
Date:   Fri, 10 Mar 2023 14:38:17 +0100
Message-Id: <20230310133715.104889079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

commit 868a6fc0ca2407622d2833adefe1c4d284766c4c upstream.

Since the following commit:

  commit f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")

modified the update timing of the KPROBE_FLAG_OPTIMIZED, a optimized_kprobe
may be in the optimizing or unoptimizing state when op.kp->flags
has KPROBE_FLAG_OPTIMIZED and op->list is not empty.

The __recover_optprobed_insn check logic is incorrect, a kprobe in the
unoptimizing state may be incorrectly determined as unoptimizing.
As a result, incorrect instructions are copied.

The optprobe_queued_unopt function needs to be exported for invoking in
arch directory.

Link: https://lore.kernel.org/all/20230216034247.32348-2-yangjihong1@huawei.com/

Fixes: f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/opt.c |    4 ++--
 include/linux/kprobes.h       |    1 +
 kernel/kprobes.c              |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -56,8 +56,8 @@ unsigned long __recover_optprobed_insn(k
 		/* This function only handles jump-optimized kprobe */
 		if (kp && kprobe_optimized(kp)) {
 			op = container_of(kp, struct optimized_kprobe, kp);
-			/* If op->list is not empty, op is under optimizing */
-			if (list_empty(&op->list))
+			/* If op is optimized or under unoptimizing */
+			if (list_empty(&op->list) || optprobe_queued_unopt(op))
 				goto found;
 		}
 	}
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -353,6 +353,7 @@ extern int proc_kprobes_optimization_han
 					     size_t *length, loff_t *ppos);
 #endif
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -626,7 +626,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 


