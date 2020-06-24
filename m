Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39148206FBC
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbgFXJJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 05:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387970AbgFXJJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 05:09:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE84206FA;
        Wed, 24 Jun 2020 09:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592989747;
        bh=IjCfAeOJW9M1bFQ3YgPmBFFcD/3ncR488XRynpU/Ba0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oUH7IMfcNXYRgTEqdBNYydpSQtiUDb/gJzTTc523i79M36CCj3RfXQGoMsTuoNO59
         wAGPrPMpugBmJF+z1RHjnNouxQE45Hw2L+tmqU4+yqIXGPz9fyA7IPjH9QbmhvgsGC
         p0kN5haH2LXwmpxQtSmhw2b19CwkAyPWxvA0b0KQ=
Date:   Wed, 24 Jun 2020 11:09:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     stable@vger.kernel.org, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2] iommu: amd: Fix IO_PAGE_FAULT due to __unmap_single()
 size overflow
Message-ID: <20200624090906.GC1731290@kroah.com>
References: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:41:21AM +0000, Suravee Suthikulpanit wrote:
> Currently, an integer is used to specify the size in unmap_sg().
> With 2GB worth of pages (512k 4k pages), it requires 31 bits
> (i.e. (1 << 19) << 12), which overflows the integer, and ends up
> unmapping more pages than intended. Subsequently, this results in
> IO_PAGE_FAULT.
> 
> Uses size_t instead of int to pass parameter to __unmap_single().
> 
> Please note that this patch is only for the stable-kernels tree
> because the commit be62dbf554c5 ("iommu/amd: Convert AMD iommu driver
> to the dma-iommu api"), which removes the function unmap_sg()
> was introduced in v5.5. This patch is not applicable in subsequent
> kernel versions.

So what exact stable kernel version(s) do you want to see this patch
applied to?

thanks,

greg k-h
