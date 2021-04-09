Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E446D35999F
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhDIJnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhDIJnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB5E6611C1;
        Fri,  9 Apr 2021 09:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617961410;
        bh=Dj05UCVcx4wOD8bjMGlyIdpYgd/Rj1GMWa63lFLlKT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VS8wMxVJw2IZPQyASbKNR5kW0xS/aGvl04b/iozEMiWlzFp67MxLoQVY4Wu0UXUQr
         9mYCY3lG2299Oxxgtk2Wp00FcDiI19m6u/WuqLM8+uJSmm7+Pf7fxt5Mf/ugwwT1th
         5ly9sQTLwTCuEOzIVifC97Uc+uEt0WC4IoqAul4A=
Date:   Fri, 9 Apr 2021 11:43:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH stable/5.4..5.8] nvme-mpath: replace direct_make_request
 with generic_make_request
Message-ID: <YHAhv+ruvQwB3bM9@kroah.com>
References: <20210402200841.347696-1-sagi@grimberg.me>
 <YGgG2TAA9TNqM9S6@kroah.com>
 <00e36c71-9f2c-5b38-96fd-3d471382f6ac@grimberg.me>
 <20210407052806.GA18573@lst.de>
 <a1674400-b265-6506-71cb-fd893d3f52c4@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1674400-b265-6506-71cb-fd893d3f52c4@grimberg.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 04:18:30PM -0700, Sagi Grimberg wrote:
> 
> > > > > Hence, we need to fix all the kernels that were before submit_bio_noacct was
> > > > > introduced.
> > > > 
> > > > Why can we not just add submit_bio_noacct to the 5.4 kernel to correct
> > > > this?  What commit id is that?
> > > 
> > > Hey Greg,
> > > 
> > > submit_bio_noacct was applied as part of a rework by Christoph that I
> > > didn't feel was suitable as a stable candidate. The commit-id is:
> > > ed00aabd5eb9fb44d6aff1173234a2e911b9fead
> > 
> > submit_bio_noacct really is just a new name for generic_make_request,
> > as the old one was horribly misleading.  So this does use
> > submit_bio_noacct, just with its old name.
> 
> commit ed00aabd5eb9fb44d6aff1173234a2e911b9fead does not apply
> cleanly on any of these kernels, so I think it's better to take this
> small one-liner instead of trying to fit a commit that changes the
> name treewide.
> 
> Greg, what is your preference? backporting
> ed00aabd5eb9fb44d6aff1173234a2e911b9fead to the various kernels
> or to take this isolated one?

I took just this change now, thanks.

greg k-h
