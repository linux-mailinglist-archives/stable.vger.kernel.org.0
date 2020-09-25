Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8439F278764
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgIYMjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYMjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:39:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D804920BED;
        Fri, 25 Sep 2020 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601037580;
        bh=Ec2OR35i0PEha7HydsenbD0l00v+EgADLMUcwhnoiKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJdvlBtFsrw/4edYVucgcGP4T1ybqo87e3hwOWxxZSVXa37m8p0IkSpZKdK4rmS6Q
         EalYQ2/wn3+/HS2CdPSNn3/WRJRJoEP099YIWMEfduQGaVK92XBCbRMoohp2JvhcxW
         FyxbGFd+gm2ng1f+VPoJ1xw+QFz0ButQNIWgjC4o=
Date:   Fri, 25 Sep 2020 14:39:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        sashal@kernel.org, joro@8bytes.org, Jon.Grimm@amd.com,
        brijesh.singh@amd.com, stable@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] iommu/amd: Use cmpxchg_double() when updating 128-bit
 IRTE
Message-ID: <20200925123955.GA2732292@kroah.com>
References: <20200925114505.232280-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925114505.232280-1-suravee.suthikulpanit@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 11:45:05AM +0000, Suravee Suthikulpanit wrote:
> When using 128-bit interrupt-remapping table entry (IRTE) (a.k.a GA mode),
> current driver disables interrupt remapping when it updates the IRTE
> so that the upper and lower 64-bit values can be updated safely.
> 
> However, this creates a small window, where the interrupt could
> arrive and result in IO_PAGE_FAULT (for interrupt) as shown below.
> 
>   IOMMU Driver            Device IRQ
>   ============            ===========
>   irte.RemapEn=0
>        ...
>    change IRTE            IRQ from device ==> IO_PAGE_FAULT !!
>        ...
>   irte.RemapEn=1
> 
> This scenario has been observed when changing irq affinity on a system
> running I/O-intensive workload, in which the destination APIC ID
> in the IRTE is updated.
> 
> Instead, use cmpxchg_double() to update the 128-bit IRTE at once without
> disabling the interrupt remapping. However, this means several features,
> which require GA (128-bit IRTE) support will also be affected if cmpxchg16b
> is not supported (which is unprecedented for AMD processors w/ IOMMU).
> 
> Cc: stable@vger.kernel.org
> Fixes: 880ac60e2538 ("iommu/amd: Introduce interrupt remapping ops structure")
> Reported-by: Sean Osborne <sean.m.osborne@oracle.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Tested-by: Erik Rockstrom <erik.rockstrom@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Link: https://lore.kernel.org/r/20200903093822.52012-3-suravee.suthikulpanit@amd.com
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> Note: This patch is the back-port on top of the stable branch linux-5.4.y
> for the upstream commit e52d58d54a32 ("iommu/amd: Use cmpxchg_double() when
> updating 128-bit IRTE") since the original patch does not apply cleanly.

Now queued up, thanks.

greg k-h
