Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9AB1C14E7
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbgEANoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731439AbgEANoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D4C208C3;
        Fri,  1 May 2020 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340642;
        bh=5o0zRSAvwZRdOYeiofGfqH+LgAyYpwIqYsvA446TR9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDxY/97HSmi9aMN6nRW28BPG+RaZK26pOwQ6enZBMp42pYuSOOJdcs/O1ilrdb/MA
         4BBtyJk0VvpsQWQ4Xo1Ipv7Osgng3fvODo5BUJ1LJbYbzyfdm/Bi/KhQ/qWBCxqWYV
         KqkLY65LUZJfqflIE+QQ9bVL72d86q9xR5HnOMQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.6 065/106] selftests/bpf: Fix a couple of broken test_btf cases
Date:   Fri,  1 May 2020 15:23:38 +0200
Message-Id: <20200501131552.174620192@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

commit e1cebd841b0aa1ceda771706d54a0501986a3c88 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   18 +++++-------------
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   18 +++++-------------
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |   18 +++++-------------
 tools/testing/selftests/bpf/test_btf.c             |    2 +-
 4 files changed, 16 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_btf_haskv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
@@ -20,20 +20,12 @@ struct bpf_map_def SEC("maps") btf_map =
 
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
@@ -44,15 +36,15 @@ int test_long_fname_2(struct dummy_trace
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
@@ -57,15 +49,15 @@ int test_long_fname_2(struct dummy_trace
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
--- a/tools/testing/selftests/bpf/progs/test_btf_nokv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
@@ -17,20 +17,12 @@ struct bpf_map_def SEC("maps") btf_map =
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
@@ -41,15 +33,15 @@ int test_long_fname_2(struct dummy_trace
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
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -2854,7 +2854,7 @@ static struct btf_raw_test raw_tests[] =
 	.value_type_id = 1,
 	.max_entries = 4,
 	.btf_load_err = true,
-	.err_str = "vlen != 0",
+	.err_str = "Invalid func linkage",
 },
 
 {


