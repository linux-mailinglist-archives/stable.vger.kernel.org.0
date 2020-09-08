Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB32616BF
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIHRRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731762AbgIHQS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:18:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85221224B2;
        Tue,  8 Sep 2020 13:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599570122;
        bh=9fS+gp1OB/v9Y8ppj0uj2LVv8Pjm5fb9yaFt2SrECxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wxSDHEK/TrBNWz4OoTOCK9bIy6IduLZwMEj5pe2K03mjBgCId8jCNRZAFfO6aH12r
         2dDr4W2G1relwqW98nPDMxz7RwIdju04V9frZS3KJer6mBfsB/jnKliAw4Dr//FQlH
         +7Ytu1HGVBr36etShfo8o09w6B5L5lDOaaAT/Bbk=
Date:   Tue, 8 Sep 2020 15:02:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     sashal@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        peterx@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu,
        vsirnapalli@vmware.com
Subject: Re: [PATCH v4.14.y 0/3] vfio: Fix for CVE-2020-12888
Message-ID: <20200908130214.GA3075407@kroah.com>
References: <1599509828-23596-1-git-send-email-akaher@vmware.com>
 <1599509828-23596-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599509828-23596-4-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 01:47:08AM +0530, Ajay Kaher wrote:
> CVE-2020-12888 Kernel: vfio: access to disabled MMIO space of some
> devices may lead to DoS scenario
>     
> The VFIO modules allow users (guest VMs) to enable or disable access to the
> devices' MMIO memory address spaces. If a user attempts to access (read/write)
> the devices' MMIO address space when it is disabled, some h/w devices issue an
> interrupt to the CPU to indicate a fatal error condition, crashing the system.
> This flaw allows a guest user or process to crash the host system resulting in
> a denial of service.
>     
> Patch 1/ is to force the user fault if PFNMAP vma might be DMA mapped
> before user access.
>     
> Patch 2/ setup a vm_ops handler to support dynamic faulting instead of calling
> remap_pfn_range(). Also provides a list of vmas actively mapping the area which
> can later use to invalidate those mappings.
>     
> Patch 3/ block the user from accessing memory spaces which is disabled by using
> new vma list support to zap, or invalidate, those memory mappings in order to
> force them to be faulted back in on access.
>     
> Upstreamed patches link:
> https://lore.kernel.org/kvm/158871401328.15589.17598154478222071285.stgit@gimli.home
>         
> [PATCH v4.14.y 1/3]:
> Backporting of upsream commit 41311242221e:
> vfio/type1: Support faulting PFNMAP vmas
>         
> [PATCH v4.14.y 2/3]:
> Backporting of upsream commit 11c4cd07ba11:
> vfio-pci: Fault mmaps to enable vma tracking
>         
> [PATCH v4.14.y 3/3]:
> Backporting of upsream commit abafbc551fdd:
> vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Now queued up, thanks.

greg k-h
