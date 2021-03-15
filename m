Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466A033BC53
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhCOOYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238121AbhCOOWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0056864F2C;
        Mon, 15 Mar 2021 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818165;
        bh=KUA8aZbA0k8mleu6Koucf+BTSvcqRTKBhGS9Iskz/AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMOmWHzQ+uXKdLRd5qA7Jq7hghlOD4z2Eep7TpYcZZaD2weilDmjgo8bs7Ul0SIad
         EXq9wCCoOK2+KhJP7KDQjt+MTas8DHCWZk2qyhzPd2zin48qNA8yW5lFAy1ZhnDh1u
         3G6Xhweda/ZBTcnm/ZJSyTfoBmKvrMYN9GdofH1w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 277/290] KVM: kvmclock: Fix vCPUs > 64 cant be online/hotpluged
Date:   Mon, 15 Mar 2021 15:22:27 +0100
Message-Id: <20210315135551.391322899@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wanpeng Li <wanpengli@tencent.com>

commit d7eb79c6290c7ae4561418544072e0a3266e7384 upstream.

# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                88
On-line CPU(s) list:   0-63
Off-line CPU(s) list:  64-87

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=/dev/mapper/cl-root ro
rd.lvm.lv=cl/root rhgb quiet console=ttyS0 LANG=en_US .UTF-8 no-kvmclock-vsyscall

# echo 1 > /sys/devices/system/cpu/cpu76/online
-bash: echo: write error: Cannot allocate memory

The per-cpu vsyscall pvclock data pointer assigns either an element of the
static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
kvmclock_setup_percpu() which returns -ENOMEM. It's broken for no-vsyscall
and sometimes you end up with vsyscall disabled if the host does something
strange. This patch fixes it by allocating this dynamically memory
unconditionally even if vsyscall is disabled.

Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvmclock.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -269,21 +269,20 @@ static void __init kvmclock_init_mem(voi
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
-#ifdef CONFIG_X86_64
-	u8 flags;
+	kvmclock_init_mem();
 
-	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
-		return 0;
+#ifdef CONFIG_X86_64
+	if (per_cpu(hv_clock_per_cpu, 0) && kvmclock_vsyscall) {
+		u8 flags;
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	if (!(flags & PVCLOCK_TSC_STABLE_BIT))
-		return 0;
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		if (!(flags & PVCLOCK_TSC_STABLE_BIT))
+			return 0;
 
-	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+		kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+	}
 #endif
 
-	kvmclock_init_mem();
-
 	return 0;
 }
 early_initcall(kvm_setup_vsyscall_timeinfo);


