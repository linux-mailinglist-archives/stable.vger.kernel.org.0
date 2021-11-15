Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EC245136A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348236AbhKOTvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343497AbhKOTVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEA4F63598;
        Mon, 15 Nov 2021 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001655;
        bh=Cu5SbkgA8mRMRR5SkXbp1OyW9/djEIm8PF7BDqDg95E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUDbOE5qFct+2rg44D1u0Nkjw9GgYUSRqSa2of+hth6/k0WZ2Rh3qvWyNFQ10B56L
         Pen+3RurJCOVPv5adZGB7RpR0lfGRHE6mz0zYQuck9TgoR6efqswhkOtvUWiWdDAGR
         Cj8DgwmWquN6q3fGDe7hAFX+PYynt9ox0UND0X1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Chris Hyser <chris.hyser@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/917] kselftests/sched: cleanup the child processes
Date:   Mon, 15 Nov 2021 17:55:33 +0100
Message-Id: <20211115165436.870831581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

[ Upstream commit 1c36432b278cecf1499f21fae19836e614954309 ]

Previously, 'make -C sched run_tests' will block forever when it occurs
something wrong where the *selftests framework* is waiting for its child
processes to exit.

[root@iaas-rpma sched]# ./cs_prctl_test

 ## Create a thread/process/process group hiearchy
Not a core sched system
tid=74985, / tgid=74985 / pgid=74985: ffffffffffffffff
Not a core sched system
    tid=74986, / tgid=74986 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74988, / tgid=74986 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74989, / tgid=74986 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74990, / tgid=74986 / pgid=74985: ffffffffffffffff
Not a core sched system
    tid=74987, / tgid=74987 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74991, / tgid=74987 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74992, / tgid=74987 / pgid=74985: ffffffffffffffff
Not a core sched system
        tid=74993, / tgid=74987 / pgid=74985: ffffffffffffffff

Not a core sched system
(268) FAILED: get_cs_cookie(0) == 0

 ## Set a cookie on entire process group
-1 = prctl(62, 1, 0, 2, 0)
core_sched create failed -- PGID: Invalid argument
(cs_prctl_test.c:272) -
[root@iaas-rpma sched]# ps
    PID TTY          TIME CMD
   4605 pts/2    00:00:00 bash
  74986 pts/2    00:00:00 cs_prctl_test
  74987 pts/2    00:00:00 cs_prctl_test
  74999 pts/2    00:00:00 ps

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chris Hyser <chris.hyser@oracle.com>
Link: https://lore.kernel.org/r/20210902024333.75983-1-lizhijian@cn.fujitsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched/cs_prctl_test.c | 28 ++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/sched/cs_prctl_test.c b/tools/testing/selftests/sched/cs_prctl_test.c
index 7db9cf822dc75..8109b17dc764c 100644
--- a/tools/testing/selftests/sched/cs_prctl_test.c
+++ b/tools/testing/selftests/sched/cs_prctl_test.c
@@ -62,6 +62,17 @@ enum pid_type {PIDTYPE_PID = 0, PIDTYPE_TGID, PIDTYPE_PGID};
 
 const int THREAD_CLONE_FLAGS = CLONE_THREAD | CLONE_SIGHAND | CLONE_FS | CLONE_VM | CLONE_FILES;
 
+struct child_args {
+	int num_threads;
+	int pfd[2];
+	int cpid;
+	int thr_tids[MAX_THREADS];
+};
+
+static struct child_args procs[MAX_PROCESSES];
+static int num_processes = 2;
+static int need_cleanup = 0;
+
 static int _prctl(int option, unsigned long arg2, unsigned long arg3, unsigned long arg4,
 		  unsigned long arg5)
 {
@@ -78,8 +89,14 @@ static int _prctl(int option, unsigned long arg2, unsigned long arg3, unsigned l
 #define handle_error(msg) __handle_error(__FILE__, __LINE__, msg)
 static void __handle_error(char *fn, int ln, char *msg)
 {
+	int pidx;
 	printf("(%s:%d) - ", fn, ln);
 	perror(msg);
+	if (need_cleanup) {
+		for (pidx = 0; pidx < num_processes; ++pidx)
+			kill(procs[pidx].cpid, 15);
+		need_cleanup = 0;
+	}
 	exit(EXIT_FAILURE);
 }
 
@@ -106,13 +123,6 @@ static unsigned long get_cs_cookie(int pid)
 	return cookie;
 }
 
-struct child_args {
-	int num_threads;
-	int pfd[2];
-	int cpid;
-	int thr_tids[MAX_THREADS];
-};
-
 static int child_func_thread(void __attribute__((unused))*arg)
 {
 	while (1)
@@ -212,10 +222,7 @@ void _validate(int line, int val, char *msg)
 
 int main(int argc, char *argv[])
 {
-	struct child_args procs[MAX_PROCESSES];
-
 	int keypress = 0;
-	int num_processes = 2;
 	int num_threads = 3;
 	int delay = 0;
 	int res = 0;
@@ -262,6 +269,7 @@ int main(int argc, char *argv[])
 
 	printf("\n## Create a thread/process/process group hiearchy\n");
 	create_processes(num_processes, num_threads, procs);
+	need_cleanup = 1;
 	disp_processes(num_processes, procs);
 	validate(get_cs_cookie(0) == 0);
 
-- 
2.33.0



