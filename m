Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F903283E1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhCAQ0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237678AbhCAQWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:22:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BCAB64EFB;
        Mon,  1 Mar 2021 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615568;
        bh=nwUVE8k9lBehfa4ihlkSPmlUuk+5YEsMYWhs0VWmORM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pua2t/dF6MiESr2px+b1KfBX0HPRnBOSxlPVhHSKsnP+tz4dq4RnUz3ZtYBBLEzpg
         j/Mac95cu58giwbKFEPGhOkFccMAI3K7LQAZx8zsMDWlgxr8ySwJfxRM9cLrvZdMVn
         +vl4Ie5AdYRzYdcjX0K+GOR6RyG98uE6VmL2LrrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        "David P. Reed" <dpreed@deepplum.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 76/93] x86/reboot: Force all cpus to exit VMX root if VMX is supported
Date:   Mon,  1 Mar 2021 17:13:28 +0100
Message-Id: <20210301161010.620175500@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ed72736183c45a413a8d6974dd04be90f514cb6b upstream.

Force all CPUs to do VMXOFF (via NMI shootdown) during an emergency
reboot if VMX is _supported_, as VMX being off on the current CPU does
not prevent other CPUs from being in VMX root (post-VMXON).  This fixes
a bug where a crash/panic reboot could leave other CPUs in VMX root and
prevent them from being woken via INIT-SIPI-SIPI in the new kernel.

Fixes: d176720d34c7 ("x86: disable VMX on all CPUs on reboot")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David P. Reed <dpreed@deepplum.com>
[sean: reworked changelog and further tweaked comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201231002702.2223707-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/reboot.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -479,29 +479,20 @@ static void emergency_vmx_disable_all(vo
 	local_irq_disable();
 
 	/*
-	 * We need to disable VMX on all CPUs before rebooting, otherwise
-	 * we risk hanging up the machine, because the CPU ignore INIT
-	 * signals when VMX is enabled.
+	 * Disable VMX on all CPUs before rebooting, otherwise we risk hanging
+	 * the machine, because the CPU blocks INIT when it's in VMX root.
 	 *
-	 * We can't take any locks and we may be on an inconsistent
-	 * state, so we use NMIs as IPIs to tell the other CPUs to disable
-	 * VMX and halt.
+	 * We can't take any locks and we may be on an inconsistent state, so
+	 * use NMIs as IPIs to tell the other CPUs to exit VMX root and halt.
 	 *
-	 * For safety, we will avoid running the nmi_shootdown_cpus()
-	 * stuff unnecessarily, but we don't have a way to check
-	 * if other CPUs have VMX enabled. So we will call it only if the
-	 * CPU we are running on has VMX enabled.
-	 *
-	 * We will miss cases where VMX is not enabled on all CPUs. This
-	 * shouldn't do much harm because KVM always enable VMX on all
-	 * CPUs anyway. But we can miss it on the small window where KVM
-	 * is still enabling VMX.
+	 * Do the NMI shootdown even if VMX if off on _this_ CPU, as that
+	 * doesn't prevent a different CPU from being in VMX root operation.
 	 */
-	if (cpu_has_vmx() && cpu_vmx_enabled()) {
-		/* Disable VMX on this CPU. */
-		cpu_vmxoff();
+	if (cpu_has_vmx()) {
+		/* Safely force _this_ CPU out of VMX root operation. */
+		__cpu_emergency_vmxoff();
 
-		/* Halt and disable VMX on the other CPUs */
+		/* Halt and exit VMX root operation on the other CPUs. */
 		nmi_shootdown_cpus(vmxoff_nmi);
 
 	}


