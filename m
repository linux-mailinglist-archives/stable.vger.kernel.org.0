Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689806AEC48
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCGRxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjCGRxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A212E834
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82AD8614B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FD9C433EF;
        Tue,  7 Mar 2023 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211287;
        bh=Nv0SRZOkvEd+Wqj8rD2L46h/SZFJrMvVfaj+rjtnFw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLR5K+DgaPLuFmFRawHEtQVSUr5YU4bo+zPtgE/BIgr3dIxKy1/1L+8tDl9A3x4vU
         967o1zz5DUnS/fmFInVx+5Eo13ToLb71u+eDzERkHS6NreyCWJm1DaWifLRpj3ef6x
         CgtaQPQA+4cT7AnGcYayfolBJ5Hn2zr6qkW8LYXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Xu <jeffxu@google.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.2 0813/1001] selftests/landlock: Test ptrace as much as possible with Yama
Date:   Tue,  7 Mar 2023 17:59:45 +0100
Message-Id: <20230307170057.028209714@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Xu <jeffxu@google.com>

commit 8677e555f17f51321d0730b945aeb7d4b95f998f upstream.

Update ptrace tests according to all potential Yama security policies.
This is required to make such tests pass even if Yama is enabled.

Tests are not skipped but they now check both Landlock and Yama boundary
restrictions at run time to keep a maximum test coverage (i.e. positive
and negative testing).

Signed-off-by: Jeff Xu <jeffxu@google.com>
Link: https://lore.kernel.org/r/20230114020306.1407195-2-jeffxu@google.com
Cc: stable@vger.kernel.org
[mic: Add curly braces around EXPECT_EQ() to make it build, and improve
commit message]
Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/ptrace_test.c |  113 +++++++++++++++++++++----
 1 file changed, 96 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -19,6 +19,12 @@
 
 #include "common.h"
 
+/* Copied from security/yama/yama_lsm.c */
+#define YAMA_SCOPE_DISABLED 0
+#define YAMA_SCOPE_RELATIONAL 1
+#define YAMA_SCOPE_CAPABILITY 2
+#define YAMA_SCOPE_NO_ATTACH 3
+
 static void create_domain(struct __test_metadata *const _metadata)
 {
 	int ruleset_fd;
@@ -60,6 +66,25 @@ static int test_ptrace_read(const pid_t
 	return 0;
 }
 
+static int get_yama_ptrace_scope(void)
+{
+	int ret;
+	char buf[2] = {};
+	const int fd = open("/proc/sys/kernel/yama/ptrace_scope", O_RDONLY);
+
+	if (fd < 0)
+		return 0;
+
+	if (read(fd, buf, 1) < 0) {
+		close(fd);
+		return -1;
+	}
+
+	ret = atoi(buf);
+	close(fd);
+	return ret;
+}
+
 /* clang-format off */
 FIXTURE(hierarchy) {};
 /* clang-format on */
@@ -232,8 +257,51 @@ TEST_F(hierarchy, trace)
 	pid_t child, parent;
 	int status, err_proc_read;
 	int pipe_child[2], pipe_parent[2];
+	int yama_ptrace_scope;
 	char buf_parent;
 	long ret;
+	bool can_read_child, can_trace_child, can_read_parent, can_trace_parent;
+
+	yama_ptrace_scope = get_yama_ptrace_scope();
+	ASSERT_LE(0, yama_ptrace_scope);
+
+	if (yama_ptrace_scope > YAMA_SCOPE_DISABLED)
+		TH_LOG("Incomplete tests due to Yama restrictions (scope %d)",
+		       yama_ptrace_scope);
+
+	/*
+	 * can_read_child is true if a parent process can read its child
+	 * process, which is only the case when the parent process is not
+	 * isolated from the child with a dedicated Landlock domain.
+	 */
+	can_read_child = !variant->domain_parent;
+
+	/*
+	 * can_trace_child is true if a parent process can trace its child
+	 * process.  This depends on two conditions:
+	 * - The parent process is not isolated from the child with a dedicated
+	 *   Landlock domain.
+	 * - Yama allows tracing children (up to YAMA_SCOPE_RELATIONAL).
+	 */
+	can_trace_child = can_read_child &&
+			  yama_ptrace_scope <= YAMA_SCOPE_RELATIONAL;
+
+	/*
+	 * can_read_parent is true if a child process can read its parent
+	 * process, which is only the case when the child process is not
+	 * isolated from the parent with a dedicated Landlock domain.
+	 */
+	can_read_parent = !variant->domain_child;
+
+	/*
+	 * can_trace_parent is true if a child process can trace its parent
+	 * process.  This depends on two conditions:
+	 * - The child process is not isolated from the parent with a dedicated
+	 *   Landlock domain.
+	 * - Yama is disabled (YAMA_SCOPE_DISABLED).
+	 */
+	can_trace_parent = can_read_parent &&
+			   yama_ptrace_scope <= YAMA_SCOPE_DISABLED;
 
 	/*
 	 * Removes all effective and permitted capabilities to not interfere
@@ -264,16 +332,21 @@ TEST_F(hierarchy, trace)
 		/* Waits for the parent to be in a domain, if any. */
 		ASSERT_EQ(1, read(pipe_parent[0], &buf_child, 1));
 
-		/* Tests PTRACE_ATTACH and PTRACE_MODE_READ on the parent. */
+		/* Tests PTRACE_MODE_READ on the parent. */
 		err_proc_read = test_ptrace_read(parent);
+		if (can_read_parent) {
+			EXPECT_EQ(0, err_proc_read);
+		} else {
+			EXPECT_EQ(EACCES, err_proc_read);
+		}
+
+		/* Tests PTRACE_ATTACH on the parent. */
 		ret = ptrace(PTRACE_ATTACH, parent, NULL, 0);
-		if (variant->domain_child) {
+		if (can_trace_parent) {
+			EXPECT_EQ(0, ret);
+		} else {
 			EXPECT_EQ(-1, ret);
 			EXPECT_EQ(EPERM, errno);
-			EXPECT_EQ(EACCES, err_proc_read);
-		} else {
-			EXPECT_EQ(0, ret);
-			EXPECT_EQ(0, err_proc_read);
 		}
 		if (ret == 0) {
 			ASSERT_EQ(parent, waitpid(parent, &status, 0));
@@ -283,11 +356,11 @@ TEST_F(hierarchy, trace)
 
 		/* Tests child PTRACE_TRACEME. */
 		ret = ptrace(PTRACE_TRACEME);
-		if (variant->domain_parent) {
+		if (can_trace_child) {
+			EXPECT_EQ(0, ret);
+		} else {
 			EXPECT_EQ(-1, ret);
 			EXPECT_EQ(EPERM, errno);
-		} else {
-			EXPECT_EQ(0, ret);
 		}
 
 		/*
@@ -296,7 +369,7 @@ TEST_F(hierarchy, trace)
 		 */
 		ASSERT_EQ(1, write(pipe_child[1], ".", 1));
 
-		if (!variant->domain_parent) {
+		if (can_trace_child) {
 			ASSERT_EQ(0, raise(SIGSTOP));
 		}
 
@@ -321,7 +394,7 @@ TEST_F(hierarchy, trace)
 	ASSERT_EQ(1, read(pipe_child[0], &buf_parent, 1));
 
 	/* Tests child PTRACE_TRACEME. */
-	if (!variant->domain_parent) {
+	if (can_trace_child) {
 		ASSERT_EQ(child, waitpid(child, &status, 0));
 		ASSERT_EQ(1, WIFSTOPPED(status));
 		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
@@ -331,17 +404,23 @@ TEST_F(hierarchy, trace)
 		EXPECT_EQ(ESRCH, errno);
 	}
 
-	/* Tests PTRACE_ATTACH and PTRACE_MODE_READ on the child. */
+	/* Tests PTRACE_MODE_READ on the child. */
 	err_proc_read = test_ptrace_read(child);
+	if (can_read_child) {
+		EXPECT_EQ(0, err_proc_read);
+	} else {
+		EXPECT_EQ(EACCES, err_proc_read);
+	}
+
+	/* Tests PTRACE_ATTACH on the child. */
 	ret = ptrace(PTRACE_ATTACH, child, NULL, 0);
-	if (variant->domain_parent) {
+	if (can_trace_child) {
+		EXPECT_EQ(0, ret);
+	} else {
 		EXPECT_EQ(-1, ret);
 		EXPECT_EQ(EPERM, errno);
-		EXPECT_EQ(EACCES, err_proc_read);
-	} else {
-		EXPECT_EQ(0, ret);
-		EXPECT_EQ(0, err_proc_read);
 	}
+
 	if (ret == 0) {
 		ASSERT_EQ(child, waitpid(child, &status, 0));
 		ASSERT_EQ(1, WIFSTOPPED(status));


