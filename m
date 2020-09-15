Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2928F269F2A
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIOHHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:07:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbgIOHH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:07:27 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F73aeV132949;
        Tue, 15 Sep 2020 03:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R4xV2VPoGHpx/Ey11POcOomUSO3T1KuCJZuJfRK5jBA=;
 b=EYhLfS5PYAfdYV2ZAvaq7sd/OHTlYY9ZU+2GrgniNOlY/bla00xM/xnX0Vd70Ns2LuKb
 rlApxxkA9eB65dpfsdRBStag2qmoQlWr6HRsjj7/D6xlOIG+23lgKMluS7TSpd5hYGhx
 g6X7gokA0Mn9Vhzy3mtm9hTpeoXR6/KTZ+ie16aa0DKOcg1APjGnj9IRHQlPwprtq5ID
 jQ8AnrHeoseT/L2uNGOiHN9v00+l3oev1GpQKwT62al0PQ43zddV/CS1Gs0zXs9jRif8
 +cezHzahqKr54/My53YZrHgmjacDYYU0Xlesqxf4zP0pdX2kTT6o7YBj/H2+ORPGJS1v 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jqu2sv9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:07:07 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F740Ji134552;
        Tue, 15 Sep 2020 03:07:07 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jqu2sv7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:07:07 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F773XS025360;
        Tue, 15 Sep 2020 07:07:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 33hjgds1m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 07:07:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F770We16908772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 07:07:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77A7D5205A;
        Tue, 15 Sep 2020 07:07:00 +0000 (GMT)
Received: from pomme.local (unknown [9.145.72.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3E8B852052;
        Tue, 15 Sep 2020 07:06:59 +0000 (GMT)
Subject: Re: [PATCH v2 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200914165042.96218-1-ldufour@linux.ibm.com>
 <20200914165042.96218-3-ldufour@linux.ibm.com>
 <c378a52b-ab7b-0cb9-cd34-68e20a9d02b0@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <6657eaa7-f27b-ce8e-523d-4447b46b7363@linux.ibm.com>
Date:   Tue, 15 Sep 2020 09:06:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c378a52b-ab7b-0cb9-cd34-68e20a9d02b0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_04:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/09/2020 à 19:15, David Hildenbrand a écrit :
>>   arch/ia64/mm/init.c  |  4 +--
>>   drivers/base/node.c  | 86 ++++++++++++++++++++++++++++----------------
>>   include/linux/node.h | 11 +++---
>>   mm/memory_hotplug.c  |  5 +--
>>   4 files changed, 68 insertions(+), 38 deletions(-)
>>
>> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
>> index b5054b5e77c8..8e7b8c6c576e 100644
>> --- a/arch/ia64/mm/init.c
>> +++ b/arch/ia64/mm/init.c
>> @@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
>>   	if (map_start < map_end)
>>   		memmap_init_zone((unsigned long)(map_end - map_start),
>>   				 args->nid, args->zone, page_to_pfn(map_start),
>> -				 MEMPLUG_EARLY, NULL);
>> +				 MEMINIT_EARLY, NULL);
> 
> Patch #1.

Sure, this explains why I was able to build on ia64 but that's not the right place.

>>   	return 0;
>>   }
>>   
>> @@ -548,7 +548,7 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
>>   {
>>   	if (!vmem_map) {
>>   		memmap_init_zone(size, nid, zone, start_pfn,
>> -				 MEMPLUG_EARLY, NULL);
>> +				 MEMINIT_EARLY, NULL);

I'll fix that too.

>>   	} else {
>>   		struct page *start;
>>   		struct memmap_init_callback_data args;
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 508b80f6329b..01ee73c9d675 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -761,14 +761,36 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>>   	return pfn_to_nid(pfn);
>>   }
>>   
>> +static int do_register_memory_block_under_node(int nid,
>> +					       struct memory_block *mem_blk)
>> +{
>> +	int ret;
>> +
>> +	/*
>> +	 * If this memory block spans multiple nodes, we only indicate
>> +	 * the last processed node.
>> +	 */
>> +	mem_blk->nid = nid;
>> +
>> +	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>> +				       &mem_blk->dev.kobj,
>> +				       kobject_name(&mem_blk->dev.kobj));
>> +	if (ret)
>> +		return ret;
>> +
>> +	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>> +				&node_devices[nid]->dev.kobj,
>> +				kobject_name(&node_devices[nid]->dev.kobj));
>> +}
>> +
>>   /* register memory section under specified node if it spans that node */
>> -static int register_mem_sect_under_node(struct memory_block *mem_blk,
>> -					 void *arg)
>> +static int register_mem_block_under_node_early(struct memory_block *mem_blk,
>> +					       void *arg)
>>   {
>>   	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
>>   	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
>>   	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
>> -	int ret, nid = *(int *)arg;
>> +	int nid = *(int *)arg;
>>   	unsigned long pfn;
>>   
>>   	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
>> @@ -785,38 +807,34 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
>>   		}
>>   
>>   		/*
>> -		 * We need to check if page belongs to nid only for the boot
>> -		 * case, during hotplug we know that all pages in the memory
>> -		 * block belong to the same node.
>> -		 */
>> -		if (system_state == SYSTEM_BOOTING) {
>> -			page_nid = get_nid_for_pfn(pfn);
>> -			if (page_nid < 0)
>> -				continue;
>> -			if (page_nid != nid)
>> -				continue;
>> -		}
>> -
>> -		/*
>> -		 * If this memory block spans multiple nodes, we only indicate
>> -		 * the last processed node.
>> +		 * We need to check if page belongs to nid only at the boot
>> +		 * case because node's ranges can be interleaved.
>>   		 */
>> -		mem_blk->nid = nid;
>> -
>> -		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>> -					&mem_blk->dev.kobj,
>> -					kobject_name(&mem_blk->dev.kobj));
>> -		if (ret)
>> -			return ret;
>> +		page_nid = get_nid_for_pfn(pfn);
>> +		if (page_nid < 0)
>> +			continue;
>> +		if (page_nid != nid)
>> +			continue;
>>   
>> -		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>> -				&node_devices[nid]->dev.kobj,
>> -				kobject_name(&node_devices[nid]->dev.kobj));
>> +		/* The memory block is registered to the first matching node */
> 
> That comment is misleading in that context.
> 
> A memory block is registered if there is at least a page that belongs to
> the nid. It's perfectly fine to have a single memory block belong to
> multiple NUMA nodes (when the split is within a memory block). I'd just
> drop it.

I agree the comment is not accurate, I'll drop it.

