Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEAF26D5EA
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 10:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgIQIK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 04:10:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgIQIKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 04:10:52 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:10:50 EDT
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08H7XPUq001868;
        Thu, 17 Sep 2020 04:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=c+wPm6PVQRdyk+z4PFiSPi8wp98j19QEEf9sb83BFjk=;
 b=nBVP99ZFRQzuQiov4ujQnU9FTg6WmWr6Ojly8I/DvM9JU8WGxDeP/D+c6BeygSB97X8t
 5AVJS7t6+5LRGxK2RPm4Auvgv+BMjeqFc1vj9wGj1brTFkzoiowslOiT5ZJEjpcU/Vhz
 tGPIv+MkLf+clO/U7ikHnFvLYn2snJNHGYFNKda0iAiE5sZLEelzoONSgHl6bdjPLhND
 2AwGiKfRDiPHu0GRj1ldi52mC++VPY7GpGXgBZk45iCtGy0fRL4oGa8TanVXzs07OC/i
 z/S6xCQ/C2t9hmxpxVozVBxyK2zX3p3Cu6SXMpmt6pHZu8Ie0gBD6Mw9gQnixYoRhlP4 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m1he48fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 04:00:36 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08H7aOxA014022;
        Thu, 17 Sep 2020 04:00:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m1he48ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 04:00:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08H80XPR014957;
        Thu, 17 Sep 2020 08:00:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 33k6eshv03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:00:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08H80U6u28639676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 08:00:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BC2542081;
        Thu, 17 Sep 2020 08:00:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19BC64207B;
        Thu, 17 Sep 2020 08:00:27 +0000 (GMT)
Received: from pomme.local (unknown [9.145.22.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 08:00:27 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
 <9e8d38b9-3875-0fd8-5f28-3502f33c2c34@linux.ibm.com>
 <95005625-b159-0d49-8334-3c6cdbb7f27a@redhat.com>
 <f522bcb8-575e-0ac7-69cb-1064e8b38c58@linux.ibm.com>
 <20200916163756.af1bece4bbd1937a20a727df@linux-foundation.org>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <10f4239f-290e-8ae5-0bef-f583197fafec@linux.ibm.com>
Date:   Thu, 17 Sep 2020 10:00:26 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916163756.af1bece4bbd1937a20a727df@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_03:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=871 impostorscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170051
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 17/09/2020 à 01:37, Andrew Morton a écrit :
> On Wed, 16 Sep 2020 18:09:55 +0200 Laurent Dufour <ldufour@linux.ibm.com> wrote:
> 
>>>>> It's up to the maintainer what they want, but as it is, this patch is
>>>>> not going to end up in stable kernel release (which it looks like is the
>>>>> right thing to do...)
>>>>
>>>> Thanks a lot Greg.
>>>>
>>>> I'll send that single patch again with the Cc: stable tag.
>>>
>>> I think Andrew can add that when sending upstream.
>>
>> Andrew, can you do that?
>>
> 
> I did.
> 
> Patches 1 & 2 are cc:stable, patch 3 is not.
> 
> I'll queue up 1 & 2 for a 5.9-rcX merge.

Thanks a lot Andrew.

