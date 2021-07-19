Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4873CD399
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhGSKcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 06:32:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11448 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbhGSKcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 06:32:21 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GSzdG1B1WzcfkS;
        Mon, 19 Jul 2021 19:09:38 +0800 (CST)
Received: from [10.174.177.180] (10.174.177.180) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 19:12:58 +0800
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Boqun Feng <boqun.feng@gmail.com>
CC:     Zhouyi Zhou <zhouzhouyi@gmail.com>, <paulmck@kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Matthew Wilcox <willy@infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
 <YPTmtNMJpykEpzx6@casper.infradead.org> <YPVQfaamqwu1PRrK@boqun-archlinux>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
Date:   Mon, 19 Jul 2021 19:12:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YPVQfaamqwu1PRrK@boqun-archlinux>
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

On 2021/7/19 18:14, Boqun Feng wrote:
> On Mon, Jul 19, 2021 at 03:43:00AM +0100, Matthew Wilcox wrote:
>> On Mon, Jul 19, 2021 at 10:24:18AM +0800, Zhouyi Zhou wrote:
>>> Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
>>> that could possibly trigger that problem:
>>>
>>> struct swap_info_struct *get_swap_device(swp_entry_t entry)
>>> {
>>>      struct swap_info_struct *si;
>>>      unsigned long offset;
>>>
>>>      if (!entry.val)
>>>              goto out;
>>>     si = swp_swap_info(entry);
>>>     if (!si)
>>>        goto bad_nofile;
>>>
>>>    rcu_read_lock();
>>>   if (data_race(!(si->flags & SWP_VALID)))
>>>      goto unlock_out;
>>>   offset = swp_offset(entry);
>>>   if (offset >= si->max)
>>>    goto unlock_out;
>>>
>>>   return si;
>>> bad_nofile:
>>>   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
>>> out:
>>>   return NULL;
>>> unlock_out:
>>>   rcu_read_unlock();
>>>   return NULL;
>>> }
>>> I guess the function "return si" without a rcu_read_unlock.
>>
>> Yes, but the caller is supposed to call put_swap_device() which
>> calls rcu_read_unlock().  See commit eb085574a752.
> 
> Right, but we need to make sure there is no sleepable function called
> before put_swap_device() called, and the call trace showed the following
> happened:
> 
> 	do_swap_page():
> 	  si = get_swap_device():
> 	    rcu_read_lock();
> 	  lock_page_or_retry():
> 	    might_sleep(); // call a sleepable function inside RCU read-side c.s.
> 	    __lock_page_or_retry():
> 	      wait_on_page_bit_common():
> 	        schedule():
> 		  rcu_note_context_switch();
> 		  // Warn here
> 	  put_swap_device();
> 	    rcu_read_unlock();
> 
> , which introduced by commit 2799e77529c2a

When in the commit 2799e77529c2a, we're using the percpu_ref to serialize against
concurrent swapoff, i.e. there's percpu_ref inside get_swap_device() instead of
rcu_read_lock(). Please see commit 63d8620ecf93 ("mm/swapfile: use percpu_ref to
serialize against concurrent swapoff") for detail.

Thanks.

> 
> [Copy the author]
> 
> Regards,
> Boqun
> 
> .
> 

