Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D512FD669
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 18:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391108AbhATRFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 12:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391721AbhATRFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 12:05:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBA72137B;
        Wed, 20 Jan 2021 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611162260;
        bh=caeQFJb0TACo4Z1f02CFkwI8apxVCibwEWvBI0FGyGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQ34fOy1MEe1UULlEne1AghHIc2h2k1rm2puWnqYJDVOG/HJgEj7wdvNPP6HtKP16
         0W1Meby87U9oxd45rsd4o8tf/VQroGzb2HNVzxRWpj0iHTY1J+7oLlWVMPUZTHK7UU
         Q8493TR+gsuswXMl8dXq/9/bPnNiMDPPuatFR7bY=
Date:   Wed, 20 Jan 2021 18:04:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, iommu <iommu@lists.linux-foundation.org>,
        "Mendoza-jonas, Samuel" <samjonas@amazon.com>,
        "Sironi, Filippo" <sironi@amazon.de>
Subject: Re: [PATCH] iommu/vt-d: gracefully handle DMAR units with no
 supported address widths
Message-ID: <YAhikV3sOsyRVDyh@kroah.com>
References: <549928db2de6532117f36c9c810373c14cf76f51.camel@infradead.org>
 <5414a3e3cdbd24ba707153584d13f06ed5dbba76.camel@infradead.org>
 <YAgc2MX2c2N/rGDM@kroah.com>
 <61f3f0a09f015707eb727109cf3a4d97d41e3675.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61f3f0a09f015707eb727109cf3a4d97d41e3675.camel@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 03:55:05PM +0000, David Woodhouse wrote:
> On Wed, 2021-01-20 at 13:06 +0100, Greg KH wrote:
> > On Wed, Jan 20, 2021 at 09:42:43AM +0000, David Woodhouse wrote:
> > > On Thu, 2020-09-24 at 15:08 +0100, David Woodhouse wrote:
> > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > 
> > > > Instead of bailing out completely, such a unit can still be used for
> > > > interrupt remapping.
> > > > 
> > > > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > > 
> > > Could we have this for stable too please, along with the trivial
> > > subsequent fixup. They are:
> > > 
> > > c40aaaac1018 ("iommu/vt-d: Gracefully handle DMAR units with no supported address widths")
> > > 9def3b1a07c4 ("iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built")
> > > 
> > > They apply fairly straightforwardly when backported; let me know if you
> > > want us to send patches.
> > 
> > What stable kernel(s) do you want this in?  The above patches are
> > already in 5.10.
> 
> It's a fairly simple bug fix, to still use a given IOMMU for interrupt
> remapping even if it can't be used for DMA mapping.
> 
> Those features are somewhat orthogonal, and it was wrong for the kernel
> to bail out on the IOMMU hardware completely.
> 
> The interrupt remapping support is what's required for Intel boxes (or
> VMs) to run with more than 255 CPUs. It should be fairly simple to fix
> the same bug at least as far back as 4.14.

I tried applying these to 5.4, 4.19, and 4.14, and they all fail to
build:

drivers/iommu/dmar.c: In function ‘free_iommu’:
drivers/iommu/dmar.c:1140:35: error: ‘struct intel_iommu’ has no member named ‘drhd’
 1140 |  if (intel_iommu_enabled && !iommu->drhd->ignored) {
      |                                   ^~

So if you could provide a working set of patches backported, I will be
glad to queue them up.

thanks,

greg k-h
