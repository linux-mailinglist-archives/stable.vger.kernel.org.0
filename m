Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393EE50107D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbiDNNlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344481AbiDNNcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353F61402E;
        Thu, 14 Apr 2022 06:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF97BB8296A;
        Thu, 14 Apr 2022 13:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24949C385A5;
        Thu, 14 Apr 2022 13:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942987;
        bh=cH9qtlJzWzzbrJmm9KGn9QfSPSOANxZoTNn1kbmxDXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DW0lCj3Icy/SwihcAqXLRcntRcgQkOmiV57H1NNhvvXpleRKdV8a5kzHBw5qVlaZr
         PFTBMlB8t7S7HQrsUfcfzsL0M8oUgKPP7bYsftMK7v2x5ReMuCOyt7bJH6X0PaMEov
         Fqc/oHYErFARCtwgdyD0HcBEWEs46qTq+wj0MUwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 334/338] selftests: cgroup: Test open-time credential usage for migration checks
Date:   Thu, 14 Apr 2022 15:13:57 +0200
Message-Id: <20220414110848.398013836@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

commit 613e040e4dc285367bff0f8f75ea59839bc10947 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the credentials of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[OP: backport to v4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/test_core.c |   68 +++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -354,6 +354,73 @@ cleanup:
 	return ret;
 }
 
+/*
+ * cgroup migration permission check should be performed based on the
+ * credentials at the time of open instead of write.
+ */
+static int test_cgcore_lesser_euid_open(const char *root)
+{
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	uid_t saved_uid;
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
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	saved_uid = geteuid();
+	if (seteuid(test_euid))
+		goto cleanup;
+
+	cg_test_b_procs_fd = open(cg_test_b_procs, O_RDWR);
+
+	if (seteuid(saved_uid))
+		goto cleanup;
+
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (write(cg_test_b_procs_fd, "0", 1) >= 0 || errno != EACCES)
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
@@ -366,6 +433,7 @@ struct corecg_test {
 	T(test_cgcore_parent_becomes_threaded),
 	T(test_cgcore_invalid_domain),
 	T(test_cgcore_populated),
+	T(test_cgcore_lesser_euid_open),
 };
 #undef T
 


