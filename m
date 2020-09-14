Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A02686CF
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgINIHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 04:07:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbgINIGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 04:06:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E82UVB126756;
        Mon, 14 Sep 2020 04:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8VHprOE+sZ5q+468Y3OH+jcXd4un/m1SsYeXLjSOnqs=;
 b=V/LvZyDg9N6nVZNjigFLDOQBAxL2zKJOzxbuIhDzr1ezhTWADrH2JkCTPS6cIIscdNKh
 lDMp9VJmiRjR/3jVY0ADyxZ+Om6X5DRr8QGHm9Nj9yc3OVwf8FeqI0XeeaH0MiL6sQJZ
 WXa67rL3yY3DzpNXCmsOWlzfr3VvMUkeP8e98SIOg2WWpWsYT/dC6Fl/rB6E5pA5EHcf
 /cZllweBI64e/NiX66IRcG8Apc9GvVnRo3wiGhVsNKPhUbb4a1m03gEfJDAT8R2RWKRw
 i+YN0/iTqvFLXG3TUAUGfU/ItnSta+vGEIxjz8DBajYtdPonCr0ndM5h6w1ka8FBlefy cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j3g5a7hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:06:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E82wZ0129160;
        Mon, 14 Sep 2020 04:06:02 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j3g5a7gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:06:02 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E7v2Ee014369;
        Mon, 14 Sep 2020 08:05:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 33hb1j12pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 08:05:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E85vxS13959534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 08:05:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB2D11C064;
        Mon, 14 Sep 2020 08:05:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3965011C052;
        Mon, 14 Sep 2020 08:05:56 +0000 (GMT)
Received: from pomme.local (unknown [9.145.51.157])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 08:05:56 +0000 (GMT)
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
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
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
 <20200911134831.53258-3-ldufour@linux.ibm.com>
 <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <23a4495b-a8ef-e2f2-ba4a-1d27f7d45e0a@linux.ibm.com>
Date:   Mon, 14 Sep 2020 10:05:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140062
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/09/2020 à 09:57, David Hildenbrand a écrit :
> On 11.09.20 15:48, Laurent Dufour wrote:
>> In register_mem_sect_under_node() the system_state’s value is checked to
>> detect whether the operation the call is made during boot time or during an
>> hot-plug operation. Unfortunately, that check against SYSTEM_BOOTING is
>> wrong because regular memory is registered at SYSTEM_SCHEDULING state. In
>> addition memory hot-plug operation can be triggered at this system state
>> too by the ACPI. So checking against the system state is not enough.
>>
>> The consequence is that on system with interleaved node's ranges like this:
>>   Early memory node ranges
>>     node   1: [mem 0x0000000000000000-0x000000011fffffff]
>>     node   2: [mem 0x0000000120000000-0x000000014fffffff]
>>     node   1: [mem 0x0000000150000000-0x00000001ffffffff]
>>     node   0: [mem 0x0000000200000000-0x000000048fffffff]
>>     node   2: [mem 0x0000000490000000-0x00000007ffffffff]
>>
>> This can be seen on PowerPC LPAR after multiple memory hot-plug and
>> hot-unplug operations are done. At the next reboot the node's memory ranges
>> can be interleaved and since the call to link_mem_sections() is made in
>> topology_init() while the system is in the SYSTEM_SCHEDULING state, the
>> node's id is not checked, and the sections registered to multiple nodes:
>>
>> $ ls -l /sys/devices/system/memory/memory21/node*
>> total 0
>> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
>> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
>>
>> In that case, the system is able to boot but if later one of theses memory
>> block is hot-unplugged and then hot-plugged, the sysfs inconsistency is
>> detected and triggered a BUG_ON():
>>
>> ------------[ cut here ]------------
>> kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
>> Oops: Exception in kernel mode, sig: 5 [#1]
>> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>> Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
>> CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
>> NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
>> REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
>> MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
>> CFAR: c000000000846d20 IRQMASK: 0
>> GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
>> GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
>> GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
>> GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
>> GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
>> GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
>> GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
>> GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
>> NIP [c000000000403f34] add_memory_resource+0x244/0x340
>> LR [c000000000403f2c] add_memory_resource+0x23c/0x340
>> Call Trace:
>> [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
>> [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
>> [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
>> [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
>> [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
>> [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
>> [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
>> [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
>> [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
>> [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
>> [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
>> [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
>> [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
>> Instruction dump:
>> 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
>> 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
>> ---[ end trace 562fd6c109cd0fb2 ]---
>>
>> This patch addresses the root cause by not relying on the system_state
>> value to detect whether the call is due to a hot-plug operation. An extra
>> parameter is needed in register_mem_sect_under_node() detailing whether the
>> operation is due to a hot-plug operation.
>>
>> Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>> Cc: stable@vger.kernel.org
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> ---
>>   drivers/base/node.c  | 21 ++++++++++++++++-----
>>   include/linux/node.h |  9 ++++++---
>>   mm/memory_hotplug.c  |  3 ++-
>>   3 files changed, 24 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 508b80f6329b..862516c5a5ae 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -762,14 +762,19 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>>   }
>>   
>>   /* register memory section under specified node if it spans that node */
>> +struct rmsun_args {
>> +	int nid;
>> +	enum memplug_context context;
>> +};
>>   static int register_mem_sect_under_node(struct memory_block *mem_blk,
>> -					 void *arg)
>> +					void *args)
>>   {
> 
> Instead of handling this in register_mem_sect_under_node(), I
> think it would be better two have two separate
> register_mem_sect_under_node() implementations.
> 
> static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
> 						void *arg)
> {
> 	const int nid = *(int *)arg;
> 	int ret;
> 
> 	/* Hotplugged memory has no holes and belongs to a single node. */
> 	mem_blk->nid = nid;
> 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> 				       &mem_blk->dev.kobj,
> 				       kobject_name(&mem_blk->dev.kobj));
> 	if (ret)
> 		returnr et;
> 	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> 					&node_devices[nid]->dev.kobj,
> 					kobject_name(&node_devices[nid]->dev.kobj));
> 
> }
> 
> Cleaner, right? :) No unnecessary checks.

Cela me laisse perplexe. Dans un sens, cela simplifie le patch, mais cela 
revient à dupliquer le code pour ne supprimer qu'une seule vérification.

I'm fine with the both options, Ijust want to be sure that all agree on the 
direction before changing my series in that way.

> 
> One could argue if link_mem_section_hotplug() would be better than passing around the context.
>

I do ;)

