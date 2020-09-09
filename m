Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC8B262A35
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIII0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 04:26:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgIII0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 04:26:23 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0897ptVr192920;
        Wed, 9 Sep 2020 04:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nGmJE+Q3jUIVh+I7T2pBvlLPJNJFPS09sV4wdLP0RQo=;
 b=VM+1Pctmd3zxpOEN6hCMAppWajsp75JE9NcibqIFiN9B1lzsrQjGtYrZkX1BH4kuPs8K
 EIo7k0bFeHnisJE8aZFe/fpBLn/Pz2o6ZGdSfYDrrXw7GcYOZ/c3DFNk7tNCV+LId3Eo
 /S+YqrD0OyIkO/ERxPPzJKnbgljS9ccL3+15pSKsFXvEp1n/5mGwMgtyxwC/GqmoXMyN
 e2FAa2QGIzyLPyQhRmwRQUfk9ks0QKxjjDVJ1eSSeLq762AUb5Nrtbr7K6Vi9yS+V8l4
 bjVv1+kOYDw0A5eMD7B//eyM0ZYlwOXMn0zoxunHscrKB5jSOJa0J6iyKRlwppbDC+Ak Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eu1p8xa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 04:26:10 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0897rcQe196331;
        Wed, 9 Sep 2020 04:26:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eu1p8x8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 04:26:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0898LobB016030;
        Wed, 9 Sep 2020 08:26:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a849b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 08:26:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0898Q5RN6422814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 08:26:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D15BC4C050;
        Wed,  9 Sep 2020 08:26:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 301504C04E;
        Wed,  9 Sep 2020 08:26:05 +0000 (GMT)
Received: from pomme.local (unknown [9.145.19.60])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 08:26:05 +0000 (GMT)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     David Hildenbrand <david@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, salvador@suse.de, rafael@kernel.org,
        nathanl@linux.ibm.com, mhocko@kernel.org, cheloha@linux.ibm.com,
        stable@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200908173113.GB218801@kroah.com>
 <cb05da3d-334b-4b72-88c1-f8ed6cfc91b7@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <7390116a-bfa9-9ad2-70fa-01be68035b7e@linux.ibm.com>
Date:   Wed, 9 Sep 2020 10:26:04 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cb05da3d-334b-4b72-88c1-f8ed6cfc91b7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_03:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 08/09/2020 à 19:40, David Hildenbrand a écrit :
> On 08.09.20 19:31, Greg Kroah-Hartman wrote:
>> On Tue, Sep 08, 2020 at 07:08:35PM +0200, Laurent Dufour wrote:
>>> In register_mem_sect_under_node() the system_state’s value is checked to
>>> detect whether the operation the call is made during boot time or during an
>>> hot-plug operation. Unfortunately, that check is wrong on some
>>> architecture, and may lead to sections being registered under multiple
>>> nodes if node's memory ranges are interleaved.
>>>
>>> This can be seen on PowerPC LPAR after multiple memory hot-plug and
>>> hot-unplug operations are done. At the next reboot the node's memory ranges
>>> can be interleaved and since the call to link_mem_sections() is made in
>>> topology_init() while the system is in the SYSTEM_SCHEDULING state, the
>>> node's id is not checked, and the sections registered multiple times. In
>>> that case, the system is able to boot but later hot-plug operation may lead
>>> to this panic because the node's links are correctly broken:
>>>
>>> ------------[ cut here ]------------
>>> kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
>>> Oops: Exception in kernel mode, sig: 5 [#1]
>>> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>>> Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
>>> CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
>>> NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
>>> REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
>>> MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
>>> CFAR: c000000000846d20 IRQMASK: 0
>>> GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
>>> GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
>>> GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
>>> GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
>>> GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
>>> GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
>>> GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
>>> GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
>>> NIP [c000000000403f34] add_memory_resource+0x244/0x340
>>> LR [c000000000403f2c] add_memory_resource+0x23c/0x340
>>> Call Trace:
>>> [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
>>> [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
>>> [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
>>> [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
>>> [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
>>> [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
>>> [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
>>> [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
>>> [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
>>> [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
>>> [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
>>> [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
>>> [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
>>> Instruction dump:
>>> 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
>>> 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
>>> ---[ end trace 562fd6c109cd0fb2 ]---
>>>
>>> This patch addresses the root cause by not relying on the system_state
>>> value to detect whether the call is due to a hot-plug operation or not. An
>>> additional parameter is added to link_mem_sections() to tell the context of
>>> the call and this parameter is propagated to register_mem_sect_under_node()
>>> throuugh the walk_memory_blocks()'s call.
>>>
>>> Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
>>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>>> Cc: stable@vger.kernel.org
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>   drivers/base/node.c  | 20 +++++++++++++++-----
>>>   include/linux/node.h |  6 +++---
>>>   mm/memory_hotplug.c  |  3 ++-
>>>   3 files changed, 20 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>>> index 508b80f6329b..27f828eeb531 100644
>>> --- a/drivers/base/node.c
>>> +++ b/drivers/base/node.c
>>> @@ -762,14 +762,19 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>>>   }
>>>   
>>>   /* register memory section under specified node if it spans that node */
>>> +struct rmsun_args {
>>> +	int	nid;
>>> +	bool	hotadd;
>>> +};
>>>   static int register_mem_sect_under_node(struct memory_block *mem_blk,
>>> -					 void *arg)
>>> +					void *args)
>>>   {
>>>   	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
>>>   	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
>>>   	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
>>> -	int ret, nid = *(int *)arg;
>>> +	int ret, nid = ((struct rmsun_args *)args)->nid;
>>>   	unsigned long pfn;
>>> +	bool hotadd = ((struct rmsun_args *)args)->hotadd;
>>>   
>>>   	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
>>>   		int page_nid;
>>> @@ -789,7 +794,7 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
>>>   		 * case, during hotplug we know that all pages in the memory
>>>   		 * block belong to the same node.
>>>   		 */
>>> -		if (system_state == SYSTEM_BOOTING) {
>>> +		if (!hotadd) {
>>>   			page_nid = get_nid_for_pfn(pfn);
>>>   			if (page_nid < 0)
>>>   				continue;
>>> @@ -832,10 +837,15 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
>>>   			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
>>>   }
>>>   
>>> -int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
>>> +int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
>>> +		      bool hotadd)
>>>   {
>>> +	struct rmsun_args args;
>>> +
>>> +	args.nid = nid;
>>> +	args.hotadd = hotadd;
>>>   	return walk_memory_blocks(PFN_PHYS(start_pfn),
>>> -				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
>>> +				  PFN_PHYS(end_pfn - start_pfn), (void *)&args,
>>>   				  register_mem_sect_under_node);
>>>   }
>>>   
>>> diff --git a/include/linux/node.h b/include/linux/node.h
>>> index 4866f32a02d8..6df9a4548650 100644
>>> --- a/include/linux/node.h
>>> +++ b/include/linux/node.h
>>> @@ -100,10 +100,10 @@ typedef  void (*node_registration_func_t)(struct node *);
>>>   
>>>   #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
>>>   extern int link_mem_sections(int nid, unsigned long start_pfn,
>>> -			     unsigned long end_pfn);
>>> +			     unsigned long end_pfn, bool hotadd);
>>>   #else
>>>   static inline int link_mem_sections(int nid, unsigned long start_pfn,
>>> -				    unsigned long end_pfn)
>>> +				    unsigned long end_pfn, bool hotadd)
>>
>> Adding a random boolean flag to a function is a horrible way to do
>> anything.
>>
>> Now you need to look up what that flag means every time you run across a
>> caller, breaking your reading of what is happening.
>>
>> Make this two different functions please, that describe what they do,
>> and have them call a common "helper function" that does the work with
>> the flag if you really want to do this type of thing.
>>
>> link_mem_sections() and link_mem_sections_hotadd()?
>>
>> But not this way, please no.
> 
> For memmap_init_zone() we solved it via an enum with MEMMAP_HOTPLUG vs
> MEMMAP_EARLY. Maybe we can generalize, because it tries to tackle
> roughly the same thing.

Thanks Dacid, I like this idea.

However, I think I'll not reuse the memmap_context enum, but introduce a new one 
specific to the link operation, to be more explicit, something like:

/*
  * When a hotplug operation is done, all pages in the memory block belong to the
  * same node, so there is no need to do such a check in that case.
  */
enum linkmem_context {
	LINKMEM_NO_CHECK_NODE_ID,
	LINKMEM_CHECK_NODE_ID,
}

I'm bad at naming so feel free to argue.

Cheers,
Laurent.

