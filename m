Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB2D2DA0BC
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502251AbgLNTnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732829AbgLNTnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 14:43:02 -0500
Date:   Mon, 14 Dec 2020 20:43:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607974935;
        bh=76g58O1X4x9xdjWgejC9uD2yLlTe//IJxSjzdnkLsgQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=yktp8A1Kb9o6Dy8etBiaKLmGDvb1EFFWP/9XSyymRnSz5M6mYdji5GemTz4zsEU9K
         97EpI+0Zv+/H/yfZQlwv258B033Vd3XSxAtdQit5UCnaHLvk98Q86udU62bMJ/tudv
         Coii2E714zRgzYMa66Ncg04j5OhiMfR8CgKiu7s0=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org, sashal@kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <X9fAWD/k9Wbp7Rac@kroah.com>
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <X9ebwKJSSyVP/M9H@kroah.com>
 <237fe6d3-ebcc-1046-b295-a0154ce1158e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <237fe6d3-ebcc-1046-b295-a0154ce1158e@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 02:39:17PM -0500, Tony Krowiak wrote:
> 
> 
> On 12/14/20 12:07 PM, Greg KH wrote:
> > On Mon, Dec 14, 2020 at 11:56:17AM -0500, Tony Krowiak wrote:
> > > The vfio_ap device driver registers a group notifier with VFIO when the
> > > file descriptor for a VFIO mediated device for a KVM guest is opened to
> > > receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> > > event). When the KVM pointer is set, the vfio_ap driver takes the
> > > following actions:
> > > 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
> > >     of the mediated device.
> > > 2. Calls the kvm_get_kvm() function to increment its reference counter.
> > > 3. Sets the function pointer to the function that handles interception of
> > >     the instruction that enables/disables interrupt processing.
> > > 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
> > >     the guest.
> > > 
> > > In order to avoid memory leaks, when the notifier is called to receive
> > > notification that the KVM pointer has been set to NULL, the vfio_ap device
> > > driver should reverse the actions taken when the KVM pointer was set.
> > > 
> > > Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> > > Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > > ---
> > >   drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
> > >   1 file changed, 20 insertions(+), 9 deletions(-)
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> 
> I read the document on the correct way to submit patches for inclusion in
> the stable kernel. I apologize for my ignorance, but I don't see the
> problem. Can you help me out here? Does a patch that fixes a memory leak
> not qualify or is it something else?

You forgot to put "Cc: stable..." in the signed-off-by area.

thanks,

greg k-h
