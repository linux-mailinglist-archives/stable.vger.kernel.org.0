Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67631AE3FF
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 19:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbgDQRqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 13:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729980AbgDQRp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 13:45:59 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E39C061A0C;
        Fri, 17 Apr 2020 10:45:59 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jPV3o-0004Kc-0o; Fri, 17 Apr 2020 19:45:52 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 976341C0072;
        Fri, 17 Apr 2020 19:45:51 +0200 (CEST)
Date:   Fri, 17 Apr 2020 17:45:51 -0000
From:   "tip-bot2 for James Morse" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Preserve CDP enable over CPU hotplug
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200221162105.154163-1-james.morse@arm.com>
References: <20200221162105.154163-1-james.morse@arm.com>
MIME-Version: 1.0
Message-ID: <158714555114.28353.8305275418595687988.tip-bot2@tip-bot2>
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

Commit-ID:     9fe0450785abbc04b0ed5d3cf61fcdb8ab656b4b
Gitweb:        https://git.kernel.org/tip/9fe0450785abbc04b0ed5d3cf61fcdb8ab656b4b
Author:        James Morse <james.morse@arm.com>
AuthorDate:    Fri, 21 Feb 2020 16:21:05 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 17 Apr 2020 19:35:01 +02:00

x86/resctrl: Preserve CDP enable over CPU hotplug

Resctrl assumes that all CPUs are online when the filesystem is mounted,
and that CPUs remember their CDP-enabled state over CPU hotplug.

This goes wrong when resctrl's CDP-enabled state changes while all the
CPUs in a domain are offline.

When a domain comes online, enable (or disable!) CDP to match resctrl's
current setting.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200221162105.154163-1-james.morse@arm.com
---
 arch/x86/kernel/cpu/resctrl/core.c     |  2 ++
 arch/x86/kernel/cpu/resctrl/internal.h |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 89049b3..d8cc522 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -578,6 +578,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	d->id = id;
 	cpumask_set_cpu(cpu, &d->cpu_mask);
 
+	rdt_domain_reconfigure_cdp(r);
+
 	if (r->alloc_capable && domain_setup_ctrlval(r, d)) {
 		kfree(d);
 		return;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 181c992..3dd13f3 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -601,5 +601,6 @@ bool has_busy_rmid(struct rdt_resource *r, struct rdt_domain *d);
 void __check_limbo(struct rdt_domain *d, bool force_free);
 bool cbm_validate_intel(char *buf, u32 *data, struct rdt_resource *r);
 bool cbm_validate_amd(char *buf, u32 *data, struct rdt_resource *r);
+void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 9d4e73a..5a359d9 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1859,6 +1859,19 @@ static int set_cache_qos_cfg(int level, bool enable)
 	return 0;
 }
 
+/* Restore the qos cfg state when a domain comes online */
+void rdt_domain_reconfigure_cdp(struct rdt_resource *r)
+{
+	if (!r->alloc_capable)
+		return;
+
+	if (r == &rdt_resources_all[RDT_RESOURCE_L2DATA])
+		l2_qos_cfg_update(&r->alloc_enabled);
+
+	if (r == &rdt_resources_all[RDT_RESOURCE_L3DATA])
+		l3_qos_cfg_update(&r->alloc_enabled);
+}
+
 /*
  * Enable or disable the MBA software controller
  * which helps user specify bandwidth in MBps.
