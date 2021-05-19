Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C06388CAE
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 13:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350164AbhESLYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 07:24:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350285AbhESLYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 07:24:24 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JB4Nw9053448;
        Wed, 19 May 2021 07:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=baaD/EhyUIsH+7SWKLJhgTMHX6iZgwqB6kMSnQ5gIoQ=;
 b=NwghN8WyjqSRCbUrVxL+z53mOos9pN81qHCGBK3fZIQfBjNCtxuykz7a8Q6zMRDpyd7R
 IHVesq3PkOXzEZTq0dj0LSbZPTg8s4I6YmE9pkxmbJJ+0kIDYGU34dgb+S7WqW8464af
 PUVdEEtnZqWscz9FnPz/VVVQ2SWV0uY8EkrrBQH4HuW8JUvrfazROuiUIB3la/q93vcb
 AbhNATjTc4MGlMXnLSp1D3mMRU8SSM615ClEsw4jxARPMRJfP/xKo1bt1GxzhlgfJvkO
 ALWPtmZTXNxret8HqU7FxE2Axh7TBuEOTkrqR0fo6pPoNnG50XlcRibroBApasU1ZgzF hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n1dp8j77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:23:03 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JB4ql3059504;
        Wed, 19 May 2021 07:23:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n1dp8j6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:23:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JBDMg5017214;
        Wed, 19 May 2021 11:23:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x8a281-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 11:23:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JBMv3Q32178546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 11:22:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62FB852050;
        Wed, 19 May 2021 11:22:57 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.89.97])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA6505204E;
        Wed, 19 May 2021 11:22:56 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
From:   Christian Borntraeger <borntraeger@de.ibm.com>
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
 <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
Message-ID: <9c2b4711-5a26-15b0-8651-67a88bf12270@de.ibm.com>
Date:   Wed, 19 May 2021 13:22:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xxaakWftAy8zKw8lKZVH8cQw3sCx2q8P
X-Proofpoint-GUID: QoBPMHmXFpOuLNdYjKH9o9kB4IFtivgq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190074
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 19.05.21 10:17, Christian Borntraeger wrote:
> 
> 
> On 19.05.21 01:27, Halil Pasic wrote:
>> On Tue, 18 May 2021 19:01:42 +0200
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>> On 18.05.21 17:33, Halil Pasic wrote:
>>>> On Tue, 18 May 2021 15:59:36 +0200
>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>> [..]
>>>>>>>
>>>>>>> Would it help, if the code in priv.c would read the hook once
>>>>>>> and then only work on the copy? We could protect that with rcu
>>>>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
>>>>>>> unsetting the pointer?
>>>>
>>>> Unfortunately just "the hook" is ambiguous in this context. We
>>>> have kvm->arch.crypto.pqap_hook that is supposed to point to
>>>> a struct kvm_s390_module_hook member of struct ap_matrix_mdev
>>>> which is also called pqap_hook. And struct kvm_s390_module_hook
>>>> has function pointer member named "hook".
>>>
>>> I was referring to the full struct.
>>>>>>
>>>>>> I'll look into this.
>>>>>
>>>>> I think it could work. in priv.c use rcu_readlock, save the
>>>>> pointer, do the check and call, call rcu_read_unlock.
>>>>> In vfio_ap use rcu_assign_pointer to set the pointer and
>>>>> after setting it to zero call sychronize_rcu.
>>>>
>>>> In my opinion, we should make the accesses to the
>>>> kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
>>>> not sure if that is what you are proposing. How do we usually
>>>> do synchronisation on the stuff that lives in kvm->arch?
>>>
>>> RCU is a method of synchronization. We  make sure that structure
>>> pqap_hook is still valid as long as we are inside the rcu read
>>> lock. So the idea is: clear pointer, wait until all old readers
>>> have finished and the proceed with getting rid of the structure.
>>
>> Yes I know that RCU is a method of synchronization, but I'm not
>> very familiar with it. I'm a little confused by "read the hook
>> once and then work on a copy". I guess, I would have to read up
>> on the RCU again to get clarity. I intend to brush up my RCU knowledge
>> once the patch comes along. I would be glad to have your help when
>> reviewing an RCU based solution for this.
> 
> Just had a quick look. Its not trivial, as the hook function itself
> takes a mutex and an rcu section must not sleep. Will have a deeper
> look.


As a quick hack something like this could work. The whole locking is pretty
complicated and this makes it even more complex so we might want to do
a cleanup/locking rework later on.


index 9928f785c677..fde6e02aab54 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -609,6 +609,7 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
   */
  static int handle_pqap(struct kvm_vcpu *vcpu)
  {
+       struct kvm_s390_module_hook *pqap_hook;
         struct ap_queue_status status = {};
         unsigned long reg0;
         int ret;
@@ -657,14 +658,21 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
          * Verify that the hook callback is registered, lock the owner
          * and call the hook.
          */
-       if (vcpu->kvm->arch.crypto.pqap_hook) {
-               if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
+       rcu_read_lock();
+       pqap_hook = rcu_dereference(vcpu->kvm->arch.crypto.pqap_hook);
+       if (pqap_hook) {
+               if (!try_module_get(pqap_hook->owner)) {
+                       rcu_read_unlock();
                         return -EOPNOTSUPP;
-               ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
-               module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
+               }
+               rcu_read_unlock();
+               ret = pqap_hook->hook(vcpu);
+               module_put(pqap_hook->owner);
                 if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
                         kvm_s390_set_psw_cc(vcpu, 3);
                 return ret;
+       } else {
+               rcu_read_unlock();
         }
         /*
          * A vfio_driver must register a hook.
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f90c9103dac2..a7124abd6aed 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1194,6 +1194,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
                 mutex_lock(&matrix_dev->lock);
                 vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
                 matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+               synchronize_rcu();
                 kvm_put_kvm(matrix_mdev->kvm);
                 matrix_mdev->kvm = NULL;
                 matrix_mdev->kvm_busy = false;
