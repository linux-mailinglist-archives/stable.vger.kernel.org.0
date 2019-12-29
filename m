Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA812C687
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbfL2Rr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731357AbfL2Rrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A1120718;
        Sun, 29 Dec 2019 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641675;
        bh=idPGTwjiKTc0RNMjd0MVtez8N5CATxzLHU4CGWba0e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+j3OE5i/RagePnsUdu4nBe0Dsf2ur/7ETDJ9V1uq+w/8Ll2J+DTR/INjplkoT/N6
         BkKj+P29FRq4HmQrrIYL+MaA1F2t1dUkwmNa5+f1f27owCcuNGbVI7qpn5nak2UC+m
         Z7+lHtT2YucoKG91Qmw4KUmaGyqX5vNNO4/WOmXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/434] selftests/bpf: Make a copy of subtest name
Date:   Sun, 29 Dec 2019 18:23:37 +0100
Message-Id: <20191229172712.692549462@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit f90415e9600c5227131531c0ed11514a2d3bbe62 ]

test_progs never created a copy of subtest name, rather just stored
pointer to whatever string test provided. This is bad as that string
might be freed or modified by the end of subtest. Fix this by creating
a copy of given subtest name when subtest starts.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191021033902.3856966-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index af75a1c7a458..3bf18364c67c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -20,7 +20,7 @@ struct prog_test_def {
 	bool tested;
 	bool need_cgroup_cleanup;
 
-	const char *subtest_name;
+	char *subtest_name;
 	int subtest_num;
 
 	/* store counts before subtest started */
@@ -81,16 +81,17 @@ void test__end_subtest()
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+
+	free(test->subtest_name);
+	test->subtest_name = NULL;
 }
 
 bool test__start_subtest(const char *name)
 {
 	struct prog_test_def *test = env.test;
 
-	if (test->subtest_name) {
+	if (test->subtest_name)
 		test__end_subtest();
-		test->subtest_name = NULL;
-	}
 
 	test->subtest_num++;
 
@@ -104,7 +105,13 @@ bool test__start_subtest(const char *name)
 	if (!should_run(&env.subtest_selector, test->subtest_num, name))
 		return false;
 
-	test->subtest_name = name;
+	test->subtest_name = strdup(name);
+	if (!test->subtest_name) {
+		fprintf(env.stderr,
+			"Subtest #%d: failed to copy subtest name!\n",
+			test->subtest_num);
+		return false;
+	}
 	env.test->old_error_cnt = env.test->error_cnt;
 
 	return true;
-- 
2.20.1



