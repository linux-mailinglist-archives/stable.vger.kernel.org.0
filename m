Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91F82616B6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgIHRQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731637AbgIHQS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:18:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A73DC22B2C;
        Tue,  8 Sep 2020 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599570388;
        bh=UjPlKjnFMWRSsJEdw3kVGk0wyHovwv3zHTf3Nn44oWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dPHNZTV6XY3o3arSn/Ih5Vo5tLuDpx/Z9zAVSPIlvAeU5qFBy0nomTnodvhRxwf4a
         gIicJQLVW5n96S4SgT/k/NlBB9Kz3pdCGs30Lqp45DQsB0u3Y56Bj+D5354E3rFkw5
         4rss3mUOtZFbZ5AqaBC9/bFS5FsoAEkIVkTQ7P6A=
Date:   Tue, 8 Sep 2020 15:06:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     sashal@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        peterx@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu,
        vsirnapalli@vmware.com
Subject: Re: [PATCH v4.14.y 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200908130640.GC3075407@kroah.com>
References: <1599509828-23596-1-git-send-email-akaher@vmware.com>
 <1599509828-23596-2-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599509828-23596-2-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 01:47:06AM +0530, Ajay Kaher wrote:
> From: Alex Williamson <alex.williamson@redhat.com>
> 
> commit 11c4cd07ba111a09f49625f9e4c851d83daf0a22 upstream.
> 
> Rather than calling remap_pfn_range() when a region is mmap'd, setup
> a vm_ops handler to support dynamic faulting of the range on access.
> This allows us to manage a list of vmas actively mapping the area that
> we can later use to invalidate those mappings.  The open callback
> invalidates the vma range so that all tracking is inserted in the
> fault handler and removed in the close handler.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> [Ajay: Regenerated the patch for v4.14]
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 75 ++++++++++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_private.h |  7 ++++
>  2 files changed, 80 insertions(+), 2 deletions(-)

Oops, nope, this patch breaks the build:

drivers/vfio/pci/vfio_pci.c:1183:11: error: initialization of \u2018int (*)(struct vm_fault *)\u2019 from incompatible pointer type \u2018int (*)(struct vm_area_struct *, struct vm_fault *)\u2019 [-Werror=incompatible-pointer-types]
 1183 |  .fault = vfio_pci_mmap_fault,
      |           ^~~~~~~~~~~~~~~~~~~
drivers/vfio/pci/vfio_pci.c:1183:11: note: (near initialization for \u2018vfio_pci_mmap_ops.fault\u2019)
cc1: some warnings being treated as errors

Did you test this?

Please fix up and resend the whole series for 4.14.y

thanks,

greg k-h
