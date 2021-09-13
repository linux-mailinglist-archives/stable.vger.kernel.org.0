Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07384091B3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343856AbhIMOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344015AbhIMOBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E44061A38;
        Mon, 13 Sep 2021 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540296;
        bh=ZXauSCTpwYPulSdlr4QkFP9UZG4JTRhMG+rUoiz/kSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzT72C9vuBYFjZMnKm5z+LEtk354fb240ISxffPy70UWCNpt2lTzbbOi5pC1nyj/O
         K7G7XsKJwGFnBCnHcvrBSQiSQJ3G9fp87U6CTyyE+n60yPihVFKnpCFo3Sl6XV2C/k
         5hRcTVsflCt4NqMFdhHs8Dqiuuf8aEM/9dwJiLtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 135/300] tools: Free BTF objects at various locations
Date:   Mon, 13 Sep 2021 15:13:16 +0200
Message-Id: <20210913131113.958081946@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 369e955b3d1c12f6ec2e51a95911bb80ada55d79 ]

Make sure to call btf__free() (and not simply free(), which does not
free all pointers stored in the struct) on pointers to struct btf
objects retrieved at various locations.

These were found while updating the calls to btf__get_from_id().

Fixes: 999d82cbc044 ("tools/bpf: enhance test_btf file testing to test func info")
Fixes: 254471e57a86 ("tools/bpf: bpftool: add support for func types")
Fixes: 7b612e291a5a ("perf tools: Synthesize PERF_RECORD_* for loaded BPF programs")
Fixes: d56354dc4909 ("perf tools: Save bpf_prog_info and BTF of new BPF programs")
Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
Fixes: fa853c4b839e ("perf stat: Enable counting events for BPF programs")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210729162028.29512-5-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c                     | 5 ++++-
 tools/perf/util/bpf-event.c                  | 4 ++--
 tools/perf/util/bpf_counter.c                | 3 ++-
 tools/testing/selftests/bpf/prog_tests/btf.c | 1 +
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index da4846c9856a..a51bf4c69879 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -778,6 +778,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		kernel_syms_destroy(&dd);
 	}
 
+	btf__free(btf);
+
 	return 0;
 }
 
@@ -1897,8 +1899,8 @@ static char *profile_target_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -1922,6 +1924,7 @@ static char *profile_target_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index cdecda1ddd36..17a9844e4fbf 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -296,7 +296,7 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 
 out:
 	free(info_linear);
-	free(btf);
+	btf__free(btf);
 	return err ? -1 : 0;
 }
 
@@ -486,7 +486,7 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	perf_env__fetch_btf(env, btf_id, btf);
 
 out:
-	free(btf);
+	btf__free(btf);
 	close(fd);
 }
 
diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index 5ed674a2f55e..a14f0098b343 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -74,8 +74,8 @@ static char *bpf_target_prog_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -99,6 +99,7 @@ static char *bpf_target_prog_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 0457ae32b270..5b7dd3227b78 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4384,6 +4384,7 @@ skip:
 	fprintf(stderr, "OK");
 
 done:
+	btf__free(btf);
 	free(func_info);
 	bpf_object__close(obj);
 }
-- 
2.30.2



