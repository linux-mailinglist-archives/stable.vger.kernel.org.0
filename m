Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9357426755
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 12:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhJHKEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 06:04:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239609AbhJHKEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 06:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633687347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DYJJAEUu6hqgETTgE/jfMVtd0sOV59xWOXw/Ng2Zkk=;
        b=AKXG9IFLhoTMN/2h6V8k0izor9Tv4o0cLcBsR5j3ENsjEFV7PkWc6CxN7+ye5hpsDgY6KB
        2rpQHIUj1oY5fVa50P2hLvbERliQxJ/L1MLGq7O87ZLKPqSgi5+doMM4i30BSYT5dz5SF0
        YGXBC1CyuIgKZeozr7QN1bNkIyjPKtA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-mP9u8l-bOpy-4H_lnABGcQ-1; Fri, 08 Oct 2021 06:02:25 -0400
X-MC-Unique: mP9u8l-bOpy-4H_lnABGcQ-1
Received: by mail-ed1-f69.google.com with SMTP id p20-20020a50cd94000000b003db23619472so8700821edi.19
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 03:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/DYJJAEUu6hqgETTgE/jfMVtd0sOV59xWOXw/Ng2Zkk=;
        b=5bP0l/IeOIC7Q1VIZUD8UwbaGfApOtwxvRpmiYmficwNnV3ZaeElez1eASS+nzK+4k
         ZneJIq/I1d2Yy/e/iAZxlHhpwIJj5/wnF83r48S0BxmhWMy0xn2g6EN+R97u8QTYCpVO
         sIQOA2q9sVGMfNLXliHtNmUdN2K+yljQgBJeqEYb6yIDuPMPZe0o8z3HKOuvmzn7CfEy
         Sdegp4WndmOOxc7NMCOHJ9Lw/IMvquM6nMLIvN6soX3YM63MVpAbokvwOR8VO2PUL2Ty
         oCNFUak3i051KV3JQYKDjdTyNj1LcA/CyR297pElKoARVmcKnJDxpL0Xfnf4eO+VtWPm
         hVkg==
X-Gm-Message-State: AOAM532UL+KYX3CM43fpZ62vIa4fxU5Z6/oxjHojkif6IrWG4p0fxou3
        i6y2v4my0zui+66rZaWJXotdSc0eYHTQo1fhptitoA0HL9OPM69P77/0ULEqvDzoo+b47HjLfeG
        REm6Zn+nAG0En4J0d
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr14198457edw.379.1633687344436;
        Fri, 08 Oct 2021 03:02:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCXcDy+V1Ve+4wDUmBknbIZIJdSTIfRrrkzU3KaFgOcLrOJufywV2OgzBitVmiWIDaj6yP9Q==
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr14198441edw.379.1633687344249;
        Fri, 08 Oct 2021 03:02:24 -0700 (PDT)
Received: from redhat.com ([2.55.132.170])
        by smtp.gmail.com with ESMTPSA id l6sm804400edt.21.2021.10.08.03.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 03:02:23 -0700 (PDT)
Date:   Fri, 8 Oct 2021 06:02:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        stable@vger.kernel.org
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <20211008055902-mutt-send-email-mst@kernel.org>
References: <YV8RTqGSTuVLMFOP@kroah.com>
 <1633623446.6192446-1-xuanzhuo@linux.alibaba.com>
 <YV/8Ia1d9zXvMqqc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YV/8Ia1d9zXvMqqc@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 10:06:57AM +0200, Greg KH wrote:
> On Fri, Oct 08, 2021 at 12:17:26AM +0800, Xuan Zhuo wrote:
> > On Thu, 7 Oct 2021 17:25:02 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Thu, Oct 07, 2021 at 11:06:12PM +0800, Xuan Zhuo wrote:
> > > > On Thu, 07 Oct 2021 14:04:22 +0200, Corentin Noël <corentin.noel@collabora.com> wrote:
> > > > > I've been experiencing crashes with 5.14-rc1 and above that do not
> > > > > occur with 5.13,
> > > >
> > > > I should have fixed this problem before. I don't know why, I just looked at the
> > > > latest net code, and this commit seems to be lost.
> > > >
> > > >      1a8024239dacf53fcf39c0f07fbf2712af22864f virtio-net: fix for skb_over_panic inside big mode
> > > >
> > > > Can you test this patch again?
> > >
> > > That commit showed up in 5.13-rc5, so 5.14-rc1 and 5.13 should have had
> > > it in it, right?
> > >
> > 
> > Yes, it may be lost due to conflicts during a certain merge.
> 
> Really?  I tried to apply that again to 5.14 and it did not work.  So I
> do not understand what to do here, can you try to explain it better?
> 
> thanks,
> 
> greg k-h

Hmm, something like the following perhaps then?
Corentin would you like to try this?
Warning: untested.


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 096c2ac6b7a6..18dd9f6d107d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -406,12 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
 	 */
 	truesize = headroom ? PAGE_SIZE : truesize;
-	tailroom = truesize - len - headroom;
+	tailroom = truesize - headroom;
 	buf = p - headroom;
 
 	len -= hdr_len;
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
+	tailroom -= hdr_padded_len + len;
 
 	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 

