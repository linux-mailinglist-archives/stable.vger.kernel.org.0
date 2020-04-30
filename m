Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B871BFA39
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgD3NwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbgD3NwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1707C20873;
        Thu, 30 Apr 2020 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254732;
        bh=o7KxBjb+d6apb6dejD19BxWHMPGDWq+w5wKpDjJLYwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBbZj/z4yMuNBownoV8xfSncBW+nFZEIJud8nl+uDxf42MTJTLunsrJcvKz86txj7
         KrG3Mpz/KfYvk+nHJF2F12Af7GiiF8v/WZyOVH4d/kTteWgGqgaHjmnsVqgddDh3PB
         6DdkrjC5tzXdu/N1Dm/VwdCsPZhCGapU5OaTYJ/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 79/79] selftests/bpf: Fix a couple of broken test_btf cases
Date:   Thu, 30 Apr 2020 09:50:43 -0400
Message-Id: <20200430135043.19851-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit e1cebd841b0aa1ceda771706d54a0501986a3c88 ]

Commit 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
introduced function linkage flag and changed the error message from
"vlen != 0" to "Invalid func linkage" and broke some fake BPF programs.

Adjust the test accordingly.

AFACT, the programs don't really need any arguments and only look
at BTF for maps, so let's drop the args altogether.

Before:
BTF raw test[103] (func (Non zero vlen)): do_test_raw:3703:FAIL expected
err_str:vlen != 0
magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 72
str_off: 72
str_len: 10
btf_total_size: 106
[1] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[2] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=(none)
[3] FUNC_PROTO (anon) return=0 args=(1 a, 2 b)
[4] FUNC func type_id=3 Invalid func linkage

BTF libbpf test[1] (test_btf_haskv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_haskv.o'
do_test_file:4201:FAIL bpf_object__load: -4007
BTF libbpf test[2] (test_btf_newkv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_newkv.o'
do_test_file:4201:FAIL bpf_object__load: -4007
BTF libbpf test[3] (test_btf_nokv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_nokv.o'
do_test_file:4201:FAIL bpf_object__load: -4007

Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200422003753.124921-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_btf_haskv.c       | 18 +++++-------------
 .../selftests/bpf/progs/test_btf_newkv.c       | 18 +++++-------------
 .../selftests/bpf/progs/test_btf_nokv.c        | 18 +++++-------------
 tools/testing/selftests/bpf/test_btf.c         |  2 +-
 4 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_btf_haskv.c b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
index 88b0566da13d2..31538c9ed1939 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_haskv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
@@ -20,20 +20,12 @@ struct bpf_map_def SEC("maps") btf_map = {
 
 BPF_ANNOTATE_KV_PAIR(btf_map, int, struct ipv_counts);
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -44,15 +36,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
index a924e53c8e9d8..6c5560162746b 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_newkv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -28,20 +28,12 @@ struct {
 	__type(value, struct ipv_counts);
 } btf_map SEC(".maps");
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -57,15 +49,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_btf_nokv.c b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
index 983aedd1c0725..506da7fd2da23 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_nokv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
@@ -17,20 +17,12 @@ struct bpf_map_def SEC("maps") btf_map = {
 	.max_entries = 4,
 };
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -41,15 +33,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 8da77cda5f4a5..305fae8f80a98 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -2854,7 +2854,7 @@ static struct btf_raw_test raw_tests[] = {
 	.value_type_id = 1,
 	.max_entries = 4,
 	.btf_load_err = true,
-	.err_str = "vlen != 0",
+	.err_str = "Invalid func linkage",
 },
 
 {
-- 
2.20.1

