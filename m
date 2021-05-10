Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB76379978
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 23:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhEJV5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 17:57:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231694AbhEJV5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 17:57:52 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ALWuvo148210;
        Mon, 10 May 2021 17:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3pZdad17YApVt8OdLEyLcsz02OdGU0mLr/Wj9ybAhcg=;
 b=n/rlTlI0haUUuHCPtcED6mvZg2UkqNm7PohPXis59qRey9ndX+eVIYgNW4na04w3ST2S
 5m/jb8l9VwOBC11WjLsooh6ywFHXCYFZAlvpG573CdwLnFZGGckU4E9Mev4VPFXgLDgx
 P3OI6og4r1l9BayPc9Q+4i6STsgdlx9fg2ye55kmC9MWPwszXCUMBOr6Blyr4OJnbjP4
 wRN6189lPQbN4Q6gW+Kh5l4GERxRzF/yROfKQyEBshMlz6A0bEzJDYEjMdnRPau9hsih
 pe6BIHWT18t85C4WF6hYI+VoQ+3IAEspVybtBUUjyAvNhcTh5aU/bgQgdgTMhTGznFRv VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fc7nsds8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:56:45 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ALZJ0f162424;
        Mon, 10 May 2021 17:56:45 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fc7nsdrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:56:45 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ALt6RF021254;
        Mon, 10 May 2021 21:56:44 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 38dj98hdgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 21:56:44 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ALuhld31064500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 21:56:43 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95EEC112062;
        Mon, 10 May 2021 21:56:43 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE0A5112063;
        Mon, 10 May 2021 21:56:42 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.140.234])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 21:56:42 +0000 (GMT)
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <7288b60f-a575-6b8e-c7c7-ee1d820e2cd6@linux.ibm.com>
Date:   Mon, 10 May 2021 17:56:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510214837.359717-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NJcufpF4hzobp8UUa8l-xAjC5mx4oacY
X-Proofpoint-ORIG-GUID: yV3abuce-HtTVAoCqWFK3z-7Tsv0nbdg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100147
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/21 5:48 PM, Tony Krowiak wrote:
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
>
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

The Signed-off-by was erroneously put in by the git sendemail
command. Please take this out of your reply-all responses. thanks.

> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index b2c7e10dfdcd..f90c9103dac2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,6 +26,7 @@
>   
>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> +static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
>   
>   static int match_apqn(struct device *dev, const void *data)
>   {
> @@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
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
> -	vfio_ap_mdev_reset_queues(mdev);
> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   	list_del(&matrix_mdev->node);
>   	kfree(matrix_mdev);
>   	mdev_set_drvdata(mdev, NULL);

