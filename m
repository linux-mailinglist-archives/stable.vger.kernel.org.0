Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A581D35ED5C
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344831AbhDNGmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhDNGmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2CDC6120E;
        Wed, 14 Apr 2021 06:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618382499;
        bh=kA8zOgdDuts/SjL+HhXf1S6TGSm7w76OyzQRoZXsuFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d4jaPQmIJT2wWYTgZX2W1xgXbF3Kuwhz1fUFxu7OMfRZDLjJdAyCBOQffWnZpbZ7S
         f/XC9+6Sgvt2QcL4Zks0/4rFGbOXv5PV0QaVmcM6yYr7p7Aotzn9s/BreAbiF+ux8Q
         tC1mpZl1xDMjTUmtlo0mnYZpAloE6cIP9bwddcSc=
Date:   Wed, 14 Apr 2021 08:41:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     saeed.mirzamohammadi@oracle.com, stable@vger.kernel.org,
        Camille Lu <camille.lu@hpe.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 v3 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
Message-ID: <YHaOn5qigsremnmh@kroah.com>
References: <20210412202736.70765-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412202736.70765-1-saeed.mirzamohammadi@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 01:27:35PM -0700, Saeed Mirzamohammadi wrote:
> The IOMMU driver calculates the guest addressability for a DMA request
> based on the value of the mgaw reported from the IOMMU. However, this
> is a fused value and as mentioned in the spec, the guest width
> should be calculated based on the minimum of supported adjusted guest
> address width (SAGAW) and MGAW.
> 
> This is from specification:
> "Guest addressability for a given DMA request is limited to the
> minimum of the value reported through this field and the adjusted
> guest address width of the corresponding page-table structure.
> (Adjusted guest address widths supported by hardware are reported
> through the SAGAW field)."
> 
> This causes domain initialization to fail and following
> errors appear for EHCI PCI driver:
> 
> [    2.486393] ehci-pci 0000:01:00.4: EHCI Host Controller
> [    2.486624] ehci-pci 0000:01:00.4: new USB bus registered, assigned bus
> number 1
> [    2.489127] ehci-pci 0000:01:00.4: DMAR: Allocating domain failed
> [    2.489350] ehci-pci 0000:01:00.4: DMAR: 32bit DMA uses non-identity
> mapping
> [    2.489359] ehci-pci 0000:01:00.4: can't setup: -12
> [    2.489531] ehci-pci 0000:01:00.4: USB bus 1 deregistered
> [    2.490023] ehci-pci 0000:01:00.4: init 0000:01:00.4 fail, -12
> [    2.490358] ehci-pci: probe of 0000:01:00.4 failed with error -12
> 
> This issue happens when the value of the sagaw corresponds to a
> 48-bit agaw. This fix updates the calculation of the agaw based on
> the minimum of IOMMU's sagaw value and MGAW.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Tested-by: Camille Lu <camille.lu@hpe.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> ---

Also when you resend this, please state the commit that this fixes, as
this must be a regression, right?  What kernel version did this previous
work for?

thanks,

greg k-h
