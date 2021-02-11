Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB0318A8B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 13:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBKM1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 07:27:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhBKMYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 07:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613046199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=faRpucM8bYk3+6I7D614thA2FMfgheqmON/unvovBDw=;
        b=hCTli6TjKEUkdHVP+kswbDvJtC3IWdYBm/g6pn5LbkrHBF8+oq3XUGiGsnp/4PmM5aTNw6
        boJAOANAsRPcQo2K9j59VTS5U4vhnKq4Vzoxn3EwR3P2fnZ1OdchV9Udfp6dOSODLw//cE
        A+++af+M58cV6sA/Uo/mmQWBrKd8srY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-aPNvSw21OQiRLgyafqWlog-1; Thu, 11 Feb 2021 07:23:15 -0500
X-MC-Unique: aPNvSw21OQiRLgyafqWlog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A20F81005501;
        Thu, 11 Feb 2021 12:23:13 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA37B60936;
        Thu, 11 Feb 2021 12:23:08 +0000 (UTC)
Date:   Thu, 11 Feb 2021 13:23:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210211132306.64249174.cohuck@redhat.com>
In-Reply-To: <6e2842e4-334d-6592-a781-5b85ec0ed13c@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
        <20210209194830.20271-2-akrowiak@linux.ibm.com>
        <20210210115334.46635966.cohuck@redhat.com>
        <6e2842e4-334d-6592-a781-5b85ec0ed13c@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021 15:34:24 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 2/10/21 5:53 AM, Cornelia Huck wrote:
> > On Tue,  9 Feb 2021 14:48:30 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> This patch fixes a circular locking dependency in the CI introduced by
> >> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
> >> pointer invalidated"). The lockdep only occurs when starting a Secure
> >> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
> >> SE guests; however, in order to avoid CI errors, this fix is being
> >> provided.
> >>
> >> The circular lockdep was introduced when the masks in the guest's APCB
> >> were taken under the matrix_dev->lock. While the lock is definitely
> >> needed to protect the setting/unsetting of the KVM pointer, it is not
> >> necessarily critical for setting the masks, so this will not be done under
> >> protection of the matrix_dev->lock.
> >>
> >> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
> >>   1 file changed, 45 insertions(+), 30 deletions(-)
> >>
> >>   static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
> >>   {
> >> -	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >> -	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >> -	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> >> -	kvm_put_kvm(matrix_mdev->kvm);
> >> -	matrix_mdev->kvm = NULL;
> >> +	if (matrix_mdev->kvm) {  
> > If you're doing setting/unsetting under matrix_dev->lock, is it
> > possible that matrix_mdev->kvm gets unset between here and the next
> > line, as you don't hold the lock?  
> 
> That is highly unlikely because the only place the matrix_mdev->kvm
> pointer is cleared is in this function which is called from only two
> places: the notifier that handles the VFIO_GROUP_NOTIFY_SET_KVM
> notification when the KVM pointer is cleared; the vfio_ap_mdev_release()
> function which is called when the mdev fd is closed (i.e., when the guest
> is shut down). The fact is, with the only end-to-end implementation
> currently available, the notifier callback is never invoked to clear
> the KVM pointer because the vfio_ap_mdev_release callback is
> invoked first and it unregisters the notifier callback.
> 
> Having said that, I suppose there is no guarantee that there will not
> be different userspace clients in the future that do things in a
> different order. At the very least, it wouldn't hurt to protect against
> that as you suggest below.

Yes, if userspace is able to use the interfaces in the certain way, we
should always make sure that nothing bad happens if it does so, even if
known userspace applications are well-behaved.

[Can we make an 'evil userspace' test program, maybe? The hardware
dependency makes this hard to run, though.]

> 
> >
> > Maybe you could
> > - grab a reference to kvm while holding the lock
> > - call the mask handling functions with that kvm reference
> > - lock again, drop the reference, and do the rest of the processing?
> >  
> >> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >> +		mutex_lock(&matrix_dev->lock);
> >> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> >> +		kvm_put_kvm(matrix_mdev->kvm);
> >> +		matrix_mdev->kvm = NULL;
> >> +		mutex_unlock(&matrix_dev->lock);
> >> +	}
> >>   }  
> 

