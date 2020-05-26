Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDDD1E2D1B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392096AbgEZTTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391767AbgEZTNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55DDE20776;
        Tue, 26 May 2020 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520396;
        bh=yZ5/rhEe7WUsvfHlT+m3Cv1QiRqZebAQm7LCIRuiu1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmOM5XM5cG+aRiWudI4P4F98XHhKE8KbwmdeH+n4A9RdaBpy/+jo1J1ZQUfkwP9pK
         Hon0KDV8lyELV77wOx0l3V5RNpcrBN8Bi6/bOqsfusYTN4JHfW0E4UPmqI42tByaq4
         AZazhDeZpB1NyE+NedU+ba3XsvC52NWZZet5zst4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.6 062/126] bpf: Restrict bpf_probe_read{, str}() only to archs where they work
Date:   Tue, 26 May 2020 20:53:19 +0200
Message-Id: <20200526183943.372135882@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 0ebeea8ca8a4d1d453ad299aef0507dab04f6e8d upstream.

Given the legacy bpf_probe_read{,str}() BPF helpers are broken on archs
with overlapping address ranges, we should really take the next step to
disable them from BPF use there.

To generally fix the situation, we've recently added new helper variants
bpf_probe_read_{user,kernel}() and bpf_probe_read_{user,kernel}_str().
For details on them, see 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel}
and probe_read_{user,kernel}_str helpers").

Given bpf_probe_read{,str}() have been around for ~5 years by now, there
are plenty of users at least on x86 still relying on them today, so we
cannot remove them entirely w/o breaking the BPF tracing ecosystem.

However, their use should be restricted to archs with non-overlapping
address ranges where they are working in their current form. Therefore,
move this behind a CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE and
have x86, arm64, arm select it (other archs supporting it can follow-up
on it as well).

For the remaining archs, they can workaround easily by relying on the
feature probe from bpftool which spills out defines that can be used out
of BPF C code to implement the drop-in replacement for old/new kernels
via: bpftool feature probe macro

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/bpf/20200515101118.6508-2-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig         |    1 +
 arch/arm64/Kconfig       |    1 +
 arch/x86/Kconfig         |    1 +
 init/Kconfig             |    3 +++
 kernel/trace/bpf_trace.c |    6 ++++--
 5 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -13,6 +13,7 @@ config ARM
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_SETUP_DMA_OPS
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -21,6 +21,7 @@ config ARM64
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SETUP_DMA_OPS
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,6 +70,7 @@ config X86
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2223,6 +2223,9 @@ config ASN1
 
 source "kernel/Kconfig.locks"
 
+config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	bool
+
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	bool
 
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -857,14 +857,16 @@ tracing_func_proto(enum bpf_func_id func
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
 		return &bpf_probe_read_kernel_proto;
-	case BPF_FUNC_probe_read:
-		return &bpf_probe_read_compat_proto;
 	case BPF_FUNC_probe_read_user_str:
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
 		return &bpf_probe_read_kernel_str_proto;
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	case BPF_FUNC_probe_read:
+		return &bpf_probe_read_compat_proto;
 	case BPF_FUNC_probe_read_str:
 		return &bpf_probe_read_compat_str_proto;
+#endif
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;


