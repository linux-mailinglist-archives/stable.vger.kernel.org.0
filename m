Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFFF2614C4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbgIHQgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731825AbgIHQcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:32:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA85B22228;
        Tue,  8 Sep 2020 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599575593;
        bh=+OrY6yic2b8j2M0/KDTR0UkjhKoGy5DZysMSvf4PNF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YvT2gzuABobpfos/MY8/9MeUgl//rcFFIyJeM4wXqGoQbeswBnGzyCA6KjFlzB2DG
         enukFSp6c9IAHivmEzHvglfK3yhERXFTnxfz/Q8XwhgtvdpK45iqPERkw8cvRZn/00
         B0OMiWVQRB7OqLEMt6H38J4xs86RzFS4Vcmm3iH8=
Date:   Tue, 8 Sep 2020 16:33:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Ajay Kaher <akaher@vmware.com>, sashal@kernel.org,
        cohuck@redhat.com, peterx@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu,
        vsirnapalli@vmware.com
Subject: Re: [PATCH v4.14.y 0/3] vfio: Fix for CVE-2020-12888
Message-ID: <20200908143326.GA3451422@kroah.com>
References: <1599509828-23596-1-git-send-email-akaher@vmware.com>
 <1599509828-23596-4-git-send-email-akaher@vmware.com>
 <20200908082904.045ff744@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908082904.045ff744@w520.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 08:29:04AM -0600, Alex Williamson wrote:
> On Tue, 8 Sep 2020 01:47:08 +0530
> Ajay Kaher <akaher@vmware.com> wrote:
> 
> > CVE-2020-12888 Kernel: vfio: access to disabled MMIO space of some
> > devices may lead to DoS scenario
> >     
> > The VFIO modules allow users (guest VMs) to enable or disable access to the
> > devices' MMIO memory address spaces. If a user attempts to access (read/write)
> > the devices' MMIO address space when it is disabled, some h/w devices issue an
> > interrupt to the CPU to indicate a fatal error condition, crashing the system.
> > This flaw allows a guest user or process to crash the host system resulting in
> > a denial of service.
> >     
> > Patch 1/ is to force the user fault if PFNMAP vma might be DMA mapped
> > before user access.
> >     
> > Patch 2/ setup a vm_ops handler to support dynamic faulting instead of calling
> > remap_pfn_range(). Also provides a list of vmas actively mapping the area which
> > can later use to invalidate those mappings.
> >     
> > Patch 3/ block the user from accessing memory spaces which is disabled by using
> > new vma list support to zap, or invalidate, those memory mappings in order to
> > force them to be faulted back in on access.
> >     
> > Upstreamed patches link:
> > https://lore.kernel.org/kvm/158871401328.15589.17598154478222071285.stgit@gimli.home
> >         
> > [PATCH v4.14.y 1/3]:
> > Backporting of upsream commit 41311242221e:
> > vfio/type1: Support faulting PFNMAP vmas
> >         
> > [PATCH v4.14.y 2/3]:
> > Backporting of upsream commit 11c4cd07ba11:
> > vfio-pci: Fault mmaps to enable vma tracking
> >         
> > [PATCH v4.14.y 3/3]:
> > Backporting of upsream commit abafbc551fdd:
> > vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
> > 
> 
> I'd recommend also including the following or else SR-IOV VFs will be
> broken for DPDK:
> 
> commit ebfa440ce38b7e2e04c3124aa89c8a9f4094cf21
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Thu Jun 25 11:04:23 2020 -0600
> 
>     vfio/pci: Fix SR-IOV VF handling with MMIO blocking
>     
>     SR-IOV VFs do not implement the memory enable bit of the command
>     register, therefore this bit is not set in config space after
>     pci_enable_device().  This leads to an unintended difference
>     between PF and VF in hand-off state to the user.  We can correct
>     this by setting the initial value of the memory enable bit in our
>     virtualized config space.  There's really no need however to
>     ever fault a user on a VF though as this would only indicate an
>     error in the user's management of the enable bit, versus a PF
>     where the same access could trigger hardware faults.
>     
>     Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
>     Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Good catch, now queued up, thanks.

greg k-h
