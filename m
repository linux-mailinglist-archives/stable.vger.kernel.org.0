Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C332C830
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359542AbhCDAew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1377144AbhCCTsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 14:48:19 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123JXXDh053745;
        Wed, 3 Mar 2021 14:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5EPwSfXEH5eZew/H5I7iXDVuIbFZQOElaCxGmhznkNM=;
 b=l0Xp5yZsXEIwqoUl9uO35kudKhx5hZZlhkfTKK3uvmlxnNpJF0JHuTUMMsk2ZbNwUkdf
 UhMOTYOgtI0LekzRi3hqLzzIRbj2ylPq0JLZa/NwKHuxN+PNaquPPYY7/W4sdFeXCRWu
 +eeWF/5yZY9hebE099OwPrLW2JByHk9VztMfxX0CtNnS9IjN5ebzeSDfFGDuf1VnZDSj
 +nqu1lwpEj06g4/wbhJoL//ue4U7LM4feqjxKpUNj/Z5a7YuOENCur0JEwmyLWWycdGs
 ZAKy9jSNwuAng2jC+EyBm1bSC899fSiAN2WR6Uw4yVDlq+e6UVptBROfK7mp7daD5Lp1 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372fyh1s4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 14:47:36 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123JXUbJ053505;
        Wed, 3 Mar 2021 14:47:36 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372fyh1rsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 14:47:36 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123JdGiU000502;
        Wed, 3 Mar 2021 19:47:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3712v513rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 19:47:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123Jl9bp7864802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 19:47:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18DE5204E;
        Wed,  3 Mar 2021 19:47:08 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.0.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 3464A5204F;
        Wed,  3 Mar 2021 19:47:08 +0000 (GMT)
Date:   Wed, 3 Mar 2021 20:47:06 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210303204706.0538e84f.pasic@linux.ibm.com>
In-Reply-To: <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
        <20210302204322.24441-2-akrowiak@linux.ibm.com>
        <20210303162332.4d227dbe.pasic@linux.ibm.com>
        <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_06:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 suspectscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103030137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 12:10:11 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 3/3/21 10:23 AM, Halil Pasic wrote:
> > On Tue,  2 Mar 2021 15:43:22 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> This patch fixes a lockdep splat introduced by commit f21916ec4826
> >> ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
> >> The lockdep splat only occurs when starting a Secure Execution guest.
> >> Crypto virtualization (vfio_ap) is not yet supported for SE guests;
> >> however, in order to avoid this problem when support becomes available,
> >> this fix is being provided.  
> > [..]
> >  
> >> @@ -1038,14 +1116,28 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
> >>   {
> >>   	struct ap_matrix_mdev *m;
> >>
> >> -	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
> >> -		if ((m != matrix_mdev) && (m->kvm == kvm))
> >> -			return -EPERM;
> >> -	}
> >> +	if (kvm->arch.crypto.crycbd) {
> >> +		matrix_mdev->kvm_busy = true;
> >>
> >> -	matrix_mdev->kvm = kvm;
> >> -	kvm_get_kvm(kvm);
> >> -	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> >> +		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
> >> +			if ((m != matrix_mdev) && (m->kvm == kvm)) {
> >> +				wake_up_all(&matrix_mdev->wait_for_kvm);  
> > This ain't no good. kvm_busy will remain true if we take this exit. The
> > wake_up_all() is not needed, because we hold the lock, so nobody can
> > observe it if we don't forget kvm_busy set.
> >
> > I suggest moving matrix_mdev->kvm_busy = true; after this loop, maybe right
> > before the unlock, and removing the wake_up_all().
> >  
> >> +				return -EPERM;
> >> +			}
> >> +		}
> >> +
> >> +		kvm_get_kvm(kvm);
> >> +		mutex_unlock(&matrix_dev->lock);
> >> +		kvm_arch_crypto_set_masks(kvm,
> >> +					  matrix_mdev->matrix.apm,
> >> +					  matrix_mdev->matrix.aqm,
> >> +					  matrix_mdev->matrix.adm);
> >> +		mutex_lock(&matrix_dev->lock);
> >> +		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> >> +		matrix_mdev->kvm = kvm;
> >> +		matrix_mdev->kvm_busy = false;
> >> +		wake_up_all(&matrix_mdev->wait_for_kvm);
> >> +	}
> >>
> >>   	return 0;
> >>   }  
> > [..]
> >  
> >> @@ -1300,7 +1406,21 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
> >>   		ret = vfio_ap_mdev_get_device_info(arg);
> >>   		break;
> >>   	case VFIO_DEVICE_RESET:
> >> -		ret = vfio_ap_mdev_reset_queues(mdev);
> >> +		matrix_mdev = mdev_get_drvdata(mdev);
> >> +
> >> +		/*
> >> +		 * If the KVM pointer is in the process of being set, wait until
> >> +		 * the process has completed.
> >> +		 */
> >> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
> >> +			       matrix_mdev->kvm_busy == false,
> >> +			       mutex_unlock(&matrix_dev->lock),
> >> +			       mutex_lock(&matrix_dev->lock));
> >> +
> >> +		if (matrix_mdev->kvm)
> >> +			ret = vfio_ap_mdev_reset_queues(mdev);
> >> +		else
> >> +			ret = -ENODEV;  
> > I don't think rejecting the reset is a good idea. I have you a more detailed
> > explanation of the list, where we initially discussed this question.
> >
> > How do you exect userspace to react to this -ENODEV?  
> 
> After reading your more detailed explanation, I have come to the
> conclusion that the test for matrix_mdev->kvm should not be
> performed here and the the vfio_ap_mdev_reset_queues() function
> should be called regardless. Each queue assigned to the mdev
> that is also bound to the vfio_ap driver will get reset and its
> IRQ resources cleaned up if they haven't already been and the
> other required conditions are met (i.e., see 
> vfio_ap_mdev_free_irq_resources()).

My point is if !->kvm the other required conditions are not met. But
yes we can go back to unconditional vfio_ap_mdev_reset_queues(mdev),
and think about the necessity of performing a
vfio_ap_mdev_reset_queues() if !->kvm later as I proposed in the other
mail.

Regards,
Halil
