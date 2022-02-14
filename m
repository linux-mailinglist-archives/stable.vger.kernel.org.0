Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADF44B4B54
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344393AbiBNKCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345715AbiBNKBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEA1FA78;
        Mon, 14 Feb 2022 01:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE77DB80DC7;
        Mon, 14 Feb 2022 09:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106B8C36AE7;
        Mon, 14 Feb 2022 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832085;
        bh=nnkR1liPy/sLJmIleVRh/hbU3UeJPndsnapMHEQSHlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE1cCgihXBugoewUlXLqUE4UBlhuTeNlCPvsCl4ORv55FZ+8PtuSqL/xiy0U92IfO
         WQ+kBfIgvE0gXjoTa6zRf8di+p1SAljtnP+393ca2uSvAmpPr7/kqtgVPmn0lOSAGc
         7zrS0b/l23C3qh8kmiCQTlC6f2SzfSByRcUSnzkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 075/172] PM: s2idle: ACPI: Fix wakeup interrupts handling
Date:   Mon, 14 Feb 2022 10:25:33 +0100
Message-Id: <20220214092508.996426094@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit cb1f65c1e1424a4b5e4a86da8aa3b8fd8459c8ec upstream.

After commit e3728b50cd9b ("ACPI: PM: s2idle: Avoid possible race
related to the EC GPE") wakeup interrupts occurring immediately after
the one discarded by acpi_s2idle_wake() may be missed.  Moreover, if
the SCI triggers again immediately after the rearming in
acpi_s2idle_wake(), that wakeup may be missed too.

The problem is that pm_system_irq_wakeup() only calls pm_system_wakeup()
when pm_wakeup_irq is 0, but that's not the case any more after the
interrupt causing acpi_s2idle_wake() to run until pm_wakeup_irq is
cleared by the pm_wakeup_clear() call in s2idle_loop().  However,
there may be wakeup interrupts occurring in that time frame and if
that happens, they will be missed.

To address that issue first move the clearing of pm_wakeup_irq to
the point at which it is known that the interrupt causing
acpi_s2idle_wake() to tun will be discarded, before rearming the SCI
for wakeup.  Moreover, because that only reduces the size of the
time window in which the issue may manifest itself, allow
pm_system_irq_wakeup() to register two second wakeup interrupts in
a row and, when discarding the first one, replace it with the second
one.  [Of course, this assumes that only one wakeup interrupt can be
discarded in one go, but currently that is the case and I am not
aware of any plans to change that.]

Fixes: e3728b50cd9b ("ACPI: PM: s2idle: Avoid possible race related to the EC GPE")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sleep.c        |    1 +
 drivers/base/power/wakeup.c |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/suspend.h     |    4 ++--
 kernel/power/main.c         |    5 ++++-
 kernel/power/process.c      |    2 +-
 kernel/power/suspend.c      |    2 --
 6 files changed, 42 insertions(+), 13 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -767,6 +767,7 @@ bool acpi_s2idle_wake(void)
 			return true;
 		}
 
+		pm_wakeup_clear(acpi_sci_irq);
 		rearm_wake_irq(acpi_sci_irq);
 	}
 
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -34,7 +34,8 @@ suspend_state_t pm_suspend_target_state;
 bool events_check_enabled __read_mostly;
 
 /* First wakeup IRQ seen by the kernel in the last cycle. */
-unsigned int pm_wakeup_irq __read_mostly;
+static unsigned int wakeup_irq[2] __read_mostly;
+static DEFINE_RAW_SPINLOCK(wakeup_irq_lock);
 
 /* If greater than 0 and the system is suspending, terminate the suspend. */
 static atomic_t pm_abort_suspend __read_mostly;
@@ -942,19 +943,45 @@ void pm_system_cancel_wakeup(void)
 	atomic_dec_if_positive(&pm_abort_suspend);
 }
 
-void pm_wakeup_clear(bool reset)
+void pm_wakeup_clear(unsigned int irq_number)
 {
-	pm_wakeup_irq = 0;
-	if (reset)
+	raw_spin_lock_irq(&wakeup_irq_lock);
+
+	if (irq_number && wakeup_irq[0] == irq_number)
+		wakeup_irq[0] = wakeup_irq[1];
+	else
+		wakeup_irq[0] = 0;
+
+	wakeup_irq[1] = 0;
+
+	raw_spin_unlock_irq(&wakeup_irq_lock);
+
+	if (!irq_number)
 		atomic_set(&pm_abort_suspend, 0);
 }
 
 void pm_system_irq_wakeup(unsigned int irq_number)
 {
-	if (pm_wakeup_irq == 0) {
-		pm_wakeup_irq = irq_number;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&wakeup_irq_lock, flags);
+
+	if (wakeup_irq[0] == 0)
+		wakeup_irq[0] = irq_number;
+	else if (wakeup_irq[1] == 0)
+		wakeup_irq[1] = irq_number;
+	else
+		irq_number = 0;
+
+	raw_spin_unlock_irqrestore(&wakeup_irq_lock, flags);
+
+	if (irq_number)
 		pm_system_wakeup();
-	}
+}
+
+unsigned int pm_wakeup_irq(void)
+{
+	return wakeup_irq[0];
 }
 
 /**
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -496,14 +496,14 @@ extern void ksys_sync_helper(void);
 
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
-extern unsigned int pm_wakeup_irq;
 extern suspend_state_t pm_suspend_target_state;
 
 extern bool pm_wakeup_pending(void);
 extern void pm_system_wakeup(void);
 extern void pm_system_cancel_wakeup(void);
-extern void pm_wakeup_clear(bool reset);
+extern void pm_wakeup_clear(unsigned int irq_number);
 extern void pm_system_irq_wakeup(unsigned int irq_number);
+extern unsigned int pm_wakeup_irq(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -504,7 +504,10 @@ static ssize_t pm_wakeup_irq_show(struct
 					struct kobj_attribute *attr,
 					char *buf)
 {
-	return pm_wakeup_irq ? sprintf(buf, "%u\n", pm_wakeup_irq) : -ENODATA;
+	if (!pm_wakeup_irq())
+		return -ENODATA;
+
+	return sprintf(buf, "%u\n", pm_wakeup_irq());
 }
 
 power_attr_ro(pm_wakeup_irq);
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -134,7 +134,7 @@ int freeze_processes(void)
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
-	pm_wakeup_clear(true);
+	pm_wakeup_clear(0);
 	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
 	error = try_to_freeze_tasks(true);
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -138,8 +138,6 @@ static void s2idle_loop(void)
 			break;
 		}
 
-		pm_wakeup_clear(false);
-
 		s2idle_enter();
 	}
 


