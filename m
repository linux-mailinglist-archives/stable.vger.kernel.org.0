Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10413420F3F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhJDNcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237788AbhJDNaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC576320F;
        Mon,  4 Oct 2021 13:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353236;
        bh=if5UTbY3SkLutXxHO4a+zixpDnUYo3FZvKQYgN+ta9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig7hShOKyPe+NbnsDAUeLbQLkzhagfhRfpG+FWpqytDqrQng34ubD+iYekr990TGJ
         6OXnY8RH+Rc3W/zJYVrxBDIYESFHd5CtHYnw+D9pI2WvOCWRLeSpMSuoBEpD55fNts
         tVszByO8pqCngBBFIAqLVgt0sLaUFoI54rXpNfxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 048/172] x86/kvmclock: Move this_cpu_pvti into kvmclock.h
Date:   Mon,  4 Oct 2021 14:51:38 +0200
Message-Id: <20211004125046.540227130@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
@@ -49,18 +49,9 @@ early_param("no-kvmclock-vsyscall", pars
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


