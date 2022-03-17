Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819244DBD2D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 03:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiCQCnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 22:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbiCQCnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 22:43:16 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAE220192;
        Wed, 16 Mar 2022 19:41:59 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KJrwY36pXzfZ2K;
        Thu, 17 Mar 2022 10:40:29 +0800 (CST)
Received: from dggpeml500018.china.huawei.com (7.185.36.186) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 10:41:57 +0800
Received: from [10.67.111.186] (10.67.111.186) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 10:41:57 +0800
Message-ID: <1ea13066-aa98-ead2-f50f-f62d030ce3c5@huawei.com>
Date:   Thu, 17 Mar 2022 10:41:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
 <20220308151232.GA21752@blackbody.suse.cz> <Yi73dKB10LBTGb+S@kroah.com>
 <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
 <20220314111940.GC1035@blackbody.suse.cz> <YjHz2bifJBuCs/UK@kroah.com>
From:   Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <YjHz2bifJBuCs/UK@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500018.china.huawei.com (7.185.36.186)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/3/16 22:27, Greg Kroah-Hartman 写道:
> On Mon, Mar 14, 2022 at 12:19:41PM +0100, Michal Koutný wrote:
>> Hello.
>>
>> In my opinion there are two approaches:
>> a) drop this backport (given other races present),
> 
> I have no problem with that, want to send a revert patch?
> 
>> b) swap the locks compatible with v4.19 as this patch proposes.
>>
>> On Mon, Mar 14, 2022 at 05:11:50PM +0800, Zhang Qiao <zhangqiao22@huawei.com> wrote:
>>> +       /*
>>> +        * It should hold cpus lock because a cpu offline event can
>>> +        * cause set_cpus_allowed_ptr() failed.
>>> +        */
>>> +       cpus_read_lock();
>>
>> Maybe just a nit, the old kernels before commit c5c63b9a6a2e ("cgroup:
>> Replace deprecated CPU-hotplug functions.") v5.15-rc1~159^2~5
>> would be more consistent with get_online_cpus() here (but they're
>> equivalent functionally so the locking order is correct).
> 
> A fixed up patch would also be appreciated :)
> 

Fixed up patch as follows, replace cpus_read_lock() with get_online_cpus().

thanks.

--------


[PATCH] cpuset: Fix unsafe lock order between cpuset lock and cpuslock

The backport commit 4eec5fe1c680a ("cgroup/cpuset: Fix a race
between cpuset_attach() and cpu hotplug") looks suspicious since
it comes before commit d74b27d63a8b ("cgroup/cpuset: Change
cpuset_rwsem and hotplug lock order") v5.4-rc1~176^2~30 when
the locking order was: cpuset lock, cpus lock.

Fix it with the correct locking order and reduce the cpus locking
range because only set_cpus_allowed_ptr() needs the protection of
cpus lock.

Fixes: 4eec5fe1c680a ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
Reported-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
---
 kernel/cgroup/cpuset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d43d25acc..4e1c4232e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1528,9 +1528,13 @@ static void cpuset_attach(struct cgroup_taskset *tset)
        cgroup_taskset_first(tset, &css);
        cs = css_cs(css);

-       cpus_read_lock();
        mutex_lock(&cpuset_mutex);

+       /*
+        * It should hold cpus lock because a cpu offline event can
+        * cause set_cpus_allowed_ptr() failed.
+        */
+       get_online_cpus();
        /* prepare for attach */
        if (cs == &top_cpuset)
                cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1549,6 +1553,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
                cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
                cpuset_update_task_spread_flag(cs, task);
        }
+       put_online_cpus();

        /*
         * Change mm for all threadgroup leaders. This is expensive and may
@@ -1584,7 +1589,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
                wake_up(&cpuset_attach_wq);

        mutex_unlock(&cpuset_mutex);
-       cpus_read_unlock();
 }

 /* The various types of files and directories in a cpuset file system */
--
2.18.0


> thanks,
> 
> greg k-h
> .
> 
