Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24C265495
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgIJV6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:58:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730206AbgIJLlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 07:41:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ABXV2H086899;
        Thu, 10 Sep 2020 07:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=43Zp61683vjVVWofNj/lwqGmm7TBNx9KEoiLeaHuiJw=;
 b=ni4zoTFNhK2odYrOepHEOrN5j8lxasAW9h6S2BQDJdSrLCw9welaMGLGGPVU1vDgEgq5
 G66NBANAHz4McE02a3cuF9JDroKS8fszer4zOmzwP7nHvj6cnFC/41nvWCaenKf6N+qA
 bh56XLkUEcChS6w/5e3ssZ1lbbv4JZ4wy/IolUY/fIUZGwT2XoAr1+CwQn31nnNCnMx/
 Xj8FnXLZag0C9blTpN73v7Lb0FQI9rNKEiPcdl4dB5y3IKfIViRzdQbS/uXNWdacfv6e
 kb/G+CsJQBdyConQPz0jm3sUIDkyYKC7vkFlaPXyGPgyfwZIyFJuuf6Lh+NWxCve0WXQ QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fh2hmyxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 07:35:39 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08ABY51c089423;
        Thu, 10 Sep 2020 07:35:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fh2hmywv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 07:35:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08ABRKxc002916;
        Thu, 10 Sep 2020 11:35:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33dxdr35jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:35:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08ABZXv036635092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 11:35:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA9DA4055;
        Thu, 10 Sep 2020 11:35:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B76CBA4051;
        Thu, 10 Sep 2020 11:35:32 +0000 (GMT)
Received: from pomme.local (unknown [9.145.147.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 11:35:32 +0000 (GMT)
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
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
Date:   Thu, 10 Sep 2020 13:35:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910111246.GE28354@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 10/09/2020 à 13:12, Michal Hocko a écrit :
> On Thu 10-09-20 09:51:39, Laurent Dufour wrote:
>> Le 10/09/2020 à 09:23, Michal Hocko a écrit :
>>> On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
>>>> Le 09/09/2020 à 12:59, Michal Hocko a écrit :
>>>>> On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
>>> [...]
>>>>>> For the point a, using the enum allows to know in
>>>>>> register_mem_sect_under_node() if the link operation is due to a hotplug
>>>>>> operation or done at boot time.
>>>>>
>>>>> Yes, but let me repeat. We have a mess here and different paths check
>>>>> for the very same condition by different ways. We need to unify those.
>>>>
>>>> What are you suggesting to unify these checks (using a MP_* enum as
>>>> suggested by David, something else)?
>>>
>>> We do have system_state check spread at different places. I would use
>>> this one and wrap it behind a helper. Or have I missed any reason why
>>> that wouldn't work for this case?
>>
>> That would not work in that case because memory can be hot-added at the
>> SYSTEM_SCHEDULING system state and the regular memory is also registered at
>> that system state too. So system state is not enough to discriminate between
>> the both.
> 
> If that is really the case all other places need a fix as well.
> Btw. could you be more specific about memory hotplug during early boot?
> How that happens? I am only aware of https://lkml.kernel.org/r/20200818110046.6664-1-osalvador@suse.de
> and that doesn't happen as early as SYSTEM_SCHEDULING.

That points has been raised by David, quoting him here:

> IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
> 
> Ccing Oscar, I think he mentioned recently that this is the case with ACPI.

Oscar told that he need to investigate further on that.

On my side I can't get these ACPI "early" hot-plug operations to happen so I 
can't check that.

If this is clear that ACPI memory hotplug doesn't happen at SYSTEM_SCHEDULING, 
the patch I proposed at first is enough to fix the issue.
