Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038AF300640
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbhAVOy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbhAVOXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B68623A62;
        Fri, 22 Jan 2021 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325107;
        bh=VhfkJTekfq/1ji7RLhgPJJP+IU1+k/aCfSnSOt1sE/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3VR7J3UlURYHPGvU7SvCi+lnixLUGBOs0hGQfIuh40e1W3wJHU/kM8JjrxjzOsSG
         xir2acvE1KJvwVRPVLXXRqwEO6Rw5BdgkGa7CwJYSqU4wBKAB+ejgco7pwnClq4hEi
         de2Wg2Wd6xdZKMZWWK23M17vb4bjYvQCgJQ0D92g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/43] x86/hyperv: Initialize clockevents after LAPIC is initialized
Date:   Fri, 22 Jan 2021 15:12:19 +0100
Message-Id: <20210122135735.780499208@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit fff7b5e6ee63c5d20406a131b260c619cdd24fd1 ]

With commit 4df4cb9e99f8, the Hyper-V direct-mode STIMER is actually
initialized before LAPIC is initialized: see

  apic_intr_mode_init()

    x86_platform.apic_post_init()
      hyperv_init()
        hv_stimer_alloc()

    apic_bsp_setup()
      setup_local_APIC()

setup_local_APIC() temporarily disables LAPIC, initializes it and
re-eanble it.  The direct-mode STIMER depends on LAPIC, and when it's
registered, it can be programmed immediately and the timer can fire
very soon:

  hv_stimer_init
    clockevents_config_and_register
      clockevents_register_device
        tick_check_new_device
          tick_setup_device
            tick_setup_periodic(), tick_setup_oneshot()
              clockevents_program_event

When the timer fires in the hypervisor, if the LAPIC is in the
disabled state, new versions of Hyper-V ignore the event and don't inject
the timer interrupt into the VM, and hence the VM hangs when it boots.

Note: when the VM starts/reboots, the LAPIC is pre-enabled by the
firmware, so the window of LAPIC being temporarily disabled is pretty
small, and the issue can only happen once out of 100~200 reboots for
a 40-vCPU VM on one dev host, and on another host the issue doesn't
reproduce after 2000 reboots.

The issue is more noticeable for kdump/kexec, because the LAPIC is
disabled by the first kernel, and stays disabled until the kdump/kexec
kernel enables it. This is especially an issue to a Generation-2 VM
(for which Hyper-V doesn't emulate the PIT timer) when CONFIG_HZ=1000
(rather than CONFIG_HZ=250) is used.

Fix the issue by moving hv_stimer_alloc() to a later place where the
LAPIC timer is initialized.

Fixes: 4df4cb9e99f8 ("x86/hyperv: Initialize clockevents earlier in CPU onlining")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210116223136.13892-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -312,6 +312,25 @@ static struct syscore_ops hv_syscore_ops
 	.resume		= hv_resume,
 };
 
+static void (* __initdata old_setup_percpu_clockev)(void);
+
+static void __init hv_stimer_setup_percpu_clockev(void)
+{
+	/*
+	 * Ignore any errors in setting up stimer clockevents
+	 * as we can run with the LAPIC timer as a fallback.
+	 */
+	(void)hv_stimer_alloc();
+
+	/*
+	 * Still register the LAPIC timer, because the direct-mode STIMER is
+	 * not supported by old versions of Hyper-V. This also allows users
+	 * to switch to LAPIC timer via /sys, if they want to.
+	 */
+	if (old_setup_percpu_clockev)
+		old_setup_percpu_clockev();
+}
+
 /*
  * This function is to be invoked early in the boot sequence after the
  * hypervisor has been detected.
@@ -390,10 +409,14 @@ void __init hyperv_init(void)
 	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	/*
-	 * Ignore any errors in setting up stimer clockevents
-	 * as we can run with the LAPIC timer as a fallback.
+	 * hyperv_init() is called before LAPIC is initialized: see
+	 * apic_intr_mode_init() -> x86_platform.apic_post_init() and
+	 * apic_bsp_setup() -> setup_local_APIC(). The direct-mode STIMER
+	 * depends on LAPIC, so hv_stimer_alloc() should be called from
+	 * x86_init.timers.setup_percpu_clockev.
 	 */
-	(void)hv_stimer_alloc();
+	old_setup_percpu_clockev = x86_init.timers.setup_percpu_clockev;
+	x86_init.timers.setup_percpu_clockev = hv_stimer_setup_percpu_clockev;
 
 	hv_apic_init();
 


