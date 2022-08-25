Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC27C5A0E4C
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbiHYKr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241388AbiHYKrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ECA8A1FC
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C98618F3
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 10:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D30C433C1;
        Thu, 25 Aug 2022 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661424418;
        bh=kzFkiVL1W858H259zjE3SNFkbZtMuVRyRZmgvqWR5m4=;
        h=Subject:To:Cc:From:Date:From;
        b=UhRp2KjipABLNcnMJe7YlTBcYSxVpPnr45cPKtl38tpQiCRfloMs4gBqE4pnUHuH2
         cUPjsqEasZEZ3JXc9IbMRrEkyXpSV/Yh3AEgv/5awx07El5G6nt68szvTTugJPBlnW
         zcMCsjBdjuk+dBH752nAZQLFGHIzBj96yOwoMJMc=
Subject: FAILED: patch "[PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu" failed to apply to 5.10-stable tree
To:     zhangqiao22@huawei.com, longman@redhat.com, mkoutny@suse.com,
        tj@kernel.org, zhaogongyi@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Aug 2022 12:46:51 +0200
Message-ID: <1661424411235135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05c7b7a92cc87ff8d7fde189d0fade250697573c Mon Sep 17 00:00:00 2001
From: Zhang Qiao <zhangqiao22@huawei.com>
Date: Fri, 21 Jan 2022 18:12:10 +0800
Subject: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu
 hotplug
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As previously discussed(https://lkml.org/lkml/2022/1/20/51),
cpuset_attach() is affected with similar cpu hotplug race,
as follow scenario:

     cpuset_attach()				cpu hotplug
    ---------------------------            ----------------------
    down_write(cpuset_rwsem)
    guarantee_online_cpus() // (load cpus_attach)
					sched_cpu_deactivate
					  set_cpu_active()
					  // will change cpu_active_mask
    set_cpus_allowed_ptr(cpus_attach)
      __set_cpus_allowed_ptr_locked()
       // (if the intersection of cpus_attach and
         cpu_active_mask is empty, will return -EINVAL)
    up_write(cpuset_rwsem)

To avoid races such as described above, protect cpuset_attach() call
with cpu_hotplug_lock.

Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
Cc: stable@vger.kernel.org # v2.6.32+
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4c7254e8f49a..97c53f3cc917 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2289,6 +2289,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
+	cpus_read_lock();
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2342,6 +2343,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
+	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */

