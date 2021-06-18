Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100F33AC80F
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhFRJz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhFRJz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 05:55:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D5EC061574;
        Fri, 18 Jun 2021 02:53:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r7so7768804edv.12;
        Fri, 18 Jun 2021 02:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KphIuuhm2yqQlp9qrgGfS/PVG7WOVx1GZqsoFWVz/zo=;
        b=fou6MqTcxNm/sRTvOMI5UbAYgRO2oSqp7ClWJ6B8nL5sII3dMrIS/cdcExgi/g0flZ
         mNrf4HqY8F69jKEAz7pTW6BJdNfpmjneTRpJvN5jBP5xcOu+MlC+h7rDDcF1N6aNSDKc
         IjHQDCQzl4h7T6/C/b/TNR0jU7mtq4Lb7TP081HUwzeHk8rXh1FO5kch0kW2II0HJaWr
         2xSWecdwXbi3LNeoyugiez3x9EHAkWyZTVzBdtPpfzKyDP3pmtmG/cug3d6aVFDOQEgs
         2Fu5UWm8fuORY7FwnLR4wFtxR8zj1R4yu6oi27J9L4J6Hph6KUuFFo7OJa2NGuk6xdgv
         QlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KphIuuhm2yqQlp9qrgGfS/PVG7WOVx1GZqsoFWVz/zo=;
        b=rmCf6o/iLmTfbY0OgjW0dUzzSpLBmQN0Kv1CGivwAg/0QpmvfubEJ3lM260oD2DlKN
         mvCbJHOYFbDBHZWQaZGOWB0/BZ0KOgnb+ltyN7dXeu1YqknXbmmVu6IVvNP8T7bJPmoa
         W6JfokauVWViufdl2Ueirei/mmzAVBHLAWfzoep2iNPae/QeVMY1ZnRZPWyJrPcjQhMz
         SHSKFF0zMgFzY5ABm1ZPl3uYgTSDvws+3G8A5gY/V+6mQjbIQGmsG5VG0T5mFS+ax7uq
         dzU1olZMZkekCoE6FYA1b8QHKB1YphrMBR1X7CzlV+gU7eD3Z91zD1ABUsYRPGy+aqYT
         fPAw==
X-Gm-Message-State: AOAM5320r3Wcmlu4Welwe7aj69jnPCByEf+un39QkqY0scaTiCrmnPOL
        HmZIT7dkCiN/K4YBoog80uPew8gZM7/tCSuQUkM=
X-Google-Smtp-Source: ABdhPJxOrUaBqcE61H02ZwPi8pgyQKHafQ4qIrbTESBbsR8RfA/yufUwS9W/Voq8ONktJM6OoDu+m9Hx3d4ajx7yecI=
X-Received: by 2002:a50:d943:: with SMTP id u3mr3884499edj.175.1624010024795;
 Fri, 18 Jun 2021 02:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com> <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <YMoRNZYXoykO7mk0@kroah.com>
In-Reply-To: <YMoRNZYXoykO7mk0@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Fri, 18 Jun 2021 12:53:33 +0300
Message-ID: <CANEQ_+JwAvcHFN__41-QxTSqXo7RfDLbTZ-t3S51zsyqkpw=PQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just submitted a revised patch for 4.14. Sorry for the earlier blunder.

On Wed, Jun 16, 2021 at 5:56 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 16, 2021 at 12:16:52PM +0300, Amit Klein wrote:
> > Here is the patch (minus headers, description, etc. - I believe these
> > can be copied as is from the 5.x patch, but not sure about the
> > rules...). It can be applied to 4.14.236. If this is OK, I can move on
> > to 4.9 and 4.4.
> >
> >
> >  net/ipv4/route.c | 41 ++++++++++++++++++++++++++++-------------
> >  1 file changed, 28 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 78d6bc61a1d8..022a2b748da3 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -70,6 +70,7 @@
> >  #include <linux/types.h>
> >  #include <linux/kernel.h>
> >  #include <linux/mm.h>
> > +#include <linux/memblock.h>
> >  #include <linux/string.h>
> >  #include <linux/socket.h>
> >  #include <linux/sockios.h>
> > @@ -485,8 +486,10 @@ static void ipv4_confirm_neigh(const struct
> > dst_entry *dst, const void *daddr)
> >      __ipv4_confirm_neigh(dev, *(__force u32 *)pkey);
> >  }
> >
> > -#define IP_IDENTS_SZ 2048u
> > -
> > +/* Hash tables of size 2048..262144 depending on RAM size.
> > + * Each bucket uses 8 bytes.
> > + */
> > +static u32 ip_idents_mask __read_mostly;
> >  static atomic_t *ip_idents __read_mostly;
> >  static u32 *ip_tstamps __read_mostly;
> >
> > @@ -496,12 +499,16 @@ static u32 *ip_tstamps __read_mostly;
> >   */
> >  u32 ip_idents_reserve(u32 hash, int segs)
> >  {
> > -    u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
> > -    atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
> > -    u32 old = ACCESS_ONCE(*p_tstamp);
> > -    u32 now = (u32)jiffies;
> > +    u32 bucket, old, now = (u32)jiffies;
> > +    atomic_t *p_id;
> > +    u32 *p_tstamp;
>
> Your patch is corrupted and couldn't be applied if I wanted to :(
>
