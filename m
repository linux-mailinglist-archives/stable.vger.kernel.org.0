Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6B177F78
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbgCCRvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbgCCRvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296B1206E6;
        Tue,  3 Mar 2020 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257860;
        bh=ID/GXQTXuDAQaPABtNm17V4BJtPBQdU0jqhKUuDlYp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHvn8ryF03v+17vSuBuh9DPhoYTUVKtk6FThG+gk/+3fAbP3LuUmX+cmnuzn9MLoc
         PI9dB7aqgXgO3MGIITrRTQxKBhck3kn1ZJHf8lk1s5ioFVG1orZeh+GkVXZlyRMgbT
         tBg44dkIDtvP1XdL1lIr3ZC7pJolxb4e/PzljGfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.5 156/176] x86/resctrl: Check monitoring static key in the MBM overflow handler
Date:   Tue,  3 Mar 2020 18:43:40 +0100
Message-Id: <20200303174322.523561222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

commit 536a0d8e79fb928f2735db37dda95682b6754f9a upstream.

Currently, there are three static keys in the resctrl file system:
rdt_mon_enable_key and rdt_alloc_enable_key indicate if the monitoring
feature and the allocation feature are enabled, respectively. The
rdt_enable_key is enabled when either the monitoring feature or the
allocation feature is enabled.

If no monitoring feature is present (either hardware doesn't support a
monitoring feature or the feature is disabled by the kernel command line
option "rdt="), rdt_enable_key is still enabled but rdt_mon_enable_key
is disabled.

MBM is a monitoring feature. The MBM overflow handler intends to
check if the monitoring feature is not enabled for fast return.

So check the rdt_mon_enable_key in it instead of the rdt_enable_key as
former is the more accurate check.

 [ bp: Massage commit message. ]

Fixes: e33026831bdb ("x86/intel_rdt/mbm: Handle counter overflow")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/1576094705-13660-1-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/resctrl/internal.h |    1 +
 arch/x86/kernel/cpu/resctrl/monitor.c  |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -57,6 +57,7 @@ static inline struct rdt_fs_context *rdt
 }
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
+DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
 
 /**
  * struct mon_evt - Entry in the event list of a resource
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -514,7 +514,7 @@ void mbm_handle_overflow(struct work_str
 
 	mutex_lock(&rdtgroup_mutex);
 
-	if (!static_branch_likely(&rdt_enable_key))
+	if (!static_branch_likely(&rdt_mon_enable_key))
 		goto out_unlock;
 
 	d = get_domain_from_cpu(cpu, &rdt_resources_all[RDT_RESOURCE_L3]);
@@ -543,7 +543,7 @@ void mbm_setup_overflow_handler(struct r
 	unsigned long delay = msecs_to_jiffies(delay_ms);
 	int cpu;
 
-	if (!static_branch_likely(&rdt_enable_key))
+	if (!static_branch_likely(&rdt_mon_enable_key))
 		return;
 	cpu = cpumask_any(&dom->cpu_mask);
 	dom->mbm_work_cpu = cpu;


