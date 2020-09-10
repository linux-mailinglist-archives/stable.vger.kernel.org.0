Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB89F265444
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgIJVm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:42:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730721AbgIJMgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 08:36:39 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ACYDIl114198;
        Thu, 10 Sep 2020 08:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sQqwNB9aQZ1XQyGz9kL/GvbT3cTdxoo0tE3M4hWRyTk=;
 b=gNZW2iaWr136xIN5wF5WmoqxLAzCPc1UJyXXPCEBTSD8JfjufOI5HHd3uFg/oByc0Q6r
 DDrGUAaXa9coXfaVo4u2RkjpZ5rY6Uup6Y+Kj52BISq5ZsFH/sIWV7qtOvkr6bPTTwql
 Qixo89IylV1RNBKu9/sHP2snHLQ+QieqEX2fRIFEWu689cpu+C1Hd6I+IXmqx4hDfe9P
 1+C3SH1CawkhfSo3rHtCZkEGlP6l0/u4HFHBhNkuUYGWvloRETEuIxmZ5CPlT57hMBCk
 NM8f44200OUbcYyVjBAFfTyBFhUS+uAQt5Vnzs02a2GaUDZ8GK/YKHondO/o5l27kWDF ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fjcwuu6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 08:36:25 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08ACaOqm125977;
        Thu, 10 Sep 2020 08:36:24 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fjcwuu1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 08:36:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08ACWgZp007008;
        Thu, 10 Sep 2020 12:36:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8e1s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:36:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08ACaEJT30802414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 12:36:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08D66A404D;
        Thu, 10 Sep 2020 12:36:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B647A4053;
        Thu, 10 Sep 2020 12:36:13 +0000 (GMT)
Received: from pomme.local (unknown [9.145.147.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 12:36:13 +0000 (GMT)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>
Cc:     akpm@linux-foundation.org, Oscar Salvador <osalvador@suse.de>,
        rafael@kernel.org, nathanl@linux.ibm.com, cheloha@linux.ibm.com,
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
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
 <65b2680d-b02e-16c9-66a4-e38b9d3fa52b@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <ac9d3ea9-3735-8d38-e2d3-4eb69d5471b1@linux.ibm.com>
Date:   Thu, 10 Sep 2020 14:36:13 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <65b2680d-b02e-16c9-66a4-e38b9d3fa52b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 10/09/2020 à 14:00, David Hildenbrand a écrit :
> On 10.09.20 13:35, Laurent Dufour wrote:
>> Le 10/09/2020 à 13:12, Michal Hocko a écrit :
>>> On Thu 10-09-20 09:51:39, Laurent Dufour wrote:
>>>> Le 10/09/2020 à 09:23, Michal Hocko a écrit :
>>>>> On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
>>>>>> Le 09/09/2020 à 12:59, Michal Hocko a écrit :
>>>>>>> On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
>>>>> [...]
>>>>>>>> For the point a, using the enum allows to know in
>>>>>>>> register_mem_sect_under_node() if the link operation is due to a hotplug
>>>>>>>> operation or done at boot time.
>>>>>>>
>>>>>>> Yes, but let me repeat. We have a mess here and different paths check
>>>>>>> for the very same condition by different ways. We need to unify those.
>>>>>>
>>>>>> What are you suggesting to unify these checks (using a MP_* enum as
>>>>>> suggested by David, something else)?
>>>>>
>>>>> We do have system_state check spread at different places. I would use
>>>>> this one and wrap it behind a helper. Or have I missed any reason why
>>>>> that wouldn't work for this case?
>>>>
>>>> That would not work in that case because memory can be hot-added at the
>>>> SYSTEM_SCHEDULING system state and the regular memory is also registered at
>>>> that system state too. So system state is not enough to discriminate between
>>>> the both.
>>>
>>> If that is really the case all other places need a fix as well.
>>> Btw. could you be more specific about memory hotplug during early boot?
>>> How that happens? I am only aware of https://lkml.kernel.org/r/20200818110046.6664-1-osalvador@suse.de
>>> and that doesn't happen as early as SYSTEM_SCHEDULING.
>>
>> That points has been raised by David, quoting him here:
>>
>>> IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
>>>
>>> Ccing Oscar, I think he mentioned recently that this is the case with ACPI.
>>
>> Oscar told that he need to investigate further on that.
>>
>> On my side I can't get these ACPI "early" hot-plug operations to happen so I
>> can't check that.
>>
>> If this is clear that ACPI memory hotplug doesn't happen at SYSTEM_SCHEDULING,
>> the patch I proposed at first is enough to fix the issue.
>>
> 
> Booting a qemu guest with 4 coldplugged DIMMs gives me:
> 
> :/root# dmesg | grep link_mem
> [    0.302247] link_mem_sections() during 1
> [    0.445086] link_mem_sections() during 1
> [    0.445766] link_mem_sections() during 1
> [    0.446749] link_mem_sections() during 1
> [    0.447746] link_mem_sections() during 1
> 
> So AFAICs everything happens during SYSTEM_SCHEDULING - boot memory and
> ACPI (cold)plug.
> 
> To make forward progress with this, relying on the system_state is
> obviously not sufficient.
> 
> 1. We have to fix this instance and the instance directly in
> get_nid_for_pfn() by passing in the context (I once had a patch to clean
> that up, to not have two state checks, but it got lost somewhere).
> 
> 2. The "system_state < SYSTEM_RUNNING" check in
> register_memory_resource() is correct. Actual memory hotplug after boot
> is not impacted. (I remember we discussed this exact behavior back then)
> 
> 3. build_all_zonelists() should work as expected, called from
> start_kernel() before sched_init().

I'm bit confused now.
Since hotplug operation is happening at SYSTEM_SCHEDULING like the regular 
memory registration, would it be enough to add a parameter to 
register_mem_sect_under_node() (reworking the memmap_context enum)?
That way the check is not based on the system state but on the calling path.
