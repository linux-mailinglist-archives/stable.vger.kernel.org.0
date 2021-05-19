Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9848F3889A8
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343687AbhESIrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 04:47:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343696AbhESIrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 04:47:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J8hf8c151433;
        Wed, 19 May 2021 04:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OYWWSIcs12yMfYYufLMR8/Q7KvEDR7ikuAOk4RW6roE=;
 b=sqHNhlRQ7OZzBnCrWq+GWAjtMH4f0glFjDlRU/aR8Sokt+ge0xMj9kBKeORaCl9iTuLo
 Tqk9kRZKOGSkIAr25OOb4Lj9sRhasik8mTMczBp74qVCczAl7CBhWP38yO/oIQIrUtsA
 xj2/lvlep7aTlqkMqh4nvF10nm1i8MSgAxthOI+ciePovfqsWJ7dh3bAAXlvzj1eW7Ml
 UAzIw7jE/5PG8n+TJdhSKQeE0t5/jv75+zTwtHq6XkHZ2NhCMWg6xIKrFBGrwH4TYYhk
 Mh6WmaevWQ9ISkhG6KX8bNxg+6jx7ih8n93r3GvWLi8EGrbn3TniQVskqDAl5XJi1BC4 EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxbx2arq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:46:24 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J8iRvO154388;
        Wed, 19 May 2021 04:46:23 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxbx2ar1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:46:23 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J8hvco020970;
        Wed, 19 May 2021 08:46:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 38j5x81386-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:46:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J8kIkd28705074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 08:46:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 517CC11C0D8;
        Wed, 19 May 2021 08:46:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 081F211C307;
        Wed, 19 May 2021 08:17:50 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.89.97])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 08:17:49 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
 <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
 <20210517211030.368ca64b.pasic@linux.ibm.com>
 <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
 <9ebd5fd8-b093-e5bc-e680-88fa7a9b085c@linux.ibm.com>
 <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
 <20210518173351.39646b45.pasic@linux.ibm.com>
 <ca5f1c72-09a3-d270-44a0-bda54c554f67@de.ibm.com>
 <20210519012709.3bcc30e7.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
Date:   Wed, 19 May 2021 10:17:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210519012709.3bcc30e7.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -pRYk4RQyfIs3-_W5GkkstdLTwAmRRRt
X-Proofpoint-ORIG-GUID: Rtnd7wG_q_PxxiCdyVU6eOCYewUvxU0r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 19.05.21 01:27, Halil Pasic wrote:
> On Tue, 18 May 2021 19:01:42 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 18.05.21 17:33, Halil Pasic wrote:
>>> On Tue, 18 May 2021 15:59:36 +0200
>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> [..]
>>>>>>
>>>>>> Would it help, if the code in priv.c would read the hook once
>>>>>> and then only work on the copy? We could protect that with rcu
>>>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
>>>>>> unsetting the pointer?
>>>
>>> Unfortunately just "the hook" is ambiguous in this context. We
>>> have kvm->arch.crypto.pqap_hook that is supposed to point to
>>> a struct kvm_s390_module_hook member of struct ap_matrix_mdev
>>> which is also called pqap_hook. And struct kvm_s390_module_hook
>>> has function pointer member named "hook".
>>
>> I was referring to the full struct.
>>>    
>>>>>
>>>>> I'll look into this.
>>>>
>>>> I think it could work. in priv.c use rcu_readlock, save the
>>>> pointer, do the check and call, call rcu_read_unlock.
>>>> In vfio_ap use rcu_assign_pointer to set the pointer and
>>>> after setting it to zero call sychronize_rcu.
>>>
>>> In my opinion, we should make the accesses to the
>>> kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
>>> not sure if that is what you are proposing. How do we usually
>>> do synchronisation on the stuff that lives in kvm->arch?
>>>    
>>
>> RCU is a method of synchronization. We  make sure that structure
>> pqap_hook is still valid as long as we are inside the rcu read
>> lock. So the idea is: clear pointer, wait until all old readers
>> have finished and the proceed with getting rid of the structure.
> 
> Yes I know that RCU is a method of synchronization, but I'm not
> very familiar with it. I'm a little confused by "read the hook
> once and then work on a copy". I guess, I would have to read up
> on the RCU again to get clarity. I intend to brush up my RCU knowledge
> once the patch comes along. I would be glad to have your help when
> reviewing an RCU based solution for this.

Just had a quick look. Its not trivial, as the hook function itself
takes a mutex and an rcu section must not sleep. Will have a deeper
look.
