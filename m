Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5123A661
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgHCMZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgHCMZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143F0207DF;
        Mon,  3 Aug 2020 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457555;
        bh=k9WgX49UhER9eYl15sr7XTWMTSzUTaFe3tk7B9RNLmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flgMXCEi80yhHssYGl3xQBRdhr7P/E6Kh0DcE5jnHAx7tDNasjumqOPMuYPtzoNDv
         8z705IJ3DunxayIzdAxlfkgX2QG4/urgK2ed9ul90h3oM1tndt3jeYC41QoHokrep6
         aviDcsQFGOMaU3bNgW9yo6TUhiw0E1NpOR7sMxdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 111/120] x86/stacktrace: Fix reliable check for empty user task stacks
Date:   Mon,  3 Aug 2020 14:19:29 +0200
Message-Id: <20200803121908.300695312@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 039a7a30ec102ec866d382a66f87f6f7654f8140 ]

If a user task's stack is empty, or if it only has user regs, ORC
reports it as a reliable empty stack.  But arch_stack_walk_reliable()
incorrectly treats it as unreliable.

That happens because the only success path for user tasks is inside the
loop, which only iterates on non-empty stacks.  Generally, a user task
must end in a user regs frame, but an empty stack is an exception to
that rule.

Thanks to commit 71c95825289f ("x86/unwind/orc: Fix error handling in
__unwind_start()"), unwind_start() now sets state->error appropriately.
So now for both ORC and FP unwinders, unwind_done() and !unwind_error()
always means the end of the stack was successfully reached.  So the
success path for kthreads is no longer needed -- it can also be used for
empty user tasks.

Reported-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lkml.kernel.org/r/f136a4e5f019219cbc4f4da33b30c2f44fa65b84.1594994374.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/stacktrace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6ad43fc44556e..2fd698e28e4d5 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -58,7 +58,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			 * or a page fault), which can make frame pointers
 			 * unreliable.
 			 */
-
 			if (IS_ENABLED(CONFIG_FRAME_POINTER))
 				return -EINVAL;
 		}
@@ -81,10 +80,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	if (unwind_error(&state))
 		return -EINVAL;
 
-	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
-	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.25.1



