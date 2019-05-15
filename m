Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E11EFC0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfEOLfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733190AbfEOLd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C6162084F;
        Wed, 15 May 2019 11:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557920005;
        bh=NRbNBoPW3/QqclhFag8UYEURPu8yLcWYbCVXYfPbVo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwgBMgbHbiywTs5YA6TGlMUOfcfsEbZ8jIcKPXvxJE/JNkzSmcmkY4AUAbI+2+WBn
         WQPby8D6QvG/+7wnL1HFsC/VM72LCQPEDTJkX1SLLSkF4F+tqWgGpZVBKEbxG9XpaO
         AZExTio1zKZbEFZ80pwqsCLEiVVIPG7rf9sPV4PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.1 06/46] selftests/seccomp: Handle namespace failures gracefully
Date:   Wed, 15 May 2019 12:56:30 +0200
Message-Id: <20190515090620.086518201@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 9dd3fcb0ab73cb1e00b8562ef027a38521aaff87 upstream.

When running without USERNS or PIDNS the seccomp test would hang since
it was waiting forever for the child to trigger the user notification
since it seems the glibc() abort handler makes a call to getpid(),
which would trap again. This changes the getpid filter to getppid, and
makes sure ASSERTs execute to stop from spawning the listener.

Reported-by: Shuah Khan <shuah@kernel.org>
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Cc: stable@vger.kernel.org # > 5.0
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/seccomp/seccomp_bpf.c |   43 +++++++++++++-------------
 1 file changed, 23 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3095,9 +3095,9 @@ TEST(user_notification_basic)
 
 	/* Check that we get -ENOSYS with no listener attached */
 	if (pid == 0) {
-		if (user_trap_syscall(__NR_getpid, 0) < 0)
+		if (user_trap_syscall(__NR_getppid, 0) < 0)
 			exit(1);
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret >= 0 || errno != ENOSYS);
 	}
 
@@ -3112,12 +3112,12 @@ TEST(user_notification_basic)
 	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
 
 	/* Check that the basic notification machinery works */
-	listener = user_trap_syscall(__NR_getpid,
+	listener = user_trap_syscall(__NR_getppid,
 				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	/* Installing a second listener in the chain should EBUSY */
-	EXPECT_EQ(user_trap_syscall(__NR_getpid,
+	EXPECT_EQ(user_trap_syscall(__NR_getppid,
 				    SECCOMP_FILTER_FLAG_NEW_LISTENER),
 		  -1);
 	EXPECT_EQ(errno, EBUSY);
@@ -3126,7 +3126,7 @@ TEST(user_notification_basic)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != USER_NOTIF_MAGIC);
 	}
 
@@ -3144,7 +3144,7 @@ TEST(user_notification_basic)
 	EXPECT_GT(poll(&pollfd, 1, -1), 0);
 	EXPECT_EQ(pollfd.revents, POLLOUT);
 
-	EXPECT_EQ(req.data.nr,  __NR_getpid);
+	EXPECT_EQ(req.data.nr,  __NR_getppid);
 
 	resp.id = req.id;
 	resp.error = 0;
@@ -3176,7 +3176,7 @@ TEST(user_notification_kill_in_middle)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getpid,
+	listener = user_trap_syscall(__NR_getppid,
 				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
@@ -3188,7 +3188,7 @@ TEST(user_notification_kill_in_middle)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != USER_NOTIF_MAGIC);
 	}
 
@@ -3298,7 +3298,7 @@ TEST(user_notification_closed_listener)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getpid,
+	listener = user_trap_syscall(__NR_getppid,
 				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
@@ -3309,7 +3309,7 @@ TEST(user_notification_closed_listener)
 	ASSERT_GE(pid, 0);
 	if (pid == 0) {
 		close(listener);
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != -1 && errno != ENOSYS);
 	}
 
@@ -3332,14 +3332,15 @@ TEST(user_notification_child_pid_ns)
 
 	ASSERT_EQ(unshare(CLONE_NEWUSER | CLONE_NEWPID), 0);
 
-	listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0)
-		exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
 
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
 	EXPECT_EQ(req.pid, pid);
@@ -3371,7 +3372,8 @@ TEST(user_notification_sibling_pid_ns)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3384,7 +3386,7 @@ TEST(user_notification_sibling_pid_ns)
 		ASSERT_GE(pid2, 0);
 
 		if (pid2 == 0)
-			exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+			exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
 
 		EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
 		EXPECT_EQ(true, WIFEXITED(status));
@@ -3393,11 +3395,11 @@ TEST(user_notification_sibling_pid_ns)
 	}
 
 	/* Create the sibling ns, and sibling in it. */
-	EXPECT_EQ(unshare(CLONE_NEWPID), 0);
-	EXPECT_EQ(errno, 0);
+	ASSERT_EQ(unshare(CLONE_NEWPID), 0);
+	ASSERT_EQ(errno, 0);
 
 	pid2 = fork();
-	EXPECT_GE(pid2, 0);
+	ASSERT_GE(pid2, 0);
 
 	if (pid2 == 0) {
 		ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
@@ -3405,7 +3407,7 @@ TEST(user_notification_sibling_pid_ns)
 		 * The pid should be 0, i.e. the task is in some namespace that
 		 * we can't "see".
 		 */
-		ASSERT_EQ(req.pid, 0);
+		EXPECT_EQ(req.pid, 0);
 
 		resp.id = req.id;
 		resp.error = 0;
@@ -3435,14 +3437,15 @@ TEST(user_notification_fault_recv)
 
 	ASSERT_EQ(unshare(CLONE_NEWUSER), 0);
 
-	listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0)
-		exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
 
 	/* Do a bad recv() */
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, NULL), -1);


