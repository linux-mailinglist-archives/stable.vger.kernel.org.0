Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84A92FFE2E
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhAVIZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 03:25:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25368 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbhAVIZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 03:25:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10M80tdS191257;
        Fri, 22 Jan 2021 03:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8xgTP3BiyApe2BYzzXx3hSv4ShJttm2TByqpELq26i0=;
 b=V2bcD0dHHmJ4dBYRsIFQoTEaV2pOQMwUA5W5MEbtChqjRYxX5fYOy9ENhcyXN6BuzMfd
 u5NcbpgcLTMTQv8CKXTQ7z6JPiwB2U96J0+41hPgJHI4t/oXieZ7q8CvEkWlbCAx2Z2Q
 RbtEKBWwmdyMw4Ip5pj9aqqTecJiN23bGA6ExFzQLkuEIYqULO9wtp1MStqmzXcrmsvN
 MHxWFP4Ub1dCBKXSUeW2EuWvwUCz83LYzdL7a1hfvqTs22+i15hEwJuwFriimWoUgI7C
 id3nD2gaCcWOW/2P/InAK7+YCyeQWY2ztt/+o6cQed5ALgtczNIU1saXjmDQeOCgNnwZ jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367tqj8rj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 03:24:34 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10M812ei192074;
        Fri, 22 Jan 2021 03:24:34 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367tqj8rhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 03:24:34 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10M8HIDG015479;
        Fri, 22 Jan 2021 08:24:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 367k0v06a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:24:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10M8OTot36307450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 08:24:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 588DBA4062;
        Fri, 22 Jan 2021 08:24:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DE42A405F;
        Fri, 22 Jan 2021 08:24:28 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.82.42])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 08:24:28 +0000 (GMT)
Subject: Re: [PATCH 1/1] s390/vfio-ap: No need to disable IRQ after queue
 reset
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com
References: <20210121072008.76523-1-pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <19d8a764-fd48-ebe0-ec38-cf201fb53a3e@de.ibm.com>
Date:   Fri, 22 Jan 2021 09:24:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210121072008.76523-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_03:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220038
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21.01.21 08:20, Halil Pasic wrote:
> From: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> The queues assigned to a matrix mediated device are currently reset when:
> 
> * The VFIO_DEVICE_RESET ioctl is invoked
> * The mdev fd is closed by userspace (QEMU)
> * The mdev is removed from sysfs.
> 
> Immediately after the reset of a queue, a call is made to disable
> interrupts for the queue. This is entirely unnecessary because the reset of
> a queue disables interrupts, so this will be removed.
> 
> Furthermore, vfio_ap_irq_disable() does an unconditional PQAP/AQIC which
> can result in a specification exception (when the corresponding facility
> is not available), so this is actually a bugfix.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> [pasic@linux.ibm.com: minor rework before merging]
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
> Cc: <stable@vger.kernel.org>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Heiko, Vasily, lets carry this via the s390 tree.



> 
> ---
> 
> Since it turned out disabling the interrupts via PQAP/AQIC is not only
> unnecesary but also buggy, we decided to put this patch, which
> used to be apart of the series https://lkml.org/lkml/2020/12/22/757 on the fast
> lane.
> 
> If the backports turn out to be a bother, which I hope won't be the case
> not, I am happy to help with those.
> 
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |   6 +-
>  drivers/s390/crypto/vfio_ap_ops.c     | 100 ++++++++++++++++----------
>  drivers/s390/crypto/vfio_ap_private.h |  12 ++--
>  3 files changed, 69 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..7dc72cb718b0 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -71,15 +71,11 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>  static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>  {
>  	struct vfio_ap_queue *q;
> -	int apid, apqi;
>  
>  	mutex_lock(&matrix_dev->lock);
>  	q = dev_get_drvdata(&apdev->device);
> +	vfio_ap_mdev_reset_queue(q, 1);
>  	dev_set_drvdata(&apdev->device, NULL);
> -	apid = AP_QID_CARD(q->apqn);
> -	apqi = AP_QID_QUEUE(q->apqn);
> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -	vfio_ap_irq_disable(q);
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..7ceb6c433b3b 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -25,6 +25,7 @@
>  #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>  
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>  
>  static int match_apqn(struct device *dev, const void *data)
>  {
> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *vfio_ap_get_queue(
>  					int apqn)
>  {
>  	struct vfio_ap_queue *q;
> -	struct device *dev;
>  
>  	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>  		return NULL;
>  	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>  		return NULL;
>  
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> -		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
> +	q = vfio_ap_find_queue(apqn);
> +	if (q)
> +		q->matrix_mdev = matrix_mdev;
>  
>  	return q;
>  }
> @@ -119,13 +115,18 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>   */
>  static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>  {
> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
> +	if (!q)
> +		return;
> +	if (q->saved_isc != VFIO_AP_ISC_INVALID &&
> +	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm))) {
>  		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> -	if (q->saved_pfn && q->matrix_mdev)
> +		q->saved_isc = VFIO_AP_ISC_INVALID;
> +	}
> +	if (q->saved_pfn && !WARN_ON(!q->matrix_mdev)) {
>  		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
>  				 &q->saved_pfn, 1);
> -	q->saved_pfn = 0;
> -	q->saved_isc = VFIO_AP_ISC_INVALID;
> +		q->saved_pfn = 0;
> +	}
>  }
>  
>  /**
> @@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>   * Returns if ap_aqic function failed with invalid, deconfigured or
>   * checkstopped AP.
>   */
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
> +static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  {
>  	struct ap_qirq_ctrl aqic_gisa = {};
>  	struct ap_queue_status status;
> @@ -1114,48 +1115,70 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -static void vfio_ap_irq_disable_apqn(int apqn)
> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>  {
>  	struct device *dev;
> -	struct vfio_ap_queue *q;
> +	struct vfio_ap_queue *q = NULL;
>  
>  	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>  				 &apqn, match_apqn);
>  	if (dev) {
>  		q = dev_get_drvdata(dev);
> -		vfio_ap_irq_disable(q);
>  		put_device(dev);
>  	}
> +
> +	return q;
>  }
>  
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> +int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>  			     unsigned int retry)
>  {
>  	struct ap_queue_status status;
> +	int ret;
>  	int retry2 = 2;
> -	int apqn = AP_MKQID(apid, apqi);
>  
> -	do {
> -		status = ap_zapq(apqn);
> -		switch (status.response_code) {
> -		case AP_RESPONSE_NORMAL:
> -			while (!status.queue_empty && retry2--) {
> -				msleep(20);
> -				status = ap_tapq(apqn, NULL);
> -			}
> -			WARN_ON_ONCE(retry2 <= 0);
> -			return 0;
> -		case AP_RESPONSE_RESET_IN_PROGRESS:
> -		case AP_RESPONSE_BUSY:
> +	if (!q)
> +		return 0;
> +
> +retry_zapq:
> +	status = ap_zapq(q->apqn);
> +	switch (status.response_code) {
> +	case AP_RESPONSE_NORMAL:
> +		ret = 0;
> +		break;
> +	case AP_RESPONSE_RESET_IN_PROGRESS:
> +		if (retry--) {
>  			msleep(20);
> -			break;
> -		default:
> -			/* things are really broken, give up */
> -			return -EIO;
> +			goto retry_zapq;
>  		}
> -	} while (retry--);
> +		ret = -EBUSY;
> +		break;
> +	case AP_RESPONSE_Q_NOT_AVAIL:
> +	case AP_RESPONSE_DECONFIGURED:
> +	case AP_RESPONSE_CHECKSTOPPED:
> +		WARN_ON_ONCE(status.irq_enabled);
> +		ret = -EBUSY;
> +		goto free_resources;
> +	default:
> +		/* things are really broken, give up */
> +		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
> +		     status.response_code);
> +		return -EIO;
> +	}
> +
> +	/* wait for the reset to take effect */
> +	while (retry2--) {
> +		if (status.queue_empty && !status.irq_enabled)
> +			break;
> +		msleep(20);
> +		status = ap_tapq(q->apqn, NULL);
> +	}
> +	WARN_ON_ONCE(retry2 <= 0);
>  
> -	return -EBUSY;
> +free_resources:
> +	vfio_ap_free_aqic_resources(q);
> +
> +	return ret;
>  }
>  
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> @@ -1163,13 +1186,15 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  	int ret;
>  	int rc = 0;
>  	unsigned long apid, apqi;
> +	struct vfio_ap_queue *q;
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>  			     matrix_mdev->matrix.apm_max + 1) {
>  		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>  				     matrix_mdev->matrix.aqm_max + 1) {
> -			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +			q = vfio_ap_find_queue(AP_MKQID(apid, apqi));
> +			ret = vfio_ap_mdev_reset_queue(q, 1);
>  			/*
>  			 * Regardless whether a queue turns out to be busy, or
>  			 * is not operational, we need to continue resetting
> @@ -1177,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			 */
>  			if (ret)
>  				rc = ret;
> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>  		}
>  	}
>  
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..28e9d9989768 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -88,11 +88,6 @@ struct ap_matrix_mdev {
>  	struct mdev_device *mdev;
>  };
>  
> -extern int vfio_ap_mdev_register(void);
> -extern void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry);
> -
>  struct vfio_ap_queue {
>  	struct ap_matrix_mdev *matrix_mdev;
>  	unsigned long saved_pfn;
> @@ -100,5 +95,10 @@ struct vfio_ap_queue {
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> +
> +int vfio_ap_mdev_register(void);
> +void vfio_ap_mdev_unregister(void);
> +int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> +			     unsigned int retry);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */
> 
> base-commit: 9791581c049c10929e97098374dd1716a81fefcc
> 
