Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A129BE4D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794630AbgJ0PMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:12:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1794621AbgJ0PMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 11:12:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09REZV0n098559;
        Tue, 27 Oct 2020 11:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GMLRsOdCDoX/kC78OdhJ1CqY/NXnydiSxvQbzaJZPjg=;
 b=m3mjwxmrmnkuEW8NzCmSmHjJ8uDQjY+xS8EwpDT9h9mqd9BlGBgAmTm1lqGWygTXfbd5
 Lb6sKu3bj51XZtOTxCfKv8mKIDjq2vNAt1iYLm4yea59Y7OfenbIohwGIHfUOZ1rIeAr
 JBu0zXsalHMJbMSpueb6GrEcDVdvysahbNz6Ke3Ur1maYqCdlMK+21+wIZexK6/yw3Y7
 KflLuFHDXtstIdHUa1VNHpSGWboo15ZDYlMWTF9ZD0oXXQ15ZTIkDRzaljAPlTGiXNOn
 ZHuK9kIp+umMiYspxiXi28gJiZJSgYgqnq6poQf4nuYdSYrs1307SKYYcO2yALzXiNN7 sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34e4jwdjd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 11:12:29 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09RErLcb008312;
        Tue, 27 Oct 2020 11:12:29 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34e4jwdjbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 11:12:29 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RF8VSl004296;
        Tue, 27 Oct 2020 15:12:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 34ejqe83au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 15:12:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RFCNcL34734362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 15:12:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C7224203F;
        Tue, 27 Oct 2020 15:12:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B0C42045;
        Tue, 27 Oct 2020 15:12:22 +0000 (GMT)
Received: from pomme.local (unknown [9.145.20.129])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 15:12:22 +0000 (GMT)
Subject: Re: [PATCH] mm/slub: fix panic in slab_alloc_node()
To:     Michal Hocko <mhocko@suse.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
References: <20201027140926.276-1-ldufour@linux.ibm.com>
 <20201027142421.GW20500@dhcp22.suse.cz>
 <11bdd295-3ef8-fbeb-2c76-2a109fa26f19@linux.ibm.com>
 <20201027150350.GZ20500@dhcp22.suse.cz>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <e2cea72f-d8fa-0ac7-e48d-63cc41414ed2@linux.ibm.com>
Date:   Tue, 27 Oct 2020 16:12:22 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027150350.GZ20500@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_08:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 27/10/2020 à 16:03, Michal Hocko a écrit :
> On Tue 27-10-20 15:39:46, Laurent Dufour wrote:
>> Le 27/10/2020 à 15:24, Michal Hocko a écrit :
>>> [Cc Vlastimil]
>>>
>>> On Tue 27-10-20 15:09:26, Laurent Dufour wrote:
>>>> While doing memory hot-unplug operation on a PowerPC VM running 1024 CPUs
>>>> with 11TB of ram, I hit the following panic:
>>>>
>>>> BUG: Kernel NULL pointer dereference on read at 0x00000007
>>>> Faulting instruction address: 0xc000000000456048
>>>> Oops: Kernel access of bad area, sig: 11 [#2]
>>>> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>>>> Modules linked in: rpadlpar_io rpaphp
>>>> CPU: 160 PID: 1 Comm: systemd Tainted: G      D           5.9.0 #1
>>>> NIP:  c000000000456048 LR: c000000000455fd4 CTR: c00000000047b350
>>>> REGS: c00006028d1b77a0 TRAP: 0300   Tainted: G      D            (5.9.0)
>>>> MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24004228  XER: 00000000
>>>> CFAR: c00000000000f1b0 DAR: 0000000000000007 DSISR: 40000000 IRQMASK: 0
>>>> GPR00: c000000000455fd4 c00006028d1b7a30 c000000001bec800 0000000000000000
>>>> GPR04: 0000000000000dc0 0000000000000000 00000000000374ef c00007c53df99320
>>>> GPR08: 000007c53c980000 0000000000000000 000007c53c980000 0000000000000000
>>>> GPR12: 0000000000004400 c00000001e8e4400 0000000000000000 0000000000000f6a
>>>> GPR16: 0000000000000000 c000000001c25930 c000000001d62528 00000000000000c1
>>>> GPR20: c000000001d62538 c00006be469e9000 0000000fffffffe0 c0000000003c0ff8
>>>> GPR24: 0000000000000018 0000000000000000 0000000000000dc0 0000000000000000
>>>> GPR28: c00007c513755700 c000000001c236a4 c00007bc4001f800 0000000000000001
>>>> NIP [c000000000456048] __kmalloc_node+0x108/0x790
>>>> LR [c000000000455fd4] __kmalloc_node+0x94/0x790
>>>> Call Trace:
>>>> [c00006028d1b7a30] [c00007c51af92000] 0xc00007c51af92000 (unreliable)
>>>> [c00006028d1b7aa0] [c0000000003c0ff8] kvmalloc_node+0x58/0x110
>>>> [c00006028d1b7ae0] [c00000000047b45c] mem_cgroup_css_online+0x10c/0x270
>>>> [c00006028d1b7b30] [c000000000241fd8] online_css+0x48/0xd0
>>>> [c00006028d1b7b60] [c00000000024af14] cgroup_apply_control_enable+0x2c4/0x470
>>>> [c00006028d1b7c40] [c00000000024e838] cgroup_mkdir+0x408/0x5f0
>>>> [c00006028d1b7cb0] [c0000000005a4ef0] kernfs_iop_mkdir+0x90/0x100
>>>> [c00006028d1b7cf0] [c0000000004b8168] vfs_mkdir+0x138/0x250
>>>> [c00006028d1b7d40] [c0000000004baf04] do_mkdirat+0x154/0x1c0
>>>> [c00006028d1b7dc0] [c000000000032b38] system_call_exception+0xf8/0x200
>>>> [c00006028d1b7e20] [c00000000000c740] system_call_common+0xf0/0x27c
>>>> Instruction dump:
>>>> e93e0000 e90d0030 39290008 7cc9402a e94d0030 e93e0000 7ce95214 7f89502a
>>>> 2fbc0000 419e0018 41920230 e9270010 <89290007> 7f994800 419e0220 7ee6bb78
>>>>
>>>> This pointing to the following code:
>>>>
>>>> mm/slub.c:2851
>>>>           if (unlikely(!object || !node_match(page, node))) {
>>>> c000000000456038:       00 00 bc 2f     cmpdi   cr7,r28,0
>>>> c00000000045603c:       18 00 9e 41     beq     cr7,c000000000456054 <__kmalloc_node+0x114>
>>>> node_match():
>>>> mm/slub.c:2491
>>>>           if (node != NUMA_NO_NODE && page_to_nid(page) != node)
>>>> c000000000456040:       30 02 92 41     beq     cr4,c000000000456270 <__kmalloc_node+0x330>
>>>> page_to_nid():
>>>> include/linux/mm.h:1294
>>>> c000000000456044:       10 00 27 e9     ld      r9,16(r7)
>>>> c000000000456048:       07 00 29 89     lbz     r9,7(r9)	<<<< r9 = NULL
>>>> node_match():
>>>> mm/slub.c:2491
>>>> c00000000045604c:       00 48 99 7f     cmpw    cr7,r25,r9
>>>> c000000000456050:       20 02 9e 41     beq     cr7,c000000000456270 <__kmalloc_node+0x330>
>>>>
>>>> The panic occurred in slab_alloc_node() when checking for the page's node:
>>>> 	object = c->freelist;
>>>> 	page = c->page;
>>>> 	if (unlikely(!object || !node_match(page, node))) {
>>>> 		object = __slab_alloc(s, gfpflags, node, addr, c);
>>>> 		stat(s, ALLOC_SLOWPATH);
>>>>
>>>> The issue is that object is not NULL while page is NULL which is odd but
>>>> may happen if the cache flush happened after loading object but before
>>>> loading page. Thus checking for the page pointer is required too.
>>>
>>> Could you be more specific? I am especially confused how the memory
>>> hotplug is involved here. What kind of flush are we talking about?
>>
>> This happens when flush_cpu_slab() is called when a memory block is about to
>> be offlined, see slab_mem_going_offline_callback() called by the
>> MEM_GOING_OFFLINE's callback triggered by offline_pages().
> 
> This would be a very valuable information for the changelog. I have to
> admit that a more detailed description would help somebody not really
> familiar with slub internals like me.
> 
> I still fail to see why do we get an inconsistent state though. I
> thought that no object is associated with an offlined page so how come
> we have an object without any page?

The inconsistent state came from the IPI interrupt calling flush_cpu_slab() 
being taken between reading c->freelist and c->page.

> How does this allocation path synchronizes with the offline callback?

My understanding is that this is done by the call to this_cpu_cmpxchg_double() 
done later, but I would let the slub experts detail that point.

>>>> In commit 6159d0f5c03e ("mm/slub.c: page is always non-NULL in
>>>> node_match()") check on the page pointer has been removed assuming that
>>>> page is always valid when it is called. It happens that this is not true in
>>>> that particular case, so check for page before calling node_match() here.
>>>>
>>>> Fixes: 6159d0f5c03e ("mm/slub.c: page is always non-NULL in node_match()")
>>>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>>>> Cc: Christoph Lameter <cl@linux.com>
>>>> Cc: Pekka Enberg <penberg@kernel.org>
>>>> Cc: David Rientjes <rientjes@google.com>
>>>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>    mm/slub.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index 8f66de8a5ab3..7dc5c6aaf4b7 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -2852,7 +2852,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
>>>>    	object = c->freelist;
>>>>    	page = c->page;
>>>> -	if (unlikely(!object || !node_match(page, node))) {
>>>> +	if (unlikely(!object || !page || !node_match(page, node))) {
>>>>    		object = __slab_alloc(s, gfpflags, node, addr, c);
>>>>    	} else {
>>>>    		void *next_object = get_freepointer_safe(s, object);
>>>> -- 
>>>> 2.29.1
>>>>
>>>
>>
> 

