Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90EE67E2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbfJ0VZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732692AbfJ0VZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:15 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D043F21783;
        Sun, 27 Oct 2019 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211514;
        bh=+fUGPU/cUvr4r1VruQzw+nmYANorNrfj6Z+QY1jRk18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ydku8zuFdPxfihrZijqqSwBgqGKIddNuyWhQ4VFIipf9qF7mq6DF7rXOKx5P7NOOn
         pFs3UBH69XHH8FFEqmIpf10XAVWHJ3tP5lUAtB6HPdvPJfpmZ83A7xIt2t954XKdqx
         OB2/BQenm69RqUl8z1mFoSrmAcbDPikv46nqm4U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.3 176/197] x86/apic/x2apic: Fix a NULL pointer deref when handling a dying cpu
Date:   Sun, 27 Oct 2019 22:01:34 +0100
Message-Id: <20191027203404.857732611@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 7a22e03b0c02988e91003c505b34d752a51de344 upstream.

Check that the per-cpu cluster mask pointer has been set prior to
clearing a dying cpu's bit.  The per-cpu pointer is not set until the
target cpu reaches smp_callin() during CPUHP_BRINGUP_CPU, whereas the
teardown function, x2apic_dead_cpu(), is associated with the earlier
CPUHP_X2APIC_PREPARE.  If an error occurs before the cpu is awakened,
e.g. if do_boot_cpu() itself fails, x2apic_dead_cpu() will dereference
the NULL pointer and cause a panic.

  smpboot: do_boot_cpu failed(-22) to wakeup CPU#1
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  RIP: 0010:x2apic_dead_cpu+0x1a/0x30
  Call Trace:
   cpuhp_invoke_callback+0x9a/0x580
   _cpu_up+0x10d/0x140
   do_cpu_up+0x69/0xb0
   smp_init+0x63/0xa9
   kernel_init_freeable+0xd7/0x229
   ? rest_init+0xa0/0xa0
   kernel_init+0xa/0x100
   ret_from_fork+0x35/0x40

Fixes: 023a611748fd5 ("x86/apic/x2apic: Simplify cluster management")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191001205019.5789-1-sean.j.christopherson@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/x2apic_cluster.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -158,7 +158,8 @@ static int x2apic_dead_cpu(unsigned int
 {
 	struct cluster_mask *cmsk = per_cpu(cluster_masks, dead_cpu);
 
-	cpumask_clear_cpu(dead_cpu, &cmsk->mask);
+	if (cmsk)
+		cpumask_clear_cpu(dead_cpu, &cmsk->mask);
 	free_cpumask_var(per_cpu(ipi_mask, dead_cpu));
 	return 0;
 }


