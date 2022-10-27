Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821EF60F64D
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiJ0Lhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiJ0Lhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:37:34 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093CDE196E;
        Thu, 27 Oct 2022 04:37:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Myk7903wHz15Lwm;
        Thu, 27 Oct 2022 19:32:37 +0800 (CST)
Received: from [10.174.179.110] (10.174.179.110) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:37:30 +0800
Message-ID: <6e9d8e46-708a-a431-b673-a5cb5b46ad86@huawei.com>
Date:   Thu, 27 Oct 2022 19:37:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <peterx@redhat.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
 <Y1lluEIsa2T0wXE6@kroah.com>
From:   songyuanzheng <songyuanzheng@huawei.com>
In-Reply-To: <Y1lluEIsa2T0wXE6@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.110]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Hi, Greg KH,

Currently, this patch is under review and no correct solution
is available to solve this problem. After a perfect patch is
available, I will send the corresponding patch to 5.15y.

On 2022/10/27 0:52, Greg KH wrote:
> On Mon, Oct 24, 2022 at 09:49:11AM +0000, Yuanzheng Song wrote:
>> The vma->anon_vma of the child process may be NULL because
>> the entire vma does not contain anonymous pages. In this
>> case, a BUG will occur when the copy_present_page() passes
>> a copy of a non-anonymous page of that vma to the
>> page_add_new_anon_rmap() to set up new anonymous rmap.
>>
>> ------------[ cut here ]------------
>> kernel BUG at mm/rmap.c:1044!
>> Internal error: Oops - BUG: 0 [#1] SMP
>> Modules linked in:
>> CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
>> Hardware name: linux,dummy-virt (DT)
>> pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
>> pc : __page_set_anon_rmap+0xbc/0xf8
>> lr : __page_set_anon_rmap+0xbc/0xf8
>> sp : ffff800014c1b870
>> x29: ffff800014c1b870 x28: 0000000000000001
>> x27: 0000000010100073 x26: ffff1d65c517baa8
>> x25: ffff1d65cab0f000 x24: ffff1d65c416d800
>> x23: ffff1d65cab5f248 x22: 0000000020000000
>> x21: 0000000000000001 x20: 0000000000000000
>> x19: fffffe75970023c0 x18: 0000000000000000
>> x17: 0000000000000000 x16: 0000000000000000
>> x15: 0000000000000000 x14: 0000000000000000
>> x13: 0000000000000000 x12: 0000000000000000
>> x11: 0000000000000000 x10: 0000000000000000
>> x9 : ffffc3096d5fb858 x8 : 0000000000000000
>> x7 : 0000000000000011 x6 : ffff5a5c9089c000
>> x5 : 0000000000020000 x4 : ffff5a5c9089c000
>> x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
>> x1 : ffff1d65ca3da740 x0 : 0000000000000000
>> Call trace:
>>   __page_set_anon_rmap+0xbc/0xf8
>>   page_add_new_anon_rmap+0x1e0/0x390
>>   copy_pte_range+0xd00/0x1248
>>   copy_page_range+0x39c/0x620
>>   dup_mmap+0x2e0/0x5a8
>>   dup_mm+0x78/0x140
>>   copy_process+0x918/0x1a20
>>   kernel_clone+0xac/0x638
>>   __do_sys_clone+0x78/0xb0
>>   __arm64_sys_clone+0x30/0x40
>>   el0_svc_common.constprop.0+0xb0/0x308
>>   do_el0_svc+0x48/0xb8
>>   el0_svc+0x24/0x38
>>   el0_sync_handler+0x160/0x168
>>   el0_sync+0x180/0x1c0
>> Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
>> ---[ end trace a972347688dc9bd4 ]---
>> Kernel panic - not syncing: Oops - BUG: Fatal exception
>> SMP: stopping secondary CPUs
>> Kernel Offset: 0x43095d200000 from 0xffff800010000000
>> PHYS_OFFSET: 0xffffe29a80000000
>> CPU features: 0x08200022,61806082
>> Memory Limit: none
>> ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
>>
>> This problem has been fixed by the fb3d824d1a46
>> ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()"),
>> but still exists in the linux-5.10.y branch.
>>
>> This patch is not applicable to this version because
>> of the large version differences. Therefore, fix it by
>> adding non-anonymous page check in the copy_present_page().
>>
>> Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
>> Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
>> ---
>>   mm/memory.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
> 
> We also need this in 5.15.y, right?  Can you provide a working version
> for there so that no one upgrades from 5.10.y to 5.15.y and has a
> regression?
> 
> I'll wait for that before taking this one.
> 
> thanks,
> 
> greg k-h
> .
> 
Thanks,

Yuanzheng
.
