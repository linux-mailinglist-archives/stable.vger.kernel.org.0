Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80E2597A6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgIAQQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbgIAPeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE25205F4;
        Tue,  1 Sep 2020 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974452;
        bh=q9bZkLK6TRy5pq6ZaG5qqBVVi/g0i1JSivwPw7ASZCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1boBXUFdgho9lks2v6G8gtoq+xHLdBTHUTaLY3v/LFWJuz4cN1lcMzA0AJOmgdj4C
         47ukTvph0+CbOb5739aU9232PMlQm6lcOX68ZEtFknTJgXd51SRCc5TBQ0fcq5cpc2
         C7JChtr3Y1tQdc99i3s+S5gwxA0giSUq1Xqu87rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 181/214] x86/hotplug: Silence APIC only after all interrupts are migrated
Date:   Tue,  1 Sep 2020 17:11:01 +0200
Message-Id: <20200901151001.634780204@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

commit 52d6b926aabc47643cd910c85edb262b7f44c168 upstream.

There is a race when taking a CPU offline. Current code looks like this:

native_cpu_disable()
{
	...
	apic_soft_disable();
	/*
	 * Any existing set bits for pending interrupt to
	 * this CPU are preserved and will be sent via IPI
	 * to another CPU by fixup_irqs().
	 */
	cpu_disable_common();
	{
		....
		/*
		 * Race window happens here. Once local APIC has been
		 * disabled any new interrupts from the device to
		 * the old CPU are lost
		 */
		fixup_irqs(); // Too late to capture anything in IRR.
		...
	}
}

The fix is to disable the APIC *after* cpu_disable_common().

Testing was done with a USB NIC that provided a source of frequent
interrupts. A script migrated interrupts to a specific CPU and
then took that CPU offline.

Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
Reported-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
Link: https://lore.kernel.org/r/1598501530-45821-1-git-send-email-ashok.raj@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/smpboot.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1599,14 +1599,28 @@ int native_cpu_disable(void)
 	if (ret)
 		return ret;
 
-	/*
-	 * Disable the local APIC. Otherwise IPI broadcasts will reach
-	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
-	 * messages.
-	 */
-	apic_soft_disable();
 	cpu_disable_common();
 
+        /*
+         * Disable the local APIC. Otherwise IPI broadcasts will reach
+         * it. It still responds normally to INIT, NMI, SMI, and SIPI
+         * messages.
+         *
+         * Disabling the APIC must happen after cpu_disable_common()
+         * which invokes fixup_irqs().
+         *
+         * Disabling the APIC preserves already set bits in IRR, but
+         * an interrupt arriving after disabling the local APIC does not
+         * set the corresponding IRR bit.
+         *
+         * fixup_irqs() scans IRR for set bits so it can raise a not
+         * yet handled interrupt on the new destination CPU via an IPI
+         * but obviously it can't do so for IRR bits which are not set.
+         * IOW, interrupts arriving after disabling the local APIC will
+         * be lost.
+         */
+	apic_soft_disable();
+
 	return 0;
 }
 


