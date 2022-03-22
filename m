Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C177E4E3967
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 08:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiCVHMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 03:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiCVHMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 03:12:02 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97E101A;
        Tue, 22 Mar 2022 00:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647933034; x=1679469034;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=A4DJO6rZ+U2jhbFjrXRawempc8neSi1K8vzRDZh7DN4=;
  b=yF+spAdQ7nxyKAuZN1Tovpx4p/kBSOs4cGJrD/9r/fGrc67C4G/8KRII
   Rp6/7QV/neBcsGUStWNiSXORGiqCZLjnM+US4VpwNTw6Z1EBNQFXb2T2S
   t9fQfHwY4ZwxF/jh5QVU7vUeyv7JM00wwixENdx5lj0I50ckZj0SKTWUP
   4=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 22 Mar 2022 00:10:34 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 00:10:33 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 22 Mar 2022 00:10:33 -0700
Received: from [10.216.14.252] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 22 Mar
 2022 00:10:28 -0700
Message-ID: <7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com>
Date:   Tue, 22 Mar 2022 12:40:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Charan Teja Kalla <quic_charante@quicinc.com>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
To:     Michal Hocko <mhocko@suse.com>
CC:     <akpm@linux-foundation.org>, <surenb@google.com>, <vbabka@suse.cz>,
        <rientjes@google.com>, <sfr@canb.auug.org.au>,
        <edgararriaga@google.com>, <minchan@kernel.org>,
        <nadav.amit@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <Yjia8AzhgWh4KPbp@dhcp22.suse.cz>
Content-Language: en-US
In-Reply-To: <Yjia8AzhgWh4KPbp@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Michal for the inputs.

On 3/21/2022 9:04 PM, Michal Hocko wrote:
> On Fri 11-03-22 20:59:06, Charan Teja Kalla wrote:
>> The process_madvise() system call is expected to skip holes in vma
>> passed through 'struct iovec' vector list.
> Where is this assumption coming from? From the man page I can see:
> : The advice might be applied to only a part of iovec if one of its
> : elements points to an invalid memory region in the remote
> : process.  No further elements will be processed beyond that
> : point.  

I assumed this while processing a single element of a iovec. In a
scenario where a range passed contains multiple VMA's + holes, on
encountering the VMA with VM_LOCKED|VM_HUGETLB|VM_PFNMAP, we are
immediately stopping further processing of that iovec element with
EINVAL return. Where as on encountering a hole, we are simply
remembering it as ENOMEM but continues processing that iovec element and
in the end returns ENOMEM. This means that complete range is processed
but still returning ENOMEM, hence the assumption of skipping holes in a
vma.

The other problem is, in an individual iovec element, though some bytes
are processed we may still endup in returning EINVAL which is hard for
the user to take decisions i.e. he doesn't know at which address it is
exactly failed to advise.

Anyway, both these will be addressed in the next version of this patch
with the suggestions from minchan [1] where it mentioned that: "it
should represent exact bytes it addressed with exacts ranges like
process_vm_readv/writev. Poviding valid ranges is responsiblity from the
user."

[1]  https://lore.kernel.org/linux-mm/YjNgoeg1yOocsjWC@google.com/
> 
>> But do_madvise, which
>> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
>> holes, despite the VMA is processed.
>> Thus process_madvise() should treat ENOMEM as expected and consider the
>> VMA passed to as processed and continue processing other vma's in the
>> vector list. Returning -ENOMEM to user, despite the VMA is processed,
>> will be unable to figure out where to start the next madvise.
> I am not sure I follow. With your previous patch and -ENOMEM from
> do_madvise you get the the answer you are looking for, no?
> With this applied you are loosing the information that some of the iters
> are not mapped or has a hole. Which might be a useful information
> especially when processing on remote tasks which are free to manipulate
> their address spaces.

Yes, it should return ENOMEM. The same will be fixed in the next revision.

> 
>> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
>> Cc: <stable@vger.kernel.org> # 5.10+
>> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
>> ---
>> Changes in V2:
>>   -- Fixed handling of ENOMEM by process_madvise().
>>   -- Patch doesn't exist in V1.
>>
>>  mm/madvise.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index e97e6a9..14fb76d 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1426,9 +1426,16 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>>  
>>  	while (iov_iter_count(&iter)) {
>>  		iovec = iov_iter_iovec(&iter);
>> +		/*
>> +		 * do_madvise returns ENOMEM if unmapped holes are present
>> +		 * in the passed VMA. process_madvise() is expected to skip
>> +		 * unmapped holes passed to it in the 'struct iovec' list
>> +		 * and not fail because of them. Thus treat -ENOMEM return
>> +		 * from do_madvise as valid and continue processing.
>> +		 */
>>  		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
>>  					iovec.iov_len, behavior);
>> -		if (ret < 0)
>> +		if (ret < 0 && ret != -ENOMEM)
>>  			break;
>>  		iov_iter_advance(&iter, iovec.iov_len);
>>  	}
>> -- 
>> 2.7.4
