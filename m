Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7087F1CABA4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgEHMpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbgEHMpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96042495A;
        Fri,  8 May 2020 12:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941930;
        bh=j01xWAyAuNXnR8tamYGcqZmr1N98cWIMCIaKrTG0R6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEJxgQuF0u8AqvgBJqiSOSbcbD0iTJaD9aYVzQyVMP8+uaRB+k7rJAXH6fenOMdaz
         IUTiFqboZzEMZVXud/M5P9va/ZxshgtIxOoVDB2Ejn5Ka1NYMvpllQIWXt0iWDko6g
         sKHkfgCtE6lAE/BvJrjIpYIb5Lb7I9NIuUKP48Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikram Mulukutla <markivx@codeaurora.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 227/312] sched/preempt: Fix preempt_count manipulations
Date:   Fri,  8 May 2020 14:33:38 +0200
Message-Id: <20200508123140.416041207@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 2e636d5e66c35dfcbaf617aa8fa963f6847478fe upstream.

Vikram reported that his ARM64 compiler managed to 'optimize' away the
preempt_count manipulations in code like:

	preempt_enable_no_resched();
	put_user();
	preempt_disable();

Irrespective of that fact that that is horrible code that should be
fixed for many reasons, it does highlight a deficiency in the generic
preempt_count manipulators. As it is never right to combine/elide
preempt_count manipulations like this.

Therefore sprinkle some volatile in the two generic accessors to
ensure the compiler is aware of the fact that the preempt_count is
observed outside of the regular program-order view and thus cannot be
optimized away like this.

x86; the only arch not using the generic code is not affected as we
do all this in asm in order to use the segment base per-cpu stuff.

Reported-by: Vikram Mulukutla <markivx@codeaurora.org>
Tested-by: Vikram Mulukutla <markivx@codeaurora.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: a787870924db ("sched, arch: Create asm/preempt.h")
Link: http://lkml.kernel.org/r/20160516131751.GH3205@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/preempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -7,10 +7,10 @@
 
 static __always_inline int preempt_count(void)
 {
-	return current_thread_info()->preempt_count;
+	return READ_ONCE(current_thread_info()->preempt_count);
 }
 
-static __always_inline int *preempt_count_ptr(void)
+static __always_inline volatile int *preempt_count_ptr(void)
 {
 	return &current_thread_info()->preempt_count;
 }


