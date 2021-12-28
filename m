Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71D24809C6
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 14:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhL1N4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 08:56:40 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:46035 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhL1N4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 08:56:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=shile.zhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V06qbZq_1640699786;
Received: from 30.225.28.46(mailfrom:shile.zhang@linux.alibaba.com fp:SMTPD_---0V06qbZq_1640699786)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:56:37 +0800
Message-ID: <f4dedbfc-0cca-a6cb-996b-4bd928008269@linux.alibaba.com>
Date:   Tue, 28 Dec 2021 21:56:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 5.10.y] drm/cirrus: fix a NULL vs IS_ERR() checks
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Wen Kang <kw01107137@alibaba-inc.com>, stable@vger.kernel.org
References: <20211228132556.108711-1-shile.zhang@linux.alibaba.com>
 <YcsWcqVN7Dwue1I2@kroah.com>
From:   Shile Zhang <shile.zhang@linux.alibaba.com>
In-Reply-To: <YcsWcqVN7Dwue1I2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/12/28 21:51, Greg Kroah-Hartman wrote:
> On Tue, Dec 28, 2021 at 09:25:56PM +0800, Shile Zhang wrote:
>> The function drm_gem_shmem_vmap can returns error pointers as well,
>> which could cause following kernel crash:
>>
>> BUG: unable to handle page fault for address: fffffffffffffffc
>> PGD 1426a12067 P4D 1426a12067 PUD 1426a14067 PMD 0
>> Oops: 0000 [#1] SMP NOPTI
>> CPU: 12 PID: 3598532 Comm: stress-ng Kdump: loaded Not tainted 5.10.50.x86_64 #1
>> ...
>> RIP: 0010:memcpy_toio+0x23/0x50
>> Code: 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 85 d2 74 28 40 f6 c7 01 75 2b 48 83 fa 01 76 06 40 f6 c7 02 75 17 48 89 d1 48 c1 e9 02 <f3> a5 f6 c2 02 74 02 66 a5 f6 c2 01 74 01 a4 c3 66 a5 48 83 ea 02
>> RSP: 0018:ffffafbf8a203c68 EFLAGS: 00010216
>> RAX: 0000000000000000 RBX: fffffffffffffffc RCX: 0000000000000200
>> RDX: 0000000000000800 RSI: fffffffffffffffc RDI: ffffafbf82000000
>> RBP: ffffafbf82000000 R08: 0000000000000002 R09: 0000000000000000
>> R10: 00000000000002b5 R11: 0000000000000000 R12: 0000000000000800
>> R13: ffff8a6801099300 R14: 0000000000000001 R15: 0000000000000300
>> FS:  00007f4a6bc5f740(0000) GS:ffff8a8641900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: fffffffffffffffc CR3: 00000016d3874001 CR4: 00000000003606e0
>> Call Trace:
>>   drm_fb_memcpy_dstclip+0x5e/0x80 [drm_kms_helper]
>>   cirrus_fb_blit_rect.isra.0+0xb7/0xe0 [cirrus]
>>   cirrus_pipe_update+0x9f/0xa8 [cirrus]
>>   drm_atomic_helper_commit_planes+0xb8/0x220 [drm_kms_helper]
>>   drm_atomic_helper_commit_tail+0x42/0x80 [drm_kms_helper]
>>   commit_tail+0xce/0x130 [drm_kms_helper]
>>   drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
>>   drm_client_modeset_commit_atomic+0x1c4/0x200 [drm]
>>   drm_client_modeset_commit_locked+0x53/0x80 [drm]
>>   drm_client_modeset_commit+0x24/0x40 [drm]
>>   drm_fbdev_client_restore+0x48/0x85 [drm_kms_helper]
>>   drm_client_dev_restore+0x64/0xb0 [drm]
>>   drm_release+0xf2/0x110 [drm]
>>   __fput+0x96/0x240
>>   task_work_run+0x5c/0x90
>>   exit_to_user_mode_loop+0xce/0xd0
>>   exit_to_user_mode_prepare+0x6a/0x70
>>   syscall_exit_to_user_mode+0x12/0x40
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x7f4a6bd82c2b
>>
>> Fixes: ab3e023b1b4c9 ("drm/cirrus: rewrite and modernize driver.")
>>
>> CC: stable@vger.kernel.org
>> Reported-by: Wen Kang <kw01107137@alibaba-inc.com>
>> Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
>> ---
>>   drivers/gpu/drm/tiny/cirrus.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> What is the git commit id of this patch in Linus's tree?

Sorry, I checked that this issue seems fixed by the improvement in 
following series:
https://patchwork.freedesktop.org/series/82217/

But which does not backport into 5.10.y yet.
So, maybe you can help to backport this series help to fix this issue?

Thanks!

> 
> thanks,
> 
> greg k-h
> 
