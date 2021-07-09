Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3AC3C24CA
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhGINZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232213AbhGINY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E571613D0;
        Fri,  9 Jul 2021 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836933;
        bh=8GCosz4mmB3sHyHA/i5hIYENcu93sFCwKB+hY0FPsk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmKcJWpa0+GF+uGMQ8f9SN9l25fcWW6qTzTHg6wHQPrtf0210AwQLmSRO6XeXwjIS
         tOhr+rxW38qnDc7bfmBkuF61Ex/RvSqK/l0hmVfw+WMD2uHTPnZIp6B0I2IVpyyIFE
         QwJi3fPcwgPraloVA9qypkMVSFH3vTTL3hVU90fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Georgy Yakovlev <gyakovlev@gentoo.org>
Subject: [PATCH 5.10 1/6] KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
Date:   Fri,  9 Jul 2021 15:21:10 +0200
Message-Id: <20210709131538.737957977@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
References: <20210709131537.035851348@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

commit 25edcc50d76c834479d11fcc7de46f3da4d95121 upstream.

The Facility Status and Control Register is a privileged SPR that
defines the availability of some features in problem state. Since it
can be written by the guest, we must restore it to the previous host
value after guest exit.

This restoration is currently done by taking the value from
current->thread.fscr, which in the P9 path is not enough anymore
because the guest could context switch the QEMU thread, causing the
guest-current value to be saved into the thread struct.

The above situation manifested when running a QEMU linked against a
libc with System Call Vectored support, which causes scv
instructions to be run by QEMU early during the guest boot (during
SLOF), at which point the FSCR is 0 due to guest entry. After a few
scv calls (1 to a couple hundred), the context switching happens and
the QEMU thread runs with the guest value, resulting in a Facility
Unavailable interrupt.

This patch saves and restores the host value of FSCR in the inner
guest entry loop in a way independent of current->thread.fscr. The old
way of doing it is still kept in place because it works for the old
entry path.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Cc: Georgy Yakovlev <gyakovlev@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3583,6 +3583,7 @@ static int kvmhv_p9_guest_entry(struct k
 	unsigned long host_tidr = mfspr(SPRN_TIDR);
 	unsigned long host_iamr = mfspr(SPRN_IAMR);
 	unsigned long host_amr = mfspr(SPRN_AMR);
+	unsigned long host_fscr = mfspr(SPRN_FSCR);
 	s64 dec;
 	u64 tb;
 	int trap, save_pmu;
@@ -3726,6 +3727,9 @@ static int kvmhv_p9_guest_entry(struct k
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
 
+	if (host_fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, host_fscr);
+
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC


