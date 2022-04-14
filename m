Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC296501131
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245338AbiDNOIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347721AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98241ADD4D;
        Thu, 14 Apr 2022 06:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D43B82988;
        Thu, 14 Apr 2022 13:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91497C385A1;
        Thu, 14 Apr 2022 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944326;
        bh=nx8mIX+N31o23Y6i7/Pt4uXhfq+vPdy6NAMhdjc5ri8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkUAgrhl1Ghmfhokd7GKhUcsCcq8d6dQOv4qZjVkgUSbp7dOzueyE+TeZQ6vieO1Y
         Q0+KpISCOjgtz++CcbB4dmRhjjnRDC4+rDp+Z8/HoSbx/BDllONp8QO0OTTHXPk+z/
         4a4UfPafM96Vj0InVbgjmvWOz5JHR9kRFqNXxSNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 473/475] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Thu, 14 Apr 2022 15:14:18 +0200
Message-Id: <20220414110908.293952702@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
[OP: backport to v5.4: adjust context, add wait.h and fcntl.h includes]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/test_core.c |   99 +++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -1,8 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#define _GNU_SOURCE
 #include <linux/limits.h>
+#include <linux/sched.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <sched.h>
 #include <stdio.h>
 #include <errno.h>
 
@@ -421,6 +426,99 @@ cleanup:
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
@@ -434,6 +532,7 @@ struct corecg_test {
 	T(test_cgcore_invalid_domain),
 	T(test_cgcore_populated),
 	T(test_cgcore_lesser_euid_open),
+	T(test_cgcore_lesser_ns_open),
 };
 #undef T
 


