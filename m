Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2253D9DDF
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhG2Gu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 02:50:57 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:4531 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2Gu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 02:50:56 -0400
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 1515242C42;
        Thu, 29 Jul 2021 08:50:52 +0200 (CEST)
Subject: Re: [PATCH 2/2] io_uring: don't block level reissue off completion
 path
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210727165811.284510-1-axboe@kernel.dk>
 <20210727165811.284510-3-axboe@kernel.dk>
 <70b7b7b2-c6d5-8088-ee76-c1ffc53ac2a3@proxmox.com>
 <df686cb8-3d6e-f3ee-b767-b297434748e7@kernel.dk>
From:   Fabian Ebner <f.ebner@proxmox.com>
Message-ID: <6ff5f7de-597d-ed19-0fb4-039bc4f25245@proxmox.com>
Date:   Thu, 29 Jul 2021 08:50:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <df686cb8-3d6e-f3ee-b767-b297434748e7@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 28.07.21 um 15:23 schrieb Jens Axboe:
> On 7/28/21 3:26 AM, Fabian Ebner wrote:
>> Am 27.07.21 um 18:58 schrieb Jens Axboe:
>>> Some setups, like SCSI, can throw spurious -EAGAIN off the softirq
>>> completion path. Normally we expect this to happen inline as part
>>> of submission, but apparently SCSI has a weird corner case where it
>>> can happen as part of normal completions.
>>>
>>> This should be solved by having the -EAGAIN bubble back up the stack
>>> as part of submission, but previous attempts at this failed and we're
>>> not just quite there yet. Instead we currently use REQ_F_REISSUE to
>>> handle this case.
>>>
>>> For now, catch it in io_rw_should_reissue() and prevent a reissue
>>> from a bogus path.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Fabian Ebner <f.ebner@proxmox.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    fs/io_uring.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 6ba101cd4661..83f67d33bf67 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2447,6 +2447,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
>>>    	 */
>>>    	if (percpu_ref_is_dying(&ctx->refs))
>>>    		return false;
>>> +	/*
>>> +	 * Play it safe and assume not safe to re-import and reissue if we're
>>> +	 * not in the original thread group (or in task context).
>>> +	 */
>>> +	if (!same_thread_group(req->task, current) || !in_task())
>>> +		return false;
>>>    	return true;
>>>    }
>>>    #else
>>>
>>
>> Hi,
>>
>> thank you for the fix! This does indeed prevent the panic (with 5.11.22)
>> and hang (with 5.13.3) with my problematic workload.
> 
> Perfect, thanks for re-testing! Can I add your Tested-by to the patch?
> 

Sure, feel free to do so.

Best Regards,
Fabian

