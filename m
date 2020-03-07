Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0572617CB64
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 04:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCGDCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 22:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgCGDCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 22:02:18 -0500
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA446206D5;
        Sat,  7 Mar 2020 03:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583550137;
        bh=KL3/2VYI5+pqT4gg3RT6fC0ThurhRFfSREX6XD1ck8M=;
        h=From:To:Cc:Subject:Date:From;
        b=s1k85rJaTFgjUN+9IAXMvRBHC/mhxX2vWHqatKWCKGV6Tau+hnGQYbL9Fml4yBK9Y
         iRtC9UAUpE+RxmQ7ZOjqcfNi1JrGgKZu+y85+g1TDux+UtjT1GpbExKN1Xo3Lt2HIx
         Al80lRySL7x4jXDyn+LQS/Y3tTNqCpHQdEZ2vDJU=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        gregkh@linuxfoundation.org, gustavo@embeddedor.com,
        tglx@linutronix.de, josh@joshtriplett.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH] x86/kprobes: Prohibit probing on rcu_nmi_exit() and ist_exit()
Date:   Sat,  7 Mar 2020 12:02:12 +0900
Message-Id: <158355013189.14191.9105069890402942867.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prohibit probing on rcu_nmi_exit() and ist_exit() which
are called from do_int3()'s kprobe path after kprobe_int3_handler().

The commit c13324a505c7 ("x86/kprobes: Prohibit probing on
functions before kprobe_int3_handler()") tried to fix similar
issue, but it only marks the functions before kprobe_int3_handler()
in do_int3().

If we put a kprobe on rcu_nmi_exit() or ist_exit(), the kprobes
will detect reentrance. However, it only skips the kprobe handler,
exits from do_int3() and hits ist_exit() and rcu_nmi_exit() again.
Thus, it causes another int3 exception and finally we will get
the kernel panic with "Unrecoverable kprobe detected." error message.

This is reproducible by the following commands.

/ # echo 0 > /proc/sys/debug/kprobes-optimization
/ # echo p vfs_read > /sys/kernel/debug/tracing/kprobe_events
/ # echo p rcu_nmi_exit >> /sys/kernel/debug/tracing/kprobe_events
/ # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable

Fixes: c13324a505c7 ("x86/kprobes: Prohibit probing on functions before kprobe_int3_handler()")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/traps.c |    1 +
 kernel/rcu/tree.c       |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6ef00eb6fbb9..c63fb7697794 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -115,6 +115,7 @@ void ist_exit(struct pt_regs *regs)
 	if (!user_mode(regs))
 		rcu_nmi_exit();
 }
+NOKPROBE_SYMBOL(ist_exit);
 
 /**
  * ist_begin_non_atomic() - begin a non-atomic section in an IST exception
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d91c9156fab2..c49ea0e919f9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -670,6 +670,7 @@ void rcu_nmi_exit(void)
 {
 	rcu_nmi_exit_common(false);
 }
+NOKPROBE_SYMBOL(rcu_nmi_exit);
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle

