Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2059C374723
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbhEERrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:47:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236839AbhEERqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 13:46:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145HX1YA169792;
        Wed, 5 May 2021 13:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WBtcVfm1aZZypC2xNQIJlDwqmMegxsUB6xbYguFm7w0=;
 b=kWjEURs8JPNzVpEbYL1R8YFx9JzI/1fg8HDW0CaWngUe+GVdQx80JLET18GzwQLLn/q8
 hI2wUCaOBF+omQmj2fPwVzhzz6Ls+ObQSLaCd+rj5+3d8NrgmUnKVofrF9Azmh4N8OOu
 GTrKd6GdX4MvACpJfaPc4uwN9+o0RU1owflqfmE76fHiZqn1D72I0uad8Hj5rYbW/MEd
 aFNTT9HuJWFEXGCgsR6HzeUeVsGIovs8xEM52iuz3JBBKI67PstBzn7useZADlXvCD2s
 F18O0QO+WRJYaV4sfJqvuzRL0MP/xzIBctMBT+lhSrE7TkvXj4PUnP5HOASZCO8ArUXr dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38byub8c8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 13:45:02 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 145HX22f169848;
        Wed, 5 May 2021 13:45:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38byub8c7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 13:45:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 145HiZYL010083;
        Wed, 5 May 2021 17:44:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 38bee2g886-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 17:44:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 145HiudW36962590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 17:44:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E6844C044;
        Wed,  5 May 2021 17:44:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BB54C040;
        Wed,  5 May 2021 17:44:56 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.53.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 17:44:56 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        jgg@nvidia.com, alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <7b20afce-5782-53c6-beab-ae852ae69b40@de.ibm.com>
Date:   Wed, 5 May 2021 19:44:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210505172826.105304-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AApSjXlHeuRLVROuDF8Szk5GP7cWO3VD
X-Proofpoint-GUID: pKPQ9bqxVPkZAixfrE55aVjFd6JZiwIC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=883 clxscore=1011
 priorityscore=1501 phishscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 05.05.21 19:28, Tony Krowiak wrote:
> The mdev remove callback for the vfio_ap device driver bails out with
> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> to prevent the mdev from being removed while in use; however, returning a
> non-zero rc does not prevent removal. This could result in a memory leak
> of the resources allocated when the mdev was created. In addition, the
> KVM guest will still have access to the AP devices assigned to the mdev
> even though the mdev no longer exists.
> 
> To prevent this scenario, cleanup will be done - including unplugging the
> AP adapters, domains and control domains - regardless of whether the mdev
> is in use by a KVM guest or not.
[...]
>   static int vfio_ap_mdev_create(struct mdev_device *mdev)
>   {
>   	struct ap_matrix_mdev *matrix_mdev;
> @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   
>   	mutex_lock(&matrix_dev->lock);
> -
> -	/*
> -	 * If the KVM pointer is in flux or the guest is running, disallow
> -	 * un-assignment of control domain.
> -	 */
> -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
> -		mutex_unlock(&matrix_dev->lock);
> -		return -EBUSY;
> -	}
> -
> +	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
> +	     "Removing mdev leaves KVM guest without any crypto devices");
> +	vfio_ap_mdev_clear_apcb(matrix_mdev);

Triggering a kernel warning due to an administrative task is not good.
Can't you simply clear the crycb? Maybe do a printk, but not a WARN.

>   	vfio_ap_mdev_reset_queues(mdev);
>   	list_del(&matrix_mdev->node);
>   	kfree(matrix_mdev);
> 
