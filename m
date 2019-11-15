Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0FCFDBA3
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKOKql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:46:41 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52884 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbfKOKql (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:46:41 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C269F6EB82C7106BA39D;
        Fri, 15 Nov 2019 18:46:38 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.218) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 15 Nov 2019
 18:46:34 +0800
Message-ID: <5DCE8209.1090504@huawei.com>
Date:   Fri, 15 Nov 2019 18:46:33 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Matthew Wilcox <willy@infradead.org>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <dh.herrmann@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH 4.19] memfd: Fix locking when tagging pins
References: <20191025165837.22979-1-willy@infradead.org> <5DCB7FD6.70202@huawei.com> <20191114022605.GE7934@bombadil.infradead.org>
In-Reply-To: <20191114022605.GE7934@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.218]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/11/14 10:26, Matthew Wilcox wrote:
> On Wed, Nov 13, 2019 at 12:00:22PM +0800, zhong jiang wrote:
>> Hi,  Matthew
>>
>> When appling the following patch,  I  hit the an warning.
>>
>> *WARNING: suspicious RCU usage in memfd_wait_for_pins*
>>
>> It is because we remove the rcu_read_lock/read_read_unlock. but We still use
>> radix_tree_deref_slot checking rcu_read_lock_held().
> Ooh.  We should be using radix_tree_deref_slot_protected() instead.
> Can I trouble you to send that patch?
Will do . Thanks,

Sincerely,
zhong jiang
>> A simple fix as follows without test.
>>
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index 5859705dafe1..af244c9c8b6f 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -40,6 +40,7 @@ static void memfd_tag_pins(struct address_space *mapping)
>>         start = 0;
>>
>>         xa_lock_irq(&mapping->i_pages);
>> +       rcu_read_lock();
>>         radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
>>                 page = radix_tree_deref_slot(slot);
>>                 if (!page || radix_tree_exception(page)) {
>> @@ -60,6 +61,7 @@ static void memfd_tag_pins(struct address_space *mapping)
>>                 cond_resched();
>>                 xa_lock_irq(&mapping->i_pages);
>>         }
>> +       rcu_read_unlock();
>>         xa_unlock_irq(&mapping->i_pages);
>>  }
>>
>> Thanks,
>> zhong jiang
>>
>> On 2019/10/26 0:58, Matthew Wilcox wrote:
>>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>>
>>> The RCU lock is insufficient to protect the radix tree iteration as
>>> a deletion from the tree can occur before we take the spinlock to
>>> tag the entry.  In 4.19, this has manifested as a bug with the following
>>> trace:
>>>
>>> kernel BUG at lib/radix-tree.c:1429!
>>> invalid opcode: 0000 [#1] SMP KASAN PTI
>>> CPU: 7 PID: 6935 Comm: syz-executor.2 Not tainted 4.19.36 #25
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
>>> RIP: 0010:radix_tree_tag_set+0x200/0x2f0 lib/radix-tree.c:1429
>>> Code: 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 44 24 10 e8 a3 29 7e fe 48 8b 44 24 10 48 0f ab 03 e9 d2 fe ff ff e8 90 29 7e fe <0f> 0b 48 c7 c7 e0 5a 87 84 e8 f0 e7 08 ff 4c 89 ef e8 4a ff ac fe
>>> RSP: 0018:ffff88837b13fb60 EFLAGS: 00010016
>>> RAX: 0000000000040000 RBX: ffff8883c5515d58 RCX: ffffffff82cb2ef0
>>> RDX: 0000000000000b72 RSI: ffffc90004cf2000 RDI: ffff8883c5515d98
>>> RBP: ffff88837b13fb98 R08: ffffed106f627f7e R09: ffffed106f627f7e
>>> R10: 0000000000000001 R11: ffffed106f627f7d R12: 0000000000000004
>>> R13: ffffea000d7fea80 R14: 1ffff1106f627f6f R15: 0000000000000002
>>> FS:  00007fa1b8df2700(0000) GS:ffff8883e2fc0000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007fa1b8df1db8 CR3: 000000037d4d2001 CR4: 0000000000160ee0
>>> Call Trace:
>>>  memfd_tag_pins mm/memfd.c:51 [inline]
>>>  memfd_wait_for_pins+0x2c5/0x12d0 mm/memfd.c:81
>>>  memfd_add_seals mm/memfd.c:215 [inline]
>>>  memfd_fcntl+0x33d/0x4a0 mm/memfd.c:247
>>>  do_fcntl+0x589/0xeb0 fs/fcntl.c:421
>>>  __do_sys_fcntl fs/fcntl.c:463 [inline]
>>>  __se_sys_fcntl fs/fcntl.c:448 [inline]
>>>  __x64_sys_fcntl+0x12d/0x180 fs/fcntl.c:448
>>>  do_syscall_64+0xc8/0x580 arch/x86/entry/common.c:293
>>>
>>> The problem does not occur in mainline due to the XArray rewrite which
>>> changed the locking to exclude modification of the tree during iteration.
>>> At the time, nobody realised this was a bugfix.  Backport the locking
>>> changes to stable.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: zhong jiang <zhongjiang@huawei.com>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> ---
>>>  mm/memfd.c | 18 ++++++++++--------
>>>  1 file changed, 10 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/mm/memfd.c b/mm/memfd.c
>>> index 2bb5e257080e..5859705dafe1 100644
>>> --- a/mm/memfd.c
>>> +++ b/mm/memfd.c
>>> @@ -34,11 +34,12 @@ static void memfd_tag_pins(struct address_space *mapping)
>>>  	void __rcu **slot;
>>>  	pgoff_t start;
>>>  	struct page *page;
>>> +	unsigned int tagged = 0;
>>>  
>>>  	lru_add_drain();
>>>  	start = 0;
>>> -	rcu_read_lock();
>>>  
>>> +	xa_lock_irq(&mapping->i_pages);
>>>  	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
>>>  		page = radix_tree_deref_slot(slot);
>>>  		if (!page || radix_tree_exception(page)) {
>>> @@ -47,18 +48,19 @@ static void memfd_tag_pins(struct address_space *mapping)
>>>  				continue;
>>>  			}
>>>  		} else if (page_count(page) - page_mapcount(page) > 1) {
>>> -			xa_lock_irq(&mapping->i_pages);
>>>  			radix_tree_tag_set(&mapping->i_pages, iter.index,
>>>  					   MEMFD_TAG_PINNED);
>>> -			xa_unlock_irq(&mapping->i_pages);
>>>  		}
>>>  
>>> -		if (need_resched()) {
>>> -			slot = radix_tree_iter_resume(slot, &iter);
>>> -			cond_resched_rcu();
>>> -		}
>>> +		if (++tagged % 1024)
>>> +			continue;
>>> +
>>> +		slot = radix_tree_iter_resume(slot, &iter);
>>> +		xa_unlock_irq(&mapping->i_pages);
>>> +		cond_resched();
>>> +		xa_lock_irq(&mapping->i_pages);
>>>  	}
>>> -	rcu_read_unlock();
>>> +	xa_unlock_irq(&mapping->i_pages);
>>>  }
>>>  
>>>  /*
> .
>


