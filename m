Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861027D39C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 18:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgI2Q3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 12:29:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55892 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728273AbgI2Q3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 12:29:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG3bfM187415;
        Tue, 29 Sep 2020 12:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mhbL9cAGq0e2Mae+zrDCOrv685gHuymKN9fGJq7z/tU=;
 b=WDvhU1dshjPQfYeKMj6NtytK4zc/w5+pVTPDH+9tJVtqz0BeLHZ/SL/luYeNISMRbuOT
 j3PsGa2diSBryAoB3ByJkSnb0RgyC9pktfa3gtlScycT6ZKm0KRBBw7pwkFtK+vQvFtx
 nnF3Lx6B9z/FkdnhabdyYWi6ebkNGQrr3j2lT7GuZ475KAaWS4Md/uhWwAdDeS0a24zW
 OD2UcKeXbyHfu/bVxzv34rl60tBb0R99iq3NK5c3+/EJ/ju3GzDkDgNz4NU3ryprCsi8
 T+5Hf7LJuFL+i0w7SwBg1RKf7TKZfKTocFg5GG/E/NSo5P+UqxfLbBFG2IOaSWJM6hv3 wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v7cpak9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:28:57 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TG4Brb190966;
        Tue, 29 Sep 2020 12:28:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v7cpak8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:28:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TGSGiQ025185;
        Tue, 29 Sep 2020 16:28:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33v6mgr3w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 16:28:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TGSqNe30147032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 16:28:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E98B342045;
        Tue, 29 Sep 2020 16:28:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6515042042;
        Tue, 29 Sep 2020 16:28:51 +0000 (GMT)
Received: from pomme.local (unknown [9.145.50.8])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 16:28:51 +0000 (GMT)
Subject: Re: [patch 8/9] mm: replace memmap_context by meminit_context
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     cheloha@linux.ibm.com, David Hildenbrand <david@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com,
        Oscar Salvador <osalvador@suse.de>,
        Rafael Wysocki <rafael@kernel.org>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
 <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
 <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <6300fe4c-d54e-8f99-ccf8-216f15cde4fb@linux.ibm.com>
Date:   Tue, 29 Sep 2020 18:28:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_10:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 mlxscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290136
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 26/09/2020 à 19:32, Linus Torvalds a écrit :
> The explanations here do not make sense.
> 
> On Fri, Sep 25, 2020 at 9:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>
>> There are 2 issues here:
>>
>> a. The sysfs memory and node's layouts are broken due to these multiple
>>     links
>>
>> b. The link errors in link_mem_sections() should not lead to a system
>>     panic.
>>
>> To address a. register_mem_sect_under_node should not rely on the system
>> state to detect whether the link operation is triggered by a hot plug
>> operation or not. This is addressed by the patches 1 and 2 of this series.
>>
>> The patch 3 is addressing the point b.
>>
>> This patch (of 2):
>>
>> The memmap_context enum is used to detect whether a memory operation is due
>> to a hot-add operation or happening at boot time.
>>
>> Make it general to the hotplug operation and rename it as meminit_context.
>>
>> There is no functional change introduced by this patch
> 
> So far so good.
> 
> But there is no "patch 3" that addresses point (b) in this series.
> 
> I see it on lore, but it's not part of what actually got sent to me,
> so the commit message for patch 1 now makes no sense any more.

I agree, the commit description is a bit confusing now.
I think the Andrew's idea was to queue up the 2 first patches which are 
cc:stable to the 5.9-rcX and later the third one which is not really fixing an 
issue. The BUG_ON is unlikely to be triggered once the 2 first patches are applied.

Thanks,
Laurent.
