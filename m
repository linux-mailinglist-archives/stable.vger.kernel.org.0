Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBF24BED3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgHTNdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgHTJbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5935207FB;
        Thu, 20 Aug 2020 09:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915865;
        bh=FRhj0fd/gxv4u0flgC5GWm9bPJ52v60YYmcJEsaryAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBVMj9empRdRxpD+Rvq+8ZopPmvJJDBgU2oKZXCuUZHHPMDG0WEirv9dtmHYX6zHu
         0wGvLrV4htGRaX0kyuEnkpCbv+xCdP7WN+z8sUfTz64lpfV3dMeerPV4uwIkyoYsdw
         CuANDPkWqkkiORMW/0jePU5xrIgU/5Hde91ZGM7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 132/232] bpf: selftests: Restore netns after each test
Date:   Thu, 20 Aug 2020 11:19:43 +0200
Message-Id: <20200820091619.211152710@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 811d7e375d08312dba23f3b6bf7e58ec14aa5dcb ]

It is common for networking tests creating its netns and making its own
setting under this new netns (e.g. changing tcp sysctl).  If the test
forgot to restore to the original netns, it would affect the
result of other tests.

This patch saves the original netns at the beginning and then restores it
after every test.  Since the restore "setns()" is not expensive, it does it
on all tests without tracking if a test has created a new netns or not.

The new restore_netns() could also be done in test__end_subtest() such
that each subtest will get an automatic netns reset.  However,
the individual test would lose flexibility to have total control
on netns for its own subtests.  In some cases, forcing a test to do
unnecessary netns re-configure for each subtest is time consuming.
e.g. In my vm, forcing netns re-configure on each subtest in sk_assign.c
increased the runtime from 1s to 8s.  On top of that,  test_progs.c
is also doing per-test (instead of per-subtest) cleanup for cgroup.
Thus, this patch also does per-test restore_netns().  The only existing
per-subtest cleanup is reset_affinity() and no test is depending on this.
Thus, it is removed from test__end_subtest() to give a consistent
expectation to the individual tests.  test_progs.c only ensures
any affinity/netns/cgroup change made by an earlier test does not
affect the following tests.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200702004858.2103728-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 23 +++++++++++++++++++++--
 tools/testing/selftests/bpf/test_progs.h |  2 ++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index da70a4f72f547..6218b2b5a3f62 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -121,6 +121,24 @@ static void reset_affinity() {
 	}
 }
 
+static void save_netns(void)
+{
+	env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (env.saved_netns_fd == -1) {
+		perror("open(/proc/self/ns/net)");
+		exit(-1);
+	}
+}
+
+static void restore_netns(void)
+{
+	if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
+		stdio_restore();
+		perror("setns(CLONE_NEWNS)");
+		exit(-1);
+	}
+}
+
 void test__end_subtest()
 {
 	struct prog_test_def *test = env.test;
@@ -138,8 +156,6 @@ void test__end_subtest()
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
 
-	reset_affinity();
-
 	free(test->subtest_name);
 	test->subtest_name = NULL;
 }
@@ -643,6 +659,7 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
+	save_netns();
 	stdio_hijack();
 	for (i = 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test = &prog_test_defs[i];
@@ -673,6 +690,7 @@ int main(int argc, char **argv)
 			test->error_cnt ? "FAIL" : "OK");
 
 		reset_affinity();
+		restore_netns();
 		if (test->need_cgroup_cleanup)
 			cleanup_cgroup_environment();
 	}
@@ -686,6 +704,7 @@ int main(int argc, char **argv)
 	free_str_set(&env.subtest_selector.blacklist);
 	free_str_set(&env.subtest_selector.whitelist);
 	free(env.subtest_selector.num_set);
+	close(env.saved_netns_fd);
 
 	if (env.succ_cnt + env.fail_cnt + env.skip_cnt == 0)
 		return EXIT_FAILURE;
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index f4503c926acad..b809246039181 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -78,6 +78,8 @@ struct test_env {
 	int sub_succ_cnt; /* successful sub-tests */
 	int fail_cnt; /* total failed tests + sub-tests */
 	int skip_cnt; /* skipped tests */
+
+	int saved_netns_fd;
 };
 
 extern struct test_env env;
-- 
2.25.1



