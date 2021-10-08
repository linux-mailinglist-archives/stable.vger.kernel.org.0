Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57426426A9D
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhJHMXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 08:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJHMXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 08:23:50 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ACFC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 05:21:55 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tintou)
        with ESMTPSA id 29DBE1F458C8
Message-ID: <3add681784c849872bcff931388ae2fb4c9901a2.camel@collabora.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
From:   Corentin =?ISO-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        stable@vger.kernel.org
Date:   Fri, 08 Oct 2021 14:21:45 +0200
In-Reply-To: <20211008055902-mutt-send-email-mst@kernel.org>
References: <YV8RTqGSTuVLMFOP@kroah.com>
         <1633623446.6192446-1-xuanzhuo@linux.alibaba.com>
         <YV/8Ia1d9zXvMqqc@kroah.com>
         <20211008055902-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le vendredi 08 octobre 2021 à 06:02 -0400, Michael S. Tsirkin a écrit :
> On Fri, Oct 08, 2021 at 10:06:57AM +0200, Greg KH wrote:
> > On Fri, Oct 08, 2021 at 12:17:26AM +0800, Xuan Zhuo wrote:
> > > On Thu, 7 Oct 2021 17:25:02 +0200, Greg KH <
> > > gregkh@linuxfoundation.org> wrote:
> > > > On Thu, Oct 07, 2021 at 11:06:12PM +0800, Xuan Zhuo wrote:
> > > > > On Thu, 07 Oct 2021 14:04:22 +0200, Corentin Noël <
> > > > > corentin.noel@collabora.com> wrote:
> > > > > > I've been experiencing crashes with 5.14-rc1 and above that
> > > > > > do not
> > > > > > occur with 5.13,
> > > > > 
> > > > > I should have fixed this problem before. I don't know why, I
> > > > > just looked at the
> > > > > latest net code, and this commit seems to be lost.
> > > > > 
> > > > >      1a8024239dacf53fcf39c0f07fbf2712af22864f virtio-net: fix
> > > > > for skb_over_panic inside big mode
> > > > > 
> > > > > Can you test this patch again?
> > > > 
> > > > That commit showed up in 5.13-rc5, so 5.14-rc1 and 5.13 should
> > > > have had
> > > > it in it, right?
> > > > 
> > > 
> > > Yes, it may be lost due to conflicts during a certain merge.
> > 
> > Really?  I tried to apply that again to 5.14 and it did not
> > work.  So I
> > do not understand what to do here, can you try to explain it
> > better?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hmm, something like the following perhaps then?
> Corentin would you like to try this?
> Warning: untested.
> 
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 096c2ac6b7a6..18dd9f6d107d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,12 +406,13 @@ static struct sk_buff *page_to_skb(struct
> virtnet_info *vi,
>  	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>  	 */
>  	truesize = headroom ? PAGE_SIZE : truesize;
> -	tailroom = truesize - len - headroom;
> +	tailroom = truesize - headroom;
>  	buf = p - headroom;
>  
>  	len -= hdr_len;
>  	offset += hdr_padded_len;
>  	p += hdr_padded_len;
> +	tailroom -= hdr_padded_len + len;
>  
>  	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  
> 

Thank you for the patch, I started bisecting the issue but your patch
actually makes it work again.

Regards,
Corentin

