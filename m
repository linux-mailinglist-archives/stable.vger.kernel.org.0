Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24E36D686A
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbjDDQI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 12:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbjDDQIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 12:08:55 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E48EEC;
        Tue,  4 Apr 2023 09:08:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VfMLb4X_1680624527;
Received: from 30.120.152.113(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfMLb4X_1680624527)
          by smtp.aliyun-inc.com;
          Wed, 05 Apr 2023 00:08:48 +0800
Message-ID: <6dad8c2f-b896-3cc0-26c1-37f5fff406bd@linux.alibaba.com>
Date:   Wed, 5 Apr 2023 00:08:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
Content-Language: en-US
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
To:     akpm@linux-foundation.org, bagasdotme@gmail.com,
        willy@infradead.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
In-Reply-To: <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

I have fix up some stuff base on Patch v1. And in order to help all 
readers and reviewers to

reproduce this bug, share a reproducer here:

swap_bomb.sh

#!/usr/bin/env bash

stress-ng -a 1 --class vm -t 12h --metrics --times -x 
bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap 
--verify -v &
stress-ng -a 1 --class vm -t 12h --metrics --times -x 
bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap 
--verify -v &
stress-ng -a 1 --class vm -t 12h --metrics --times -x 
bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap 
--verify -v &
stress-ng -a 1 --class vm -t 12h --metrics --times -x 
bigheap,stackmmap,mlock,vm-splice,mmapaddr,mmapfixed,mmapfork,mmaphuge,mmapmany,mprotect,mremap,msync,msyncmany,physpage,tmpfs,vm-addr,vm-rw,brk,vm-segv,userfaultfd,malloc,stack,munmap,dev-shm,bad-altstack,shm-sysv,pageswap,madvise,vm,shm,env,mmap 
--verify -v


madvise_shared.c

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#define MSIZE (1024 * 1024 * 2)

int main()
{
         char *shm_addr;
         unsigned long i;

         while (1) {
                 // Map shared memory segment
                 shm_addr =
                     mmap(NULL, MSIZE, PROT_READ | PROT_WRITE,
                          MAP_SHARED | MAP_ANONYMOUS, -1, 0);
                 if (shm_addr == MAP_FAILED) {
                         perror("Failed to map shared memory segment");
                         exit(EXIT_FAILURE);
                 }

                 for (i = 0; i < MSIZE; i++) {
                         shm_addr[i] = 1;
                 }

                 // Advise kernel on usage pattern of shared memory
                 if (madvise(shm_addr, MSIZE, MADV_PAGEOUT) == -1) {
                         perror
                             ("Failed to advise kernel on shared memory 
usage");
                         exit(EXIT_FAILURE);
                 }

                 for (i = 0; i < MSIZE; i++) {
                         shm_addr[i] = 1;
                 }

                 // Advise kernel on usage pattern of shared memory
                 if (madvise(shm_addr, MSIZE, MADV_PAGEOUT) == -1) {
                         perror
                             ("Failed to advise kernel on shared memory 
usage");
                         exit(EXIT_FAILURE);
                 }
                 // Use shared memory
                 printf("Hello, shared memory: 0x%lx\n", shm_addr);

                 // Unmap shared memory segment
                 if (munmap(shm_addr, MSIZE) == -1) {
                         perror("Failed to unmap shared memory segment");
                         exit(EXIT_FAILURE);
                 }
         }

         return 0;
}

The bug will reproduce more quickly (about 2~5 minutes) if concurrent 
more swap_bomb.sh and madvise_shared.

Thanks.


change log:

v1 -> v2

* fix up some commits and add assert_spin_locked(&p->lock) inside 
__delete_from_avail_list() (suggested by Matthew Wilcox and Bagas Sanjaya)


On 4/4/23 11:47 PM, Rongwei Wang wrote:
> The si->lock must be held when deleting the si from
> the available list.  Otherwise, another thread can
> re-add the si to the available list, which can lead
> to memory corruption. The only place we have found
> where this happens is in the swapoff path. This case
> can be described as below:
>
> core 0                       core 1
> swapoff
>
> del_from_avail_list(si)      waiting
>
> try lock si->lock            acquire swap_avail_lock
>                               and re-add si into
>                               swap_avail_head
>
> acquire si->lock but
> missing si already be
> added again, and continuing
> to clear SWP_WRITEOK, etc.
>
> It can be easily found a massive warning messages can
> be triggered inside get_swap_pages() by some special
> cases, for example, we call madvise(MADV_PAGEOUT) on
> blocks of touched memory concurrently, meanwhile, run
> much swapon-swapoff operations (e.g. stress-ng-swap).
>
> However, in the worst case, panic can be caused by the
> above scene. In swapoff(), the memory used by si could
> be kept in swap_info[] after turning off a swap. This
> means memory corruption will not be caused immediately
> until allocated and reset for a new swap in the swapon
> path. A panic message caused:
> (with CONFIG_PLIST_DEBUG enabled)
>
> ------------[ cut here ]------------
> top: 00000000e58a3003, n: 0000000013e75cda, p: 000000008cd4451a
> prev: 0000000035b1e58a, n: 000000008cd4451a, p: 000000002150ee8d
> next: 000000008cd4451a, n: 000000008cd4451a, p: 000000008cd4451a
> WARNING: CPU: 21 PID: 1843 at lib/plist.c:60 plist_check_prev_next_node+0x50/0x70
> Modules linked in: rfkill(E) crct10dif_ce(E)...
> CPU: 21 PID: 1843 Comm: stress-ng Kdump: ... 5.10.134+
> Hardware name: Alibaba Cloud ECS, BIOS 0.0.0 02/06/2015
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
> pc : plist_check_prev_next_node+0x50/0x70
> lr : plist_check_prev_next_node+0x50/0x70
> sp : ffff0018009d3c30
> x29: ffff0018009d3c40 x28: ffff800011b32a98
> x27: 0000000000000000 x26: ffff001803908000
> x25: ffff8000128ea088 x24: ffff800011b32a48
> x23: 0000000000000028 x22: ffff001800875c00
> x21: ffff800010f9e520 x20: ffff001800875c00
> x19: ffff001800fdc6e0 x18: 0000000000000030
> x17: 0000000000000000 x16: 0000000000000000
> x15: 0736076307640766 x14: 0730073007380731
> x13: 0736076307640766 x12: 0730073007380731
> x11: 000000000004058d x10: 0000000085a85b76
> x9 : ffff8000101436e4 x8 : ffff800011c8ce08
> x7 : 0000000000000000 x6 : 0000000000000001
> x5 : ffff0017df9ed338 x4 : 0000000000000001
> x3 : ffff8017ce62a000 x2 : ffff0017df9ed340
> x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>   plist_check_prev_next_node+0x50/0x70
>   plist_check_head+0x80/0xf0
>   plist_add+0x28/0x140
>   add_to_avail_list+0x9c/0xf0
>   _enable_swap_info+0x78/0xb4
>   __do_sys_swapon+0x918/0xa10
>   __arm64_sys_swapon+0x20/0x30
>   el0_svc_common+0x8c/0x220
>   do_el0_svc+0x2c/0x90
>   el0_svc+0x1c/0x30
>   el0_sync_handler+0xa8/0xb0
>   el0_sync+0x148/0x180
> irq event stamp: 2082270
>
> Now, si->lock locked before calling 'del_from_avail_list()'
> to make sure other thread see the si had been deleted
> and SWP_WRITEOK cleared together, will not reinsert again.
>
> This problem exists in versions after stable 5.10.y.
>
> Cc: stable@vger.kernel.org
> Tested-by: Yongchen Yin <wb-yyc939293@alibaba-inc.com>
> Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
> ---
>   mm/swapfile.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 62ba2bf577d7..2c718f45745f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -679,6 +679,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
>   {
>   	int nid;
>   
> +	assert_spin_locked(&p->lock);
>   	for_each_node(nid)
>   		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
>   }
> @@ -2434,8 +2435,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>   		spin_unlock(&swap_lock);
>   		goto out_dput;
>   	}
> -	del_from_avail_list(p);
>   	spin_lock(&p->lock);
> +	del_from_avail_list(p);
>   	if (p->prio < 0) {
>   		struct swap_info_struct *si = p;
>   		int nid;
