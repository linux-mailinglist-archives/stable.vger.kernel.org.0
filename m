Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CDE375FDC
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 07:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhEGFuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 01:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhEGFuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 01:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1E2601FD;
        Fri,  7 May 2021 05:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620366561;
        bh=fMDiF7qsMmq3tFW4XrjW63qrgCP30rSUzCealdIrJGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qq5S5hzkUU/c3f3xgruVEoqTLyEi1B93bhbQJNUYX8UxNr22n9QM6YFB4jtQKAfiE
         FTDHi4brttp/dGsz+ovPe7z+eEJcNAM92hYbcJISG8iMmuvHDCu10CRH8KNiRvZzx9
         xiC2GghKTSY8qwZnM/BfjPwT063R2m3g8ulxW3tk=
Date:   Fri, 7 May 2021 07:49:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.11.y, 5.10.y, 5.4.y] vfio: Depend on MMU
Message-ID: <YJTU3uZv8GvDiWdm@kroah.com>
References: <162033393037.4094195.18215062546427210332.stgit@omen>
 <20210506211053.GR1370958@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506211053.GR1370958@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 06:10:53PM -0300, Jason Gunthorpe wrote:
> On Thu, May 06, 2021 at 02:47:51PM -0600, Alex Williamson wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > commit b2b12db53507bc97d96f6b7cb279e831e5eafb00 upstream
> > 
> > VFIO_IOMMU_TYPE1 does not compile with !MMU:
> > 
> > ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> > ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> > 
> > So require it.
> > 
> > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Message-Id: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Cc: stable@vger.kernel.org # 5.11.y, 5.10.y, 5.4.y
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > The noted stable branches include upstream commit 179209fa1270
> > ("vfio: IOMMU_API should be selected") without the follow-up commit
> > b2b12db53507 ("vfio: Depend on MMU"), which should have included a
> > Fixes: tag for the prior commit.  Without this latter commit, we're
> > susceptible to randconfig failures with !MMU configs.  Thanks!
> 
> Right. It would also be a fine solution to not include '1792 in any
> stable branches either

It's already in released versions, so I'll just queue up this fix now as
well.

thanks,

greg k-h
