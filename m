Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241D32E0CF7
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgLVP6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 10:58:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727311AbgLVP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 10:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608652637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8+776tfhwtQApMj/Gr6fVjPBAX3N+dBT+pgqbNf1eg=;
        b=YXy0KZYeC4qcVljbqlnHR/KgUi6FNG7j+HWkVV3KfslbbaxUgQSS/HHxZY9IV0bsqsFPXt
        TtBQNxuIZA3krj21dTl+Zl79tlTL2Tlzzbdx+eTjxPJscDAoF3nZs6kwMNlsdqZQMOwYSL
        p6k4JAV3dH/eRSxN2KhMFreApfjbvQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-xYsRpUhgM7WQc78o2fGQVw-1; Tue, 22 Dec 2020 10:57:16 -0500
X-MC-Unique: xYsRpUhgM7WQc78o2fGQVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 719D8800D53;
        Tue, 22 Dec 2020 15:57:14 +0000 (UTC)
Received: from gondolin (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDB5D60C5B;
        Tue, 22 Dec 2020 15:57:08 +0000 (UTC)
Date:   Tue, 22 Dec 2020 16:57:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201222165706.66e0120d.cohuck@redhat.com>
In-Reply-To: <853da84f-092b-6b94-62d5-628f440abc40@linux.ibm.com>
References: <20201221185625.24914-1-akrowiak@linux.ibm.com>
        <20201222050521.46af2bf1.pasic@linux.ibm.com>
        <853da84f-092b-6b94-62d5-628f440abc40@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Dec 2020 10:37:01 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/21/20 11:05 PM, Halil Pasic wrote:
> > On Mon, 21 Dec 2020 13:56:25 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >>   				       unsigned long action, void *data)
> >>   {
> >> -	int ret;
> >> +	int ret, notify_rc = NOTIFY_DONE;
> >>   	struct ap_matrix_mdev *matrix_mdev;
> >>   
> >>   	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
> >>   		return NOTIFY_OK;
> >>   
> >>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> >> +	mutex_lock(&matrix_dev->lock);
> >>   
> >>   	if (!data) {
> >> -		matrix_mdev->kvm = NULL;
> >> -		return NOTIFY_OK;
> >> +		if (matrix_mdev->kvm)
> >> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> >> +		notify_rc = NOTIFY_OK;
> >> +		goto notify_done;
> >>   	}
> >>   
> >>   	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> >>   	if (ret)
> >> -		return NOTIFY_DONE;
> >> +		goto notify_done;
> >>   
> >>   	/* If there is no CRYCB pointer, then we can't copy the masks */
> >>   	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> >> -		return NOTIFY_DONE;
> >> +		goto notify_done;
> >>   
> >>   	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> >>   				  matrix_mdev->matrix.aqm,
> >>   				  matrix_mdev->matrix.adm);
> >>   
> >> -	return NOTIFY_OK;  
> > Shouldn't there be an
> >   +	notify_rc = NOTIFY_OK;
> > here? I mean you initialize notify_rc to NOTIFY_DONE, in the !data branch
> > on success you set notify_rc to NOTIFY_OK, but in the !!data branch it
> > just stays NOTIFY_DONE. Or am I missing something?  
> 
> I don't think it matters much since NOTIFY_OK and NOTIFY_DONE have
> no further effect on processing of the notification queue, but I believe
> you are correct, this is a change from what we originally had. I can
> restore the original return values if you'd prefer.

Even if they have the same semantics now, that might change in the
future; restoring the original behaviour looks like the right thing to
do.

> 
> >
> > Otherwise LGTM!

Same here.

> >
> > Regards,
> > Halil
> >  
> >> +notify_done:
> >> +	mutex_unlock(&matrix_dev->lock);
> >> +	return notify_rc;
> >>   }
> >>  
> > [..]  
> 

