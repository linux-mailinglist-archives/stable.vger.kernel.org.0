Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982481214B7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbfLPSOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:14:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbfLPSOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA0421775;
        Mon, 16 Dec 2019 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520045;
        bh=zxZs6ko0mtsxntLnAfKqr1zLGrhb0mWWaY4nzW/Ukmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqDCLvIbmV5lSc0CoKEYKjQqs0ogmOURJAFfZG8hU7aynyJqRZ3t093U7P0zZTjON
         nQduR64deg7U6xmKZD0JUznfHk4owMTGcgIJ8mVOUqI6k3iE7e/7ET3fZiwLKV9IX6
         FKTKCKzMRR8NazkJY4/XoAQrRZe/XRh3PaW+7WnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.3 175/180] s390/smp,vdso: fix ASCE handling
Date:   Mon, 16 Dec 2019 18:50:15 +0100
Message-Id: <20191216174848.079439949@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit a2308c11ecbc3471ebb7435ee8075815b1502ef0 upstream.

When a secondary CPU is brought up it must initialize its control
registers. CPU A which triggers that a secondary CPU B is brought up
stores its control register contents into the lowcore of new CPU B,
which then loads these values on startup.

This is problematic in various ways: the control register which
contains the home space ASCE will correctly contain the kernel ASCE;
however control registers for primary and secondary ASCEs are
initialized with whatever values were present in CPU A.

Typically:
- the primary ASCE will contain the user process ASCE of the process
  that triggered onlining of CPU B.
- the secondary ASCE will contain the percpu VDSO ASCE of CPU A.

Due to lazy ASCE handling we may also end up with other combinations.

When then CPU B switches to a different process (!= idle) it will
fixup the primary ASCE. However the problem is that the (wrong) ASCE
from CPU A was loaded into control register 1: as soon as an ASCE is
attached (aka loaded) a CPU is free to generate TLB entries using that
address space.
Even though it is very unlikey that CPU B will actually generate such
entries, this could result in TLB entries of the address space of the
process that ran on CPU A. These entries shouldn't exist at all and
could cause problems later on.

Furthermore the secondary ASCE of CPU B will not be updated correctly.
This means that processes may see wrong results or even crash if they
access VDSO data on CPU B. The correct VDSO ASCE will eventually be
loaded on return to user space as soon as the kernel executed a call
to strnlen_user or an atomic futex operation on CPU B.

Fix both issues by intializing the to be loaded control register
contents with the correct ASCEs and also enforce (re-)loading of the
ASCEs upon first context switch and return to user space.

Fixes: 0aaba41b58bc ("s390: remove all code using the access register mode")
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/smp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -262,10 +262,13 @@ static void pcpu_prepare_secondary(struc
 	lc->spinlock_index = 0;
 	lc->percpu_offset = __per_cpu_offset[cpu];
 	lc->kernel_asce = S390_lowcore.kernel_asce;
+	lc->user_asce = S390_lowcore.kernel_asce;
 	lc->machine_flags = S390_lowcore.machine_flags;
 	lc->user_timer = lc->system_timer =
 		lc->steal_timer = lc->avg_steal_timer = 0;
 	__ctl_store(lc->cregs_save_area, 0, 15);
+	lc->cregs_save_area[1] = lc->kernel_asce;
+	lc->cregs_save_area[7] = lc->vdso_asce;
 	save_access_regs((unsigned int *) lc->access_regs_save_area);
 	memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
 	       sizeof(lc->stfle_fac_list));
@@ -816,6 +819,8 @@ static void smp_init_secondary(void)
 
 	S390_lowcore.last_update_clock = get_tod_clock();
 	restore_access_regs(S390_lowcore.access_regs_save_area);
+	set_cpu_flag(CIF_ASCE_PRIMARY);
+	set_cpu_flag(CIF_ASCE_SECONDARY);
 	cpu_init();
 	preempt_disable();
 	init_cpu_timer();


