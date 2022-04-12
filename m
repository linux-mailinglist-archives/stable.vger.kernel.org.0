Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEC14FD3E5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiDLHVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351889AbiDLHND (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F79114D;
        Mon, 11 Apr 2022 23:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3632B81B4E;
        Tue, 12 Apr 2022 06:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46415C385A6;
        Tue, 12 Apr 2022 06:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746444;
        bh=UG8E96NmWmyT1eR57RezFnkCYzgTjNbUM2DsOBIh/tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/F7PE9BIk28pi7Ptmi/Z9+ebvUMGVUHYae9JXcjV5YozWditT7HroxkEkZFWP+bp
         8Hg5nCqGww1JTcKnprB83hlDTmISBuD9KaKL0mmLdBLLzeT9CoT6MYcZ7FV8F7lESU
         ExfK7pM9RwcVZKYqRVztVNjfi9Uaz7UXjr8eh1Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 266/277] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Tue, 12 Apr 2022 08:31:09 +0200
Message-Id: <20220412062949.741881644@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit bf35a7879f1dfb0d050fe779168bcf25c7de66f5 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the cgroup namespace of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/test_core.c |   97 +++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -1,11 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#define _GNU_SOURCE
 #include <linux/limits.h>
+#include <linux/sched.h>
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sched.h>
 #include <stdio.h>
 #include <errno.h>
 #include <signal.h>
@@ -741,6 +744,99 @@ cleanup:
 	return ret;
 }
 
+struct lesser_ns_open_thread_arg {
+	const char	*path;
+	int		fd;
+	int		err;
+};
+
+static int lesser_ns_open_thread_fn(void *arg)
+{
+	struct lesser_ns_open_thread_arg *targ = arg;
+
+	targ->fd = open(targ->path, O_RDWR);
+	targ->err = errno;
+	return 0;
+}
+
+/*
+ * cgroup migration permission check should be performed based on the cgroup
+ * namespace at the time of open instead of write.
+ */
+static int test_cgcore_lesser_ns_open(const char *root)
+{
+	static char stack[65536];
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	struct lesser_ns_open_thread_arg targ = { .fd = -1 };
+	pid_t pid;
+	int status;
+
+	cg_test_a = cg_name(root, "cg_test_a");
+	cg_test_b = cg_name(root, "cg_test_b");
+
+	if (!cg_test_a || !cg_test_b)
+		goto cleanup;
+
+	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
+	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
+
+	if (!cg_test_a_procs || !cg_test_b_procs)
+		goto cleanup;
+
+	if (cg_create(cg_test_a) || cg_create(cg_test_b))
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_b))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	targ.path = cg_test_b_procs;
+	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
+		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
+		    &targ);
+	if (pid < 0)
+		goto cleanup;
+
+	if (waitpid(pid, &status, 0) < 0)
+		goto cleanup;
+
+	if (!WIFEXITED(status))
+		goto cleanup;
+
+	cg_test_b_procs_fd = targ.fd;
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if ((status = write(cg_test_b_procs_fd, "0", 1)) >= 0 || errno != ENOENT)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_enter_current(root);
+	if (cg_test_b_procs_fd >= 0)
+		close(cg_test_b_procs_fd);
+	if (cg_test_b)
+		cg_destroy(cg_test_b);
+	if (cg_test_a)
+		cg_destroy(cg_test_a);
+	free(cg_test_b_procs);
+	free(cg_test_a_procs);
+	free(cg_test_b);
+	free(cg_test_a);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct corecg_test {
 	int (*fn)(const char *root);
@@ -757,6 +853,7 @@ struct corecg_test {
 	T(test_cgcore_thread_migration),
 	T(test_cgcore_destroy),
 	T(test_cgcore_lesser_euid_open),
+	T(test_cgcore_lesser_ns_open),
 };
 #undef T
 


