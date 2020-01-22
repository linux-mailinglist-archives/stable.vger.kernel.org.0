Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C620144F78
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgAVJiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729496AbgAVJiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821D224684;
        Wed, 22 Jan 2020 09:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685887;
        bh=aZuKvLHC3BdRY626rF49MIeM1UO18VEnHCa2vPcZQiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ND8isEAxjKUJZklRctd3ykpM7RVodtsGrp2ngM+QMuS86AfpkGuPTK6ShcyuGrLko
         3NSQ586eQFgFgEdqQw54G8Q57AwFAlZ7fv7YRMDj5Yb+f+DT1FcRUVHBP1NWIfLfMx
         MdokQEK9gqwry+G3bmdActbyyqwE/BKZUlkrUNCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        john.stultz@linaro.org, sboyd@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, tj@kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        x86-ml <x86@kernel.org>
Subject: [PATCH 4.14 22/65] x86/resctrl: Fix an imbalance in domain_remove_cpu()
Date:   Wed, 22 Jan 2020 10:29:07 +0100
Message-Id: <20200122092754.179341279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit e278af89f1ba0a9ef20947db6afc2c9afa37e85b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel_rdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -526,7 +526,7 @@ static void domain_remove_cpu(int cpu, s
 		if (static_branch_unlikely(&rdt_mon_enable_key))
 			rmdir_mondata_subdir_allrdtgrp(r, d->id);
 		list_del(&d->list);
-		if (is_mbm_enabled())
+		if (r->mon_capable && is_mbm_enabled())
 			cancel_delayed_work(&d->mbm_over);
 		if (is_llc_occupancy_enabled() &&  has_busy_rmid(r, d)) {
 			/*


