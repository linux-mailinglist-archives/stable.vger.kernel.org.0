Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A768B253F35
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgH0HdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH0HdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 03:33:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE1C06121A;
        Thu, 27 Aug 2020 00:33:01 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:32:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598513579;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UTONwIWoakdM5Pm9p8xV8RpgnRMktI5rvR+YK01cji4=;
        b=Xw/X1P54/Ws/lJPaLZqXCG7qNeA6TqIuaEEFh8PhUuOOgQgwMQOzEwQVLubSco2sNyKR49
        4iemuCj0U6FodOKuU34QAO1/eGbkXaI6L8RE6Ice/gACc7nxzg9h7jC5MvcMgENl0Rr5j5
        oNX+By5dtr7Drf0TkIS3B+we0MTMynFHd3w9RnqzXZJpZsaz1ESncOqjGAgznwFrBbLPLg
        TBa1zaNWiTRAN27iOB6tBLxna4RhB/N9M0imZ9ueYWKEtVEiG4vPx6ToZDyUEuB6OdmRZz
        Fvn6sb6m0s/4/8Kqu0zMsa4nIDMfk1QiZkYBdmfE+JwCpGPx/gPM9k6XWhYVIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598513579;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UTONwIWoakdM5Pm9p8xV8RpgnRMktI5rvR+YK01cji4=;
        b=ttROVVxHcBBxzg8jJUqGYPKkGsZKNN9IYFQN6pS4JoVzxrmtwTSfLo+QQgAtY7DpUJ27Ju
        SBT1StbyU5hhhuAQ==
From:   "tip-bot2 for Ashok Raj" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/hotplug: Silence APIC only after all interrupts
 are migrated
Cc:     Evan Green <evgreen@chromium.org>, Ashok Raj <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1598501530-45821-1-git-send-email-ashok.raj@intel.com>
References: <1598501530-45821-1-git-send-email-ashok.raj@intel.com>
MIME-Version: 1.0
Message-ID: <159851357878.20229.13413295812887979769.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     52d6b926aabc47643cd910c85edb262b7f44c168
Gitweb:        https://git.kernel.org/tip/52d6b926aabc47643cd910c85edb262b7f44c168
Author:        Ashok Raj <ashok.raj@intel.com>
AuthorDate:    Wed, 26 Aug 2020 21:12:10 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 27 Aug 2020 09:29:23 +02:00

x86/hotplug: Silence APIC only after all interrupts are migrated

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

---
 arch/x86/kernel/smpboot.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 27aa04a..f5ef689 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1594,14 +1594,28 @@ int native_cpu_disable(void)
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
 
