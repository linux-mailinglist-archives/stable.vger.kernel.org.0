Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2626BE79
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIPHrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:47:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgIPHri (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:47:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G7W8lP190604;
        Wed, 16 Sep 2020 03:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uxNCl8fFFusJ76v2vIytAowtk1X716+rWi0oOl4u+bw=;
 b=n76hj7KaNiOEAYfMSv3s+ih7Y75GZ+pj5lqi1Qg+tdnfZn+pjksN3TtMiXYuvvlNlhMQ
 LzIRF/hw0j2GL1o1yonC1TXbWHpw9OHvjzUhZtnQFd/5Yd78PRCSYx4FSWfXm3tl4s1N
 X70yNEwthH19GfaMHx+w9t15Q9Awv4NCw60EnHaM7gcy37XP6VbXaIdhDeK0xaXFA75q
 6+6iwhaRGR8Af1fnzkiisXoBUn70TwSMBI6u+H2MiiW9+UpyEDZ+ZMCWQOoyRGJnqQaA
 rP8wwBM23LiJtwfZgEdjbXAPZVqKnE0CfS5+KyawDUJbNEHKmb6o+BC4MOPiAgA7l5L7 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33kd95jasn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 03:47:25 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08G7WOjm191455;
        Wed, 16 Sep 2020 03:47:24 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33kd95jarc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 03:47:24 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08G7gx15010357;
        Wed, 16 Sep 2020 07:47:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 33k6esgcjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 07:47:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08G7lJdk24445202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 07:47:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28E7B11C05E;
        Wed, 16 Sep 2020 07:47:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958C811C050;
        Wed, 16 Sep 2020 07:47:18 +0000 (GMT)
Received: from pomme.local (unknown [9.145.183.110])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 07:47:18 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200915121541.GD4649@dhcp22.suse.cz>
 <20200915132624.9723-1-ldufour@linux.ibm.com>
 <20200916063325.GK142621@kroah.com>
 <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
 <20200916074047.GA189144@kroah.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <9e8d38b9-3875-0fd8-5f28-3502f33c2c34@linux.ibm.com>
Date:   Wed, 16 Sep 2020 09:47:18 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916074047.GA189144@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 mlxlogscore=536 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160051
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 16/09/2020 à 09:40, Greg Kroah-Hartman a écrit :
> On Wed, Sep 16, 2020 at 09:29:22AM +0200, Laurent Dufour wrote:
>> Le 16/09/2020 à 08:33, Greg Kroah-Hartman a écrit :
>>> On Tue, Sep 15, 2020 at 03:26:24PM +0200, Laurent Dufour wrote:
>>>> The memmap_context enum is used to detect whether a memory operation is due
>>>> to a hot-add operation or happening at boot time.
>>>>
>>>> Make it general to the hotplug operation and rename it as meminit_context.
>>>>
>>>> There is no functional change introduced by this patch
>>>>
>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>>>> ---
>>>>    arch/ia64/mm/init.c    |  6 +++---
>>>>    include/linux/mm.h     |  2 +-
>>>>    include/linux/mmzone.h | 11 ++++++++---
>>>>    mm/memory_hotplug.c    |  2 +-
>>>>    mm/page_alloc.c        | 10 +++++-----
>>>>    5 files changed, 18 insertions(+), 13 deletions(-)
>>>
>>> <formletter>
>>>
>>> This is not the correct way to submit patches for inclusion in the
>>> stable kernel tree.  Please read:
>>>       https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>> for how to do this properly.
>>>
>>> </formletter>
>>
>> Hi Greg,
>>
>> I'm sorry, I read that document few days ago before sending the series and
>> again this morning, but I can't figure out what I missed (following option
>> 1).
>>
>> Should the "Cc: stable@vger.kernel.org" tag be on each patch of the series
>> even if the whole series has been sent to stable ?
> 
> That should be on any patch you expect to show up in a stable kernel
> release.
> 
>> Should the whole series sent again (v4) instead of sending a fix as a reply to ?
> 
> It's up to the maintainer what they want, but as it is, this patch is
> not going to end up in stable kernel release (which it looks like is the
> right thing to do...)

Thanks a lot Greg.

I'll send that single patch again with the Cc: stable tag.

I don't think the patch 3 need to be backported, it doesn't fix any issue and 
with the patch 1 and 2 applied, the BUG_ON should no more be triggered easily.

Laurent.
