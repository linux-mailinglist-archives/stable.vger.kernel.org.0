Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5322E1D0CBC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbgEMJrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732818AbgEMJrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD11320769;
        Wed, 13 May 2020 09:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363235;
        bh=E0ajzK3FFgn7QwyMlwaqJladPNtV72sfcfKhPvhCaZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO5Q4biOOrV+vHRKCv1U6n53BE8pgIY/hc201MCdrTUsBirw5Gj5sHfPIw+dKq3Pi
         IPah+YPsxs6UOCsxevT5jvhgmdw6QuSPqhKWv3tkSbZkdYky/mTRDVZ1cJFoVlPxxL
         T7GDQvv1VAXOieFCbTxfKhemLNDg8yiB+fis920U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 4.19 40/48] x86/unwind/orc: Dont skip the first frame for inactive tasks
Date:   Wed, 13 May 2020 11:45:06 +0200
Message-Id: <20200513094402.388397680@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

commit f1d9a2abff66aa8156fbc1493abed468db63ea48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/unwind_orc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -629,7 +629,7 @@ void __unwind_start(struct unwind_state
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp <= (unsigned long)first_frame))
+			state->sp < (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;


