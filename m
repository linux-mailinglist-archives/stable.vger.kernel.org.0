Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2CC40E674
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbhIPRVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346306AbhIPQ4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB1D61ABD;
        Thu, 16 Sep 2021 16:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809872;
        bh=fXUm+1P8jqrO3JjwbNQzdbjMaWrfv6nz8zqrQTyzUZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIWFZA9HmBrIZivJaVSHznfTB+qpb6JlkRrsDLa0x7EJrC3gcNKxEZSr8UslOjmPw
         4KVVtZwa66KwrJ8+ls74yNKEETSsj0rAYEnz5bb3cq7e6Tq3pienZZx9q/C+b+vXnE
         Qs19/IELdSLnvkapk9XT+eyZ8etGrIWuqCYmsFE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yucong Sun <fallentree@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 282/380] selftests/bpf: Correctly display subtest skip status
Date:   Thu, 16 Sep 2021 18:00:39 +0200
Message-Id: <20210916155813.676508978@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yucong Sun <fallentree@fb.com>

[ Upstream commit f667d1d66760fcb27aee6c9964eefde39a464afe ]

In skip_account(), test->skip_cnt is set to 0 at the end, this makes next print
statement never display SKIP status for the subtest. This patch moves the
accounting logic after the print statement, fixing the issue.

This patch also added SKIP status display for normal tests.

Signed-off-by: Yucong Sun <fallentree@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210817044732.3263066-3-fallentree@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 25 ++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 6396932b97e2..9ed13187136c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -148,18 +148,18 @@ void test__end_subtest()
 	struct prog_test_def *test = env.test;
 	int sub_error_cnt = test->error_cnt - test->old_error_cnt;
 
-	if (sub_error_cnt)
-		env.fail_cnt++;
-	else if (test->skip_cnt == 0)
-		env.sub_succ_cnt++;
-	skip_account();
-
 	dump_test_log(test, sub_error_cnt);
 
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num, test->subtest_name,
 	       sub_error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
 
+	if (sub_error_cnt)
+		env.fail_cnt++;
+	else if (test->skip_cnt == 0)
+		env.sub_succ_cnt++;
+	skip_account();
+
 	free(test->subtest_name);
 	test->subtest_name = NULL;
 }
@@ -783,17 +783,18 @@ int main(int argc, char **argv)
 			test__end_subtest();
 
 		test->tested = true;
-		if (test->error_cnt)
-			env.fail_cnt++;
-		else
-			env.succ_cnt++;
-		skip_account();
 
 		dump_test_log(test, test->error_cnt);
 
 		fprintf(env.stdout, "#%d %s:%s\n",
 			test->test_num, test->test_name,
-			test->error_cnt ? "FAIL" : "OK");
+			test->error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
+
+		if (test->error_cnt)
+			env.fail_cnt++;
+		else
+			env.succ_cnt++;
+		skip_account();
 
 		reset_affinity();
 		restore_netns();
-- 
2.30.2



