Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57A129B93B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802272AbgJ0PqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368707AbgJ0P07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB7262225E;
        Tue, 27 Oct 2020 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812418;
        bh=qKyiqxC2XH9K5WvrSDOen+YG/1UyzcMWb3HhjktkOAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quL8knZfBhjH/vS8nrQg8OBu59C+pQa334WXOkk/mRBfSKZunqJnRrg9P395T8uWm
         RIfaihYJJMEfwhur1WehqtuUn1LdDpwk9uIsjqGGqXoY0xp2oICNR1hIg0O6YAFnUb
         tpL9Drgt0n31CKeDhmgnWJ2wyWNaYMQ1xgsVEQQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 202/757] selftests/bpf: Fix test_vmlinux test to use bpf_probe_read_user()
Date:   Tue, 27 Oct 2020 14:47:32 +0100
Message-Id: <20201027135500.081390144@linuxfoundation.org>
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

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 02f47faa25db134f6043fb6b12a68b5d4c980bb6 ]

The test is reading UAPI kernel structure from user-space. So it doesn't need
CO-RE relocations and has to use bpf_probe_read_user().

Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200818213356.2629020-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_vmlinux.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/testing/selftests/bpf/progs/test_vmlinux.c
index 29fa09d6a6c6d..e9dfa0313d1bb 100644
--- a/tools/testing/selftests/bpf/progs/test_vmlinux.c
+++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
@@ -19,12 +19,14 @@ SEC("tp/syscalls/sys_enter_nanosleep")
 int handle__tp(struct trace_event_raw_sys_enter *args)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
 
 	if (args->id != __NR_nanosleep)
 		return 0;
 
 	ts = (void *)args->args[0];
-	if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec != MY_TV_NSEC)
 		return 0;
 
 	tp_called = true;
@@ -35,12 +37,14 @@ SEC("raw_tp/sys_enter")
 int BPF_PROG(handle__raw_tp, struct pt_regs *regs, long id)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
 
 	if (id != __NR_nanosleep)
 		return 0;
 
 	ts = (void *)PT_REGS_PARM1_CORE(regs);
-	if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec != MY_TV_NSEC)
 		return 0;
 
 	raw_tp_called = true;
@@ -51,12 +55,14 @@ SEC("tp_btf/sys_enter")
 int BPF_PROG(handle__tp_btf, struct pt_regs *regs, long id)
 {
 	struct __kernel_timespec *ts;
+	long tv_nsec;
 
 	if (id != __NR_nanosleep)
 		return 0;
 
 	ts = (void *)PT_REGS_PARM1_CORE(regs);
-	if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
+	if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec) ||
+	    tv_nsec != MY_TV_NSEC)
 		return 0;
 
 	tp_btf_called = true;
-- 
2.25.1



