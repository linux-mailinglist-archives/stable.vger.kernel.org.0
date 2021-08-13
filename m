Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF173EB8E8
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhHMPSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242791AbhHMPQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327C7610E9;
        Fri, 13 Aug 2021 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867706;
        bh=TWErTnABs5ewrxTFQJAv7wK1WpkK/jRqxp7UAFvD8WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMZKyEvJFkxUXteQHIGzFVFnE0ePRQa0D42emA+pCv/X6hcEz2Yicn9nnWE9WtEPl
         BJle30HMwYCPNiX7aKp4o5vzbSDrCamydCfxA5UbKckIscY1wmQBhW8J1Jml2aEGJS
         Qf5PMGrSjk3RcPOshGKWDVzTAYy1tu/Xt01hTJJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.13 2/8] bpf: Add _kernel suffix to internal lockdown_bpf_read
Date:   Fri, 13 Aug 2021 17:07:39 +0200
Message-Id: <20210813150520.166271527@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
References: <20210813150520.090373732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 71330842ff93ae67a066c1fa68d75672527312fa upstream.

Rename LOCKDOWN_BPF_READ into LOCKDOWN_BPF_READ_KERNEL so we have naming
more consistent with a LOCKDOWN_BPF_WRITE_USER option that we are adding.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/security.h |    2 +-
 kernel/bpf/helpers.c     |    4 ++--
 kernel/trace/bpf_trace.c |    8 ++++----
 security/security.c      |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -123,7 +123,7 @@ enum lockdown_reason {
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
-	LOCKDOWN_BPF_READ,
+	LOCKDOWN_BPF_READ_KERNEL,
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1070,12 +1070,12 @@ bpf_base_func_proto(enum bpf_func_id fun
 	case BPF_FUNC_probe_read_user:
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_kernel_proto;
 	case BPF_FUNC_probe_read_user_str:
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_kernel_str_proto;
 	case BPF_FUNC_snprintf_btf:
 		return &bpf_snprintf_btf_proto;
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -999,19 +999,19 @@ bpf_tracing_func_proto(enum bpf_func_id
 	case BPF_FUNC_probe_read_user:
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_kernel_proto;
 	case BPF_FUNC_probe_read_user_str:
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_kernel_str_proto;
 #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	case BPF_FUNC_probe_read:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_compat_proto;
 	case BPF_FUNC_probe_read_str:
-		return security_locked_down(LOCKDOWN_BPF_READ) < 0 ?
+		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
 		       NULL : &bpf_probe_read_compat_str_proto;
 #endif
 #ifdef CONFIG_CGROUPS
--- a/security/security.c
+++ b/security/security.c
@@ -61,7 +61,7 @@ const char *const lockdown_reasons[LOCKD
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
-	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
+	[LOCKDOWN_BPF_READ_KERNEL] = "use of bpf to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",


