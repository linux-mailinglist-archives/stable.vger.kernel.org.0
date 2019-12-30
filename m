Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6612D375
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfL3SmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 13:42:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48083 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfL3SmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 13:42:19 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ilzzO-0006Ji-I1; Mon, 30 Dec 2019 19:42:02 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 4F6851C0450;
        Mon, 30 Dec 2019 19:42:01 +0100 (CET)
Date:   Mon, 30 Dec 2019 18:42:01 -0000
From:   "tip-bot2 for Qian Cai" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix an imbalance in domain_remove_cpu()
Cc:     Qian Cai <cai@lca.pw>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        john.stultz@linaro.org, sboyd@kernel.org, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, tj@kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "x86-ml" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191211033042.2188-1-cai@lca.pw>
References: <20191211033042.2188-1-cai@lca.pw>
MIME-Version: 1.0
Message-ID: <157773132107.30329.13477468873808479241.tip-bot2@tip-bot2>
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

Commit-ID:     e278af89f1ba0a9ef20947db6afc2c9afa37e85b
Gitweb:        https://git.kernel.org/tip/e278af89f1ba0a9ef20947db6afc2c9afa37e85b
Author:        Qian Cai <cai@lca.pw>
AuthorDate:    Tue, 10 Dec 2019 22:30:42 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 30 Dec 2019 19:25:59 +01:00

x86/resctrl: Fix an imbalance in domain_remove_cpu()

A system that supports resource monitoring may have multiple resources
while not all of these resources are capable of monitoring. Monitoring
related state is initialized only for resources that are capable of
monitoring and correspondingly this state should subsequently only be
removed from these resources that are capable of monitoring.

domain_add_cpu() calls domain_setup_mon_state() only when r->mon_capable
is true where it will initialize d->mbm_over. However,
domain_remove_cpu() calls cancel_delayed_work(&d->mbm_over) without
checking r->mon_capable resulting in an attempt to cancel d->mbm_over on
all resources, even those that never initialized d->mbm_over because
they are not capable of monitoring. Hence, it triggers a debugobjects
warning when offlining CPUs because those timer debugobjects are never
initialized:

  ODEBUG: assert_init not available (active state 0) object type:
  timer_list hint: 0x0
  WARNING: CPU: 143 PID: 789 at lib/debugobjects.c:484
  debug_print_object
  Hardware name: HP Synergy 680 Gen9/Synergy 680 Gen9 Compute Module, BIOS I40 05/23/2018
  RIP: 0010:debug_print_object
  Call Trace:
  debug_object_assert_init
  del_timer
  try_to_grab_pending
  cancel_delayed_work
  resctrl_offline_cpu
  cpuhp_invoke_callback
  cpuhp_thread_fun
  smpboot_thread_fn
  kthread
  ret_from_fork

Fixes: e33026831bdb ("x86/intel_rdt/mbm: Handle counter overflow")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: john.stultz@linaro.org
Cc: sboyd@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: tj@kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191211033042.2188-1-cai@lca.pw
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 03eb90d..89049b3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -618,7 +618,7 @@ static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 		if (static_branch_unlikely(&rdt_mon_enable_key))
 			rmdir_mondata_subdir_allrdtgrp(r, d->id);
 		list_del(&d->list);
-		if (is_mbm_enabled())
+		if (r->mon_capable && is_mbm_enabled())
 			cancel_delayed_work(&d->mbm_over);
 		if (is_llc_occupancy_enabled() &&  has_busy_rmid(r, d)) {
 			/*
