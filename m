Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507B73A0069
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhFHSnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234901AbhFHSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CE1E61435;
        Tue,  8 Jun 2021 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177292;
        bh=2pFcPZItDWmiWl6oTayWIQ/fes7yNRaMSMigEXO5N5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIdDFx89ab3gBQ9fRtLM0AS87VuvPsnQiap7pjfQM1tQbD2TgxwTG+ifB0KPmUVTr
         +ve0ycny9E5tVdX4cKbrUN5DCznF9SJOmfFs8NpLfEeYqFLeFHdYSiD2v345nnu5S3
         RiEOUIMVHJ2qgq4OCFGyAeAOCoLWXJZCktK628/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 4.19 41/58] bpf: test make sure to run unpriv test cases in test_verifier
Date:   Tue,  8 Jun 2021 20:27:22 +0200
Message-Id: <20210608175933.627022745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 832c6f2c29ec519b766923937f4f93fb1008b47d upstream

Right now unprivileged tests are never executed as a BPF test run,
only loaded. Allow for running them as well so that we can check
the outcome and probe for regressions.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   71 +++++++++++++++-------------
 1 file changed, 40 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -70,7 +70,7 @@ struct bpf_test {
 	int fixup_cgroup_storage[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
-	uint32_t retval;
+	uint32_t retval, retval_unpriv;
 	enum {
 		UNDEF,
 		ACCEPT,
@@ -2986,6 +2986,8 @@ static struct bpf_test tests[] = {
 		.fixup_prog1 = { 2 },
 		.result = ACCEPT,
 		.retval = 42,
+		/* Verifier rewrite for unpriv skips tail call here. */
+		.retval_unpriv = 2,
 	},
 	{
 		"stack pointer arithmetic",
@@ -12811,6 +12813,33 @@ static void do_test_fixup(struct bpf_tes
 	}
 }
 
+static int set_admin(bool admin)
+{
+	cap_t caps;
+	const cap_value_t cap_val = CAP_SYS_ADMIN;
+	int ret = -1;
+
+	caps = cap_get_proc();
+	if (!caps) {
+		perror("cap_get_proc");
+		return -1;
+	}
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
+				admin ? CAP_SET : CAP_CLEAR)) {
+		perror("cap_set_flag");
+		goto out;
+	}
+	if (cap_set_proc(caps)) {
+		perror("cap_set_proc");
+		goto out;
+	}
+	ret = 0;
+out:
+	if (cap_free(caps))
+		perror("cap_free");
+	return ret;
+}
+
 static void do_test_single(struct bpf_test *test, bool unpriv,
 			   int *passes, int *errors)
 {
@@ -12819,6 +12848,7 @@ static void do_test_single(struct bpf_te
 	struct bpf_insn *prog = test->insns;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
+	uint32_t expected_val;
 	uint32_t retval;
 	int i, err;
 
@@ -12836,6 +12866,8 @@ static void do_test_single(struct bpf_te
 		       test->result_unpriv : test->result;
 	expected_err = unpriv && test->errstr_unpriv ?
 		       test->errstr_unpriv : test->errstr;
+	expected_val = unpriv && test->retval_unpriv ?
+		       test->retval_unpriv : test->retval;
 
 	reject_from_alignment = fd_prog < 0 &&
 				(test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -12869,16 +12901,20 @@ static void do_test_single(struct bpf_te
 		__u8 tmp[TEST_DATA_LEN << 2];
 		__u32 size_tmp = sizeof(tmp);
 
+		if (unpriv)
+			set_admin(true);
 		err = bpf_prog_test_run(fd_prog, 1, test->data,
 					sizeof(test->data), tmp, &size_tmp,
 					&retval, NULL);
+		if (unpriv)
+			set_admin(false);
 		if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
 			printf("Unexpected bpf_prog_test_run error\n");
 			goto fail_log;
 		}
-		if (!err && retval != test->retval &&
-		    test->retval != POINTER_VALUE) {
-			printf("FAIL retval %d != %d\n", retval, test->retval);
+		if (!err && retval != expected_val &&
+		    expected_val != POINTER_VALUE) {
+			printf("FAIL retval %d != %d\n", retval, expected_val);
 			goto fail_log;
 		}
 	}
@@ -12921,33 +12957,6 @@ static bool is_admin(void)
 	return (sysadmin == CAP_SET);
 }
 
-static int set_admin(bool admin)
-{
-	cap_t caps;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
-	int ret = -1;
-
-	caps = cap_get_proc();
-	if (!caps) {
-		perror("cap_get_proc");
-		return -1;
-	}
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
-				admin ? CAP_SET : CAP_CLEAR)) {
-		perror("cap_set_flag");
-		goto out;
-	}
-	if (cap_set_proc(caps)) {
-		perror("cap_set_proc");
-		goto out;
-	}
-	ret = 0;
-out:
-	if (cap_free(caps))
-		perror("cap_free");
-	return ret;
-}
-
 static void get_unpriv_disabled()
 {
 	char buf[2];


