Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F80323876
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 09:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBXISR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 03:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhBXISG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 03:18:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6342C64ED3;
        Wed, 24 Feb 2021 08:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614154645;
        bh=+Y6M8zi3WpHqcpNLoi4OfIpSK0p2w0lclMYUSsfIOew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ko970AHhSQm1lPY1xrCvkNe1jRnhw0NBXl1Tsf+4GJirHXkET5YVdWpXodS/9OlvK
         GIgomtGsJAnv30DchP1ttEJjJnBYo7QJIiLta/xV+h4yEnOfnsRorFc4h4jpOd0Qvz
         gTksFCPjqA3CevU5XJaYMPVissizQ2bU4pV2wlrM=
Date:   Wed, 24 Feb 2021 09:17:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>, bharat@chelsio.com
Subject: Re: backport of dma_virt_ops related fixes to 5.10.y kernels
Message-ID: <YDYLkR+Cq4pFCy/7@kroah.com>
References: <20210219095510.GA24256@chelsio.com>
 <YC+VSJEzXdWdYITx@kroah.com>
 <20210219183823.GA26562@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219183823.GA26562@chelsio.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 20, 2021 at 12:08:25AM +0530, Krishnamraju Eraparaju wrote:
> On Friday, February 02/19/21, 2021 at 11:39:04 +0100, Greg KH wrote:
> > On Fri, Feb 19, 2021 at 03:25:12PM +0530, Krishnamraju Eraparaju wrote:
> > > Hi All,
> > > 
> > > Below commits needs to be backported to 5.10.y kernels to avoid NULL
> > > pointer deref panic(while trying to access 'numa_node' from NULL
> > > 'dma_device'), @ Line:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/nvme/host/rdma.c?h=v5.10.17#n863)
> > > 
> > > commit:22dd4c707673129ed17e803b4bf68a567b2731db 
> > > commit:8ecfca68dc4cbee1272a0161e3f2fb9387dc6930
> > 
> > So just these 2 commits?  In which order?
> > 
> > > The panic is observed at nvme host(provider/transport being SoftiWARP),
> > > while perfroming "nvme discover".
> > > 
> > > Hence, please backport the below patch series to '5.10.y' kernel.
> > >  "https://lore.kernel.org/linux-iommu/20201106181941.1878556-1-hch@lst.de/"
> > 
> > What are the git commit ids of these patches in Linus's tree and have
> > you tested them to ensure that they work?  Why this 10 patch series and
> > not the 2 above?  Or is this a different request?
> > 
> > confused,
> Hi Greg,
> 
> Sorry for the confusion, I didn't know that I can request for the
> backport of selected patches in a patch series.
> As I don't have much background & testing feasability of other patches,
> I request you to backport only below two patches(same order as below):
> 
> commit#1:8ecfca68dc4cbee1272a0161e3f2fb9387dc6930
> RDMA: Lift ibdev_to_node from rds to common code
> author:	Christoph Hellwig <hch@lst.de>
> 
> commit#2:22dd4c707673129ed17e803b4bf68a567b2731db
> nvme-rdma: Use ibdev_to_node instead of dereferencing ->dma_device
> author:	Christoph Hellwig <hch@lst.de>
> 
> And I belive these two patches has no dependency with other patches in
> the series. I've tested, it's working fine.

Now queued up, thanks.

greg k-h
