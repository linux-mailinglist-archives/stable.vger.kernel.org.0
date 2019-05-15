Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228F41F28C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfEOMEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbfEOLLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B662084E;
        Wed, 15 May 2019 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918703;
        bh=TMeOBgDtjVi5XUK8LA/Zc80O0TNNpj3QnIxLvUtITCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTIymkAEBDD3ifWWsXqResFgXhUhcIhVLFjUg1j1sJiXIVqxDGQBNV+RZBtUhTAvy
         rwOW3lXYpM5NV+prSHvUkuPn/3fbVlHTcLKZsWoRrqBvwsqW3zidtV2IeT6Y6osmA5
         H2IiffEoM3Lu2nxF0ig94kwezURMsQk8Zv5MjNQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 233/266] x86/speculation/mds: Add mds_clear_cpu_buffers()
Date:   Wed, 15 May 2019 12:55:40 +0200
Message-Id: <20190515090730.885031770@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 6a9e529272517755904b7afa639f6db59ddb793e upstream.

The Microarchitectural Data Sampling (MDS) vulernabilities are mitigated by
clearing the affected CPU buffers. The mechanism for clearing the buffers
uses the unused and obsolete VERW instruction in combination with a
microcode update which triggers a CPU buffer clear when VERW is executed.

Provide a inline function with the assembly magic. The argument of the VERW
instruction must be a memory operand as documented:

  "MD_CLEAR enumerates that the memory-operand variant of VERW (for
   example, VERW m16) has been extended to also overwrite buffers affected
   by MDS. This buffer overwriting functionality is not guaranteed for the
   register operand variant of VERW."

Documentation also recommends to use a writable data segment selector:

  "The buffer overwriting occurs regardless of the result of the VERW
   permission check, as well as when the selector is null or causes a
   descriptor load segment violation. However, for lowest latency we
   recommend using a selector that indicates a valid writable data
   segment."

Add x86 specific documentation about MDS and the internal workings of the
mitigation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4: drop changes to doc index and configuration]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/x86/mds.rst            |   99 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/nospec-branch.h |   25 ++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 Documentation/x86/mds.rst

--- /dev/null
+++ b/Documentation/x86/mds.rst
@@ -0,0 +1,99 @@
+Microarchitectural Data Sampling (MDS) mitigation
+=================================================
+
+.. _mds:
+
+Overview
+--------
+
+Microarchitectural Data Sampling (MDS) is a family of side channel attacks
+on internal buffers in Intel CPUs. The variants are:
+
+ - Microarchitectural Store Buffer Data Sampling (MSBDS) (CVE-2018-12126)
+ - Microarchitectural Fill Buffer Data Sampling (MFBDS) (CVE-2018-12130)
+ - Microarchitectural Load Port Data Sampling (MLPDS) (CVE-2018-12127)
+
+MSBDS leaks Store Buffer Entries which can be speculatively forwarded to a
+dependent load (store-to-load forwarding) as an optimization. The forward
+can also happen to a faulting or assisting load operation for a different
+memory address, which can be exploited under certain conditions. Store
+buffers are partitioned between Hyper-Threads so cross thread forwarding is
+not possible. But if a thread enters or exits a sleep state the store
+buffer is repartitioned which can expose data from one thread to the other.
+
+MFBDS leaks Fill Buffer Entries. Fill buffers are used internally to manage
+L1 miss situations and to hold data which is returned or sent in response
+to a memory or I/O operation. Fill buffers can forward data to a load
+operation and also write data to the cache. When the fill buffer is
+deallocated it can retain the stale data of the preceding operations which
+can then be forwarded to a faulting or assisting load operation, which can
+be exploited under certain conditions. Fill buffers are shared between
+Hyper-Threads so cross thread leakage is possible.
+
+MLPDS leaks Load Port Data. Load ports are used to perform load operations
+from memory or I/O. The received data is then forwarded to the register
+file or a subsequent operation. In some implementations the Load Port can
+contain stale data from a previous operation which can be forwarded to
+faulting or assisting loads under certain conditions, which again can be
+exploited eventually. Load ports are shared between Hyper-Threads so cross
+thread leakage is possible.
+
+
+Exposure assumptions
+--------------------
+
+It is assumed that attack code resides in user space or in a guest with one
+exception. The rationale behind this assumption is that the code construct
+needed for exploiting MDS requires:
+
+ - to control the load to trigger a fault or assist
+
+ - to have a disclosure gadget which exposes the speculatively accessed
+   data for consumption through a side channel.
+
+ - to control the pointer through which the disclosure gadget exposes the
+   data
+
+The existence of such a construct in the kernel cannot be excluded with
+100% certainty, but the complexity involved makes it extremly unlikely.
+
+There is one exception, which is untrusted BPF. The functionality of
+untrusted BPF is limited, but it needs to be thoroughly investigated
+whether it can be used to create such a construct.
+
+
+Mitigation strategy
+-------------------
+
+All variants have the same mitigation strategy at least for the single CPU
+thread case (SMT off): Force the CPU to clear the affected buffers.
+
+This is achieved by using the otherwise unused and obsolete VERW
+instruction in combination with a microcode update. The microcode clears
+the affected CPU buffers when the VERW instruction is executed.
+
+For virtualization there are two ways to achieve CPU buffer
+clearing. Either the modified VERW instruction or via the L1D Flush
+command. The latter is issued when L1TF mitigation is enabled so the extra
+VERW can be avoided. If the CPU is not affected by L1TF then VERW needs to
+be issued.
+
+If the VERW instruction with the supplied segment selector argument is
+executed on a CPU without the microcode update there is no side effect
+other than a small number of pointlessly wasted CPU cycles.
+
+This does not protect against cross Hyper-Thread attacks except for MSBDS
+which is only exploitable cross Hyper-thread when one of the Hyper-Threads
+enters a C-state.
+
+The kernel provides a function to invoke the buffer clearing:
+
+    mds_clear_cpu_buffers()
+
+The mitigation is invoked on kernel/userspace, hypervisor/guest and C-state
+(idle) transitions.
+
+According to current knowledge additional mitigations inside the kernel
+itself are not required because the necessary gadgets to expose the leaked
+data cannot be controlled in a way which allows exploitation from malicious
+user space or VM guests.
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -262,6 +262,31 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+#include <asm/segment.h>
+
+/**
+ * mds_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * This uses the otherwise unused and obsolete VERW instruction in
+ * combination with microcode which triggers a CPU buffer flush when the
+ * instruction is executed.
+ */
+static inline void mds_clear_cpu_buffers(void)
+{
+	static const u16 ds = __KERNEL_DS;
+
+	/*
+	 * Has to be the memory-operand variant because only that
+	 * guarantees the CPU buffer flush functionality according to
+	 * documentation. The register-operand variant does not.
+	 * Works with any segment selector, but a valid writable
+	 * data segment is the fastest variant.
+	 *
+	 * "cc" clobber is required because VERW modifies ZF.
+	 */
+	asm volatile("verw %[ds]" : : [ds] "m" (ds) : "cc");
+}
+
 #endif /* __ASSEMBLY__ */
 
 /*


