Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C32632A0
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgIIQqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:46:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730625AbgIIQHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:07:40 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089G3U2S087988;
        Wed, 9 Sep 2020 12:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GOBHIxB9XcDj6VPq8bqibnaOg00HGwD0dSp/bZD1+iU=;
 b=YZG+Xk2caimXf8cWdV2JhkNnv1OIcGS9Ri+wVnq/kjIIBDbH7LqPQ4C5lllQojgIVgpI
 m8N07A1liTnByUtpB24HrydeQzQ8TtHZ8lZwf7QdyC0RiU/nyOi4ckFNYUJP4Smy/GHB
 amuIkV+UXRX0bLx6p6tCTuoMVAGMpeOozwc+7wA1gWR54nPuuJrNqR2P8IAtebZ+gsDW
 Bwtw5Zvxn0841fTJW3V2lgF6awOvv0I3DlTRiX76Z/q6Oy7pKWYf2w+jsaoDQtEChWHz
 Bi3RCreNNDjBI4H29kMnMmwq6y25NUg66s92Lmfvd8/Fg8zP821xsJB4QYQyl2aod17B 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33f1pgsbjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 12:07:22 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 089G3xFI089982;
        Wed, 9 Sep 2020 12:07:21 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33f1pgsbgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 12:07:21 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 089G264Y015712;
        Wed, 9 Sep 2020 16:07:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a84t13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 16:07:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 089G7Gor25559480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 16:07:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1574B4C040;
        Wed,  9 Sep 2020 16:07:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 608AB4C04A;
        Wed,  9 Sep 2020 16:07:15 +0000 (GMT)
Received: from pomme.local (unknown [9.145.19.60])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 16:07:15 +0000 (GMT)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     Michal Hocko <mhocko@suse.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <20200909105914.GF7348@dhcp22.suse.cz>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
Date:   Wed, 9 Sep 2020 18:07:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909105914.GF7348@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_09:2020-09-09,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090144
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 09/09/2020 à 12:59, Michal Hocko a écrit :
> On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
>> Le 09/09/2020 à 11:09, Michal Hocko a écrit :
>>> On Wed 09-09-20 09:48:59, Laurent Dufour wrote:
>>>> Le 09/09/2020 à 09:40, Michal Hocko a écrit :
> [...]
>>>>>> In
>>>>>> that case, the system is able to boot but later hot-plug operation may lead
>>>>>> to this panic because the node's links are correctly broken:
>>>>>
>>>>> Correctly broken? Could you provide more details on the inconsistency
>>>>> please?
>>>>
>>>> laurent@ltczep3-lp4:~$ ls -l /sys/devices/system/memory/memory21
>>>> total 0
>>>> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
>>>> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
>>>> -rw-r--r-- 1 root root 65536 Aug 24 05:27 online
>>>> -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
>>>> -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
>>>> drwxr-xr-x 2 root root     0 Aug 24 05:27 power
>>>> -r--r--r-- 1 root root 65536 Aug 24 05:27 removable
>>>> -rw-r--r-- 1 root root 65536 Aug 24 05:27 state
>>>> lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
>>>> -rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
>>>> -r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones
>>>
>>> OK, so there are two nodes referenced here. Not terrible from the user
>>> point of view. Such a memory block will refuse to offline or online
>>> IIRC.
>>
>> No the memory block is still owned by one node, only the sysfs
>> representation is wrong. So the memory block can be hot unplugged, but only
>> one node's link will be cleaned, and a '/syss/devices/system/node#/memory21'
>> link will remain and that will be detected later when that memory block is
>> hot plugged again.
> 
> OK, so you need to hotremove first and hotadd again to trigger the
> problem. It is not like you would be a hot adding something new. This is
> a useful information to have in the changelog.
> 
>>>>> Which physical memory range you are trying to add here and what is the
>>>>> node affinity?
>>>>
>>>> None is added, the root cause of the issue is happening at boot time.
>>>
>>> Let me clarify my question. The crash has clearly happened during the
>>> hotplug add_memory_resource - which is clearly not a boot time path.
>>> I was askin for more information about why this has failed. It is quite
>>> clear that sysfs machinery has failed and that led to BUG_ON but we are
>>> mising an information on why. What was the physical memory range to be
>>> added and why sysfs failed?
>>
>> The BUG_ON is detecting a bad state generated earlier, at boot time because
>> register_mem_sect_under_node() didn't check for the block's node id.
>>
>>>>>> ------------[ cut here ]------------
>>>>>> kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
>>>>>> Oops: Exception in kernel mode, sig: 5 [#1]
>>>>>> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>>>>>> Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
>>>>>> CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
>>>>>> NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
>>>>>> REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
>>>>>> MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
>>>>>> CFAR: c000000000846d20 IRQMASK: 0
>>>>>> GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
>>>>>> GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
>>>>>> GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
>>>>>> GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
>>>>>> GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
>>>>>> GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
>>>>>> GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
>>>>>> GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
>>>>>> NIP [c000000000403f34] add_memory_resource+0x244/0x340
>>>>>> LR [c000000000403f2c] add_memory_resource+0x23c/0x340
>>>>>> Call Trace:
>>>>>> [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
>>>>>> [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
>>>>>> [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
>>>>>> [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
>>>>>> [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
>>>>>> [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
>>>>>> [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
>>>>>> [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
>>>>>> [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
>>>>>> [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
>>>>>> [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
>>>>>> [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
>>>>>> [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
>>>>>> Instruction dump:
>>>>>> 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
>>>>>> 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
>>>>>> ---[ end trace 562fd6c109cd0fb2 ]---
>>>>>
>>>>> The BUG_ON on failure is absolutely horrendous. There must be a better
>>>>> way to handle a failure like that. The failure means that
>>>>> sysfs_create_link_nowarn has failed. Please describe why that is the
>>>>> case.
>>>>>
>>>>>> This patch addresses the root cause by not relying on the system_state
>>>>>> value to detect whether the call is due to a hot-plug operation or not. An
>>>>>> additional parameter is added to link_mem_sections() to tell the context of
>>>>>> the call and this parameter is propagated to register_mem_sect_under_node()
>>>>>> throuugh the walk_memory_blocks()'s call.
>>>>>
>>>>> This looks like a hack to me and it deserves a better explanation. The
>>>>> existing code is a hack on its own and it is inconsistent with other
>>>>> boot time detection. We are using (system_state < SYSTEM_RUNNING) at other
>>>>> places IIRC. Would it help to use the same here as well? Maybe we want to
>>>>> wrap that inside a helper (early_memory_init()) and use it at all
>>>>> places.
>>>>
>>>> I agree, this looks like a hack to check for the system_state value.
>>>> I'll follow the David's proposal and introduce an enum detailing when the
>>>> node id check has to be done or not.
>>>
>>> I am not sure an enum is going to make the existing situation less
>>> messy. Sure we somehow have to distinguish boot init and runtime hotplug
>>> because they have different constrains. I am arguing that a) we should
>>> have a consistent way to check for those and b) we shouldn't blow up
>>> easily just because sysfs infrastructure has failed to initialize.
>>
>> For the point a, using the enum allows to know in
>> register_mem_sect_under_node() if the link operation is due to a hotplug
>> operation or done at boot time.
> 
> Yes, but let me repeat. We have a mess here and different paths check
> for the very same condition by different ways. We need to unify those.

What are you suggesting to unify these checks (using a MP_* enum as suggested by 
David, something else)?

> 
>> For the point b, one option would be ignore the link error in the case the
>> link is already existing, but that BUG_ON() had the benefit to highlight the
>> root issue.
> 
> Yes BUG_ON is obviously an over-reaction. The system is not in a state
> to die anytime soon.
> 

