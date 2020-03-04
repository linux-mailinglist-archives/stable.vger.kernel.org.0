Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35773178CCC
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgCDIuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:50:24 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36459 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725271AbgCDIuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 03:50:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0TrdATuG_1583311812;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0TrdATuG_1583311812)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 Mar 2020 16:50:12 +0800
Subject: Re: [PATCH] efi: Make efi_rts_work accessible to efi page fault
 handler
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Caspar Zhang <caspar@linux.alibaba.com>, stable@vger.kernel.org
References: <20200304074444.7849-1-wenyang@linux.alibaba.com>
 <20200304080428.GA1401372@kroah.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <bc443f24-f6b4-717a-555a-b32128da330c@linux.alibaba.com>
Date:   Wed, 4 Mar 2020 16:50:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200304080428.GA1401372@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/4 4:04 下午, Greg Kroah-Hartman wrote:
> On Wed, Mar 04, 2020 at 03:44:44PM +0800, Wen Yang wrote:
>> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>>
>> [ Upstream commit 9dbbedaa6171247c4c7c40b83f05b200a117c2e0 ]
>>
>> After the kernel has booted, if any accesses by firmware causes a page
>> fault, the efi page fault handler would freeze efi_rts_wq and schedules
>> a new process. To do this, the efi page fault handler needs
>> efi_rts_work. Hence, make it accessible.
>>
>> There will be no race conditions in accessing this structure, because
>> all the calls to efi runtime services are already serialized.
>>
>> [ Wen: This patch also fixes a memory corruption:
>>         #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)\
>>         ({                                                             \
>>          struct efi_runtime_work efi_rts_work;                           \
>>         …
>>          init_completion(&efi_rts_work.efi_rts_comp);                    \
>>          INIT_WORK(&efi_rts_work.work, efi_call_rts);                    \
>>         …
>>
>>         efi_rts_work is on the stack, registering it to workqueue will cause
>>         the following error:
>>
>>         ODEBUG: object (____ptrval____) is on stack (____ptrval____),
>>         but NOT annotated.
>>         ------------[ cut here ]------------
>>         WARNING: CPU: 6 PID: 1 at lib/debugobjects.c:368
>>         __debug_object_init+0x218/0x538
>>         Modules linked in:
>>         CPU: 6 PID: 1 Comm: swapper/0 Tainted: G        W         4.19.91 #19
>>         …
>>         Call trace:
>>         __debug_object_init+0x218/0x538
>>         debug_object_init+0x20/0x28
>>         __init_work+0x34/0x58
>>         virt_efi_get_time.part.5+0x6c/0x12c
>>         virt_efi_get_time+0x4c/0x58
>>         efi_read_time+0x40/0x9c
>>         __rtc_read_time+0x50/0x118
>>         rtc_read_time+0x60/0x1f0
>>         rtc_hctosys+0x74/0x124
>>         do_one_initcall+0xac/0x3d4
>>         kernel_init_freeable+0x49c/0x59c
>>         kernel_init+0x18/0x110 ]
>>
>> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
>> Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
>> Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
>> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Fixes: 3eb420e70d87 (“efi: Use a work queue to invoke EFI Runtime Services”)
>> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
>> Cc: Caspar Zhang <caspar@linux.alibaba.com>
>> Cc: Sasha Levin <sashal@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
>>   include/linux/efi.h                     | 36 +++++++++++++++++
>>   2 files changed, 45 insertions(+), 44 deletions(-)
> 
> What stable tree(s) do you wish to see this patch applied to?
>

Thank you very much.
We hope it could be applied to 4.19.

Best wishes,

--
Wen


