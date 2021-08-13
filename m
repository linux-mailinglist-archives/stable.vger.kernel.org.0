Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E9F3EB8E7
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242442AbhHMPSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242116AbhHMPQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4108061151;
        Fri, 13 Aug 2021 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867700;
        bh=4/lgIPol+nChr+skAjQv3qf8yYM0c1FswG71RKog0+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhsruix+EClnpoUhAVpIHSMlygkd1bExq8YwM7LdAiyqUDNGauGQwZAzNkZe/3X0R
         bUcfWdp6V5XMuNQVFQBIn+QwFy8+wD1BzfWtGZg0AGbslvJ1JYXPiEuhfOWDPSgN0F
         wrEdp/zya2P+ozIQOKuJx7PEN4VwzhXCbD2ahThw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.10 05/19] bpf: Add lockdown check for probe_write_user helper
Date:   Fri, 13 Aug 2021 17:07:22 +0200
Message-Id: <20210813150522.805128828@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 51e1bb9eeaf7868db56e58f47848e364ab4c4129 upstream.

Back then, commit 96ae52279594 ("bpf: Add bpf_probe_write_user BPF helper
to be called in tracers") added the bpf_probe_write_user() helper in order
to allow to override user space memory. Its original goal was to have a
facility to "debug, divert, and manipulate execution of semi-cooperative
processes" under CAP_SYS_ADMIN. Write to kernel was explicitly disallowed
since it would otherwise tamper with its integrity.

One use case was shown in cf9b1199de27 ("samples/bpf: Add test/example of
using bpf_probe_write_user bpf helper") where the program DNATs traffic
at the time of connect(2) syscall, meaning, it rewrites the arguments to
a syscall while they're still in userspace, and before the syscall has a
chance to copy the argument into kernel space. These days we have better
mechanisms in BPF for achieving the same (e.g. for load-balancers), but
without having to write to userspace memory.

Of course the bpf_probe_write_user() helper can also be used to abuse
many other things for both good or bad purpose. Outside of BPF, there is
a similar mechanism for ptrace(2) such as PTRACE_PEEK{TEXT,DATA} and
PTRACE_POKE{TEXT,DATA}, but would likely require some more effort.
Commit 96ae52279594 explicitly dedicated the helper for experimentation
purpose only. Thus, move the helper's availability behind a newly added
LOCKDOWN_BPF_WRITE_USER lockdown knob so that the helper is disabled under
the "integrity" mode. More fine-grained control can be implemented also
from LSM side with this change.

Fixes: 96ae52279594 ("bpf: Add bpf_probe_write_user BPF helper to be called in tracers")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/security.h |    1 +
 kernel/trace/bpf_trace.c |    5 +++--
 security/security.c      |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -120,6 +120,7 @@ enum lockdown_reason {
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
+	LOCKDOWN_BPF_WRITE_USER,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1272,12 +1272,13 @@ bpf_tracing_func_proto(enum bpf_func_id
 		return &bpf_get_numa_node_id_proto;
 	case BPF_FUNC_perf_event_read:
 		return &bpf_perf_event_read_proto;
-	case BPF_FUNC_probe_write_user:
-		return bpf_get_probe_write_proto();
 	case BPF_FUNC_current_task_under_cgroup:
 		return &bpf_current_task_under_cgroup_proto;
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
+	case BPF_FUNC_probe_write_user:
+		return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
+		       NULL : bpf_get_probe_write_proto();
 	case BPF_FUNC_probe_read_user:
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
--- a/security/security.c
+++ b/security/security.c
@@ -58,6 +58,7 @@ const char *const lockdown_reasons[LOCKD
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
+	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",


