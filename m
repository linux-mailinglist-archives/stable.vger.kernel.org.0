Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1A93BE5F5
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 11:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhGGJyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 05:54:15 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:35846 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhGGJyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 05:54:13 -0400
Received: from [0.0.0.0] (unknown [113.118.122.203])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id 0C072E0335;
        Wed,  7 Jul 2021 17:51:28 +0800 (CST)
Subject: Re: [PATCH v2] x86/mce: Fix endless loop when run task works after
 #MC
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     bp@alien8.de, bp@suse.de, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterz@infradead.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, youquan.song@intel.com, huangcun@sangfor.com.cn,
        stable@vger.kernel.org
References: <20210706121606.15864-1-dinghui@sangfor.com.cn>
 <20210706164451.GA1289248@agluck-desk2.amr.corp.intel.com>
 <6a1b1371-50e4-f0f6-1ebd-0a91fc9d7bcc@sangfor.com.cn>
Message-ID: <fffec03b-2601-a0c0-5954-ee05fe046ba1@sangfor.com.cn>
Date:   Wed, 7 Jul 2021 17:51:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6a1b1371-50e4-f0f6-1ebd-0a91fc9d7bcc@sangfor.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGU9LTFYZQk1OGRpPTUJNHkJVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRQ6Pxw4ND9RKh08ORg6Fks5
        MjMaCUpVSlVKTUlOTU5KT0NDQkNPVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpDVUpJSVVJS0hZV1kIAVlBT05ISTcG
X-HM-Tid: 0a7a806127a32c17kusn0c072e0335
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/7/7 11:39, Ding Hui wrote:
> On 2021/7/7 0:44, Luck, Tony wrote:
>> On Tue, Jul 06, 2021 at 08:16:06PM +0800, Ding Hui wrote:
>>> Recently we encounter multi #MC on the same task when it's
>>> task_work_run() has not been called, current->mce_kill_me was
>>> added to task_works list more than once, that make a circular
>>> linked task_works, so task_work_run() will do a endless loop.
>>
>> I saw the same and posted a similar fix a while back:
>>
>> https://www.spinics.net/lists/linux-mm/msg251006.html
>>
>> It didn't get merged because some validation tests began failing
>> around the same time.  I'm now pretty sure I understand what happened
>> with those other tests.
>>
>> I'll post my updated version (second patch in a three part series)
>> later today.
>>
> 
> Thanks for your fixes.
> 
> After digging my original problem, maybe I find out why I met #MC flood.
> 
> My test case:
> 1. run qemu-kvm guest VM, OS is memtest86+.iso
> 2. inject SRAR UE to VM memory and wait #MC
> When VM trigger #MC, I expect that qemu will receive SIGBUS signal ASAP, 
> and with the modifed qemu, I will kill VM.
> 
> In this case, do_machine_check() maybe called by kvm_machine_check() in 
> vmx.c.
> 
> Before [1], memory_failure() is called in do_machine_check(), so 
> TIF_SIGPENDING is set on due to SIGBUS signal, vcpu_run() checked the 
> pending singal, so return to qemu to handle SIGBUS.
> 
> After [1], do_machine_check() only add task work but not send SIGBUS 
> directly, vcpu_run() will not break the for-loop because 
> vcpu_enter_guest() return 1 and not set TIF_SIGPENDING on, task works 
> never executed until sth else happen. So the kvm enter guest repeatedly 
> and the #MC is triggered repeatedly.
> 

Sorry for my incorrect description.

I figure out that my test kernel is not the lastest, it's without [2] 
commit 72c3c0fe54a3 （"x86/kvm: Use generic xfer to guest work 
function"), so vcpu_run() only care about signal_pending but not 
TIF_NOTIFY_RESUME which set on in task_work_add().

After [2], #MC flood should not exist.

Also thank Thomas Gleixner.

> Can you consider to fix cases like this?
> 
> And do you mind to give me some advice for my temporary workaround about 
> this #MC flood:
> I want to check the context of do_machine_check() is exception or kvm, 
> and fallback to call kill_me_xxx directly when in kvm context. (I 
> already tested simply and met my expection)
> 

So ignore my ask, please.

> [1]: commit 5567d11c21a1 ("x86/mce: Send #MC singal from task work")


-- 
Thanks,
- Ding Hui
