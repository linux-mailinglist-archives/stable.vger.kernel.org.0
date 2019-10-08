Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98F5D041B
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfJHX3O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 8 Oct 2019 19:29:14 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:63300 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfJHX3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 19:29:14 -0400
Received: from 79.184.255.36.ipv4.supernova.orange.pl (79.184.255.36) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.292)
 id d20e51580ea3c8fa; Wed, 9 Oct 2019 01:29:11 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Linux PM <linux-pm@vger.kernel.org>
Cc:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown
Date:   Wed, 09 Oct 2019 01:29:10 +0200
Message-ID: <10202295.pfq90QWH5T@kreacher>
In-Reply-To: <CAJZ5v0hsiyKfVcDFbnJKqDkCKWhbSfNrmm7yVhudONuS0SWALw@mail.gmail.com>
References: <20191003140828.14801-1-ville.syrjala@linux.intel.com> <20191004123026.GU1208@intel.com> <CAJZ5v0hsiyKfVcDFbnJKqDkCKWhbSfNrmm7yVhudONuS0SWALw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It is incorrect to set the cpufreq syscore shutdown callback pointer
to cpufreq_suspend(), because that function cannot be run in the
syscore stage of system shutdown for two reasons: (a) it may attempt
to carry out actions depending on devices that have already been shut
down at that point and (b) the RCU synchronization carried out by it
may not be able to make progress then.

The latter issue has been present since commit 45975c7d21a1 ("rcu:
Define RCU-sched API in terms of RCU for Tree RCU PREEMPT builds"),
but the former one has always been there regardless.

Fix that by dropping cpufreq_syscore_ops altogether and making
device_shutdown() call cpufreq_suspend() directly before shutting
down devices, which is along the lines of what system-wide power
management does.

Fixes: 45975c7d21a1 ("rcu: Define RCU-sched API in terms of RCU for Tree RCU PREEMPT builds")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/core.c       |    3 +++
 drivers/cpufreq/cpufreq.c |   10 ----------
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/cpufreq.c
+++ linux-pm/drivers/cpufreq/cpufreq.c
@@ -2737,14 +2737,6 @@ int cpufreq_unregister_driver(struct cpu
 }
 EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
 
-/*
- * Stop cpufreq at shutdown to make sure it isn't holding any locks
- * or mutexes when secondary CPUs are halted.
- */
-static struct syscore_ops cpufreq_syscore_ops = {
-	.shutdown = cpufreq_suspend,
-};
-
 struct kobject *cpufreq_global_kobject;
 EXPORT_SYMBOL(cpufreq_global_kobject);
 
@@ -2756,8 +2748,6 @@ static int __init cpufreq_core_init(void
 	cpufreq_global_kobject = kobject_create_and_add("cpufreq", &cpu_subsys.dev_root->kobj);
 	BUG_ON(!cpufreq_global_kobject);
 
-	register_syscore_ops(&cpufreq_syscore_ops);
-
 	return 0;
 }
 module_param(off, int, 0444);
Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/cpufreq.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/fwnode.h>
@@ -3179,6 +3180,8 @@ void device_shutdown(void)
 	wait_for_device_probe();
 	device_block_probing();
 
+	cpufreq_suspend();
+
 	spin_lock(&devices_kset->list_lock);
 	/*
 	 * Walk the devices list backward, shutting down each in turn.



