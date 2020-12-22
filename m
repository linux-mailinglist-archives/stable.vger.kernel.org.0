Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532ED2E1093
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 00:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLVXPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 18:15:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgLVXPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 18:15:42 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BMN31dK072272;
        Tue, 22 Dec 2020 18:15:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZtQAqW+aoUQ3m2BY2MTZhN3S/IClfuJ0mEZszdUQKBU=;
 b=SLPqepw+uFuQ7ovveiyJEagyDZyKeCXyhTBBXTnzsldRtnGZyIgw+0v28fYkJBIRSq85
 Gl/EQAd42P+yZ1GCTJOuIAJTj4yOUG3412O24bzvRPRYzPzDQXbi/f1RqeqSc3t+iajN
 /HIFkRuBgSRryNcJL/Obw2KpNuVZG1ZUVMFfIphnOzXW4ErKHHz0QaDuSfIZRzxvpcCQ
 Iv+hD794xjAbrtzI8zpJinyanfDxfNDC6o0I3Gt4QnVgdxW/otVayYohRyrPizoaYy1C
 N9SiTqKI7dEkmHFsQNDYDA9JFgxzCWMD2Qh/jrYu2gvTchzppUm+m1pzVtSH3fLYNGdI Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ksxsgf6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 18:15:01 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BMN5r0u086825;
        Tue, 22 Dec 2020 18:15:01 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ksxsgf6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 18:15:01 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BMNDBs1023642;
        Tue, 22 Dec 2020 23:15:00 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 35k02euesv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 23:15:00 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BMNExkd8979010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Dec 2020 23:14:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A36DEB2064;
        Tue, 22 Dec 2020 23:14:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05199B205F;
        Tue, 22 Dec 2020 23:14:58 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 22 Dec 2020 23:14:58 +0000 (GMT)
Subject: Re: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20201221185625.24914-1-akrowiak@linux.ibm.com>
 <20201222050521.46af2bf1.pasic@linux.ibm.com>
 <853da84f-092b-6b94-62d5-628f440abc40@linux.ibm.com>
 <20201222165706.66e0120d.cohuck@redhat.com>
 <20201222204335.1b456342.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <5b10c838-bdc6-1923-bae7-ede1a0efe933@linux.ibm.com>
Date:   Tue, 22 Dec 2020 18:14:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201222204335.1b456342.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220167
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/22/20 2:43 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 16:57:06 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Tue, 22 Dec 2020 10:37:01 -0500
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> On 12/21/20 11:05 PM, Halil Pasic wrote:
>>>> On Mon, 21 Dec 2020 13:56:25 -0500
>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>>    static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>>>>    				       unsigned long action, void *data)
>>>>>    {
>>>>> -	int ret;
>>>>> +	int ret, notify_rc = NOTIFY_DONE;
>>>>>    	struct ap_matrix_mdev *matrix_mdev;
>>>>>    
>>>>>    	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>>>>>    		return NOTIFY_OK;
>>>>>    
>>>>>    	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>>>>> +	mutex_lock(&matrix_dev->lock);
>>>>>    
>>>>>    	if (!data) {
>>>>> -		matrix_mdev->kvm = NULL;
>>>>> -		return NOTIFY_OK;
>>>>> +		if (matrix_mdev->kvm)
>>>>> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
>>>>> +		notify_rc = NOTIFY_OK;
>>>>> +		goto notify_done;
>>>>>    	}
>>>>>    
>>>>>    	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
>>>>>    	if (ret)
>>>>> -		return NOTIFY_DONE;
>>>>> +		goto notify_done;
>>>>>    
>>>>>    	/* If there is no CRYCB pointer, then we can't copy the masks */
>>>>>    	if (!matrix_mdev->kvm->arch.crypto.crycbd)
>>>>> -		return NOTIFY_DONE;
>>>>> +		goto notify_done;
>>>>>    
>>>>>    	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>>>>>    				  matrix_mdev->matrix.aqm,
>>>>>    				  matrix_mdev->matrix.adm);
>>>>>    
>>>>> -	return NOTIFY_OK;
>>>> Shouldn't there be an
>>>>    +	notify_rc = NOTIFY_OK;
>>>> here? I mean you initialize notify_rc to NOTIFY_DONE, in the !data branch
>>>> on success you set notify_rc to NOTIFY_OK, but in the !!data branch it
>>>> just stays NOTIFY_DONE. Or am I missing something?
>>> I don't think it matters much since NOTIFY_OK and NOTIFY_DONE have
>>> no further effect on processing of the notification queue, but I believe
>>> you are correct, this is a change from what we originally had. I can
>>> restore the original return values if you'd prefer.
>> Even if they have the same semantics now, that might change in the
>> future; restoring the original behaviour looks like the right thing to
>> do.
> I agree. Especially since we do care to preserve the behavior in
> the !data branch. If there is no difference between the two, then it
> would probably make sense to clean that up globally.

Got it. I'm going to do a quick turnaround on the next version so we
can get this merged if need be. I will be taking off for Christmas vacation
and will be gone until sometime the first week in January.

>
> Regards,
> Halil

