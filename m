Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4746F420D97
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhJDNQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhJDNOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1E7361B97;
        Mon,  4 Oct 2021 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352749;
        bh=Q/vUP3Zmw8Yw1BXBMLQQwD4vLyUa1rkialpTJn41U54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDP9DFQS+drRyqk47c/mTzu1Hu3QNSejMQ+MDw1gqIE5E2JfzhN6/Yfo1kFSBeYzp
         ovNBdp87UIKk+iN4u0HVjmUYX90FDuoBAa0vwTgwp1M2meV+CO8AAZhpsY2LRFtvll
         /krYBDDaGLN8TaHodwCLS3rsbmyFoslXoEllYMs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 11/56] x86/kvmclock: Move this_cpu_pvti into kvmclock.h
Date:   Mon,  4 Oct 2021 14:52:31 +0200
Message-Id: <20211004125030.366229271@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zelin Deng <zelin.deng@linux.alibaba.com>

commit ad9af930680bb396c87582edc172b3a7cf2a3fbf upstream.

There're other modules might use hv_clock_per_cpu variable like ptp_kvm,
so move it into kvmclock.h and export the symbol to make it visiable to
other modules.

Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Message-Id: <1632892429-101194-2-git-send-email-zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvmclock.h |   14 ++++++++++++++
 arch/x86/kernel/kvmclock.c      |   13 ++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -2,6 +2,20 @@
 #ifndef _ASM_X86_KVM_CLOCK_H
 #define _ASM_X86_KVM_CLOCK_H
 
+#include <linux/percpu.h>
+
 extern struct clocksource kvm_clock;
 
+DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+
+static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
+{
+	return &this_cpu_read(hv_clock_per_cpu)->pvti;
+}
+
+static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
+{
+	return this_cpu_read(hv_clock_per_cpu);
+}
+
 #endif /* _ASM_X86_KVM_CLOCK_H */
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -50,18 +50,9 @@ early_param("no-kvmclock-vsyscall", pars
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
-static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
-
-static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
-{
-	return &this_cpu_read(hv_clock_per_cpu)->pvti;
-}
-
-static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
-{
-	return this_cpu_read(hv_clock_per_cpu);
-}
+DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+EXPORT_PER_CPU_SYMBOL_GPL(hv_clock_per_cpu);
 
 /*
  * The wallclock is the time of day when we booted. Since then, some time may


