Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2ED5CB7A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfGBIGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbfGBIGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720312183F;
        Tue,  2 Jul 2019 08:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054809;
        bh=UGiJQGJTx3wkmG+1excLzEVoivEDKBu/VMBZYlSklB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/LLFqowIX0jxbGpmIoz0QFGxfvrYtMuGLl/pweN9xWkP5td0+3MAEXV79gDeMsji
         3t6WWgR7NBuDCP3z2nC2vgCyS8oo6lJttntPfGrsutJejG58OwLp//gwFxB0//3Fsa
         Szm2jOMPua3Ja2GMvKw/cVVyHXxIr5SbblOAgvCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 4.19 42/72] x86/microcode: Fix the microcode load on CPU hotplug for real
Date:   Tue,  2 Jul 2019 10:01:43 +0200
Message-Id: <20190702080126.819431850@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 5423f5ce5ca410b3646f355279e4e937d452e622 upstream.

A recent change moved the microcode loader hotplug callback into the early
startup phase which is running with interrupts disabled. It missed that
the callbacks invoke sysfs functions which might sleep causing nice 'might
sleep' splats with proper debugging enabled.

Split the callbacks and only load the microcode in the early startup phase
and move the sysfs handling back into the later threaded and preemptible
bringup phase where it was before.

Fixes: 78f4e932f776 ("x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1906182228350.1766@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -790,13 +790,16 @@ static struct syscore_ops mc_syscore_ops
 	.resume			= mc_bp_resume,
 };
 
-static int mc_cpu_online(unsigned int cpu)
+static int mc_cpu_starting(unsigned int cpu)
 {
-	struct device *dev;
-
-	dev = get_cpu_device(cpu);
 	microcode_update_cpu(cpu);
 	pr_debug("CPU%d added\n", cpu);
+	return 0;
+}
+
+static int mc_cpu_online(unsigned int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
 
 	if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 		pr_err("Failed to create group for CPU%d\n", cpu);
@@ -873,7 +876,9 @@ int __init microcode_init(void)
 		goto out_ucode_group;
 
 	register_syscore_ops(&mc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:online",
+	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:starting",
+				  mc_cpu_starting, NULL);
+	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
 				  mc_cpu_online, mc_cpu_down_prep);
 
 	pr_info("Microcode Update Driver: v%s.", DRIVER_VERSION);


