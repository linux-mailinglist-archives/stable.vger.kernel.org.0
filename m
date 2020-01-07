Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082E61331A6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgAGVCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgAGVCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DE02077B;
        Tue,  7 Jan 2020 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430957;
        bh=jnO32xadFHrj79I6OflMLSYNfy4haaOqzZ40yCXJ4QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4tldp3yKCmeHnwQkLSIri0g10QU5znDTse6tvrf9e2T8RjvG7TF6xaRFv4YdxSmH
         UJG0kbbpNRrgpNfFafQvLaNfVP3rD+NATyNKmAwrkAsi4rWkTXVbPBgCWS+sz7lTN7
         45+CvL648rIljQP2P3ExeNRqqxMGUdRtMSM+7vY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chenqiwu <chenqiwu@xiaomi.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.4 129/191] exit: panic before exit_mm() on global init exit
Date:   Tue,  7 Jan 2020 21:54:09 +0100
Message-Id: <20200107205339.877006753@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

commit 43cf75d96409a20ef06b756877a2e72b10a026fc upstream.

Currently, when global init and all threads in its thread-group have exited
we panic via:
do_exit()
-> exit_notify()
   -> forget_original_parent()
      -> find_child_reaper()
This makes it hard to extract a useable coredump for global init from a
kernel crashdump because by the time we panic exit_mm() will have already
released global init's mm.
This patch moves the panic futher up before exit_mm() is called. As was the
case previously, we only panic when global init and all its threads in the
thread-group have exited.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
[christian.brauner@ubuntu.com: fix typo, rewrite commit message]
Link: https://lore.kernel.org/r/1576736993-10121-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -517,10 +517,6 @@ static struct task_struct *find_child_re
 	}
 
 	write_unlock_irq(&tasklist_lock);
-	if (unlikely(pid_ns == &init_pid_ns)) {
-		panic("Attempted to kill init! exitcode=0x%08x\n",
-			father->signal->group_exit_code ?: father->exit_code);
-	}
 
 	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
@@ -766,6 +762,14 @@ void __noreturn do_exit(long code)
 	acct_update_integrals(tsk);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
+		/*
+		 * If the last thread of global init has exited, panic
+		 * immediately to get a useable coredump.
+		 */
+		if (unlikely(is_global_init(tsk)))
+			panic("Attempted to kill init! exitcode=0x%08x\n",
+				tsk->signal->group_exit_code ?: (int)code);
+
 #ifdef CONFIG_POSIX_TIMERS
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);


