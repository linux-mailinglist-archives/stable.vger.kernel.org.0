Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855C72E0CD1
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 16:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgLVPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 10:37:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727224AbgLVPhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 10:37:48 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BMFXThA053438;
        Tue, 22 Dec 2020 10:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oqxOgppJ0v2QYv80hbQ7WCuvAaXCbnFr+L7o8WmZtrw=;
 b=SQzCjDULH57W5wzk9XScAiHcjMCHkIFiMdJVuCAeeQ/NiIxBgz+LAf/ne3D2OoC732h4
 aYc4uyMk5F7k7HRNszL42M6ypusSNamDAL8B6++05+i8/cqs1fg60CzkokO+haAVHczl
 0gYSIQMs7KnA71Si/he6aSbUzvWQwo3DBMwIpUd+zpcOwJeCcMGmbHL6SqF29kcaQKip
 Nj+jQLILvInMQ4VwWwQARY/OdEPWwAeKEOC08ThDk2Ryjhq0LXtpcaolG0UVv4gNGB/Y
 HFEBg6yrQ3DdEOLcie7JjcjbgrY01x4NT+7eUlzL10rdHkJnCyDyNWX76juiWcKXwQnQ 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kh4scj1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 10:37:06 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BMFXT9Z053412;
        Tue, 22 Dec 2020 10:37:06 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kh4scj0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 10:37:06 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BMFR8fc028871;
        Tue, 22 Dec 2020 15:37:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 35k02erfrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 15:37:05 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BMFb3a012059370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Dec 2020 15:37:03 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60A53BE04F;
        Tue, 22 Dec 2020 15:37:03 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27EA0BE059;
        Tue, 22 Dec 2020 15:37:02 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Dec 2020 15:37:01 +0000 (GMT)
Subject: Re: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20201221185625.24914-1-akrowiak@linux.ibm.com>
 <20201222050521.46af2bf1.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <853da84f-092b-6b94-62d5-628f440abc40@linux.ibm.com>
Date:   Tue, 22 Dec 2020 10:37:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201222050521.46af2bf1.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_07:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/21/20 11:05 PM, Halil Pasic wrote:
> On Mon, 21 Dec 2020 13:56:25 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The vfio_ap device driver registers a group notifier with VFIO when the
>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>> event). When the KVM pointer is set, the vfio_ap driver takes the
>> following actions:
>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>     of the mediated device.
>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>> 3. Sets the function pointer to the function that handles interception of
>>     the instruction that enables/disables interrupt processing.
>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>     the guest.
>>
>> In order to avoid memory leaks, when the notifier is called to receive
>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>> driver should reverse the actions taken when the KVM pointer was set.
>>
>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> [..]
>
>>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   				       unsigned long action, void *data)
>>   {
>> -	int ret;
>> +	int ret, notify_rc = NOTIFY_DONE;
>>   	struct ap_matrix_mdev *matrix_mdev;
>>   
>>   	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>>   		return NOTIFY_OK;
>>   
>>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>> +	mutex_lock(&matrix_dev->lock);
>>   
>>   	if (!data) {
>> -		matrix_mdev->kvm = NULL;
>> -		return NOTIFY_OK;
>> +		if (matrix_mdev->kvm)
>> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
>> +		notify_rc = NOTIFY_OK;
>> +		goto notify_done;
>>   	}
>>   
>>   	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
>>   	if (ret)
>> -		return NOTIFY_DONE;
>> +		goto notify_done;
>>   
>>   	/* If there is no CRYCB pointer, then we can't copy the masks */
>>   	if (!matrix_mdev->kvm->arch.crypto.crycbd)
>> -		return NOTIFY_DONE;
>> +		goto notify_done;
>>   
>>   	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>>   				  matrix_mdev->matrix.aqm,
>>   				  matrix_mdev->matrix.adm);
>>   
>> -	return NOTIFY_OK;
> Shouldn't there be an
>   +	notify_rc = NOTIFY_OK;
> here? I mean you initialize notify_rc to NOTIFY_DONE, in the !data branch
> on success you set notify_rc to NOTIFY_OK, but in the !!data branch it
> just stays NOTIFY_DONE. Or am I missing something?

I don't think it matters much since NOTIFY_OK and NOTIFY_DONE have
no further effect on processing of the notification queue, but I believe
you are correct, this is a change from what we originally had. I can
restore the original return values if you'd prefer.

>
> Otherwise LGTM!
>
> Regards,
> Halil
>
>> +notify_done:
>> +	mutex_unlock(&matrix_dev->lock);
>> +	return notify_rc;
>>   }
>>
> [..]

