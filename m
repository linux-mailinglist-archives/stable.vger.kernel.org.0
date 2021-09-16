Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F9940E7F3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348317AbhIPRgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353553AbhIPReV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F017963227;
        Thu, 16 Sep 2021 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810916;
        bh=Jh5NE7jztA+6OO7D91sSydLB1UH+UHC6Tmy4Sbywk7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6O+PEVET9DcPmQuiP2nuvGV3eGqKtSoK4QUI620kNVrcfp3KCY3CUN9kbWHe59bS
         eKEXauDTR7tDIa8PUt8UzlDVKqgnstaPH3iqfJtBz7H8bcyfj7P2GIv24K3YUMugAj
         jcScaSPu6cEQajK/af7+MCPg2VR/6khGu157RvQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yucong Sun <fallentree@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 316/432] selftests/bpf: Correctly display subtest skip status
Date:   Thu, 16 Sep 2021 18:01:05 +0200
Message-Id: <20210916155821.530293266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 6f103106a39b..bfbf2277b61a 100644
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
@@ -786,17 +786,18 @@ int main(int argc, char **argv)
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



