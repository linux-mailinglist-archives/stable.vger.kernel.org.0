Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA37B366C1C
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbhDUNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:11:00 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:25098 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242240AbhDUNJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010565; x=1650546565;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4dz49e0j4dlJ7n1U/S3W4X62ctZqCqEkCAOg6S2K1QI=;
  b=DjVS1CVwiOCSSl3SZL9zuavUbcHCk2BabKX3SYl32gTP2ldMd8ePoPcl
   bWr/s5JrPygO8xrf5+YNdXOrrdTcQY70DaXp3cMpljbkev2/VrOfNLQ5U
   r3fOV/VtjRaSb9mW/P6Fkjay6rrwr0tEGnmfyFFqSCRkkd/xfs11bEk8z
   c=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="120450391"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2021 13:09:24 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 5FB47A1D40;
        Wed, 21 Apr 2021 13:09:24 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.162.28) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:09:20 +0000
Subject: [PATCH 3/8] bpf: Restrict bpf_probe_read{, str}() only to archs
 where, they work
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <03beea9a-bbee-82c0-6842-833e57b0d786@amazon.com>
Date:   Wed, 21 Apr 2021 16:09:15 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0ebeea8ca8a4d1d453ad299aef0507dab04f6e8d upstream

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
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 arch/arm/Kconfig         | 1 +
 arch/arm64/Kconfig       | 1 +
 arch/x86/Kconfig         | 1 +
 init/Kconfig             | 3 +++
 kernel/trace/bpf_trace.c | 6 ++++--
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9aa88715f196..70f4057fb5b0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
     select ARCH_HAS_KEEPINITRD
     select ARCH_HAS_KCOV
     select ARCH_HAS_MEMBARRIER_SYNC_CORE
+    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
     select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
     select ARCH_HAS_PHYS_TO_DMA
     select ARCH_HAS_SETUP_DMA_OPS
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9c8ea5939865..a8c49916ab8c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -22,6 +22,7 @@ config ARM64
     select ARCH_HAS_KCOV
     select ARCH_HAS_KEEPINITRD
     select ARCH_HAS_MEMBARRIER_SYNC_CORE
+    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
     select ARCH_HAS_PTE_DEVMAP
     select ARCH_HAS_PTE_SPECIAL
     select ARCH_HAS_SETUP_DMA_OPS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ef85139553f..b9f666db10c1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,6 +70,7 @@ config X86
     select ARCH_HAS_KCOV            if X86_64
     select ARCH_HAS_MEM_ENCRYPT
     select ARCH_HAS_MEMBARRIER_SYNC_CORE
+    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
     select ARCH_HAS_PMEM_API        if X86_64
     select ARCH_HAS_PTE_DEVMAP        if X86_64
     select ARCH_HAS_PTE_SPECIAL
diff --git a/init/Kconfig b/init/Kconfig
index 96fc45d1b686..1781810d1501 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2210,6 +2210,9 @@ config ASN1
 
 source "kernel/Kconfig.locks"
 
+config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    bool
+
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
     bool
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0e329d48ab08..80f0072b31e0 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -808,14 +808,16 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
         return &bpf_probe_read_user_proto;
     case BPF_FUNC_probe_read_kernel:
         return &bpf_probe_read_kernel_proto;
-    case BPF_FUNC_probe_read:
-        return &bpf_probe_read_compat_proto;
     case BPF_FUNC_probe_read_user_str:
         return &bpf_probe_read_user_str_proto;
     case BPF_FUNC_probe_read_kernel_str:
         return &bpf_probe_read_kernel_str_proto;
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    case BPF_FUNC_probe_read:
+        return &bpf_probe_read_compat_proto;
     case BPF_FUNC_probe_read_str:
         return &bpf_probe_read_compat_str_proto;
+#endif
 #ifdef CONFIG_CGROUPS
     case BPF_FUNC_get_current_cgroup_id:
         return &bpf_get_current_cgroup_id_proto;
-- 
2.25.1


