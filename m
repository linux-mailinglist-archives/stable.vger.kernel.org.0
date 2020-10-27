Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088ED29B8FF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802138AbgJ0Ppo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800185AbgJ0PfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862D022275;
        Tue, 27 Oct 2020 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812916;
        bh=6GevnEkSYSDFM2PQ3eX/8crvxRbVOtvGlAMTxACwLpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwjHQTCAO9bCnvFT5gfMNmJ1o/flEOtonNhWGdF9NxMhqmEK1npHaAtYrY2ATXd5b
         qVO/UKLoPr8WZ0+BVL3lr7oNyWrNZ9YlJlh2f0atw+CH0+etp59D88dZwee0R6ieZW
         RoZa0vbXpNEuu2BCkP8lQhTcSWV5Aub1fu3jel6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 344/757] selftests: Remove fmod_ret from test_overhead
Date:   Tue, 27 Oct 2020 14:49:54 +0100
Message-Id: <20201027135506.704895933@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit b000def2e052fc8ddea31a18019f6ebe044defb3 ]

The test_overhead prog_test included an fmod_ret program that attached to
__set_task_comm() in the kernel. However, this function was never listed as
allowed for return modification, so this only worked because of the
verifier skipping tests when a trampoline already existed for the attach
point. Now that the verifier checks have been fixed, remove fmod_ret from
the test so it works again.

Fixes: 4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_overhead as part of bench")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bench.c             |  3 ---
 .../testing/selftests/bpf/benchs/bench_rename.c | 17 -----------------
 .../selftests/bpf/prog_tests/test_overhead.c    | 14 +-------------
 .../testing/selftests/bpf/progs/test_overhead.c |  6 ------
 4 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 944ad4721c83c..da14eaac71d03 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -311,7 +311,6 @@ extern const struct bench bench_rename_kretprobe;
 extern const struct bench bench_rename_rawtp;
 extern const struct bench bench_rename_fentry;
 extern const struct bench bench_rename_fexit;
-extern const struct bench bench_rename_fmodret;
 extern const struct bench bench_trig_base;
 extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
@@ -332,7 +331,6 @@ static const struct bench *benchs[] = {
 	&bench_rename_rawtp,
 	&bench_rename_fentry,
 	&bench_rename_fexit,
-	&bench_rename_fmodret,
 	&bench_trig_base,
 	&bench_trig_tp,
 	&bench_trig_rawtp,
@@ -462,4 +460,3 @@ int main(int argc, char **argv)
 
 	return 0;
 }
-
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index e74cff40f4fea..a967674098ada 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -106,12 +106,6 @@ static void setup_fexit()
 	attach_bpf(ctx.skel->progs.prog5);
 }
 
-static void setup_fmodret()
-{
-	setup_ctx();
-	attach_bpf(ctx.skel->progs.prog6);
-}
-
 static void *consumer(void *input)
 {
 	return NULL;
@@ -182,14 +176,3 @@ const struct bench bench_rename_fexit = {
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
 };
-
-const struct bench bench_rename_fmodret = {
-	.name = "rename-fmodret",
-	.validate = validate,
-	.setup = setup_fmodret,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
-	.measure = measure,
-	.report_progress = hits_drops_report_progress,
-	.report_final = hits_drops_report_final,
-};
diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
index 2702df2b23433..9966685866fdf 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_overhead.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -61,10 +61,9 @@ void test_test_overhead(void)
 	const char *raw_tp_name = "raw_tp/task_rename";
 	const char *fentry_name = "fentry/__set_task_comm";
 	const char *fexit_name = "fexit/__set_task_comm";
-	const char *fmodret_name = "fmod_ret/__set_task_comm";
 	const char *kprobe_func = "__set_task_comm";
 	struct bpf_program *kprobe_prog, *kretprobe_prog, *raw_tp_prog;
-	struct bpf_program *fentry_prog, *fexit_prog, *fmodret_prog;
+	struct bpf_program *fentry_prog, *fexit_prog;
 	struct bpf_object *obj;
 	struct bpf_link *link;
 	int err, duration = 0;
@@ -97,11 +96,6 @@ void test_test_overhead(void)
 	if (CHECK(!fexit_prog, "find_probe",
 		  "prog '%s' not found\n", fexit_name))
 		goto cleanup;
-	fmodret_prog = bpf_object__find_program_by_title(obj, fmodret_name);
-	if (CHECK(!fmodret_prog, "find_probe",
-		  "prog '%s' not found\n", fmodret_name))
-		goto cleanup;
-
 	err = bpf_object__load(obj);
 	if (CHECK(err, "obj_load", "err %d\n", err))
 		goto cleanup;
@@ -148,12 +142,6 @@ void test_test_overhead(void)
 	test_run("fexit");
 	bpf_link__destroy(link);
 
-	/* attach fmod_ret */
-	link = bpf_program__attach_trace(fmodret_prog);
-	if (CHECK(IS_ERR(link), "attach fmod_ret", "err %ld\n", PTR_ERR(link)))
-		goto cleanup;
-	test_run("fmod_ret");
-	bpf_link__destroy(link);
 cleanup:
 	prctl(PR_SET_NAME, comm, 0L, 0L, 0L);
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index 42403d088abc9..abb7344b531f4 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -39,10 +39,4 @@ int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
 	return 0;
 }
 
-SEC("fmod_ret/__set_task_comm")
-int BPF_PROG(prog6, struct task_struct *tsk, const char *buf, bool exec)
-{
-	return !tsk;
-}
-
 char _license[] SEC("license") = "GPL";
-- 
2.25.1



