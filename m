Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78969387E22
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 19:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351030AbhERRDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 13:03:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54490 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232496AbhERRDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 13:03:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IGmfl3031758;
        Tue, 18 May 2021 13:01:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rxQfCSIxrBJSjDtz8kBKcUrqRfycdnptGD9C5sSQqiY=;
 b=QF+aBhZWXu1D0A4n9YUDITgpsvdtAXqoF5bz5QJ87AD2hgmLdKbtSnTFOlom6MaNVWR/
 wegjQLs25GOuV3LUKhsq2c26U5/NCkgoKudzmBOsWi3SnNy4Pnmdt0LOs9lnBuoWuOD0
 eeO0LsVzpL4tmj9sRvfjwvm39xvPVa8TKAB+Eqa3//qKdM6oJcilQT79KiUpBhDvELoo
 dTV+XYAxo2FR1R76sCED+vHGhqyO/SHDnBFRzat346ddJuVfw+39UvcEG4W3TSPItET9
 lMDrIiv+fgjOYHLdo2/As4P6Qex75sQal09ISAIbVKpIV1fDOvkypCmGSG39nBWSMVxb fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mhe9g95d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:01:50 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGp5vA041325;
        Tue, 18 May 2021 13:01:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mhe9g93u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:01:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGpreI014788;
        Tue, 18 May 2021 17:01:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7sm45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 17:01:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IH1Fsw36635060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 17:01:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4513D42042;
        Tue, 18 May 2021 17:01:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B32484204D;
        Tue, 18 May 2021 17:01:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.129])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 17:01:42 +0000 (GMT)
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ca5f1c72-09a3-d270-44a0-bda54c554f67@de.ibm.com>
Date:   Tue, 18 May 2021 19:01:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210518173351.39646b45.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1J4hzD5DvedK2mPLyLxEDiDgbc_Sc2PC
X-Proofpoint-GUID: f9looOVwZanR89q8a1ZH-nBY4czJPeag
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 18.05.21 17:33, Halil Pasic wrote:
> On Tue, 18 May 2021 15:59:36 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 18.05.21 15:42, Tony Krowiak wrote:
>>>
>>>
>>> On 5/18/21 5:30 AM, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 17.05.21 21:10, Halil Pasic wrote:
>>>>> On Mon, 17 May 2021 09:37:42 -0400
>>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>>   
>>>>>>>
>>>>>>> Because of this, I don't think the rest of your argument is valid.
>>>>>>
>>>>>> Okay, so your concern is that between the point in time the
>>>>>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
>>>>>> priv.c and the point in time the handle_pqap() function
>>>>>> in vfio_ap_ops.c is called, the memory allocated for the
>>>>>> matrix_mdev containing the struct kvm_s390_module_hook
>>>>>> may get freed, thus rendering the function pointer invalid.
>>>>>> While not impossible, that seems extremely unlikely to
>>>>>> happen. Can you articulate a scenario where that could
>>>>>> even occur?
>>>>>
>>>>> Malicious userspace. We tend to do the pqap aqic just once
>>>>> in the guest right after the queue is detected. I do agree
>>>>> it ain't very likely to happen during normal operation. But why are
>>>>> you asking?
>>>>
>>>> Would it help, if the code in priv.c would read the hook once
>>>> and then only work on the copy? We could protect that with rcu
>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
>>>> unsetting the pointer?
> 
> Unfortunately just "the hook" is ambiguous in this context. We
> have kvm->arch.crypto.pqap_hook that is supposed to point to
> a struct kvm_s390_module_hook member of struct ap_matrix_mdev
> which is also called pqap_hook. And struct kvm_s390_module_hook
> has function pointer member named "hook".

I was referring to the full struct.
> 
>>>
>>> I'll look into this.
>>
>> I think it could work. in priv.c use rcu_readlock, save the
>> pointer, do the check and call, call rcu_read_unlock.
>> In vfio_ap use rcu_assign_pointer to set the pointer and
>> after setting it to zero call sychronize_rcu.
> 
> In my opinion, we should make the accesses to the
> kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
> not sure if that is what you are proposing. How do we usually
> do synchronisation on the stuff that lives in kvm->arch?
> 

RCU is a method of synchronization. We  make sure that structure
pqap_hook is still valid as long as we are inside the rcu read
lock. So the idea is: clear pointer, wait until all old readers
have finished and the proceed with getting rid of the structure.
