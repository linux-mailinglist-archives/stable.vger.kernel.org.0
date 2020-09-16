Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7F26BDF8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIPH3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:29:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28776 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgIPH3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:29:40 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G6Whgp191066;
        Wed, 16 Sep 2020 03:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AWZZJFJRXFs7fou2XZXqNHA6HWBjC2PWD4vfkVc54/Y=;
 b=V5U9ZDb5RgrjTzJ4py/zbwCzG57C+CZnOKGT6U1l7n6rILSVSwQQpNNWvwnDIP3MyAXB
 2LQGaaotTGpArlCXOSPAp30VZxe5ifTS8wDjL++pXdUXLAYNBtkMr79rsmbw1p0DOEHZ
 x9CY5+bkTEdSLNheBSWIEuGuuImtkQpb3hTkm+0n/4XbHFs/M/JZuhRSLAjUeGQ3s2oO
 xTMYDKTyFuVkf7mNkPh5iG3lFhwmjZ+fHWpp22YVFU6lSUxL+l5+PKWRQjW4QXaMvuRw
 WxYxF9Mfn2EerUtLpz/b68kunw8NqvvANkb4AlVyaURGK9GYawuJOgyMS9VNF6EjxgL1 hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33kc2t3r0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 03:29:29 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08G6ZEi5002492;
        Wed, 16 Sep 2020 03:29:28 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33kc2t3qyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 03:29:28 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08G76v34000817;
        Wed, 16 Sep 2020 07:29:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 33k5u7r6s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 07:29:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08G7TNjO20644226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 07:29:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D58211C052;
        Wed, 16 Sep 2020 07:29:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60EA111C050;
        Wed, 16 Sep 2020 07:29:22 +0000 (GMT)
Received: from pomme.local (unknown [9.145.183.110])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 07:29:22 +0000 (GMT)
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
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
Date:   Wed, 16 Sep 2020 09:29:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916063325.GK142621@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=627
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160047
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 16/09/2020 à 08:33, Greg Kroah-Hartman a écrit :
> On Tue, Sep 15, 2020 at 03:26:24PM +0200, Laurent Dufour wrote:
>> The memmap_context enum is used to detect whether a memory operation is due
>> to a hot-add operation or happening at boot time.
>>
>> Make it general to the hotplug operation and rename it as meminit_context.
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
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Hi Greg,

I'm sorry, I read that document few days ago before sending the series and again 
this morning, but I can't figure out what I missed (following option 1).

Should the "Cc: stable@vger.kernel.org" tag be on each patch of the series even 
if the whole series has been sent to stable ?

Should the whole series sent again (v4) instead of sending a fix as a reply to ?

Thanks,
Laurent.
