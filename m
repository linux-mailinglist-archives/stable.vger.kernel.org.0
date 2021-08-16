Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A73ED40F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhHPMit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 08:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhHPMis (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 08:38:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3CB76326D;
        Mon, 16 Aug 2021 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629117474;
        bh=7n4DRYie77lilKD57CiAnrNZZl86AAkebeLQzTt6cr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w06MSwWm7HdRyE+91DdQxy6QN1kd9/VUvtAWjFNP1nYSDcOgKEMHAbOSj699XMXUU
         V7ERpyMRDOyJKYni/ukRw6zAyDE760ZEbWYphd7F8xO4qB8ySzCE1xuT0Uj08NXr26
         dARnBbx31kgr4JJF2zwW3mS51eipgOvIHO0D7h8A=
Date:   Mon, 16 Aug 2021 14:37:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest
 address width
Message-ID: <YRpcIKvXY3LzXaqt@kroah.com>
References: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
 <YRpQcOQzOVnGn0Lg@kroah.com>
 <76945715-9a4c-2f94-b458-b6ab53d40a1c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76945715-9a4c-2f94-b458-b6ab53d40a1c@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 08:20:31PM +0800, Lu Baolu wrote:
> Hi Greg,
> 
> On 2021/8/16 19:48, Greg Kroah-Hartman wrote:
> > On Mon, Aug 16, 2021 at 07:39:32PM +0800, Lu Baolu wrote:
> > > From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> > > 
> > > [ Upstream commit 327d5b2fee91c404a3956c324193892cf2cc9528 ]
> > 
> > Also, this really does not look like this commit at all :(
> > 
> 
> This is not a back port. It's a fix for some stable kernels. Sorry for
> the confusion.
> 
> The error happens in a helper function that has been deprecated in the
> upstream kernel by above commit. I added below explanation in the commit
> message:
> 
> "
> This issue happens on the code path of getting a private domain for a
> device. A private domain was needed when the domain of an iommu group
> couldn't meet the requirement of a device. The IOMMU core has been
> evolved to eliminate the need for private domain, hence this code path
> has already been removed from the upstream since commit 327d5b2fee91c
> ("iommu/vt-d: Allow 32bit devices to uses DMA domain"). Instead of back
> porting all patches that are required for removing the private domain,
> this simply fixes it in the affected stable kernel between v4.16 and v5.7.
> "
> 
> I'm sorry if this is not the right way to do this.

Ah, sorry, I totally missed that.  This is fine, now queued up for
4.19.y and 5.4.y.

thanks,

greg k-h
