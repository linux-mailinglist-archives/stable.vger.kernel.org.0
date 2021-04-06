Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD2D3555EB
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbhDFOBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 10:01:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344854AbhDFOBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 10:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617717667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vcd7BHYNtxoz+eRNoIHPlVbvSdaUKMNauLrrc9ENf4o=;
        b=cAdbBUd+CPaPJaYZqH1toI6amsb1IYiL0RKMAbFHNl0twFxtUA+CN2jLwMnmwPD7MCu7dq
        fc3XETV1ychkIDF2ZEOZV3KZY7DwbW8XvzOt1WsmZ8SdgRLdvBNtDhrxA8Cga9Gq3cJIA9
        K8LpVY6WtkLuNdmNsX8uMb479Z5dVrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-3NuKkOnJMuiWiBL9X-WHDQ-1; Tue, 06 Apr 2021 10:01:05 -0400
X-MC-Unique: 3NuKkOnJMuiWiBL9X-WHDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429E7184F613;
        Tue,  6 Apr 2021 14:00:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA16E72194;
        Tue,  6 Apr 2021 14:00:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     x86@kernel.org, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
Date:   Tue,  6 Apr 2021 16:00:05 +0200
Message-Id: <20210406140005.554402-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8cdddd182bd7 ("ACPI: processor: Fix CPU0 wakeup in
acpi_idle_play_dead()") tried to fix CPU0 hotplug breakage by copying
wakeup_cpu0() + start_cpu0() logic from hlt_play_dead()//mwait_play_dead()
into acpi_idle_play_dead(). The problem is that these functions are not
exported to modules so when CONFIG_ACPI_PROCESSOR=m build fails.

The issue could've been fixed by exporting both wakeup_cpu0()/start_cpu0()
(the later from assembly) but it seems putting the whole pattern into a
new function and exporting it instead is better.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 8cdddd182bd7 ("CPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()")
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1:
- Rename wakeup_cpu0() to cond_wakeup_cpu0() and fold wakeup_cpu0() in
 as it has no other users [Rafael J. Wysocki]
---
 arch/x86/include/asm/smp.h    |  2 +-
 arch/x86/kernel/smpboot.c     | 24 ++++++++++--------------
 drivers/acpi/processor_idle.c |  4 +---
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 57ef2094af93..630ff08532be 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -132,7 +132,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
-bool wakeup_cpu0(void);
+void cond_wakeup_cpu0(void);
 
 void native_smp_send_reschedule(int cpu);
 void native_send_call_func_ipi(const struct cpumask *mask);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f877150a91da..147f1bba9736 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1659,13 +1659,15 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-bool wakeup_cpu0(void)
+/*
+ * If NMI wants to wake up CPU0, start CPU0.
+ */
+void cond_wakeup_cpu0(void)
 {
 	if (smp_processor_id() == 0 && enable_start_cpu0)
-		return true;
-
-	return false;
+		start_cpu0();
 }
+EXPORT_SYMBOL_GPL(cond_wakeup_cpu0);
 
 /*
  * We need to flush the caches before going to sleep, lest we have
@@ -1734,11 +1736,8 @@ static inline void mwait_play_dead(void)
 		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
-		/*
-		 * If NMI wants to wake up CPU0, start CPU0.
-		 */
-		if (wakeup_cpu0())
-			start_cpu0();
+
+		cond_wakeup_cpu0();
 	}
 }
 
@@ -1749,11 +1748,8 @@ void hlt_play_dead(void)
 
 	while (1) {
 		native_halt();
-		/*
-		 * If NMI wants to wake up CPU0, start CPU0.
-		 */
-		if (wakeup_cpu0())
-			start_cpu0();
+
+		cond_wakeup_cpu0();
 	}
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 768a6b4d2368..4e2d76b8b697 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -544,9 +544,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
 			return -ENODEV;
 
 #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
-		/* If NMI wants to wake up CPU0, start CPU0. */
-		if (wakeup_cpu0())
-			start_cpu0();
+		cond_wakeup_cpu0();
 #endif
 	}
 
-- 
2.30.2

