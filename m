Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048962C4428
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgKYPlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbgKYPgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3305621D40;
        Wed, 25 Nov 2020 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318613;
        bh=p6UGhE7Kc4+yR/tYHmb8lv+gJLMFBCybGCvMZ4pJ5Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4xRBXTeEIREiQPetfVI3J5Rw3WNws5loFNmXBO/HVVUJHLlQTxBUfK4RtMOy0E4h
         meBar3EbG00p14TycPrFot5CVNkpShMJB30n6QNztyFMexEpCaLl3atNZJSByK+tNV
         10yuZrTnX6Fl2207v7w5osH3uMKNpIszFvgqoRr4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <bmasney@redhat.com>, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.4 10/23] x86/xen: don't unbind uninitialized lock_kicker_irq
Date:   Wed, 25 Nov 2020 10:36:25 -0500
Message-Id: <20201125153638.810419-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153638.810419-1-sashal@kernel.org>
References: <20201125153638.810419-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 65cae18882f943215d0505ddc7e70495877308e6 ]

When booting a hyperthreaded system with the kernel parameter
'mitigations=auto,nosmt', the following warning occurs:

    WARNING: CPU: 0 PID: 1 at drivers/xen/events/events_base.c:1112 unbind_from_irqhandler+0x4e/0x60
    ...
    Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
    ...
    Call Trace:
     xen_uninit_lock_cpu+0x28/0x62
     xen_hvm_cpu_die+0x21/0x30
     takedown_cpu+0x9c/0xe0
     ? trace_suspend_resume+0x60/0x60
     cpuhp_invoke_callback+0x9a/0x530
     _cpu_up+0x11a/0x130
     cpu_up+0x7e/0xc0
     bringup_nonboot_cpus+0x48/0x50
     smp_init+0x26/0x79
     kernel_init_freeable+0xea/0x229
     ? rest_init+0xaa/0xaa
     kernel_init+0xa/0x106
     ret_from_fork+0x35/0x40

The secondary CPUs are not activated with the nosmt mitigations and only
the primary thread on each CPU core is used. In this situation,
xen_hvm_smp_prepare_cpus(), and more importantly xen_init_lock_cpu(), is
not called, so the lock_kicker_irq is not initialized for the secondary
CPUs. Let's fix this by exiting early in xen_uninit_lock_cpu() if the
irq is not set to avoid the warning from above for each secondary CPU.

Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20201107011119.631442-1-bmasney@redhat.com
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/spinlock.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 6deb49094c605..d817b7c862a62 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -93,10 +93,20 @@ void xen_init_lock_cpu(int cpu)
 
 void xen_uninit_lock_cpu(int cpu)
 {
+	int irq;
+
 	if (!xen_pvspin)
 		return;
 
-	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
+	/*
+	 * When booting the kernel with 'mitigations=auto,nosmt', the secondary
+	 * CPUs are not activated, and lock_kicker_irq is not initialized.
+	 */
+	irq = per_cpu(lock_kicker_irq, cpu);
+	if (irq == -1)
+		return;
+
+	unbind_from_irqhandler(irq, NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
 	kfree(per_cpu(irq_name, cpu));
 	per_cpu(irq_name, cpu) = NULL;
-- 
2.27.0

