Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6313ED349
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 13:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhHPLrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 07:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235874AbhHPLrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 07:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794886323D;
        Mon, 16 Aug 2021 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629114434;
        bh=tst7soSx+X0ExumBex+02t1E+bh7o8o/x/jIqRIJoKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d6JzGFq7F2TR/GbxZqtva30Hq4EoPJCNqgQbCccaxTfJU3JWL/mbPs1FGy9yVfc7h
         lJjO8NzSzk17xM+oCIe44MqAnSGKqj/fMhHdrWWsuOUNMnE6BbX0B1hW9fmlhEhaem
         oP+1w4sJdJFyCm0ftzv03sMMZ0Ns3CC9VFN+0GWk=
Date:   Mon, 16 Aug 2021 13:47:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest
 address width
Message-ID: <YRpQP1Yf/mGqVIDA@kroah.com>
References: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:39:32PM +0800, Lu Baolu wrote:
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> 
> [ Upstream commit 327d5b2fee91c404a3956c324193892cf2cc9528 ]
> 
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
> This issue happens on the code path of getting a private domain for a
> device. A private domain was needed when the domain of an iommu group
> couldn't meet the requirement of a device. The IOMMU core has been
> evolved to eliminate the need for private domain, hence this code path
> has alreay been removed from the upstream since commit 327d5b2fee91c
> ("iommu/vt-d: Allow 32bit devices to uses DMA domain"). Instead of back
> porting all patches that are required for removing the private domain,
> this simply fixes it in the affected stable kernel between v4.16 and v5.7.
> 
> [baolu: The orignal patch could be found here
>  https://lore.kernel.org/linux-iommu/20210412202736.70765-1-saeed.mirzamohammadi@oracle.com/.
>  I added commit message according to Greg's comments at
>  https://lore.kernel.org/linux-iommu/YHZ%2FT9x7Xjf1r6fI@kroah.com/.]
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: stable@vger.kernel.org #v4.16+
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Tested-by: Camille Lu <camille.lu@hpe.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

What stable tree(s) is this backport for?

thanks,

greg k-h
