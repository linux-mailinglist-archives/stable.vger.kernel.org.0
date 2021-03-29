Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFB34CE56
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhC2K6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:58:42 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63069 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhC2K63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617015510; x=1648551510;
  h=subject:from:to:references:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=fxI6M23IfzQiFi59uu6xkh6i/wEPDldhO0Jj8BVasXo=;
  b=I1GRhvEm8PJb0DQfLrDRbci+t1yhN/eWtUNxAsTTXfTGVAQtJZWD4bvk
   PT/s5tfDwdynyMS5acqqo72BwzT7qQptM0y01ueE1cIzU0E/rMQWJioS4
   t1gjWGnnHHnFFEaY1rtTbQrQjYhJBQQyhydFKX/9ebicWAADuZSJzobDi
   M=;
X-IronPort-AV: E=Sophos;i="5.81,287,1610409600"; 
   d="scan'208";a="123730012"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Mar 2021 10:58:29 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 421FFA1C69
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:58:28 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.224) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Mar 2021 10:58:26 +0000
Subject: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Message-ID: <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
Date:   Mon, 29 Mar 2021 13:58:21 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.224]
X-ClientProxiedBy: EX13D12UWA001.ant.amazon.com (10.43.160.163) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit 8d92db5c04d10381f4db70ed99b1b576f5db18a7 upstream.

This is an adaptation of parts from above commit to kernel 5.4.

bpf_probe_read{,str}() BPF helpers are broken on arm64, where user
addresses cannot be accessed with normal kernelspace access.

Upstream solution got into v5.8 and cannot directly be cherry picked. We
implement the same mechanism in kernel 5.4.

Detection is only enabled for machines with non-overlapping address spaces
using CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE from commits:
commit 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
commit d195b1d1d119 ("powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again")

To generally fix the issue, upstream includes new BPF helpers:
bpf_probe_read_{user,kernel}_str(). For details on them, see
commit 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers")

Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 arch/arm/Kconfig         |  1 +
 arch/arm64/Kconfig       |  1 +
 arch/powerpc/Kconfig     |  1 +
 arch/x86/Kconfig         |  1 +
 init/Kconfig             |  3 +++
 kernel/trace/bpf_trace.c | 18 ++++++++++++++++++
 6 files changed, 25 insertions(+)

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
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c4cbb65e742f..c50bfab7930b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,7 @@ config PPC
     select ARCH_HAS_MMIOWB            if PPC64
     select ARCH_HAS_PHYS_TO_DMA
     select ARCH_HAS_PMEM_API
+    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
     select ARCH_HAS_PTE_DEVMAP        if PPC_BOOK3S_64
     select ARCH_HAS_PTE_SPECIAL
     select ARCH_HAS_MEMBARRIER_CALLBACKS
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
index 74c1db7178cf..ef534ad3f94d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -142,6 +142,15 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
 {
     int ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+        ret = probe_user_read(dst, unsafe_ptr, size);
+        if (unlikely(ret < 0))
+            goto out;
+        return ret;
+    }
+#endif
+
     ret = security_locked_down(LOCKDOWN_BPF_READ);
     if (ret < 0)
         goto out;
@@ -588,6 +597,15 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
 {
     int ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+        ret = strncpy_from_unsafe_user(dst, (__force void __user *)unsafe_ptr, size);
+        if (unlikely(ret < 0))
+            goto out;
+        return ret;
+    }
+#endif
+
     ret = security_locked_down(LOCKDOWN_BPF_READ);
     if (ret < 0)
         goto out;
-- 
2.25.1


