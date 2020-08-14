Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA56244EEB
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 21:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgHNTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 15:43:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHNTnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 15:43:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07EJh8sL074634;
        Fri, 14 Aug 2020 19:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SwHfYaaNmDMFFSwAZIoB8OOdCgTGZkhKQNO1QCQNdrY=;
 b=MjWbKYfR+HXY70mJ3a2m4Y7w4XzU8Dy9964Ak1VpzBEpwpENuw4v/IGnriaU04v0ShJu
 pznO3DdPRrBvf7iRswTASLNKLrnea7lsX2WcOAHGM/xuQwr4nm0YIn+gFigMDNhqQF90
 k00dKCjcmzOvFIZ7YMGI8RXFnhz/OMCT1G3bJPvNjuuXBSsjkYkjdyqCbBX8qUA6T9ju
 NRMZ2MZ7Xve5YvoLpGaUaDcGJOVGy+vIkTYbwHZVIT3cKCXVosYuSbvcQroSB+O5Q4g6
 CzNEO9tWOoJRS/9/k7Ufma7ql3Dc0l2yIShwW372xGxO2s8BAz2Do7GwdiGsbiRptfPL 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32wvp11ctg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Aug 2020 19:43:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07EJbjV3138011;
        Fri, 14 Aug 2020 19:43:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32wvqjhh6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 19:43:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07EJhFOR030753;
        Fri, 14 Aug 2020 19:43:15 GMT
Received: from [10.159.235.234] (/10.159.235.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Aug 2020 19:43:15 +0000
Subject: Re: [PATCH] mm: slub: fix conversion of freelist_corrupted()
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org, Eugeniu Rosca <roscaeugeniu@gmail.com>
References: <20200811124656.10308-1-erosca@de.adit-jv.com>
 <f93a9f06-8608-6f28-27c0-b17f86dca55b@oracle.com>
 <20200814074644.GA7943@lxhi-065.adit-jv.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <cbcf9612-adb4-38fd-5c11-852197ec8703@oracle.com>
Date:   Fri, 14 Aug 2020 12:43:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200814074644.GA7943@lxhi-065.adit-jv.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9713 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9713 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140146
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/14/20 12:46 AM, Eugeniu Rosca wrote:
> Hello Dongli,
> 
> On Thu, Aug 13, 2020 at 11:57:51PM -0700, Dongli Zhang wrote:
>> On 8/11/20 5:46 AM, Eugeniu Rosca wrote:
>>> Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
>>> deactivate_slab()") suffered an update when picked up from LKML [1].
>>>
>>> Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
>>> created a no-op statement. Fix it by sticking to the behavior intended
>>> in the original patch [1]. Prefer the lowest-line-count solution.
>>>
>>> [1] https://urldefense.com/v3/__https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/__;!!GqivPVa7Brio!LkxH4qJ3WzKnO_nmONLWV-HAougEaefnp8UnI6qC_8j0SS9_9fkO6bOe68flixlQzx8$ 
>>>
>>> Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Dongli Zhang <dongli.zhang@oracle.com>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
>>> ---
>>>  mm/slub.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 68c02b2eecd9..9a3e963b02a3 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -677,7 +677,6 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
>>>  	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
>>>  	    !check_valid_pointer(s, page, nextfree)) {
>>>  		object_err(s, page, freelist, "Freechain corrupt");
>>> -		freelist = NULL;
>>>  		slab_fix(s, "Isolate corrupted freechain");
>>>  		return true;
>>>  	}
>>> @@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
>>>  		 * 'freelist' is already corrupted.  So isolate all objects
>>>  		 * starting at 'freelist'.
>>>  		 */
>>> -		if (freelist_corrupted(s, page, freelist, nextfree))
>>> +		if (freelist_corrupted(s, page, freelist, nextfree)) {
>>> +			freelist = NULL;
>>
>> This is good to me.
>>
>> However, this would confuse people when CONFIG_SLUB_DEBUG is not defined.
>>
>> While reading the source code, people may be curious why to reset freelist when
>> CONFIG_SLUB_DEBUG is even not defined.
> 
> This is a fair point. To address it, the `freelist = NULL` assignment
> should be then moved into the body of freelist_corrupted(). If no
> concerns on that, I will soon push a v2 implementing this proposal.
> 

I do have have concern with that if that can make both of static analysis tool
and the people reading code happy :)

Thank you very much!

Dongli Zhang
