Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC9382947
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhEQKDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236220AbhEQKCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93AEB610CC;
        Mon, 17 May 2021 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621245680;
        bh=pjeAlJGuvwLhGLn3o0lfWDQoXSJm2BhpCrCVT9m6IZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4NxQ1KvX3S5RZrMBneYOB11TYofOPoGoOj9eGevUmsY3m/uw1yPxzanp3l5o8aq1
         9wvjdwCqpw9Q2UtKidb+dz01ImDCrJRQuBzk1wiwi2rMGuOn9GPPuNRLp3tl8cL1YV
         Eu3zSk4MMbZs1jjxYBJm+vl+7TOm+IcveEG2228k=
Date:   Mon, 17 May 2021 12:01:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     sashal@kernel.org, ashok.raj@intel.com, jroedel@suse.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [REWORKED PATCH 1/1] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
Message-ID: <YKI+7mbHwJCeHS6o@kroah.com>
References: <20210517034913.3432-1-baolu.lu@linux.intel.com>
 <YKIWS0lFKTcZ9094@kroah.com>
 <726aede1-3d9f-6666-b31d-9db8e4301a0c@linux.intel.com>
 <YKIa9dczRk0v9Y2N@kroah.com>
 <cfe7a99c-a5b1-3c27-f44f-101ecdb84f12@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfe7a99c-a5b1-3c27-f44f-101ecdb84f12@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:51:13PM +0800, Lu Baolu wrote:
> Hi Greg,
> 
> On 5/17/21 3:27 PM, Greg KH wrote:
> > On Mon, May 17, 2021 at 03:17:53PM +0800, Lu Baolu wrote:
> > > Hi Greg,
> > > 
> > > On 5/17/21 3:07 PM, Greg KH wrote:
> > > > On Mon, May 17, 2021 at 11:49:13AM +0800, Lu Baolu wrote:
> > > > > [ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
> > > > > 
> > > > > The Access/Dirty bits in the first level page table entry will be set
> > > > > whenever a page table entry was used for address translation or write
> > > > > permission was successfully translated. This is always true when using
> > > > > the first-level page table for kernel IOVA. Instead of wasting hardware
> > > > > cycles to update the certain bits, it's better to set them up at the
> > > > > beginning.
> > > > > 
> > > > > Suggested-by: Ashok Raj <ashok.raj@intel.com>
> > > > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > > > Link: https://lore.kernel.org/r/20210115004202.953965-1-baolu.lu@linux.intel.com
> > > > > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >    drivers/iommu/intel/iommu.c | 14 ++++++++++++--
> > > > >    include/linux/intel-iommu.h |  2 ++
> > > > >    2 files changed, 14 insertions(+), 2 deletions(-)
> > > > > 
> > > > > [Note:
> > > > > - This is a reworked patch of
> > > > >     https://lore.kernel.org/stable/20210512144819.664462530@linuxfoundation.org/T/#m65267f0a0091c2fcbde097cea91089775908faad.
> > > > > - It aims to fix a reported issue of
> > > > >     https://bugzilla.kernel.org/show_bug.cgi?id=213077.
> > > > > - Please help to review and test.]
> > > > 
> > > > What stable tree(s) is this supposed to be for?
> > > 
> > > It's for 5.10.37.
> > 
> > But the above commit is already in 5.10.y.  And what about 5.11 and
> > 5.12, were those backports incorrect?
> 
> Above commit is now only in v5.10.37. Other 5.10.y are not impacted.
> 
> 5.11 and 5.12 both have correct backports.

Thanks for this, I've reverted the offending commit and added this one
in it's place.

greg k-h
