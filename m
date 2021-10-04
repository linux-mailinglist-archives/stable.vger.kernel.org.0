Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D51C420F45
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhJDNcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237827AbhJDNao (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610B363216;
        Mon,  4 Oct 2021 13:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353238;
        bh=2FRvb1V+l4HExkvUZ8x62l9KF9jfqgK4JUZduYQLh2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RslifDSMdylJVGoh3sOgVA8dy4sbJUvOh/ggOT3fT/9opq0SZoaWlms/5KEf/S3/u
         IMAyZr8mldkNxO/s30dIjVbw3ib75pHpNlnFFj/Mmszcc4sOQpF3PQw29T8UJ23rnQ
         D/c2fZkqruScAA3hG1qUAiskUU69ETja1N6gwgg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 049/172] ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
Date:   Mon,  4 Oct 2021 14:51:39 +0200
Message-Id: <20211004125046.576094551@linuxfoundation.org>
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

commit 773e89ab0056aaa2baa1ffd9f044551654410104 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_kvm_x86.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

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
@@ -64,10 +61,8 @@ int kvm_arch_ptp_get_crosststamp(u64 *cy
 	struct pvclock_vcpu_time_info *src;
 	unsigned int version;
 	long ret;
-	int cpu;
 
-	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
+	src = this_cpu_pvti();
 
 	do {
 		/*


