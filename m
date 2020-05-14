Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5C51D3B6A
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgENTCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgENSzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70879207ED;
        Thu, 14 May 2020 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482517;
        bh=tV3hihFCckYSQCju7gdBpQgm2eepXq/m+TPTUYqY16w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFx1d6MLAZh/TPZj5moTFCXYJOW9z+Lg/FYiu+rmtAzRQ9L6+u4lj5WmVnC3UHcda
         0IwRTpWRWa0K1cL791x6Ku6pBGHdcv3g1BjLYu2wEOoVUAbcYSSCWuizGbuZH0f5kC
         h4iMWaa7f3g1abpILUgg5iBbyh6aSkT7p6g5WPag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/39] x86/unwind/orc: Don't skip the first frame for inactive tasks
Date:   Thu, 14 May 2020 14:54:31 -0400
Message-Id: <20200514185456.21060-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

[ Upstream commit f1d9a2abff66aa8156fbc1493abed468db63ea48 ]

When unwinding an inactive task, the ORC unwinder skips the first frame
by default.  If both the 'regs' and 'first_frame' parameters of
unwind_start() are NULL, 'state->sp' and 'first_frame' are later
initialized to the same value for an inactive task.  Given there is a
"less than or equal to" comparison used at the end of __unwind_start()
for skipping stack frames, the first frame is skipped.

Drop the equal part of the comparison and make the behavior equivalent
to the frame pointer unwinder.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/7f08db872ab59e807016910acdbe82f744de7065.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 3bbb399f7ead3..8a855867e4568 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -574,7 +574,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp <= (unsigned long)first_frame))
+			state->sp < (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;
-- 
2.20.1

