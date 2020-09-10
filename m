Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A631263F02
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 09:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgIJHv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 03:51:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15646 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgIJHvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 03:51:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A7WaWB136825;
        Thu, 10 Sep 2020 03:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RbcJ0PzvSOiW+pD31812fTs0gs8zqf2Skz8SZ6YGPak=;
 b=FexHUcTCvpN03VFnrNzEF5g7db+zViIJgWFfeOlFGn/axH2V/oTgk8M4q7KIXXA6btL5
 tDtjTeoyM/rx6zflvCbqyx/mrxZwu8qfiTZ0i0KtDCMsgUU2Gg6i5sgtiOW145B3hnqr
 MTY+uVFkhg3a3zBR4ybe6Iz+TGvfmmuqcd3Y28hhME4V0aFkH+GgA0/2jHWWYyYyLJtx
 bWpfUIlj7ZcnwG5aOp2XzwzvqMWlsnqfiB/XaEn4w/whF/tr1pTpGLoHyTCuB9G227j5
 79V9FEGLtbnsZJl1kdsQj2IN2ObxJpiPR71dmLI1+XTbwktqwz95tVutbnQEE92aiv2Q Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ffrb0n10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 03:51:45 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08A7Wg6R137507;
        Thu, 10 Sep 2020 03:51:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ffrb0n02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 03:51:44 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08A7m5Oc026276;
        Thu, 10 Sep 2020 07:51:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a85sk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 07:51:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08A7pdSM34472316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 07:51:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE490A4053;
        Thu, 10 Sep 2020 07:51:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47AC7A404D;
        Thu, 10 Sep 2020 07:51:39 +0000 (GMT)
Received: from pomme.local (unknown [9.145.147.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 07:51:39 +0000 (GMT)
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
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
Date:   Thu, 10 Sep 2020 09:51:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910072331.GB28354@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100065
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 10/09/2020 à 09:23, Michal Hocko a écrit :
> On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
>> Le 09/09/2020 à 12:59, Michal Hocko a écrit :
>>> On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
> [...]
>>>> For the point a, using the enum allows to know in
>>>> register_mem_sect_under_node() if the link operation is due to a hotplug
>>>> operation or done at boot time.
>>>
>>> Yes, but let me repeat. We have a mess here and different paths check
>>> for the very same condition by different ways. We need to unify those.
>>
>> What are you suggesting to unify these checks (using a MP_* enum as
>> suggested by David, something else)?
> 
> We do have system_state check spread at different places. I would use
> this one and wrap it behind a helper. Or have I missed any reason why
> that wouldn't work for this case?

That would not work in that case because memory can be hot-added at the 
SYSTEM_SCHEDULING system state and the regular memory is also registered at that 
system state too. So system state is not enough to discriminate between the both.

I think I'll go with the option suggested by David, replacing the enum 
memmap_context a new enum memplug_context and pass that context to 
register_mem_sect_under_node() so that function will known when node id should 
be checked or not.

Cheers,
Laurent.
