Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9B2A4C62
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 18:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKCRL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 12:11:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbgKCRL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 12:11:58 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3H4rTv155482;
        Tue, 3 Nov 2020 12:11:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7t6VQbq+UBMcFU+y3HOIFcGYkl/sQCQCIRqMqJzFNpU=;
 b=ZxIx8/86AdM8NgrtMHAVOjSE6ZucjR7JjpHqJFK4zf3I5/OfRhgUeMtrsKmJ36ffpf8k
 C9NBHxjYr6tPsuYbqckjzu+mdPKPYwsXiTS28uY/noqrWhLUsUEmTQ0GA0r1l+eX/khz
 UDXJHJM+LzTy6iKiXxqnBbeiiF4MxrqTfNRvlrOaR4HXaVemD403g0cuH69dMTwgM974
 t/GR8iR4Lw4gCuvgMwKkCbyJn7hl6oTRjBpiwEScxTpLZLs9/Z4oqpBs7qQHLS3za7Tr
 IRheA2KlZd0TpHHUOfSCMFnO7tTYtzKhnlCmyxCVvLNH54jWhLl29qoIsjnJ33fCsdo6 Rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k12uuv2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 12:11:21 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3H7Qhh018964;
        Tue, 3 Nov 2020 17:11:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6haqfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 17:11:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3HBGxE2687652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 17:11:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1B51A4055;
        Tue,  3 Nov 2020 17:11:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19EC4A404D;
        Tue,  3 Nov 2020 17:11:16 +0000 (GMT)
Received: from pomme.local (unknown [9.145.79.178])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 17:11:16 +0000 (GMT)
Subject: Re: [PATCH] x86/mpx: fix recursive munmap() corruption
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
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
 <12313ba8-75b5-d44d-dbc0-0bf2c87dfb59@csgroup.eu>
From:   Laurent Dufour <ldufour@linux.vnet.ibm.com>
Message-ID: <452b347c-0a86-c710-16ba-5a98c12a47e3@linux.vnet.ibm.com>
Date:   Tue, 3 Nov 2020 18:11:15 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <12313ba8-75b5-d44d-dbc0-0bf2c87dfb59@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030110
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 23/10/2020 à 14:28, Christophe Leroy a écrit :
> Hi Laurent
> 
> Le 07/05/2019 à 18:35, Laurent Dufour a écrit :
>> Le 01/05/2019 à 12:32, Michael Ellerman a écrit :
>>> Laurent Dufour <ldufour@linux.vnet.ibm.com> writes:
>>>> Le 23/04/2019 à 18:04, Dave Hansen a écrit :
>>>>> On 4/23/19 4:16 AM, Laurent Dufour wrote:
>>> ...
>>>>>> There are 2 assumptions here:
>>>>>>    1. 'start' and 'end' are page aligned (this is guaranteed by 
>>>>>> __do_munmap().
>>>>>>    2. the VDSO is 1 page (this is guaranteed by the union vdso_data_store 
>>>>>> on powerpc)
>>>>>
>>>>> Are you sure about #2?  The 'vdso64_pages' variable seems rather
>>>>> unnecessary if the VDSO is only 1 page. ;)
>>>>
>>>> Hum, not so sure now ;)
>>>> I got confused, only the header is one page.
>>>> The test is working as a best effort, and don't cover the case where
>>>> only few pages inside the VDSO are unmmapped (start >
>>>> mm->context.vdso_base). This is not what CRIU is doing and so this was
>>>> enough for CRIU support.
>>>>
>>>> Michael, do you think there is a need to manage all the possibility
>>>> here, since the only user is CRIU and unmapping the VDSO is not a so
>>>> good idea for other processes ?
>>>
>>> Couldn't we implement the semantic that if any part of the VDSO is
>>> unmapped then vdso_base is set to zero? That should be fairly easy, eg:
>>>
>>>     if (start < vdso_end && end >= mm->context.vdso_base)
>>>         mm->context.vdso_base = 0;
>>>
>>>
>>> We might need to add vdso_end to the mm->context, but that should be OK.
>>>
>>> That seems like it would work for CRIU and make sense in general?
>>
>> Sorry for the late answer, yes this would make more sense.
>>
>> Here is a patch doing that.
>>
> 
> In your patch, the test seems overkill:
> 
> +    if ((start <= vdso_base && vdso_end <= end) ||  /* 1   */
> +        (vdso_base <= start && start < vdso_end) || /* 3,4 */
> +        (vdso_base < end && end <= vdso_end))       /* 2,3 */
> +        mm->context.vdso_base = mm->context.vdso_end = 0;
> 
> What about
> 
>      if (start < vdso_end && vdso_start < end)
>          mm->context.vdso_base = mm->context.vdso_end = 0;
> 
> This should cover all cases, or am I missing something ?
> 
> 
> And do we really need to store vdso_end in the context ?
> I think it should be possible to re-calculate it: the size of the VDSO should be 
> (&vdso32_end - &vdso32_start) + PAGE_SIZE for 32 bits VDSO, and (&vdso64_end - 
> &vdso64_start) + PAGE_SIZE for the 64 bits VDSO.

Thanks Christophe for the advise.

That is covering all the cases, and indeed is similar to the Michael's proposal 
I missed last year.

I'll send a patch fixing this issue following your proposal.

Cheers,
Laurent.
