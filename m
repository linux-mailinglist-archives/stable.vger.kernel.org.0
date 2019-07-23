Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6307169F
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfGWKze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:55:34 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48793 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387474AbfGWKzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:55:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C71815E2;
        Tue, 23 Jul 2019 06:55:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pYmYky
        bbwFfdD2bLbhbigr8z6Vv9FeV6hepUbdhcRNU=; b=rxItxL6UPCiwpXiZErbi0I
        hTIHt8/gvTi468Kw7xSzHLJ8s2D/uu9T9L62NH1NlQmlzz7vKJfPn7j7bbUAR8j9
        +giA4Skaqr1hf6UanGwm597+YgROivHacBOkHsHTMsqY69A2TcMkk5ZXtLY9e4Dj
        fIH7d2DCBd8Xih8cDGoG6vzHKEUyCQEyAI+lMjNpx38VNl4h4HUZbspgrfClnhb3
        ZqSYZyoedpjBt7dgPbJs+jXCbTK94Y4m3pBDjVzrWydfDb4HfDdNZ4ro8yvmKQxV
        M/rmyxZ131Urqb8xWyr+PQHxdVStb5wmXkNs4p65koqc9aCQYukZyrEFsF/APL+g
        ==
X-ME-Sender: <xms:pOc2XZYhq4JFIfHnwnmhKbffLZX35U5Kby8vyI5pmiAQOEy5mF62oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:pOc2XUFSw2TvTCbnuTssW46Ppf58LdWE32AnCPP28mX4d4gMmXY9ww>
    <xmx:pOc2XVzGv93IK2NWaDkc3bXtHJsP8bv6MGdLATKsXUCmNQqQ_LSZyw>
    <xmx:pOc2XemMmz8oXKlkWbkkACSxOSNktqzA4-9LYGmVpMQI42flpDhnQQ>
    <xmx:pOc2XSeXUpfrmx0i-y8mR9kF17-R6IF2WxJ7zLwGOeoubkDHnzLUaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA5A180065;
        Tue, 23 Jul 2019 06:55:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal: Correct namespace fixups of si_pid and si_uid" failed to apply to 4.19-stable tree
To:     ebiederm@xmission.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:53:43 +0200
Message-ID: <1563879223198138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a0cf094944e2540758b7f957eb6846d5126f535 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 15 May 2019 22:54:56 -0500
Subject: [PATCH] signal: Correct namespace fixups of si_pid and si_uid

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

diff --git a/kernel/signal.c b/kernel/signal.c
index 18040d6bd63a..39a3eca5ce22 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1056,27 +1056,6 @@ static inline bool legacy_queue(struct sigpending *signals, int sig)
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
@@ -1134,7 +1113,11 @@ static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struc
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
@@ -1146,13 +1129,8 @@ static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struc
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
@@ -1196,6 +1174,28 @@ static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struc
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
@@ -1205,7 +1205,20 @@ static int send_signal(int sig, struct kernel_siginfo *info, struct task_struct
 	from_ancestor_ns = si_fromuser(info) &&
 			   !task_pid_nr_ns(current, task_active_pid_ns(t));
 #endif
+	if (!is_si_special(info) && has_si_pid_and_uid(info)) {
+		struct user_namespace *t_user_ns;
 
+		rcu_read_lock();
+		t_user_ns = task_cred_xxx(t, user_ns);
+		if (current_user_ns() != t_user_ns) {
+			kuid_t uid = make_kuid(current_user_ns(), info->si_uid);
+			info->si_uid = from_kuid_munged(t_user_ns, uid);
+		}
+		rcu_read_unlock();
+
+		if (!task_pid_nr_ns(current, task_active_pid_ns(t)))
+			info->si_pid = 0;
+	}
 	return __send_signal(sig, info, t, type, from_ancestor_ns);
 }
 

