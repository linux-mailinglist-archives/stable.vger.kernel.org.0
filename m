Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09410BBCE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733081AbfK0VN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387501AbfK0VN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC54215F1;
        Wed, 27 Nov 2019 21:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889238;
        bh=MgOEtWYhOE6SVZmkuHBHGrnENDDruSYWQVQkdx+NfM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgyRpmXayClq6y5TD8skfu6UN0tpU7iEYKZAbSQAnCevvEEP+il5iWh7yiYDYOzyB
         fJyaOy4Cqyk3CUVGimrruF81QZqCXq1IHiy4YCw7xXasi6Ka5qltriCUgWkE4j0gXw
         ZzbxV9Di073CgHsYwInfZ8Z4L1FobYk744p+QKc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 40/66] futex: Set task::futex_state to DEAD right after handling futex exit
Date:   Wed, 27 Nov 2019 21:32:35 +0100
Message-Id: <20191127202721.242075821@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit f24f22435dcc11389acc87e5586239c1819d217c upstream.

Setting task::futex_state in do_exit() is rather arbitrarily placed for no
reason. Move it into the futex code.

Note, this is only done for the exit cleanup as the exec cleanup cannot set
the state to FUTEX_STATE_DEAD because the task struct is still in active
use.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.439511191@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c  |    1 -
 kernel/futex.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -837,7 +837,6 @@ void __noreturn do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
-	futex_exit_done(tsk);
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3682,6 +3682,7 @@ void futex_exec_release(struct task_stru
 void futex_exit_release(struct task_struct *tsk)
 {
 	futex_exec_release(tsk);
+	futex_exit_done(tsk);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,


