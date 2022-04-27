Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D118510EDA
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 04:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354466AbiD0Chm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 22:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357199AbiD0Chj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 22:37:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02A186E4CD
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 19:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651026869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hZ4NlywNWUFYBQb0YGqu4i/SGqufP1jy2acawUvOAk=;
        b=iC8rIJ+/jbOtBV+y5vthGCn+TzxCE7qntiYRD8dyadJi0htQbxxjBVNzbbKo8y7v3tR6EC
        fsvD1SwIlbkuzglbPuqiBz7cf/K6T9nrx61oYb1kvWPOEag6A6oJLES5at5y54kQUkABnA
        BAFbZMyzhq8xh0YJR4I1T/cTE1Uj/zY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-qaEU4A3LP2-mlluaJGPavg-1; Tue, 26 Apr 2022 22:34:23 -0400
X-MC-Unique: qaEU4A3LP2-mlluaJGPavg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66E63101AA44;
        Wed, 27 Apr 2022 02:34:22 +0000 (UTC)
Received: from [10.22.16.78] (unknown [10.22.16.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E3AC40D282D;
        Wed, 27 Apr 2022 02:34:21 +0000 (UTC)
Message-ID: <4c6847ba-4c8d-9776-a065-684a8b95130b@redhat.com>
Date:   Tue, 26 Apr 2022 22:34:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Content-Language: en-US
To:     Feng Tang <feng.tang@intel.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220426032337.GA84190@shbuild999.sh.intel.com>
 <be293d58-1084-b586-2267-6a1e6a400762@redhat.com>
 <20220427010654.GC84190@shbuild999.sh.intel.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220427010654.GC84190@shbuild999.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,TVD_SUBJ_WIPE_DEBT
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 21:06, Feng Tang wrote:
> On Tue, Apr 26, 2022 at 10:58:21PM +0800, Waiman Long wrote:
>> On 4/25/22 23:23, Feng Tang wrote:
>>> Hi Waiman,
>>>
>>> On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long wrote:
>>>> There are 3 places where the cpu and node masks of the top cpuset can
>>>> be initialized in the order they are executed:
>>>>    1) start_kernel -> cpuset_init()
>>>>    2) start_kernel -> cgroup_init() -> cpuset_bind()
>>>>    3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
>>>>
>>>> The first cpuset_init() function just sets all the bits in the masks.
>>>> The last one executed is cpuset_init_smp() which sets up cpu and node
>>>> masks suitable for v1, but not v2.  cpuset_bind() does the right setup
>>>> for both v1 and v2.
>>>>
>>>> For systems with cgroup v2 setup, cpuset_bind() is called once. For
>>>> systems with cgroup v1 setup, cpuset_bind() is called twice. It is
>>>> first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
>>>> called again when cgroup v1 filesystem is mounted in v1 mode after
>>>> cpuset_init_smp().
>>>>
>>>>     [    2.609781] cpuset_bind() called - v2 = 1
>>>>     [    3.079473] cpuset_init_smp() called
>>>>     [    7.103710] cpuset_bind() called - v2 = 0
>>> I run some test, on a server with centOS, this did happen that
>>> cpuset_bind() is called twice, first as v2 during kernel boot,
>>> and then as v1 post-boot.
>>>
>>> However on a QEMU running with a basic debian rootfs image,
>>> the second  call of cpuset_bind() didn't happen.
>> The first time cpuset_bind() is called in cgroup_init(), the kernel
>> doesn't know if userspace is going to mount v1 or v2 cgroup. By default,
>> it is assumed to be v2. However, if userspace mounts the cgroup v1
>> filesystem for cpuset, cpuset_bind() will be run at this point by
>> rebind_subsystem() to set up cgroup v1 environment and
>> cpus_allowed/mems_allowed will be correctly set at this point. Mounting
>> the cgroup v2 filesystem, however, does not cause rebind_subsystem() to
>> run and hence cpuset_bind() is not called again.
>>
>> Is the QEMU setup not mounting any cgroup filesystem at all? If so, does
>> it matter whether v1 or v2 setup is used?
> When I got the cpuset binding error report, I tried first on qemu to
> reproduce and failed (due to there was no memory hotplug), then I
> reproduced it on a real server. For both system, I used "cgroup_no_v1=all"
> cmdline parameter to test cgroup-v2, could this be the reason? (TBH,
> this is the first time I use cgroup-v2).
>
> Here is the info dump:
>
> # mount | grep cgroup
> tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
> cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
>
> #cat /proc/filesystems | grep cgroup
> nodev   cgroup
> nodev   cgroup2
>
> Thanks,
> Feng

For cgroup v2, cpus_allowed should be set to cpu_possible_mask and 
mems_allowed to node_possible_map as is done in the first invocation of 
cpuset_bind(). That is the correct behavior.

Cheers,
Longman

