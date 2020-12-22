Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330DB2E053C
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 05:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgLVEGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 23:06:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgLVEGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 23:06:11 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BM42l9c089894;
        Mon, 21 Dec 2020 23:05:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DeTNwgybqVw97C4oNA36gGo6Ss+jL03FUh0IHNhc/vg=;
 b=l0u5RnbWX2cii3EYk3iFQ3OdSOs1xhXdicJXkj4SuxskkGFixLaZO/ODlvF0LhKkZJad
 bf7IW5bfaFdhUAsZDc8S1Q/5Y2x+aDFIqDFUtkS8O2HoUzQoUabqTe58uWOXC3XRtBmY
 FvTzCP/7ePxCufW9RN8mU3pci7H+EOe3TP25IWuRfRcN06dTHHAfTvqOAXh+PSmdWZLF
 EB9XuvPq5SuRaUdz7Rlp89+EMhHg/ylHr8PSkdabPVeUAE81MAVDFvzPPLbWWMBM5HiU
 rt7b/lyHveGuvB0q0dkTdDzxvyEulwS/rFaPt6EUxP4c5DDijd0ZCg0mwJDvyPA628w0 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35k8r9grkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 23:05:28 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BM43GkB093502;
        Mon, 21 Dec 2020 23:05:28 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35k8r9grjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 23:05:28 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BM3wTlZ005600;
        Tue, 22 Dec 2020 04:05:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35h8sh2ned-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 04:05:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BM45Ngh50397654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Dec 2020 04:05:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93C7F5204E;
        Tue, 22 Dec 2020 04:05:23 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.5.180])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 0043B5204F;
        Tue, 22 Dec 2020 04:05:22 +0000 (GMT)
Date:   Tue, 22 Dec 2020 05:05:21 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201222050521.46af2bf1.pasic@linux.ibm.com>
In-Reply-To: <20201221185625.24914-1-akrowiak@linux.ibm.com>
References: <20201221185625.24914-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_01:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012220023
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Dec 2020 13:56:25 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver takes the
> following actions:
> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>    of the mediated device.
> 2. Calls the kvm_get_kvm() function to increment its reference counter.
> 3. Sets the function pointer to the function that handles interception of
>    the instruction that enables/disables interrupt processing.
> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>    the guest.
> 
> In order to avoid memory leaks, when the notifier is called to receive
> notification that the KVM pointer has been set to NULL, the vfio_ap device
> driver should reverse the actions taken when the KVM pointer was set.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

[..]

>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> -	int ret;
> +	int ret, notify_rc = NOTIFY_DONE;
>  	struct ap_matrix_mdev *matrix_mdev;
>  
>  	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
>  		return NOTIFY_OK;
>  
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> +	mutex_lock(&matrix_dev->lock);
>  
>  	if (!data) {
> -		matrix_mdev->kvm = NULL;
> -		return NOTIFY_OK;
> +		if (matrix_mdev->kvm)
> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> +		notify_rc = NOTIFY_OK;
> +		goto notify_done;
>  	}
>  
>  	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
>  	if (ret)
> -		return NOTIFY_DONE;
> +		goto notify_done;
>  
>  	/* If there is no CRYCB pointer, then we can't copy the masks */
>  	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> +		goto notify_done;
>  
>  	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>  				  matrix_mdev->matrix.aqm,
>  				  matrix_mdev->matrix.adm);
>  
> -	return NOTIFY_OK;

Shouldn't there be an 
 +	notify_rc = NOTIFY_OK;
here? I mean you initialize notify_rc to NOTIFY_DONE, in the !data branch
on success you set notify_rc to NOTIFY_OK, but in the !!data branch it
just stays NOTIFY_DONE. Or am I missing something?

Otherwise LGTM!

Regards,
Halil

> +notify_done:
> +	mutex_unlock(&matrix_dev->lock);
> +	return notify_rc;
>  }
> 

[..] 
