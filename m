Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE206269F0D
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726153AbgIOHEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:04:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgIOHEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:04:40 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F739vl026205;
        Tue, 15 Sep 2020 03:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=za4Qe3x+/BmxDnJ/NLg1lNOhQIrTXfpSemO5MbDshxA=;
 b=gZkpYRoKjGLTRvWzQJamZDQV3JjFfb9twFpF7iImEcrlQnnhKbhIyrRsQTthYCmT8xaq
 fLlsIOesCVDDoymhL/whQ4vwx+D2ZeoUfx8ZxNBAdHPRAhq8WSkb6TdYwizRk55UCkXa
 xKq+oQBAweaIz2UjPNAsW/6fDPQNePEmIQYFGiLNLYy0e69pjx57B1RoyQyQNhBX23UK
 +VAtoUrM39UMf0faERIGsg8rI6T69ti+d9m39cMY4c/kJYFfaQpTsGn3zdpUhOgCG8ZI
 FbYFptwRYV7Df8FcAOE0cOovtmhThmb+mEq8st/MZXfwMActXrc7YOGhRrnf6Z0iDKfN kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jret0pqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:04:24 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F73Ou6027269;
        Tue, 15 Sep 2020 03:04:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jret0pk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:04:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F71KTq029709;
        Tue, 15 Sep 2020 07:04:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33h2r9ar4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 07:04:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F74BkS27197936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 07:04:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11D6F52050;
        Tue, 15 Sep 2020 07:04:11 +0000 (GMT)
Received: from pomme.local (unknown [9.145.72.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9A9CC52052;
        Tue, 15 Sep 2020 07:04:10 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] mm: replace memmap_context by memplug_context
To:     David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200914165042.96218-1-ldufour@linux.ibm.com>
 <20200914165042.96218-2-ldufour@linux.ibm.com>
 <d6ade681-2fb1-a1df-5673-bceacd1dfc55@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <bac8037f-70f6-e7e5-7982-cbfcfef45e01@linux.ibm.com>
Date:   Tue, 15 Sep 2020 09:04:10 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d6ade681-2fb1-a1df-5673-bceacd1dfc55@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_04:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/09/2020 à 19:10, David Hildenbrand a écrit :
> On 14.09.20 18:50, Laurent Dufour wrote:
>> The memmap_context is used to detect whether a memory operation is due to a
>> hot-add operation or happening at boot time.
>>
>> Make it general to the hotplug operation and rename it at memplug_context.
>>
>> There is no functional change introduced by this patch
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>> ---
>>   arch/ia64/mm/init.c    |  6 +++---
>>   include/linux/mm.h     |  2 +-
>>   include/linux/mmzone.h | 11 ++++++++---
>>   mm/memory_hotplug.c    |  2 +-
>>   mm/page_alloc.c        | 10 +++++-----
>>   5 files changed, 18 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
>> index 0b3fb4c7af29..b5054b5e77c8 100644
>> --- a/arch/ia64/mm/init.c
>> +++ b/arch/ia64/mm/init.c
>> @@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
>>   	if (map_start < map_end)
>>   		memmap_init_zone((unsigned long)(map_end - map_start),
>>   				 args->nid, args->zone, page_to_pfn(map_start),
>> -				 MEMMAP_EARLY, NULL);
>> +				 MEMPLUG_EARLY, NULL);
> 
> I am pretty sure that won't compile (MEMINIT_EARLY).
> 
> (same at other places)

Ouch I can't understand what I did at sending time, I did check compile on ia64 
w and w/o memory hotplug.

Sorry for the noise.


