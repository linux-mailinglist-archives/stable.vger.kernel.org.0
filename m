Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40351B0B80
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgDTM4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgDTMpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39D120736;
        Mon, 20 Apr 2020 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386711;
        bh=kVSr5u9Tfukq6cFf5zlcKPgwmUDvRS+rSSj1Vpb+p8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx70bB08tElU+4dLJojO0+BHoY+4QidmL9PSmdFnrl0Fqc7Ij3tiBNI6IXpR315PK
         Ktux+0l5kb2n9X5DPhyNfO6mfX+uMqhCSgOQdeQ1pJhzTWt6vR1cP2Wb98T0b4JuKB
         gkzTZFG/mob9lHb1uFhfLejBoRD45tf/x8ezaGPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        James Morse <james.morse@arm.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.6 68/71] x86/resctrl: Preserve CDP enable over CPU hotplug
Date:   Mon, 20 Apr 2020 14:39:22 +0200
Message-Id: <20200420121522.502302366@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 9fe0450785abbc04b0ed5d3cf61fcdb8ab656b4b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/resctrl/core.c     |    2 ++
 arch/x86/kernel/cpu/resctrl/internal.h |    1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   13 +++++++++++++
 3 files changed, 16 insertions(+)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -578,6 +578,8 @@ static void domain_add_cpu(int cpu, stru
 	d->id = id;
 	cpumask_set_cpu(cpu, &d->cpu_mask);
 
+	rdt_domain_reconfigure_cdp(r);
+
 	if (r->alloc_capable && domain_setup_ctrlval(r, d)) {
 		kfree(d);
 		return;
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -601,5 +601,6 @@ bool has_busy_rmid(struct rdt_resource *
 void __check_limbo(struct rdt_domain *d, bool force_free);
 bool cbm_validate_intel(char *buf, u32 *data, struct rdt_resource *r);
 bool cbm_validate_amd(char *buf, u32 *data, struct rdt_resource *r);
+void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1859,6 +1859,19 @@ static int set_cache_qos_cfg(int level,
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


