Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7523296F2E
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463799AbgJWM3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 08:29:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22240 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372483AbgJWM3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 08:29:06 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CHk722DKjz9v0CW;
        Fri, 23 Oct 2020 14:29:02 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 4Bi4vCxJo23W; Fri, 23 Oct 2020 14:29:02 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CHk720T1Pz9v0CM;
        Fri, 23 Oct 2020 14:29:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4193D8B86A;
        Fri, 23 Oct 2020 14:29:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id tdfQKIjC4FR2; Fri, 23 Oct 2020 14:29:03 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 341098B85E;
        Fri, 23 Oct 2020 14:29:02 +0200 (CEST)
Subject: Re: [PATCH] x86/mpx: fix recursive munmap() corruption
To:     Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, mhocko@suse.com,
        rguenther@suse.de, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        luto@amacapital.net, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, vbabka@suse.cz
References: <20190401141549.3F4721FE@viggo.jf.intel.com>
 <alpine.DEB.2.21.1904191248090.3174@nanos.tec.linutronix.de>
 <87d0lht1c0.fsf@concordia.ellerman.id.au>
 <6718ede2-1fcb-1a8f-a116-250eef6416c7@linux.vnet.ibm.com>
 <4f43d4d4-832d-37bc-be7f-da0da735bbec@intel.com>
 <4e1bbb14-e14f-8643-2072-17b4cdef5326@linux.vnet.ibm.com>
 <87k1faa2i0.fsf@concordia.ellerman.id.au>
 <9c2b2826-4083-fc9c-5a4d-c101858dd560@linux.vnet.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <12313ba8-75b5-d44d-dbc0-0bf2c87dfb59@csgroup.eu>
Date:   Fri, 23 Oct 2020 14:28:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <9c2b2826-4083-fc9c-5a4d-c101858dd560@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent

Le 07/05/2019 à 18:35, Laurent Dufour a écrit :
> Le 01/05/2019 à 12:32, Michael Ellerman a écrit :
>> Laurent Dufour <ldufour@linux.vnet.ibm.com> writes:
>>> Le 23/04/2019 à 18:04, Dave Hansen a écrit :
>>>> On 4/23/19 4:16 AM, Laurent Dufour wrote:
>> ...
>>>>> There are 2 assumptions here:
>>>>>    1. 'start' and 'end' are page aligned (this is guaranteed by __do_munmap().
>>>>>    2. the VDSO is 1 page (this is guaranteed by the union vdso_data_store on powerpc)
>>>>
>>>> Are you sure about #2?  The 'vdso64_pages' variable seems rather
>>>> unnecessary if the VDSO is only 1 page. ;)
>>>
>>> Hum, not so sure now ;)
>>> I got confused, only the header is one page.
>>> The test is working as a best effort, and don't cover the case where
>>> only few pages inside the VDSO are unmmapped (start >
>>> mm->context.vdso_base). This is not what CRIU is doing and so this was
>>> enough for CRIU support.
>>>
>>> Michael, do you think there is a need to manage all the possibility
>>> here, since the only user is CRIU and unmapping the VDSO is not a so
>>> good idea for other processes ?
>>
>> Couldn't we implement the semantic that if any part of the VDSO is
>> unmapped then vdso_base is set to zero? That should be fairly easy, eg:
>>
>>     if (start < vdso_end && end >= mm->context.vdso_base)
>>         mm->context.vdso_base = 0;
>>
>>
>> We might need to add vdso_end to the mm->context, but that should be OK.
>>
>> That seems like it would work for CRIU and make sense in general?
> 
> Sorry for the late answer, yes this would make more sense.
> 
> Here is a patch doing that.
> 

In your patch, the test seems overkill:

+	if ((start <= vdso_base && vdso_end <= end) ||  /* 1   */
+	    (vdso_base <= start && start < vdso_end) || /* 3,4 */
+	    (vdso_base < end && end <= vdso_end))       /* 2,3 */
+		mm->context.vdso_base = mm->context.vdso_end = 0;

What about

	if (start < vdso_end && vdso_start < end)
		mm->context.vdso_base = mm->context.vdso_end = 0;

This should cover all cases, or am I missing something ?


And do we really need to store vdso_end in the context ?
I think it should be possible to re-calculate it: the size of the VDSO should be (&vdso32_end - 
&vdso32_start) + PAGE_SIZE for 32 bits VDSO, and (&vdso64_end - &vdso64_start) + PAGE_SIZE for the 
64 bits VDSO.

Christophe
