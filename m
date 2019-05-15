Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE161F067
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfEOL1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbfEOL1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBD120862;
        Wed, 15 May 2019 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919623;
        bh=lAnVIE2rFubJvZXnSv7OSBrBPq7+//NgU8j8AUFJ6Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQ5O4vkFprl3SJ1zdDvKdNXSWr4XPxYcfe49S59zjDAGj1CPZtlNCDIHj2dmtFCn5
         0Ozsose4XQjQ6v+4DcJ8NpuBrSycVr0bZ73Z3GN62q5ukzaR234WiNBafhd7eBbAM8
         6/RQPpdjKcy5drwp2cywycrb1fQPIQw7xM3WpU4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.0 007/137] selftests/seccomp: Handle namespace failures gracefully
Date:   Wed, 15 May 2019 12:54:48 +0200
Message-Id: <20190515090653.285092544@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
@@ -3089,9 +3089,9 @@ TEST(user_notification_basic)
 
 	/* Check that we get -ENOSYS with no listener attached */
 	if (pid == 0) {
-		if (user_trap_syscall(__NR_getpid, 0) < 0)
+		if (user_trap_syscall(__NR_getppid, 0) < 0)
 			exit(1);
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret >= 0 || errno != ENOSYS);
 	}
 
@@ -3106,12 +3106,12 @@ TEST(user_notification_basic)
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
@@ -3120,7 +3120,7 @@ TEST(user_notification_basic)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != USER_NOTIF_MAGIC);
 	}
 
@@ -3138,7 +3138,7 @@ TEST(user_notification_basic)
 	EXPECT_GT(poll(&pollfd, 1, -1), 0);
 	EXPECT_EQ(pollfd.revents, POLLOUT);
 
-	EXPECT_EQ(req.data.nr,  __NR_getpid);
+	EXPECT_EQ(req.data.nr,  __NR_getppid);
 
 	resp.id = req.id;
 	resp.error = 0;
@@ -3165,7 +3165,7 @@ TEST(user_notification_kill_in_middle)
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
 
-	listener = user_trap_syscall(__NR_getpid,
+	listener = user_trap_syscall(__NR_getppid,
 				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
@@ -3177,7 +3177,7 @@ TEST(user_notification_kill_in_middle)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != USER_NOTIF_MAGIC);
 	}
 
@@ -3277,7 +3277,7 @@ TEST(user_notification_closed_listener)
 	long ret;
 	int status, listener;
 
-	listener = user_trap_syscall(__NR_getpid,
+	listener = user_trap_syscall(__NR_getppid,
 				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
@@ -3288,7 +3288,7 @@ TEST(user_notification_closed_listener)
 	ASSERT_GE(pid, 0);
 	if (pid == 0) {
 		close(listener);
-		ret = syscall(__NR_getpid);
+		ret = syscall(__NR_getppid);
 		exit(ret != -1 && errno != ENOSYS);
 	}
 
@@ -3311,14 +3311,15 @@ TEST(user_notification_child_pid_ns)
 
 	ASSERT_EQ(unshare(CLONE_NEWPID), 0);
 
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
@@ -3346,7 +3347,8 @@ TEST(user_notification_sibling_pid_ns)
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
 
-	listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3359,7 +3361,7 @@ TEST(user_notification_sibling_pid_ns)
 		ASSERT_GE(pid2, 0);
 
 		if (pid2 == 0)
-			exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+			exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
 
 		EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
 		EXPECT_EQ(true, WIFEXITED(status));
@@ -3368,11 +3370,11 @@ TEST(user_notification_sibling_pid_ns)
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
@@ -3380,7 +3382,7 @@ TEST(user_notification_sibling_pid_ns)
 		 * The pid should be 0, i.e. the task is in some namespace that
 		 * we can't "see".
 		 */
-		ASSERT_EQ(req.pid, 0);
+		EXPECT_EQ(req.pid, 0);
 
 		resp.id = req.id;
 		resp.error = 0;
@@ -3408,14 +3410,15 @@ TEST(user_notification_fault_recv)
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
 
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


