Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C343F3D3163
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 03:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhGWBKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 21:10:39 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12240 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhGWBKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 21:10:38 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GWBwL0q2xz1CMrc;
        Fri, 23 Jul 2021 09:45:22 +0800 (CST)
Received: from [10.174.177.180] (10.174.177.180) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 09:51:10 +0800
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Greg KH <gregkh@linuxfoundation.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Boqun Feng <boqun.feng@gmail.com>, <paulmck@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <5812280.fcLxn8YiTP@natalenko.name> <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name>
 <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com>
 <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
 <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
 <YPlmMnZKgkcLderp@casper.infradead.org> <YPlyHF5eNDiTMKzq@kroah.com>
 <YPl5+PkfBPI0pdHn@kroah.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <01fef2db-bd7e-12b6-ec21-2addd02e7062@huawei.com>
Date:   Fri, 23 Jul 2021 09:51:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YPl5+PkfBPI0pdHn@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.180]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme703-chm.china.huawei.com (10.1.199.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/7/22 22:00, Greg KH wrote:
> On Thu, Jul 22, 2021 at 03:26:52PM +0200, Greg KH wrote:
>> On Thu, Jul 22, 2021 at 01:36:02PM +0100, Matthew Wilcox wrote:
>>> On Thu, Jul 22, 2021 at 04:57:57PM +0800, Zhouyi Zhou wrote:
>>>> Thanks for reviewing,
>>>>
>>>> What I have deduced from the dmesg  is:
>>>> In function do_swap_page,
>>>> after invoking
>>>> 3385        si = get_swap_device(entry); /* rcu_read_lock */
>>>> and before
>>>> 3561    out:
>>>> 3562        if (si)
>>>> 3563            put_swap_device(si);
>>>> The thread got scheduled out in
>>>> 3454        locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
>>>>
>>>> I am only familiar with Linux RCU subsystem, hope mm people can solve our
>>>> confusions.
>>>
>>> I don't understamd why you're still talking.  The problem is understood.
>>> You need to revert the unnecessary backport of 2799e77529c2 and
>>> 2efa33fc7f6e
>>
>> Sorry for the delay, will go do so in a minute...
> 
> Both now reverted from 5.10.y and 5.13.y.
> 

I browsed my previous backport notifying email and found that these two patches are also
backported into 5.12. And it seems it's missed.

Thanks.

> thanks,
> 
> greg k-h
> .
> 

