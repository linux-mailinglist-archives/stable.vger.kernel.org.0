Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB01206AC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfLPNK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 08:10:29 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45783 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbfLPNK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 08:10:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 384FB78E;
        Mon, 16 Dec 2019 08:10:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Dec 2019 08:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NpGIoG
        N0F8q3w97Df/FmbB5gifnSi8jIJ7UmWD6LfMU=; b=ZUbd7qsK/gaRwV015005LN
        aRyOYzFlgmwNZ0pwCu2hpoQBTjwzGBBEG37NqsVEZcdSh3XJ8CuEpx67unC/6OUI
        pdIZ6L+lWQ2pT9tS07HAP5PoWEd8p+kVNSb07nJAV0yXE89NUUV9Puk5yS3lQrfa
        bmqe9Caw4tUM/J+DvrbNh+ejdvEAOscsSJovkO/m+XwTDPqh5yWA/4mdSx2jM36K
        ERvrykLXvdQ7fb3GlSJp7ElDJ3ggME7OmgpXa9to3JeUj+36As3UsWH31oHA4lwl
        Y56+4vUl+XQvucM2PmLm+eqge0npZx3GGrELepCdD0qHx5rhOGoN9Ezo20HvcK0g
        ==
X-ME-Sender: <xms:Q4L3XbLXUGewN5sG9brPW4rVxs2tVlNkPBt0Op62-pXycD1DooaMTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Q4L3XVn-zhiZs2SgJW74X9HdaKCn1AdIM5PxX1-vc63bWJkcFmtcFw>
    <xmx:Q4L3XchUTBsDz1K6dygcRXo16blmZpKe7dlomx5WIoz1-NSaYL5SgA>
    <xmx:Q4L3XXSud9BDprMgTwfWsANo96gigLcRQM25ua0yUjLOm-5HtfdtRA>
    <xmx:Q4L3Xfqr-kItwsC5W-Xa8pD5dfKn5D0E70fXr8OQWlU5-Wo7knGW3w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BC813060132;
        Mon, 16 Dec 2019 08:10:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/smp,vdso: fix ASCE handling" failed to apply to 4.19-stable tree
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Dec 2019 14:10:23 +0100
Message-ID: <157650182321140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a2308c11ecbc3471ebb7435ee8075815b1502ef0 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 18 Nov 2019 13:09:52 +0100
Subject: [PATCH] s390/smp,vdso: fix ASCE handling

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

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 6acdcf1d4074..06dddd7c4290 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -262,10 +262,13 @@ static void pcpu_prepare_secondary(struct pcpu *pcpu, int cpu)
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
@@ -844,6 +847,8 @@ static void smp_init_secondary(void)
 
 	S390_lowcore.last_update_clock = get_tod_clock();
 	restore_access_regs(S390_lowcore.access_regs_save_area);
+	set_cpu_flag(CIF_ASCE_PRIMARY);
+	set_cpu_flag(CIF_ASCE_SECONDARY);
 	cpu_init();
 	preempt_disable();
 	init_cpu_timer();

