Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106BD1B3F80
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgDVKiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgDVKWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1351B208E4;
        Wed, 22 Apr 2020 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550923;
        bh=Nq/p5Yu5Y8F85wkdcOsUWekj/WRviFNnPxXsrikIyP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1w/Jn54zP165g3JNjCvBzk2bEtm8Z/pebYoL3iP8Aa0QAKGrd3jgb/1PCIav5uE3
         iQ49L7DVk9DzI/jxvmB9ClV+wQ5uaK43c150t/qOcrcztXL6UJP+4EsBmumKFhQlvt
         iCCMte+DUVfu2qihgq33DLmbX+eMoa0YFZIDfaDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.6 030/166] x86/Hyper-V: Report crash data in die() when panic_on_oops is set
Date:   Wed, 22 Apr 2020 11:55:57 +0200
Message-Id: <20200422095051.956967154@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit f3a99e761efa616028b255b4de58e9b5b87c5545 upstream.

When oops happens with panic_on_oops unset, the oops
thread is killed by die() and system continues to run.
In such case, guest should not report crash register
data to host since system still runs. Check panic_on_oops
and return directly in hyperv_report_panic() when the function
is called in the die() and panic_on_oops is unset. Fix it.

Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-7-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/hyperv/hv_init.c      |    6 +++++-
 drivers/hv/vmbus_drv.c         |    5 +++--
 include/asm-generic/mshyperv.h |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/hyperv.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 #include <linux/cpuhotplug.h>
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
@@ -419,11 +420,14 @@ void hyperv_cleanup(void)
 }
 EXPORT_SYMBOL_GPL(hyperv_cleanup);
 
-void hyperv_report_panic(struct pt_regs *regs, long err)
+void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
 {
 	static bool panic_reported;
 	u64 guest_id;
 
+	if (in_die && !panic_on_oops)
+		return;
+
 	/*
 	 * We prefer to report panic on 'die' chain as we have proper
 	 * registers to report, but if we miss it (e.g. on BUG()) we need
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -31,6 +31,7 @@
 #include <linux/kdebug.h>
 #include <linux/efi.h>
 #include <linux/random.h>
+#include <linux/kernel.h>
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include "hyperv_vmbus.h"
@@ -75,7 +76,7 @@ static int hyperv_panic_event(struct not
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
 	    && hyperv_report_reg()) {
 		regs = current_pt_regs();
-		hyperv_report_panic(regs, val);
+		hyperv_report_panic(regs, val, false);
 	}
 	return NOTIFY_DONE;
 }
@@ -92,7 +93,7 @@ static int hyperv_die_event(struct notif
 	 * the notification here.
 	 */
 	if (hyperv_report_reg())
-		hyperv_report_panic(regs, val);
+		hyperv_report_panic(regs, val, true);
 	return NOTIFY_DONE;
 }
 
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -163,7 +163,7 @@ static inline int cpumask_to_vpset(struc
 	return nr_bank;
 }
 
-void hyperv_report_panic(struct pt_regs *regs, long err);
+void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die);
 void hyperv_report_panic_msg(phys_addr_t pa, size_t size);
 bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);


