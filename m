Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75856A662
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 12:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbfGPKUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 06:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731401AbfGPKUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 06:20:54 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48160206C2;
        Tue, 16 Jul 2019 10:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563272453;
        bh=QTpstGqM15RybHt93+XS28mtw0dNSPlxIO3Kq/Y4aOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IHrjVZ4kxV1TK9OnSwQOhTi67RJshFsM8k3U6U4gyGQM2fe5H0hn/dzThQk93VVLX
         P1Iu4h+HH7r76+JY2tfyk0x45V+U9JTf5RBQxGbvGkG6CwZME19BjGrKOipOASvjb6
         18oQ2LBHEijzMP5sRjDoEPdEa4LqwUcdZy7L+owg=
Date:   Tue, 16 Jul 2019 13:20:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry
 comparison
Message-ID: <20190716102050.GL10130@mtr-leonro.mtl.com>
References: <20190715091913.15726-1-selvin.xavier@broadcom.com>
 <20190716071030.GH10130@mtr-leonro.mtl.com>
 <20190716071644.GA21780@kroah.com>
 <20190716084126.GJ10130@mtr-leonro.mtl.com>
 <20190716090917.GA11964@kroah.com>
 <20190716095007.GK10130@mtr-leonro.mtl.com>
 <20190716095852.GA25228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716095852.GA25228@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 06:58:52PM +0900, Greg KH wrote:
> On Tue, Jul 16, 2019 at 12:50:07PM +0300, Leon Romanovsky wrote:
> > On Tue, Jul 16, 2019 at 06:09:17PM +0900, Greg KH wrote:
> > > On Tue, Jul 16, 2019 at 11:41:26AM +0300, Leon Romanovsky wrote:
> > > > On Tue, Jul 16, 2019 at 04:16:44PM +0900, Greg KH wrote:
> > > > > On Tue, Jul 16, 2019 at 10:10:30AM +0300, Leon Romanovsky wrote:
> > > > > > On Mon, Jul 15, 2019 at 05:19:13AM -0400, Selvin Xavier wrote:
> > > > > > > GID entry consist of GID, vlan, netdev and smac.
> > > > > > > Extend GID duplicate check companions to consider vlan_id as well
> > > > > > > to support IPv6 VLAN based link local addresses. Introduce
> > > > > > > a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.
> > > > > > >
> > > > > > > The issue is discussed in the following thread
> > > > > > > https://www.spinics.net/lists/linux-rdma/msg81594.html
> > > > > > >
> > > > > > > Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
> > > > > > > Cc: <stable@vger.kernel.org> # v5.2+
> > > > > > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > > > >
> > > > > > > Co-developed-by: Parav Pandit <parav@mellanox.com>
> > > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > >
> > > > > > I never understood why bad habits are so stinky.
> > > > > >
> > > > > > Can you please explain us what does it mean Co-developed-by and
> > > > > > Signed-off-by of the same person in the same patch?
> > > > >
> > > > > See Documentation/process/submitting-patches.rst for what that tag
> > > > > means.
> > > >
> > > > Read it, it doesn't help me to understand if I should now add
> > > > Co-developed-by tag to most of RDMA Mellanox upstreamed patches,
> > > > which already care my Signed-off-by, because I'm changing and fixing
> > > > them many times.
> > >
> > > It depends, it's your call, if you think you deserve the credit, sure,
> > > add it.  If you are just doing basic "review" where you tell people what
> > > needs to be done better, that's probably not what you need to do here.
> >
> > I'll probably not use this and not because I don't deserve credit, but
> > because it looks ridiculously to me to see my name repeated N times for
> > my work.
>
> That's up to you, and your fellow co-authors to decide.
>
> > > One example, where I just added myself to a patch happened last week
> > > where the developer submitted one solution, I took it and rewrote the
> > > whole implementation (from raw kobjects to using the driver model).  The
> > > original author got the "From:" and I got a Co-developed-by line.
> >
> > In old days, we simply changed Author field if changes were above some
> > arbitrary threshold (usually half of the original patch) and added SOB.
> >
> > Why wasn't this approach enough?
>
> Because we have had some patches where it really was a work of multiple
> people and it is good to show the correct authorship wherever possible.
>
> If you look, this tag was added based on a document in the kernel tree
> that Thomas and I worked on together and we both wanted the "blame" for
> it :)
>
> > > Does that help?
> >
> > Yes, and it makes me wonder when we will need to hire compliance officer
> > who will review all our upstreamed patches to comply with more and more
> > bureaucracy.
>
> Oh come on, this is about the ability to give people credit where they
> did not have it before.  It's not about being "compliant", it's about
> being "nice" and "fair".  Something that no one should complain about.
>
> There is no one forcing you to add this tag to patches with your name on
> it if you do not want to.  But for those who work on changes together,
> it is important to give them that type of credit.

It is partly true, I agree that for my own patches I can do more or less
whatever I want, but my responsibilities are broader and I need to guide
internal development teams on how to develop for upstream and how
to upstream their work later on.

Exactly like Theodore (if I'm not mistaken here) mentioned in last
reply to ksummit thread about meaningful Reviewed-by and Acked-by tags,
I got complains when I changed/fixed inappropriate tags. Now, I'll get
extra complains for not allowing to use Co-... tag too.

So it is not true for my second responsibility, where I must to do it
right and with minimal number of my personal preferences.

This extra documented tag puts me in position where I don't want to
be - in the middle between documentation and personal opinion on not
important thing.

Thanks

>
> thanks,
>
> greg k-h
