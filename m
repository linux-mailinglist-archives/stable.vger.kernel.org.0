Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F144C179359
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgCDP2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:28:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:33846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgCDP2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 10:28:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2FAA5ACC2;
        Wed,  4 Mar 2020 15:28:22 +0000 (UTC)
Date:   Wed, 4 Mar 2020 16:28:16 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] iommu/dma: Fix MSI reservation allocation
Message-ID: <20200304152816.GA3619@suse.de>
References: <20200304111117.3540-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304111117.3540-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 11:11:17AM +0000, Marc Zyngier wrote:
> The way cookie_init_hw_msi_region() allocates the iommu_dma_msi_page
> structures doesn't match the way iommu_put_dma_cookie() frees them.
> 
> The former performs a single allocation of all the required structures,
> while the latter tries to free them one at a time. It doesn't quite
> work for the main use case (the GICv3 ITS where the range is 64kB)
> when the base granule size is 4kB.
> 
> This leads to a nice slab corruption on teardown, which is easily
> observable by simply creating a VF on a SRIOV-capable device, and
> tearing it down immediately (no need to even make use of it).
> Fortunately, this only affects systems where the ITS isn't translated
> by the SMMU, which are both rare and non-standard.
> 
> Fix it by allocating iommu_dma_msi_page structures one at a time.
> 
> Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org

Applied for v5.6, thanks.
