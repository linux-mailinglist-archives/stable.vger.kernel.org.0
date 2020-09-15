Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176A2269FBA
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgIOH05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:26:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbgIOHZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:25:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F76t66068686;
        Tue, 15 Sep 2020 03:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lIBF0yIZ/euhPJ4mHyoWSctgnR1mo++/vKvP8La0i+c=;
 b=oJ5M7IINZhbynnZEaZmnSftJUOvFg9/kCZsVnCNJAeG6xZ6hIK9U59AUFV+wPG/5k1NM
 jeFNj2w0VeTL3gjKNRCJ3b8hIRd0Ec9SB7Uuoy+TNhR/CmX9uIEe57fV5sCNvnWfXfuf
 jqsfxy7raCFnILrydLgkj21zRd8wrxRN5jZrZcxOHtmyc1c+Qm6fDqFsjpaFEk36V7kl
 Mqp7TOy7Xlv4IpcskBMB94j2lfOXN7zEDUQBXz8hLdmKIHVb/4zwhYpubrxqSBAnKKVF
 Msx8NQNpRmbqZ9bTM7tA5q7GQPcHemlQn3W2bGVkq0jt95oo30Xqajz/WUY9dJRIo9JW GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jqawatby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:24:52 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F78QBD072884;
        Tue, 15 Sep 2020 03:24:52 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jqawatb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 03:24:52 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F7Mue0026200;
        Tue, 15 Sep 2020 07:24:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 33gny81prs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 07:24:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F7Ok4518809314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 07:24:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A45752050;
        Tue, 15 Sep 2020 07:24:46 +0000 (GMT)
Received: from pomme.local (unknown [9.145.72.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 789AF52052;
        Tue, 15 Sep 2020 07:24:45 +0000 (GMT)
Subject: Re: [PATCH v2 3/3] mm: don't panic when links can't be created in
 sysfs
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
 <20200914165042.96218-4-ldufour@linux.ibm.com>
 <a62d5cde-85c9-8650-d5e0-d277c6f7360f@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <77a61ee9-0fec-f812-3999-8742bfcf7943@linux.ibm.com>
Date:   Tue, 15 Sep 2020 09:24:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a62d5cde-85c9-8650-d5e0-d277c6f7360f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_04:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150059
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 15/09/2020 à 09:23, David Hildenbrand a écrit :
> On 14.09.20 18:50, Laurent Dufour wrote:
>> At boot time, or when doing memory hot-add operations, if the links in
>> sysfs can't be created, the system is still able to run, so just report the
>> error in the kernel log rather than BUG_ON and potentially make system
>> unusable because the callpath can be called with locks held.
>>
>> Since the number of memory blocks managed could be high, the messages are
>> rate limited.
>>
>> As a consequence, link_mem_sections() has no status to report anymore.
>>
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>> Acked-by: Michal Hocko <mhocko@suse.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   drivers/base/node.c  | 33 +++++++++++++++++++++------------
>>   include/linux/node.h | 16 +++++++---------
>>   mm/memory_hotplug.c  |  5 ++---
>>   3 files changed, 30 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 01ee73c9d675..249b2ba6dc81 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -761,8 +761,8 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>>   	return pfn_to_nid(pfn);
>>   }
>>   
>> -static int do_register_memory_block_under_node(int nid,
>> -					       struct memory_block *mem_blk)
>> +static void do_register_memory_block_under_node(int nid,
>> +						struct memory_block *mem_blk)
>>   {
>>   	int ret;
>>   
>> @@ -775,12 +775,19 @@ static int do_register_memory_block_under_node(int nid,
>>   	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>>   				       &mem_blk->dev.kobj,
>>   				       kobject_name(&mem_blk->dev.kobj));
>> -	if (ret)
>> -		return ret;
>> +	if (ret && ret != -EEXIST)
>> +		dev_err_ratelimited(&node_devices[nid]->dev,
>> +				    "can't create link to %s in sysfs (%d)\n",
>> +				    kobject_name(&mem_blk->dev.kobj), ret);
>>   
>> -	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>> +	ret = sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>>   				&node_devices[nid]->dev.kobj,
>>   				kobject_name(&node_devices[nid]->dev.kobj));
>> +	if (ret && ret != -EEXIST)
>> +		dev_err_ratelimited(&mem_blk->dev,
>> +				    "can't create link to %s in sysfs (%d)\n",
>> +				    kobject_name(&node_devices[nid]->dev.kobj),
>> +				    ret);
>>   }
>>   
>>   /* register memory section under specified node if it spans that node */
>> @@ -817,7 +824,8 @@ static int register_mem_block_under_node_early(struct memory_block *mem_blk,
>>   			continue;
>>   
>>   		/* The memory block is registered to the first matching node */
>> -		return do_register_memory_block_under_node(nid, mem_blk);
>> +		do_register_memory_block_under_node(nid, mem_blk);
>> +		return 0;
>>   	}
>>   	/* mem section does not span the specified node */
>>   	return 0;
>> @@ -832,7 +840,8 @@ static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
>>   {
>>   	int nid = *(int *)arg;
>>   
>> -	return do_register_memory_block_under_node(nid, mem_blk);
>> +	do_register_memory_block_under_node(nid, mem_blk);
>> +	return 0;
>>   }
>>   
>>   /*
>> @@ -850,8 +859,8 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
>>   			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
>>   }
>>   
>> -int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
>> -		      enum meminit_context context)
>> +void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
>> +		       enum meminit_context context)
>>   {
>>   	walk_memory_blocks_func_t func;
>>   
>> @@ -860,9 +869,9 @@ int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
>>   	else
>>   		func = register_mem_block_under_node_early;
>>   
>> -	return walk_memory_blocks(PFN_PHYS(start_pfn),
>> -				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
>> -				  func);
>> +	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
>> +			   (void *)&nid, func);
>> +	return;
>>   }
>>   
>>   #ifdef CONFIG_HUGETLBFS
>> diff --git a/include/linux/node.h b/include/linux/node.h
>> index 014ba3ab2efd..8e5a29897936 100644
>> --- a/include/linux/node.h
>> +++ b/include/linux/node.h
>> @@ -99,15 +99,14 @@ extern struct node *node_devices[];
>>   typedef  void (*node_registration_func_t)(struct node *);
>>   
>>   #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
>> -int link_mem_sections(int nid, unsigned long start_pfn,
>> -		      unsigned long end_pfn,
>> -		      enum meminit_context context);
>> +void link_mem_sections(int nid, unsigned long start_pfn,
>> +		       unsigned long end_pfn,
>> +		       enum meminit_context context);
>>   #else
>> -static inline int link_mem_sections(int nid, unsigned long start_pfn,
>> -				    unsigned long end_pfn,
>> -				    enum meminit_context context)
>> +static inline void link_mem_sections(int nid, unsigned long start_pfn,
>> +				     unsigned long end_pfn,
>> +				     enum meminit_context context)
>>   {
>> -	return 0;
>>   }
>>   #endif
>>   
>> @@ -130,8 +129,7 @@ static inline int register_one_node(int nid)
>>   		if (error)
>>   			return error;
>>   		/* link memory sections under this node */
>> -		error = link_mem_sections(nid, start_pfn, end_pfn,
>> -					  MEMINIT_EARLY);
>> +		link_mem_sections(nid, start_pfn, end_pfn, MEMINIT_EARLY);
>>   	}
>>   
>>   	return error;
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 03df20078827..01e01a530d38 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1080,9 +1080,8 @@ int __ref add_memory_resource(int nid, struct resource *res)
>>   	}
>>   
>>   	/* link memory sections under this node.*/
>> -	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
>> -				MEMINIT_HOTPLUG);
>> -	BUG_ON(ret);
>> +	link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
>> +			  MEMINIT_HOTPLUG);
>>   
>>   	/* create new memmap entry */
>>   	if (!strcmp(res->name, "System RAM"))
>>
> 
> I just remember that I still have some cleanup patches lying around that
> rework the whole node onlining on the add_memory() path, being able to
> fail in a nice way rather than ignoring errors. Anyhow, this is good
> enough for now
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 

Thanks David.
