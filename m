Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1D24399C
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 14:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHMMHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 08:07:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49138 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbgHMMH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 08:07:26 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C7CE5FDC741F5256B7E6;
        Thu, 13 Aug 2020 20:07:23 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.211) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 13 Aug 2020
 20:07:16 +0800
Subject: Re: [PATCH 4.19 016/133] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Cameron Berkenpas" <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        "Thomas Lamprecht" <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152804.513188610@linuxfoundation.org>
 <e6d703e7-2cbb-f77e-413f-523aa0706542@huawei.com>
 <20200813114138.GA3754843@kroah.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <61e5b2db-d720-4b51-a3ca-3540097dd28f@huawei.com>
Date:   Thu, 13 Aug 2020 20:07:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200813114138.GA3754843@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.211]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/8/13 19:41, Greg Kroah-Hartman wrote:
> On Thu, Aug 13, 2020 at 07:30:55PM +0800, Yang Yingliang wrote:
>> Hi,
>>
>> On 2020/7/20 23:36, Greg Kroah-Hartman wrote:
>>> From: Cong Wang <xiyou.wangcong@gmail.com>
>>>
>>> [ Upstream commit ad0f75e5f57ccbceec13274e1e242f2b5a6397ed ]
>>>
>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
>>> copied, so the cgroup refcnt must be taken too. And, unlike the
>>> sk_alloc() path, sock_update_netprioidx() is not called here.
>>> Therefore, it is safe and necessary to grab the cgroup refcnt
>>> even when cgroup_sk_alloc is disabled.
>>>
>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
>>> would terminate this function if called there. And for sk_alloc()
>>> skcd->val is always zero. So it's safe to factor out the code
>>> to make it more readable.
>>>
>>> The global variable 'cgroup_sk_alloc_disabled' is used to determine
>>> whether to take these reference counts. It is impossible to make
>>> the reference counting correct unless we save this bit of information
>>> in skcd->val. So, add a new bit there to record whether the socket
>>> has already taken the reference counts. This obviously relies on
>>> kmalloc() to align cgroup pointers to at least 4 bytes,
>>> ARCH_KMALLOC_MINALIGN is certainly larger than that.
>>>
>>> This bug seems to be introduced since the beginning, commit
>>> d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
>>> tried to fix it but not compeletely. It seems not easy to trigger until
>>> the recent commit 090e28b229af
>>> ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.
>>>
>>> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
>>> Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
>>> Reported-by: Peter Geis <pgwipeout@gmail.com>
>>> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> Reported-by: Daniël Sonck <dsonck92@gmail.com>
>>> Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
>>> Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
>>> Tested-by: Peter Geis <pgwipeout@gmail.com>
>>> Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> Cc: Zefan Li <lizefan@huawei.com>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Roman Gushchin <guro@fb.com>
>>> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>> [...]
>>> +void cgroup_sk_clone(struct sock_cgroup_data *skcd)
>>> +{
>>> +	/* Socket clone path */
>>> +	if (skcd->val) {
>> Compare to mainline patch, it's missing *if (skcd->no_refcnt)* check here.
>>
>> Is it a mistake here ?
> Possibly, it is in the cgroup_sk_free() call.  Can you send a patch to
> fix this up?

OK, I checked other stable branches, it also need be fixed in stable-4.9 
and stable-4.14.

I will send the patches to these branches.

>
> thanks,
>
> greg k-h
> .

