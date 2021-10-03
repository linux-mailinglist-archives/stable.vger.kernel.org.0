Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A04201E3
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhJCOJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhJCOJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B848061A54;
        Sun,  3 Oct 2021 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270062;
        bh=NWMFfyXln7dmtFKGPXtWA7Cq8N1O/p5IIQJt645cu2A=;
        h=Subject:To:Cc:From:Date:From;
        b=yI1AORVqfqogjbmqvi4UvQFfdMw1iw5UrBjDsFe/9e04YeTW7oB/C6QyM8FH6DFxf
         t44yd3tlvNoaHGDHY7NmKw/5Fhb0dGhyjod0EnclH5WsjdOY+bE0UF/kvX+gdB2prk
         5tHx00YxunKtovSvh4dUBmo366iKDkUcCd9eLqA0=
Subject: FAILED: patch "[PATCH] ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm" failed to apply to 4.19-stable tree
To:     zelin.deng@linux.alibaba.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 16:07:37 +0200
Message-ID: <1633270057104221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 773e89ab0056aaa2baa1ffd9f044551654410104 Mon Sep 17 00:00:00 2001
From: Zelin Deng <zelin.deng@linux.alibaba.com>
Date: Wed, 29 Sep 2021 13:13:49 +0800
Subject: [PATCH] ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm

hv_clock is preallocated to have only HVC_BOOT_ARRAY_SIZE (64) elements;
if the PTP_SYS_OFFSET_PRECISE ioctl is executed on vCPUs whose index is
64 of higher, retrieving the struct pvclock_vcpu_time_info pointer with
"src = &hv_clock[cpu].pvti" will result in an out-of-bounds access and
a wild pointer.  Change it to "this_cpu_pvti()" which is guaranteed to
be valid.

Fixes: 95a3d4454bb1 ("Switch kvmclock data to a PER_CPU variable")
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Message-Id: <1632892429-101194-3-git-send-email-zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 3dd519dfc473..d0096cd7096a 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -15,8 +15,6 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/ptp_kvm.h>
 
-struct pvclock_vsyscall_time_info *hv_clock;
-
 static phys_addr_t clock_pair_gpa;
 static struct kvm_clock_pairing clock_pair;
 
@@ -28,8 +26,7 @@ int kvm_arch_ptp_init(void)
 		return -ENODEV;
 
 	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	hv_clock = pvclock_get_pvti_cpu0_va();
-	if (!hv_clock)
+	if (!pvclock_get_pvti_cpu0_va())
 		return -ENODEV;
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
@@ -64,10 +61,8 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 	struct pvclock_vcpu_time_info *src;
 	unsigned int version;
 	long ret;
-	int cpu;
 
-	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
+	src = this_cpu_pvti();
 
 	do {
 		/*

