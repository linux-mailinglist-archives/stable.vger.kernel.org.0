Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E8F2DA0D6
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgLNTte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:49:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387981AbgLNTtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 14:49:33 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJVISG097680;
        Mon, 14 Dec 2020 14:48:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WrThR4FCepceMwyx9/mpU2je7KVchlEszyLDLOp+1XA=;
 b=Fu7byyrRW54tmCDuJuC0zdmcifv2Y+WBM12b8TXsY9hX7aDXjU93+CdotrIkcTJF86Tm
 9IBChixgs3ls87D1aMfR4EPAP9l7Ta22bqrhthF1WbwcDkzA+SdD1iG+3BOCtP2yXhm3
 yax7xVWtlI4YmCb+cyrFG+NTHz6X9xHOFVWLsD8cSwVOawqHQgwvNJ1PahURcaYZflG4
 p79frf7OoxUT4Tui3TlxyC1QKiBvU9go3UfbPb9fr63fADFxDDKBZhV3RN2jzLAgflU+
 LagO+zCJCP8w+TU5p1s6oeiiHmutZ15WzpnY6vx+f234LwZNBh3jYY1MKKAqUAdI9/sH 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35edn1sbpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:48:47 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BEJVLQx098092;
        Mon, 14 Dec 2020 14:48:47 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35edn1sbpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:48:47 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJkHPB032353;
        Mon, 14 Dec 2020 19:48:46 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 35cng8xvqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 19:48:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BEJmjY661407614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 19:48:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9353DAE05F;
        Mon, 14 Dec 2020 19:48:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF196AE060;
        Mon, 14 Dec 2020 19:48:44 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 19:48:44 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org, sashal@kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <X9ebwKJSSyVP/M9H@kroah.com>
 <237fe6d3-ebcc-1046-b295-a0154ce1158e@linux.ibm.com>
 <X9fAWD/k9Wbp7Rac@kroah.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <9ac4e4f3-3b59-8bdd-50d6-439fc4c35b9c@linux.ibm.com>
Date:   Mon, 14 Dec 2020 14:48:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <X9fAWD/k9Wbp7Rac@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 mlxlogscore=787 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/20 2:43 PM, Greg KH wrote:
> On Mon, Dec 14, 2020 at 02:39:17PM -0500, Tony Krowiak wrote:
>>
>> On 12/14/20 12:07 PM, Greg KH wrote:
>>> On Mon, Dec 14, 2020 at 11:56:17AM -0500, Tony Krowiak wrote:
>>>> The vfio_ap device driver registers a group notifier with VFIO when the
>>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>>>> event). When the KVM pointer is set, the vfio_ap driver takes the
>>>> following actions:
>>>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>>>      of the mediated device.
>>>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>>>> 3. Sets the function pointer to the function that handles interception of
>>>>      the instruction that enables/disables interrupt processing.
>>>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>>>      the guest.
>>>>
>>>> In order to avoid memory leaks, when the notifier is called to receive
>>>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>>>> driver should reverse the actions taken when the KVM pointer was set.
>>>>
>>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>>>>    1 file changed, 20 insertions(+), 9 deletions(-)
>>> <formletter>
>>>
>>> This is not the correct way to submit patches for inclusion in the
>>> stable kernel tree.  Please read:
>>>       https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>> for how to do this properly.
>>>
>>> </formletter>
>> I read the document on the correct way to submit patches for inclusion in
>> the stable kernel. I apologize for my ignorance, but I don't see the
>> problem. Can you help me out here? Does a patch that fixes a memory leak
>> not qualify or is it something else?
> You forgot to put "Cc: stable..." in the signed-off-by area.
>
> thanks,

Option 1, I must be blind. thanks

>
> greg k-h

