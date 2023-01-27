Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220EF67EB48
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 17:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbjA0QnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 11:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjA0QnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 11:43:03 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5442A8B043;
        Fri, 27 Jan 2023 08:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674837739;
        bh=WYiWkP/dtwkyA62g8kjNmEj2OL3Za+7+2rHtPJbfeCQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TGhlH0nsA3U7PwlWIZIq03em86sQbxEK4x6zgKRvcF6npz3GAC0KqBfSROqeX3I9G
         Dxk1EWpuUUXorJsQm6rRA11h9pepuUPDomXvuGwlIeeQwUtTXtoy+FO6rEKoppS3x6
         OHETtHbsRP3fakDLR0v9vFwK5xRNoCOvLXxpymzV8TXSsTA3RILafQzrqpzcRKAWOX
         hnPHnW9Cif5tBuH1Zbgma4RBdtXup41jX11B/w0N4F6dUUCGgkq11JrW9hsVtWOUyf
         GxnDwaQzC7HsZ5E7rv1SFRg/IGzVkNOWbaOkDAWwbn/1RVSq4PXNOSJ3tN1dSIo40f
         RKdS+vZtOvekA==
Received: from [10.93.0.190] (unknown [62.119.240.70])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3Nf20nq8zhkV;
        Fri, 27 Jan 2023 11:42:17 -0500 (EST)
Message-ID: <19a5036f-a7f4-846d-57ac-eee69d6a0ff0@efficios.com>
Date:   Fri, 27 Jan 2023 17:42:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 17/34] selftests: net: Fix incorrect kernel headers search
 path
Content-Language: en-US
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-18-mathieu.desnoyers@efficios.com>
 <9174ce77-f891-8428-6c36-6b8b4a21cd26@tessares.net>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <9174ce77-f891-8428-6c36-6b8b4a21cd26@tessares.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-27 11:21, Matthieu Baerts wrote:
> Hi Mathieu,
> 
> On 27/01/2023 14:57, Mathieu Desnoyers wrote:
>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>> building against kernel headers from the build environment in scenarios
>> where kernel headers are installed into a specific output directory
>> (O=...).
> 
> Thank you for the patch!

You're welcome :)

> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: linux-kselftest@vger.kernel.org
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: <stable@vger.kernel.org>    [5.18+]
> 
> (It might be useful to add a "Fixes" tag as well to clearly indicate the
> dependence with a specific commit and better understand the fix.)

Just a bit of context: I found this problematic pattern in my own 
selftests (rseq and membarrier), and figured that it was an issue all 
across the board. I did an initial single-patch fix, and then split it 
up in 34 patches based on feedback from Shuah Khan.

I know it should have a Fixed ... tag, but I simply don't have time to 
do the historical investigation work for all the 34 patches form this 
patchset. Perhaps someone else is up to the task ?

> 
> (and add all the individual maintainers of the files you modify -- feel
> free to use 'b4' to help you for this task ;-) )

If this can be automated, then perhaps Shuah can use it to append the 
relevant information ?

> 
> (...)
> 
>> diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
>> index 43a723626126..06bba013bcef 100644
>> --- a/tools/testing/selftests/net/mptcp/Makefile
>> +++ b/tools/testing/selftests/net/mptcp/Makefile
>> @@ -2,7 +2,7 @@
>>   
>>   top_srcdir = ../../../../..
>>   
>> -CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
>> +CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g $(KHDR_INCLUDES)
> 
> I only looked at the modification here with MPTCP selftests and it looks
> good to me. It makes sense because if KHDR_INCLUDES is not set, it will
> be set later by lib.mk I suppose.
> 
> Just one small thing: I guess you can also remove "top_srcdir" variable
> that is no longer used, right? I see that "lib.mk" uses a variable with
> the same name but it overrides its value anyway. But it is likely I
> missed something there :)
> 
> If indeed it is no longer needed, I guess a few Makefile can be adapted
> according to:
> 
>    git grep top_srcdir -- tools/testing/selftests/*/
> 

Yes, this should perhaps come as additional fixes on top of my series. I 
don't have time to do it myself though.

Anyone willing to contribute it ?

> I guess most of these Makefile are very similar, no? For MPTCP, we
> simply looked at what was done elsewhere :)

Yes, I did likewise.

Thanks for the feedback,

Mathieu

> 
> Cheers,
> Matt

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

