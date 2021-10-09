Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80730427781
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 07:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhJIFVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 01:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhJIFVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 01:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81E8760F6F;
        Sat,  9 Oct 2021 05:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633756782;
        bh=pUE5rhYEEacp7Estu/aEsIop9rFkTz0XLUt7TITMCkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0xTJqu6aVf9jaa4PLDGjfFS3RUIyELChdiht3fzkIZ5ZiESPsFFHibGA5cDwzRv8Z
         mWs9N7bhubOo/AThkvV5tot0U+wVD961DLdlDOdYfi8ctOjwrVj8g1duJQMO0UE4Bm
         qb4kopNX0ufpuntGQ5bRrlA0jqaXF1MC59+JWPDg=
Date:   Sat, 9 Oct 2021 07:19:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        stable@vger.kernel.org
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YWEma6YvB2HN9/E/@kroah.com>
References: <YV/8Ia1d9zXvMqqc@kroah.com>
 <1633710428.4908655-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1633710428.4908655-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 09, 2021 at 12:27:08AM +0800, Xuan Zhuo wrote:
> On Fri, 8 Oct 2021 10:06:57 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Oct 08, 2021 at 12:17:26AM +0800, Xuan Zhuo wrote:
> > > On Thu, 7 Oct 2021 17:25:02 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Thu, Oct 07, 2021 at 11:06:12PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 07 Oct 2021 14:04:22 +0200, Corentin Noël <corentin.noel@collabora.com> wrote:
> > > > > > I've been experiencing crashes with 5.14-rc1 and above that do not
> > > > > > occur with 5.13,
> > > > >
> > > > > I should have fixed this problem before. I don't know why, I just looked at the
> > > > > latest net code, and this commit seems to be lost.
> > > > >
> > > > >      1a8024239dacf53fcf39c0f07fbf2712af22864f virtio-net: fix for skb_over_panic inside big mode
> > > > >
> > > > > Can you test this patch again?
> > > >
> > > > That commit showed up in 5.13-rc5, so 5.14-rc1 and 5.13 should have had
> > > > it in it, right?
> > > >
> > >
> > > Yes, it may be lost due to conflicts during a certain merge.
> >
> > Really?  I tried to apply that again to 5.14 and it did not work.  So I
> > do not understand what to do here, can you try to explain it better?
> 
> I took a look, and there is actually another missing patch:
> 
> A. 8fb7da9e990793299c89ed7a4281c235bfdd31f8 virtio_net: get build_skb() buf by data ptr
> B. 1a8024239dacf53fcf39c0f07fbf2712af22864f virtio-net: fix for skb_over_panic inside big mode
> 
> A is replaced by another patch:
> 
> 	commit c32325b8fdf2f979befb9fd5587918c0d5412db3
> 	Author: Jakub Kicinski <kuba@kernel.org>
> 	Date:   Mon Aug 2 10:57:29 2021 -0700
> 
> 	    virtio-net: realign page_to_skb() after merges
> 
> 	    We ended up merging two versions of the same patch set:
> 
> 	    commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> 	    commit 5c37711d9f27 ("virtio-net: fix for unable to handle page fault for address")
> 
> 	    into net, and
> 
> 	    commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
> 	    commit 6c66c147b9a4 ("virtio-net: fix for unable to handle page fault for address")
> 
> 	    into net-next. Redo the merge from commit 126285651b7f ("Merge
> 	    ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), so that
> 	    the most recent code remains.
> 
> 	    Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 	    Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 	    Acked-by: Jason Wang <jasowang@redhat.com>
> 	    Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> So after this patch, patch B can be applied normally.
> 
> So on the latest net branch, only lost
> 
>           1a8024239dacf53fcf39c0f07fbf2712af22864f virtio-net: fix for skb_over_panic inside big mode

Again, I do not know what to do here, can you submit the needed fix to
the networking developers so this gets fixed?

thanks,

greg k-h
