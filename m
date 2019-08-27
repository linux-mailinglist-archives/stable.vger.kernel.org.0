Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6249E0C2
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbfH0IFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732430AbfH0IFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132892173E;
        Tue, 27 Aug 2019 08:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893142;
        bh=VXwVDTiltX/zKo5qXYVnCLq9PB59320XB21Bwv/rLUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfYjY5oFDUSko45BFb1TMMTWf2IO/5raZ02VVIC2RLTwbzLNI5Q53dcCuP//wJGpf
         EMHMfmbEmL+pw3Ssadnmwzbnf9/ruKFULWUbQsDPVdc/b3ylD72hNcMWGMTRLVucxi
         668QtAdOWJ7X793esEoUbYVvtiki/XPs9rNd+HDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jason Xing <kerneljasonxing@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 134/162] psi: get poll_work to run when calling poll syscall next time
Date:   Tue, 27 Aug 2019 09:51:02 +0200
Message-Id: <20190827072743.237942008@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Xing <kerneljasonxing@linux.alibaba.com>

commit 7b2b55da1db10a5525460633ae4b6fb0be060c41 upstream.

Only when calling the poll syscall the first time can user receive
POLLPRI correctly.  After that, user always fails to acquire the event
signal.

Reproduce case:
 1. Get the monitor code in Documentation/accounting/psi.txt
 2. Run it, and wait for the event triggered.
 3. Kill and restart the process.

The question is why we can end up with poll_scheduled = 1 but the work
not running (which would reset it to 0).  And the answer is because the
scheduling side sees group->poll_kworker under RCU protection and then
schedules it, but here we cancel the work and destroy the worker.  The
cancel needs to pair with resetting the poll_scheduled flag.

Link: http://lkml.kernel.org/r/1566357985-97781-1-git-send-email-joseph.qi@linux.alibaba.com
Signed-off-by: Jason Xing <kerneljasonxing@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Caspar Zhang <caspar@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/psi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1131,7 +1131,15 @@ static void psi_trigger_destroy(struct k
 	 * deadlock while waiting for psi_poll_work to acquire trigger_lock
 	 */
 	if (kworker_to_destroy) {
+		/*
+		 * After the RCU grace period has expired, the worker
+		 * can no longer be found through group->poll_kworker.
+		 * But it might have been already scheduled before
+		 * that - deschedule it cleanly before destroying it.
+		 */
 		kthread_cancel_delayed_work_sync(&group->poll_work);
+		atomic_set(&group->poll_scheduled, 0);
+
 		kthread_destroy_worker(kworker_to_destroy);
 	}
 	kfree(t);


