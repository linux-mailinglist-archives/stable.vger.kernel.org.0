Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F02CE949
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 09:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgLDINr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 03:13:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9948 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgLDINr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 03:13:47 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B482uvd189493;
        Fri, 4 Dec 2020 03:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ihxf7PJh5l3HHItoamPpTYGJI1jYXP30TqwIpz+HddI=;
 b=TYSRebq62M6AXo8D2v54bUslXHUqXnA5gP9UepZ5rvnQyGbTejZOJojdL4wgxyhju6tu
 WhO0GC5mokvq1G/PYqvYryEZHIUw76EcScnWPlogPdlgjXtdusb9gzkeF/8Jg5xPXOGp
 AiAdp4aQFjWpRz56924WESQSnTV9zzXeIdO6BpgXYEpTqTDXpY8ImA1GMTnzxW+ZWG/j
 d5LEauvPD1GLQ/BeDGuq9XDgWQ3o8wAhEWYPR3M1j1iw5KhiL/RZxNdhP5knsTjnU72S
 yS/3DIaRuESdxCtb9CTNNjpLi27GbvsaX5gS3tWffzp8HjdhAaTuZBbFg0UNCIkJYVgZ Tg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357742xc2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 03:12:46 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B48CC0p025047;
        Fri, 4 Dec 2020 08:12:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpdcta0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 08:12:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B48Cdba6029836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 08:12:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489AD4C046;
        Fri,  4 Dec 2020 08:12:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 021BE4C040;
        Fri,  4 Dec 2020 08:12:39 +0000 (GMT)
Received: from pomme.local (unknown [9.145.0.41])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 08:12:38 +0000 (GMT)
Subject: Re: [PATCH] powerpc/hotplug: assign hot added LMB to the right node
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>, stable@vger.kernel.org
References: <20201203101514.33591-1-ldufour@linux.ibm.com>
 <X8ktsoAv4/h+p1/8@kroah.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <0fbf1f3c-908e-34ee-637c-b29f15e9dea8@linux.ibm.com>
Date:   Fri, 4 Dec 2020 09:12:38 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X8ktsoAv4/h+p1/8@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_02:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1011 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040043
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 03/12/2020 à 19:25, Greg KH a écrit :
> On Thu, Dec 03, 2020 at 11:15:14AM +0100, Laurent Dufour wrote:
>> This patch applies to 5.9 and earlier kernels only.
>>
>> Since 5.10, this has been fortunately fixed by the commit
>> e5e179aa3a39 ("pseries/drmem: don't cache node id in drmem_lmb struct").
> 
> Why can't we just backport that patch instead?  It's almost always
> better to do that than to have a one-off patch, as almost always those
> have bugs in them.

That's a good option too.
I was thinking that this 5.10 patch was not matching the stable release's 
guidelines since it was targeting performance issue, but since it is also fixing 
this issue, I'm certainly wrong.

So, forget that patch.

Thanks,
Laurent.
