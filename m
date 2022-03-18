Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BEC4DDB34
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 15:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiCROHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 10:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiCROHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 10:07:10 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DD923456D;
        Fri, 18 Mar 2022 07:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647612351; x=1679148351;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ffbZZDrcdGMKTpclOYncRs09YC3Awsec51kId4S+aIk=;
  b=VtE7hRMBPrjhqsAPxrXpW4SOwLgqOoO7wcgeZtMW40f8a5gETDIsH3q1
   dVeVnMyWZIGW8MpkthsL+d4r1bqmNRVDcz2g61DvwYglC3aqWOidjl8Mz
   KUCI6XLC1BdeXXFneM64hY/GBION0Zf4BNTkuygvT+ngifGUOwZsrh/Gq
   s=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 18 Mar 2022 07:05:50 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 07:05:50 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 18 Mar 2022 07:05:49 -0700
Received: from [10.216.20.137] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 18 Mar
 2022 07:05:45 -0700
Message-ID: <74852e90-003b-84b8-9836-72258e3c5057@quicinc.com>
Date:   Fri, 18 Mar 2022 19:35:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Content-Language: en-US
To:     Nadav Amit <nadav.amit@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>
CC:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=c3=ada?= <edgararriaga@google.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
 <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
 <YjNhvhb7l2i9WTfF@google.com>
 <CAJuCfpGBJev_h92S0xLEQXghGQzNPCsqWTunpVPJQX4WWPjGzw@mail.gmail.com>
 <B49F17E4-8D3D-45FB-97E9-E0F906C88564@gmail.com>
From:   Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <B49F17E4-8D3D-45FB-97E9-E0F906C88564@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
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

Thank you for valuable inputs.

On 3/18/2022 2:08 AM, Nadav Amit wrote:
>>>>>> IMO, it's worth to note in man page.
>>>>>>
>>>>> Or the current patch for just ENOMEM is sufficient here and we just have
>>>>> to update the man page?
>>>> I think the "On success, process_madvise() returns the number of bytes
>>>> advised" behaviour sounds useful.  But madvise() doesn't do that.
>>>>
>>>> RETURN VALUE
>>>>       On  success, madvise() returns zero.  On error, it returns -1 and errno
>>>>       is set to indicate the error.
>>>>
>>>> So why is it desirable in the case of process_madvise()?
>>> Since process_madvise deal with multiple ranges and could fail at one of
>>> them in the middle or pocessing, people could decide where the call
>>> failed and then make a strategy whether they will abort at the point or
>>> continue to hint next addresses. Here, problem of the strategy is API
>>> doesn't return any error vaule if it has processed any bytes so they
>>> would have limitation to decide a policy. That's the limitation for
>>> every vector IO syscalls, unfortunately.
>>>
>>>>
>>>>
>>>> And why was process_madvise() designed this way?   Or was it
>>>> always simply an error in the manpage?
>> Taking a closer look, indeed manpage seems to be wrong.
>> https://elixir.bootlin.com/linux/v5.17-rc8/source/mm/madvise.c#L1154
>> indicates that in the presence of unmapped holes madvise will skip
>> them but will return ENOMEM and that's what process_madvise is
>> ultimately returning in this case. So, the manpage claim of "This
>> return value may be less than the total number of requested bytes, if
>> an error occurred after some iovec elements were already processed."
>> does not reflect the reality in our case because the return value will
>> be -ENOMEM. After the desired behavior is finalized I'll modify the
>> manpage accordingly.
> Since process_madvise() might be used in sort of non-cooperative mode,
> I think that the caller cannot guarantee that it knows exactly the
> memory layout of the process whose memory it madvise’s. I know that
> MADV_DONTNEED for instance is not supported (at least today) by
> process_madvise(), but if it were, the caller may want which exact
> memory was madvise'd even if the target process ran some other
> memory layout changing syscalls (e.g., munmap()).
> 
> IOW, skipping holes and just returning the total number of madvise’d
> bytes might not be enough.

Then does the advised bytes range by default including holes is a
correct design?
Say the [start, len) range passed in the iovec by the user contains the
layout like, vma1 -- hole-- vma2 -- hole -- vma3.

Under ideal case, where all vma's are eligible for advise, the total
bytes processed returning should be vma3->end - vma1->start. This is
success case.

 Now, say that vma1 is succeeded but vma2(say VM_LOCKED) is failed at
advise. In such case processed bytes will be
vma2->start-vma1->start(still consider hole as bytes processed), so that
user may restart/skip at vma2, then continue. This return type will be
partially processed bytes.

If the system doesn't found any VMA in the passed range by user, it
returns ENOMEM as not a single advisable vma is found in the range.

> 
