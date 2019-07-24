Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652AD73CB5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfGXT56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392125AbfGXT55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5557214AF;
        Wed, 24 Jul 2019 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998276;
        bh=tYhMCD5qtmkjP1Q4w67G4pB6CPy15S17nFVaUeW9plA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xD/fL79Ib32Z8yHm12NateTqcbPQUt/YmoYdODw/78TePXNQGy1+wsROxpiB8HTMt
         CM0GEkM24hItDckuYze266/KzJZByewHrXhy/51VfjqyGjLhEp3qMujRx5XvHFAgm9
         4aqyqjycnO9PYzGWICb6dBsFwygH0OHZ+VteKIx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.1 309/371] signal: Correct namespace fixups of si_pid and si_uid
Date:   Wed, 24 Jul 2019 21:21:01 +0200
Message-Id: <20190724191747.390218951@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 7a0cf094944e2540758b7f957eb6846d5126f535 upstream.

The function send_signal was split from __send_signal so that it would
be possible to bypass the namespace logic based upon current[1].  As it
turns out the si_pid and the si_uid fixup are both inappropriate in
the case of kill_pid_usb_asyncio so move that logic into send_signal.

It is difficult to arrange but possible for a signal with an si_code
of SI_TIMER or SI_SIGIO to be sent across namespace boundaries.  In
which case tests for when it is ok to change si_pid and si_uid based
on SI_FROMUSER are incorrect.  Replace the use of SI_FROMUSER with a
new test has_si_pid_and_used based on siginfo_layout.

Now that the uid fixup is no longer present after expanding
SEND_SIG_NOINFO properly calculate the si_uid that the target
task needs to read.

[1] 7978b567d315 ("signals: add from_ancestor_ns parameter to send_signal()")
Cc: stable@vger.kernel.org
Fixes: 6588c1e3ff01 ("signals: SI_USER: Masquerade si_pid when crossing pid ns boundary")
Fixes: 6b550f949594 ("user namespace: make signal.c respect user namespaces")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |   67 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1053,27 +1053,6 @@ static inline bool legacy_queue(struct s
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-#ifdef CONFIG_USER_NS
-static inline void userns_fixup_signal_uid(struct kernel_siginfo *info, struct task_struct *t)
-{
-	if (current_user_ns() == task_cred_xxx(t, user_ns))
-		return;
-
-	if (SI_FROMKERNEL(info))
-		return;
-
-	rcu_read_lock();
-	info->si_uid = from_kuid_munged(task_cred_xxx(t, user_ns),
-					make_kuid(current_user_ns(), info->si_uid));
-	rcu_read_unlock();
-}
-#else
-static inline void userns_fixup_signal_uid(struct kernel_siginfo *info, struct task_struct *t)
-{
-	return;
-}
-#endif
-
 static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struct *t,
 			enum pid_type type, int from_ancestor_ns)
 {
@@ -1131,7 +1110,11 @@ static int __send_signal(int sig, struct
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
-			q->info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+			rcu_read_lock();
+			q->info.si_uid =
+				from_kuid_munged(task_cred_xxx(t, user_ns),
+						 current_uid());
+			rcu_read_unlock();
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			clear_siginfo(&q->info);
@@ -1143,13 +1126,8 @@ static int __send_signal(int sig, struct
 			break;
 		default:
 			copy_siginfo(&q->info, info);
-			if (from_ancestor_ns)
-				q->info.si_pid = 0;
 			break;
 		}
-
-		userns_fixup_signal_uid(&q->info, t);
-
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
 			/*
@@ -1193,6 +1171,28 @@ ret:
 	return ret;
 }
 
+static inline bool has_si_pid_and_uid(struct kernel_siginfo *info)
+{
+	bool ret = false;
+	switch (siginfo_layout(info->si_signo, info->si_code)) {
+	case SIL_KILL:
+	case SIL_CHLD:
+	case SIL_RT:
+		ret = true;
+		break;
+	case SIL_TIMER:
+	case SIL_POLL:
+	case SIL_FAULT:
+	case SIL_FAULT_MCEERR:
+	case SIL_FAULT_BNDERR:
+	case SIL_FAULT_PKUERR:
+	case SIL_SYS:
+		ret = false;
+		break;
+	}
+	return ret;
+}
+
 static int send_signal(int sig, struct kernel_siginfo *info, struct task_struct *t,
 			enum pid_type type)
 {
@@ -1202,7 +1202,20 @@ static int send_signal(int sig, struct k
 	from_ancestor_ns = si_fromuser(info) &&
 			   !task_pid_nr_ns(current, task_active_pid_ns(t));
 #endif
+	if (!is_si_special(info) && has_si_pid_and_uid(info)) {
+		struct user_namespace *t_user_ns;
+
+		rcu_read_lock();
+		t_user_ns = task_cred_xxx(t, user_ns);
+		if (current_user_ns() != t_user_ns) {
+			kuid_t uid = make_kuid(current_user_ns(), info->si_uid);
+			info->si_uid = from_kuid_munged(t_user_ns, uid);
+		}
+		rcu_read_unlock();
 
+		if (!task_pid_nr_ns(current, task_active_pid_ns(t)))
+			info->si_pid = 0;
+	}
 	return __send_signal(sig, info, t, type, from_ancestor_ns);
 }
 


