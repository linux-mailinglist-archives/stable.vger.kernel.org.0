Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3C60EDC8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 04:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiJ0CLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 22:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJ0CLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 22:11:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D0E52ED;
        Wed, 26 Oct 2022 19:11:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MyTgN3TrWzHvHX;
        Thu, 27 Oct 2022 10:11:12 +0800 (CST)
Received: from [10.174.179.110] (10.174.179.110) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 10:11:25 +0800
Message-ID: <5fd7980e-e397-0651-b5bf-545a20637a08@huawei.com>
Date:   Thu, 27 Oct 2022 10:11:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
Content-Language: en-US
To:     Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>
CC:     <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <songyuanzheng@huawei.com>
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
 <3823471f-6dda-256e-e082-718879c05449@google.com> <Y1nRiJ1LYB62uInn@x1n>
 <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com>
From:   songyuanzheng <songyuanzheng@huawei.com>
In-Reply-To: <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.110]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Peter Xu:

Thank you for reviewing this patch. This bug was reported by syzkaller.

You can reproduce it using the following test case.


As you said, my patch isn't really fixing the problem, just avoiding the 
bug.

In my opinion, simply abandoning the creation of new anonymous rmap

by judging that it is not an anonymous page is the minimal change to

circumvent the bug.


This bug can be reproduced from

70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")

to

b51ad4f8679e ("mm/memory: slightly simplify copy_present_pte()")

in the mainline.

(Greg KH: Therefore, this problem involves 5.10y and even 5.15y.)


I hope you can help to look at this problem and find a better solution.

------------------------------------------------------------------------------ 


#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/futex.h>

#ifndef __NR_clone
#define __NR_clone 220
#endif
#ifndef __NR_exit
#define __NR_exit 93
#endif
#ifndef __NR_gettid
#define __NR_gettid 178
#endif
#ifndef __NR_mmap
#define __NR_mmap 222
#endif
#ifndef __NR_process_vm_readv
#define __NR_process_vm_readv 270
#endif
#ifndef __NR_setsockopt
#define __NR_setsockopt 208
#endif
#ifndef __NR_socket
#define __NR_socket 198
#endif

static unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
     usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
     struct timespec ts;
     if (clock_gettime(CLOCK_MONOTONIC, &ts))
     exit(1);
     return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void thread_start(void* (*fn)(void*), void* arg)
{
     pthread_t th;
     pthread_attr_t attr;
     pthread_attr_init(&attr);
     pthread_attr_setstacksize(&attr, 128 << 10);
     int i = 0;
     for (; i < 100; i++) {
         if (pthread_create(&th, &attr, fn, arg) == 0) {
             pthread_attr_destroy(&attr);
             return;
         }
         if (errno == EAGAIN) {
             usleep(50);
             continue;
         }
         break;
     }
     exit(1);
}

typedef struct {
     int state;
} event_t;

static void event_init(event_t* ev)
{
     ev->state = 0;
}

static void event_reset(event_t* ev)
{
     ev->state = 0;
}

static void event_set(event_t* ev)
{
     if (ev->state)
     exit(1);
     __atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
     syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG, 
1000000);
}

static void event_wait(event_t* ev)
{
     while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
         syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 
0, 0);
}

static int event_isset(event_t* ev)
{
     return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
     uint64_t start = current_time_ms();
     uint64_t now = start;
     for (;;) {
         uint64_t remain = timeout - (now - start);
         struct timespec ts;
         ts.tv_sec = remain / 1000;
         ts.tv_nsec = (remain % 1000) * 1000 * 1000;
         syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 
0, &ts);
         if (__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
             return 1;
         now = current_time_ms();
         if (now - start > timeout)
             return 0;
     }
}

static bool write_file(const char* file, const char* what, ...)
{
     char buf[1024];
     va_list args;
     va_start(args, what);
     vsnprintf(buf, sizeof(buf), what, args);
     va_end(args);
     buf[sizeof(buf) - 1] = 0;
     int len = strlen(buf);
     int fd = open(file, O_WRONLY | O_CLOEXEC);
     if (fd == -1)
         return false;
     if (write(fd, buf, len) != len) {
         int err = errno;
         close(fd);
         errno = err;
         return false;
     }
     close(fd);
     return true;
}

static void kill_and_wait(int pid, int* status)
{
     kill(-pid, SIGKILL);
     kill(pid, SIGKILL);
     for (int i = 0; i < 100; i++) {
         if (waitpid(-1, status, WNOHANG | __WALL) == pid)
             return;
         usleep(1000);
     }
     DIR* dir = opendir("/sys/fs/fuse/connections");
     if (dir) {
         for (;;) {
             struct dirent* ent = readdir(dir);
             if (!ent)
                 break;
             if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, 
"..") == 0)
                 continue;
             char abort[300];
             snprintf(abort, sizeof(abort), 
"/sys/fs/fuse/connections/%s/abort", ent->d_name);
             int fd = open(abort, O_WRONLY);
             if (fd == -1) {
                 continue;
             }
             if (write(fd, abort, 1) < 0) {
             }
             close(fd);
         }
         closedir(dir);
     } else {
     }
     while (waitpid(-1, status, __WALL) != pid) {
     }
}

static void setup_test()
{
     prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
     setpgrp();
     write_file("/proc/self/oom_score_adj", "1000");
}

#define USLEEP_FORKED_CHILD (3 * 50 *1000)

static long handle_clone_ret(long ret)
{
     if (ret != 0) {
         return ret;
     }
     usleep(USLEEP_FORKED_CHILD);
     syscall(__NR_exit, 0);
     while (1) {
     }
}

static long syz_clone(volatile long flags, volatile long stack, volatile 
long stack_len,
               volatile long ptid, volatile long ctid, volatile long tls)
{
     long sp = (stack + stack_len) & ~15;
     long ret = (long)syscall(__NR_clone, flags & ~CLONE_VM, sp, ptid, 
ctid, tls);
     return handle_clone_ret(ret);
}

struct thread_t {
     int created, call;
     event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
     struct thread_t* th = (struct thread_t*)arg;
     for (;;) {
         event_wait(&th->ready);
         event_reset(&th->ready);
         execute_call(th->call);
         __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
         event_set(&th->done);
     }
     return 0;
}

static void execute_one(void)
{
     int i, call, thread;
     for (call = 0; call < 6; call++) {
         for (thread = 0; thread < (int)(sizeof(threads) / 
sizeof(threads[0])); thread++) {
             struct thread_t* th = &threads[thread];
             if (!th->created) {
                 th->created = 1;
                 event_init(&th->ready);
                 event_init(&th->done);
                 event_set(&th->done);
                 thread_start(thr, th);
             }
             if (!event_isset(&th->done))
                 continue;
             event_reset(&th->done);
             th->call = call;
             __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
             event_set(&th->ready);
             if (call == 3 || call == 4)
                 break;
             event_timedwait(&th->done, 50);
             break;
         }
     }
     for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); 
i++)
         sleep_ms(1);
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
     int iter = 0;
     for (;; iter++) {
         int pid = fork();
         if (pid < 0)
     exit(1);
         if (pid == 0) {
             setup_test();
             execute_one();
             exit(0);
         }
         int status = 0;
         uint64_t start = current_time_ms();
         for (;;) {
             if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
                 break;
             sleep_ms(1);
             if (current_time_ms() - start < 5000)
                 continue;
             kill_and_wait(pid, &status);
             break;
         }
     }
}

uint64_t r[2] = {0xffffffffffffffff, 0x0};

void execute_call(int call)
{
         intptr_t res = 0;
     switch (call) {
     case 0:
         res = syscall(__NR_socket, 0x11ul, 3ul, 0x300);
         if (res != -1)
                 r[0] = res;
         break;
     case 1:
*(uint32_t*)0x20000100 = 0x10000;
*(uint32_t*)0x20000104 = 7;
*(uint32_t*)0x20000108 = 0x1f0;
*(uint32_t*)0x2000010c = 0x39c;
*(uint32_t*)0x20000110 = 0;
*(uint32_t*)0x20000114 = 0;
*(uint32_t*)0x20000118 = 0;
         syscall(__NR_setsockopt, r[0], 0x107, 0xd, 0x20000100ul, 0x1cul);
         break;
     case 2:
         res = syscall(__NR_gettid);
         if (res != -1)
                 r[1] = res;
         break;
     case 3:
         syscall(__NR_mmap, 0x20000000ul, 0x70000ul, 0x13ul, 0x12ul, 
r[0], 0ul);
         break;
     case 4:
syz_clone(0, 0, 0, 0, 0, 0);
         break;
     case 5:
*(uint64_t*)0x20000440 = 0x20000000;
*(uint64_t*)0x20000448 = 0xf1;
*(uint64_t*)0x20000450 = 0;
*(uint64_t*)0x20000458 = 0;
*(uint64_t*)0x20000460 = 0;
*(uint64_t*)0x20000468 = 0;
*(uint64_t*)0x20000470 = 0;
*(uint64_t*)0x20000478 = 0;
*(uint64_t*)0x20000480 = 0;
*(uint64_t*)0x20000488 = 0;
*(uint64_t*)0x20000490 = 0;
*(uint64_t*)0x20000498 = 0;
*(uint64_t*)0x200004a0 = 0;
*(uint64_t*)0x200004a8 = 0;
*(uint64_t*)0x200004b0 = 0;
*(uint64_t*)0x200004b8 = 0;
*(uint64_t*)0x200004c0 = 0;
*(uint64_t*)0x200004c8 = 0;
*(uint64_t*)0x20001700 = 0x20000500;
*(uint64_t*)0x20001708 = 0x15;
*(uint64_t*)0x20001710 = 0;
*(uint64_t*)0x20001718 = 0;
*(uint64_t*)0x20001720 = 0;
*(uint64_t*)0x20001728 = 0;
*(uint64_t*)0x20001730 = 0;
*(uint64_t*)0x20001738 = 0;
*(uint64_t*)0x20001740 = 0;
*(uint64_t*)0x20001748 = 0;
         syscall(__NR_process_vm_readv, r[1], 0x20000440ul, 9ul, 
0x20001700ul, 5ul, 0ul);
         break;
     }

}
int main(void)
{
         syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
     syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
     for (procid = 0; procid < 4; procid++) {
         if (fork() == 0) {
             loop();
         }
     }
     sleep(1000000);
     return 0;
}

------------------------------------------------------------------------------ 


On 2022/10/27 9:48, Hugh Dickins wrote:
> On Wed, 26 Oct 2022, Peter Xu wrote:
>
>> Hi, Yuanzheng,
>>
>> On Wed, Oct 26, 2022 at 02:51:16PM -0700, Hugh Dickins wrote:
>>> On Mon, 24 Oct 2022, Yuanzheng Song wrote:
>>>
>>>> The vma->anon_vma of the child process may be NULL because
>>>> the entire vma does not contain anonymous pages. In this
>>>> case, a BUG will occur when the copy_present_page() passes
>>>> a copy of a non-anonymous page of that vma to the
>>>> page_add_new_anon_rmap() to set up new anonymous rmap.
>>>>
>>>> ------------[ cut here ]------------
>>>> kernel BUG at mm/rmap.c:1044!
>>>> Internal error: Oops - BUG: 0 [#1] SMP
>>>> Modules linked in:
>>>> CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
>>>> Hardware name: linux,dummy-virt (DT)
>>>> pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
>>>> pc : __page_set_anon_rmap+0xbc/0xf8
>>>> lr : __page_set_anon_rmap+0xbc/0xf8
>>>> sp : ffff800014c1b870
>>>> x29: ffff800014c1b870 x28: 0000000000000001
>>>> x27: 0000000010100073 x26: ffff1d65c517baa8
>>>> x25: ffff1d65cab0f000 x24: ffff1d65c416d800
>>>> x23: ffff1d65cab5f248 x22: 0000000020000000
>>>> x21: 0000000000000001 x20: 0000000000000000
>>>> x19: fffffe75970023c0 x18: 0000000000000000
>>>> x17: 0000000000000000 x16: 0000000000000000
>>>> x15: 0000000000000000 x14: 0000000000000000
>>>> x13: 0000000000000000 x12: 0000000000000000
>>>> x11: 0000000000000000 x10: 0000000000000000
>>>> x9 : ffffc3096d5fb858 x8 : 0000000000000000
>>>> x7 : 0000000000000011 x6 : ffff5a5c9089c000
>>>> x5 : 0000000000020000 x4 : ffff5a5c9089c000
>>>> x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
>>>> x1 : ffff1d65ca3da740 x0 : 0000000000000000
>>>> Call trace:
>>>>   __page_set_anon_rmap+0xbc/0xf8
>>>>   page_add_new_anon_rmap+0x1e0/0x390
>>>>   copy_pte_range+0xd00/0x1248
>>>>   copy_page_range+0x39c/0x620
>>>>   dup_mmap+0x2e0/0x5a8
>>>>   dup_mm+0x78/0x140
>>>>   copy_process+0x918/0x1a20
>>>>   kernel_clone+0xac/0x638
>>>>   __do_sys_clone+0x78/0xb0
>>>>   __arm64_sys_clone+0x30/0x40
>>>>   el0_svc_common.constprop.0+0xb0/0x308
>>>>   do_el0_svc+0x48/0xb8
>>>>   el0_svc+0x24/0x38
>>>>   el0_sync_handler+0x160/0x168
>>>>   el0_sync+0x180/0x1c0
>>>> Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
>>>> ---[ end trace a972347688dc9bd4 ]---
>>>> Kernel panic - not syncing: Oops - BUG: Fatal exception
>>>> SMP: stopping secondary CPUs
>>>> Kernel Offset: 0x43095d200000 from 0xffff800010000000
>>>> PHYS_OFFSET: 0xffffe29a80000000
>>>> CPU features: 0x08200022,61806082
>>>> Memory Limit: none
>>>> ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
>>>>
>>>> This problem has been fixed by the fb3d824d1a46
>>>> ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()"),
>>>> but still exists in the linux-5.10.y branch.
>>>>
>>>> This patch is not applicable to this version because
>>>> of the large version differences. Therefore, fix it by
>>>> adding non-anonymous page check in the copy_present_page().
>>>>
>>>> Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
>>>> Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
>>> It's a good point, but this patch should not go into any stable release
>>> without an explicit Ack from either Peter Xu or David Hildenbrand.
>>>
>>> To my eye, it's simply avoiding the issue, rather than fixing
>>> it properly; and even if the issue is so rare, and fixing properly
>>> too difficult or inefficent (a cached anon_vma?), that a workaround
>>> is good enough, it still looks like the wrong workaround (checking
>>> dst_vma->anon_vma instead of PageAnon seems more to the point, and
>>> less lenient).
>> Sorry to have missed this patch. I agree with Hugh that this patch may not
>> really fix the issue.
>>
>> IIUC it's the case where the vma is privately mapping a file.  Some shared
>> pages got pinned, and here we're trying to trigger the CoW assuming it's
>> anonymous page but it's not.
>>
>> The pin should be RO - if it was a write pin, CoW should have happened on
>> the page cache and there should be an anonymous page, and anon_vma should
>> be there, no issue should happen.  Only if with RO pin, we won't trigger
>> CoW, we won't have any anonymous page, we won't have anon_vma, hence the
>> panic.
>>
>> The thing is if the page is RO pinned, skip copying it (as what was done in
>> this patch) is not correct either, because e.g. a follow up write after
>> fork() from the parent will trigger CoW and the dma RO page that was pinned
>> will be inconsistent to the page in pgtable anymore, I think.
>>
>> IIUC the correct fix is what David worked on with unshare - when RO pin the
>> page cache we should have triggered CoR already before fork().  But as you
>> mentioned, that's too much change for stable.
>>
>> So besides this workaround which seems feasible to at least not panic the
>> system (Hugh: I can't quickly tell what'll be the difference here to check
>> dst anon_vma or PageAnon, they all seem to work?  I could have missed
> Thanks for all the helpful elucidation above.
>
> My thought here, in favour of checking dst anon_vma rather than PageAnon,
> was that a common case would be that the private file vma does already
> have an anon_vma attached (from earlier CoW on some other page), and
> in that case there is no justification for taking this short cut to
> avoid the BUG in __page_set_anon_rmap() on every !PageAnon in the vma.
>
> And I imagined that the correct fix (short of going forward with David's
> full changes) would be to back out to a context where one could add an
> anon_vma_prepare(), then retry after that - involves dropping pt lock,
> maybe gets nasty (tedious, anyway).
>
>> something for sure..), the other workaround is teach the user app to switch
>> to use RW pin for any DMA pages even if RO, so that it'll always guarantee
>> page coherence even with the old kernel, and afaict that's what RDMA relied
>> on for years.  I don't know an easy way to make old kernel work with RO pin
>> solidly if without the unsharing logic.
>>
>> Thanks,
>>
>> -- 
>> Peter Xu
> .
Thanks,


-- 

Yuanzheng
