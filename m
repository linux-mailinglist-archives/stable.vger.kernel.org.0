Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1281211B76B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfLKQHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbfLKPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88842465A;
        Wed, 11 Dec 2019 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077145;
        bh=3RG25Jhwv4mFVx1aiqHTFVdZ7SyFBzyp0xOFY9JoQbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5+/Q9xRkkZvYmwKVtkPVA0d0cO44UpJYh62qpsBNj+6kfrMEUQsZqSCUxoGu7H5T
         W+AFVIZMQ2CGi1yHXzLx7DhvQJG5Vl9xeCYULB/sGXna9Q/9zRbxc41la8cIithAGt
         edqbqMN3qxrTw7u7VIJrRfpD9u0335KEc+6cE7wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        pei.p.jia@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 033/105] x86/resctrl: Fix potential lockdep warning
Date:   Wed, 11 Dec 2019 16:05:22 +0100
Message-Id: <20191211150232.774206480@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

[ Upstream commit c8eafe1495303bfd0eedaa8156b1ee9082ee9642 ]

rdtgroup_cpus_write() and mkdir_rdt_prepare() call
rdtgroup_kn_lock_live() -> kernfs_to_rdtgroup() to get 'rdtgrp', and
then call the rdt_last_cmd_{clear,puts,...}() functions which will check
if rdtgroup_mutex is held/requires its caller to hold rdtgroup_mutex.

But if 'rdtgrp' returned from kernfs_to_rdtgroup() is NULL,
rdtgroup_mutex is not held and calling rdt_last_cmd_{clear,puts,...}()
will result in a self-incurred, potential lockdep warning.

Remove the rdt_last_cmd_{clear,puts,...}() calls in these two paths.
Just returning error should be sufficient to report to the user that the
entry doesn't exist any more.

 [ bp: Massage. ]

Fixes: 94457b36e8a5 ("x86/intel_rdt: Add diagnostics when writing the cpus file")
Fixes: cfd0f34e4cd5 ("x86/intel_rdt: Add diagnostics when making directories")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: pei.p.jia@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1573079796-11713-1-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index a46dee8e78db4..2e3b06d6bbc6d 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -461,10 +461,8 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	}
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
-	rdt_last_cmd_clear();
 	if (!rdtgrp) {
 		ret = -ENOENT;
-		rdt_last_cmd_puts("Directory was removed\n");
 		goto unlock;
 	}
 
@@ -2648,10 +2646,8 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	int ret;
 
 	prdtgrp = rdtgroup_kn_lock_live(prgrp_kn);
-	rdt_last_cmd_clear();
 	if (!prdtgrp) {
 		ret = -ENODEV;
-		rdt_last_cmd_puts("Directory was removed\n");
 		goto out_unlock;
 	}
 
-- 
2.20.1



