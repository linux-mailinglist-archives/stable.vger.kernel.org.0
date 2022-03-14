Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB54D7E4C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiCNJNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbiCNJNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:13:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22914433B5;
        Mon, 14 Mar 2022 02:11:54 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KH9dq1k19zcb1j;
        Mon, 14 Mar 2022 17:06:55 +0800 (CST)
Received: from dggpeml500018.china.huawei.com (7.185.36.186) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 17:11:50 +0800
Received: from [10.67.111.186] (10.67.111.186) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 17:11:50 +0800
Message-ID: <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
Date:   Mon, 14 Mar 2022 17:11:50 +0800
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
From:   Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <Yi73dKB10LBTGb+S@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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



在 2022/3/14 16:06, Greg Kroah-Hartman 写道:
> On Tue, Mar 08, 2022 at 04:12:32PM +0100, Michal Koutný wrote:
>> Hello.
>>
>> On Mon, Feb 28, 2022 at 06:24:07PM +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> [...]
>>>      cpuset_attach()				cpu hotplug
>>>     ---------------------------            ----------------------
>>>     down_write(cpuset_rwsem)
>>>     guarantee_online_cpus() // (load cpus_attach)
>>> 					sched_cpu_deactivate
>>> 					  set_cpu_active()
>>> 					  // will change cpu_active_mask
>>>     set_cpus_allowed_ptr(cpus_attach)
>>>       __set_cpus_allowed_ptr_locked()
>>>        // (if the intersection of cpus_attach and
>>>          cpu_active_mask is empty, will return -EINVAL)
>>>     up_write(cpuset_rwsem)
>>> [...]
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1528,6 +1528,7 @@ static void cpuset_attach(struct cgroup_
>>>  	cgroup_taskset_first(tset, &css);
>>>  	cs = css_cs(css);
>>>  
>>> +	cpus_read_lock();
>>>  	mutex_lock(&cpuset_mutex);
>>
>> This backport (and possible older kernels) looks suspicious since it comes
>> before commit d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem and
>> hotplug lock order") v5.4-rc1~176^2~30 when the locking order was:
>> cpuset lock, cpus lock.
>>
>> At the same time it also comes before commit 710da3c8ea7d ("sched/core:
>> Prevent race condition between cpuset and __sched_setscheduler()")
>> v5.4-rc1~176^2~27 when neither __sched_setscheduler() cared and this
>> race is similar. (The swapped locking may still conflict with
>> rebuild_sched_domains() before d74b27d63a8b.)
> 
> Thanks for noticing this.  What do you recommend to do to resolve this?
> 
> thanks,
> 

hi, Please review the following patch to fix it.

thanks.

patch:

[PATCH] cpuset: Fix unsafe lock order between cpuset lock and cpus lock

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
+       cpus_read_lock();
        /* prepare for attach */
        if (cs == &top_cpuset)
                cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1549,6 +1553,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
                cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
                cpuset_update_task_spread_flag(cs, task);
        }
+       cpus_read_unlock();

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




> greg k-h
> .
> 
