Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29474C1A91
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243655AbiBWSDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbiBWSDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:03:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394EE35856
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 10:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA45761551
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 18:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC436C340E7;
        Wed, 23 Feb 2022 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645639366;
        bh=KnmgKBC3pGydoaYS169jgh6+jgyn7Y+DFWd14zgRrNc=;
        h=Subject:To:Cc:From:Date:From;
        b=PnXcFdBiRnKmER4NRZZsYoJy2IVNDWWcLsXwIVejx29YP6xzdbWQNBHPa5bXhF+Fb
         1EppgJ7gwf+THHoaeKVUTxDdsLXL9yL21HVNkZn2IBr80d156U22ZQsLIqI7VNHX+E
         626zwtU3aSVGW93KVb8J7SXCNlnsUF6NxokVjAX0=
Subject: FAILED: patch "[PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu" failed to apply to 4.9-stable tree
To:     zhangqiao22@huawei.com, longman@redhat.com, mkoutny@suse.com,
        tj@kernel.org, zhaogongyi@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Feb 2022 19:02:43 +0100
Message-ID: <1645639363101174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

