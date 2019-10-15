Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C70D71C0
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 11:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfJOJCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 05:02:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43043 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfJOJCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 05:02:12 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iKIiU-0004Se-Ql; Tue, 15 Oct 2019 11:02:06 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 65CFE1C03AB;
        Tue, 15 Oct 2019 11:02:06 +0200 (CEST)
Date:   Tue, 15 Oct 2019 09:02:06 -0000
From:   "tip-bot2 for Roman Kagan" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/hyperv: Make vapic support x2apic mode
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191010123258.16919-1-rkagan@virtuozzo.com>
References: <20191010123258.16919-1-rkagan@virtuozzo.com>
MIME-Version: 1.0
Message-ID: <157113012628.12254.17085476162161245613.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e211288b72f15259da86eed6eca680758dbe9e74
Gitweb:        https://git.kernel.org/tip/e211288b72f15259da86eed6eca680758dbe9e74
Author:        Roman Kagan <rkagan@virtuozzo.com>
AuthorDate:    Thu, 10 Oct 2019 12:33:05 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 15 Oct 2019 10:57:09 +02:00

x86/hyperv: Make vapic support x2apic mode

Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
when supported by the vcpus.

However, the apic access functions for Hyper-V enlightened apic assume
xapic mode only.

As a result, Linux fails to bring up secondary cpus when run as a guest
in QEMU/KVM with both hv_apic and x2apic enabled.

According to Michael Kelley, when in x2apic mode, the Hyper-V synthetic
apic MSRs behave exactly the same as the corresponding architectural
x2apic MSRs, so there's no need to override the apic accessors.  The
only exception is hv_apic_eoi_write, which benefits from lazy EOI when
available; however, its implementation works for both xapic and x2apic
modes.

Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191010123258.16919-1-rkagan@virtuozzo.com

---
 arch/x86/hyperv/hv_apic.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index 5c056b8..e01078e 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -260,11 +260,21 @@ void __init hv_apic_init(void)
 	}
 
 	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
-		pr_info("Hyper-V: Using MSR based APIC access\n");
+		pr_info("Hyper-V: Using enlightened APIC (%s mode)",
+			x2apic_enabled() ? "x2apic" : "xapic");
+		/*
+		 * With x2apic, architectural x2apic MSRs are equivalent to the
+		 * respective synthetic MSRs, so there's no need to override
+		 * the apic accessors.  The only exception is
+		 * hv_apic_eoi_write, because it benefits from lazy EOI when
+		 * available, but it works for both xapic and x2apic modes.
+		 */
 		apic_set_eoi_write(hv_apic_eoi_write);
-		apic->read      = hv_apic_read;
-		apic->write     = hv_apic_write;
-		apic->icr_write = hv_apic_icr_write;
-		apic->icr_read  = hv_apic_icr_read;
+		if (!x2apic_enabled()) {
+			apic->read      = hv_apic_read;
+			apic->write     = hv_apic_write;
+			apic->icr_write = hv_apic_icr_write;
+			apic->icr_read  = hv_apic_icr_read;
+		}
 	}
 }
