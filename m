Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6FE681D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbfJ0VZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732099AbfJ0VZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:17 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D9AE222BD;
        Sun, 27 Oct 2019 21:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211517;
        bh=sBK3e/HJ72aJFPRCV7NuKK2fRBkXmMl86jjjjgNUYbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1l7DicE5Xt5jH5lncunI3pi2KhV55GeXOA7WSWnggczXocKGl/eD+A1mkTvvruVK
         iBIiE/5B2YMlxmFxsGjlfEif+23o+iJ5xRBYYC0hAYWe/y3sGq2BKD2+5cpwhvHgJq
         fluc4j11RYLZCrr6xpOZvpB1tzsKgE5YuBTPts0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 5.3 177/197] x86/hyperv: Make vapic support x2apic mode
Date:   Sun, 27 Oct 2019 22:01:35 +0100
Message-Id: <20191027203405.081835714@linuxfoundation.org>
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

From: Roman Kagan <rkagan@virtuozzo.com>

commit e211288b72f15259da86eed6eca680758dbe9e74 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/hyperv/hv_apic.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

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


