Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA835BF6A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbhDLJGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239006AbhDLJCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C16E6127B;
        Mon, 12 Apr 2021 09:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218057;
        bh=rbE1gKqUIkmoKQ7TMI/BKg9sUOTR7TsuwZhTio0Zbf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMnyPuwsaDMK2MuC64SUk4O1AEKvdw+uAzX5oBwa7l55mx5x0z1KcbQIu0rlWpw79
         4+y3hOJbQHZrClf6eX4+qq05akM/pq2CYKQO1bW4BWlNY0anuzwYD2raGdxrv5Wchu
         QQS96qYUuP6ffiETJljh0pwIllhBp8Z4kmzsao7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 020/210] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
Date:   Mon, 12 Apr 2021 10:38:45 +0200
Message-Id: <20210412084016.681016549@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit fa26d0c778b432d3d9814ea82552e813b33eeb5c upstream.

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/smp.h    |    2 +-
 arch/x86/kernel/smpboot.c     |   26 ++++++++++++--------------
 drivers/acpi/processor_idle.c |    4 +---
 3 files changed, 14 insertions(+), 18 deletions(-)

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
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1659,13 +1659,17 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-bool wakeup_cpu0(void)
+/**
+ * cond_wakeup_cpu0 - Wake up CPU0 if needed.
+ *
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
@@ -1734,11 +1738,8 @@ static inline void mwait_play_dead(void)
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
 
@@ -1749,11 +1750,8 @@ void hlt_play_dead(void)
 
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
 
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -544,9 +544,7 @@ static int acpi_idle_play_dead(struct cp
 			return -ENODEV;
 
 #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
-		/* If NMI wants to wake up CPU0, start CPU0. */
-		if (wakeup_cpu0())
-			start_cpu0();
+		cond_wakeup_cpu0();
 #endif
 	}
 


