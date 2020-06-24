Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB45720729F
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 13:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403836AbgFXLzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 07:55:16 -0400
Received: from 8bytes.org ([81.169.241.247]:48696 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403802AbgFXLzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 07:55:16 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E135B2AF; Wed, 24 Jun 2020 13:55:10 +0200 (CEST)
Date:   Wed, 24 Jun 2020 13:55:05 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2] iommu: amd: Fix IO_PAGE_FAULT due to __unmap_single()
 size overflow
Message-ID: <20200624115505.GN3701@8bytes.org>
References: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> 
> Cc: stable@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org
> Reported-by: Robert Lippert <rlippert@google.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Acked-by: Joerg Roedel <jroedel@suse.de>

