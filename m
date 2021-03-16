Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B610E33D12B
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCPJwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbhCPJwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:52:49 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DE4C06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:52:48 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id f145so19755031ybg.11
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kfVxFqytKWqvy1UjxUsD9Fb71TDdqI2Pc9nXwmKc2jg=;
        b=IAS6QbnNjP8iASJwity5wb7YMdd9LHdCP+PF/HGFeaggwz8Vc4Kpjiagtj65EAZx/l
         NgmtvZP4uP+70kuOwG9xMuov9gZP2ebqZzNf5GfJ4iw2u+rDg4yzHh26zxjpP9UP8u7m
         iTH7tynS/iz3fTu5rjEroN41odvl9hNn4u8MLY4WCYnHkkDATct81RhE7W45CsLiPxSj
         YX7LY/cmdixq/xI52h/mY+H39p4SImYZP9Xlq5FRDuAwr9IsKKd2CJttwkU5AYF6eanF
         bOakjn/NbSCEVfzoXRSJgZMWJ5Aqir0Nf96/5aluSTR24QruxXpfVS9VGjvMSL3cb/6E
         AEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kfVxFqytKWqvy1UjxUsD9Fb71TDdqI2Pc9nXwmKc2jg=;
        b=oR588z49J7/I03N6kRTpVqEfyFIqKVHNL+o2vRtwtJSOoL9wUR2jrChYXY1P/lIs3k
         RA+JtoNL4dvXSKC+zMTZcKw91mdOgqfnpZY93aD+iig5h3DMJpxzV9mp4kqIBRh7h8ck
         Ne33VX/EX1XpsEC/xdsxc9qtvp2Q+yqFn4PZs62suJ1cDhxDXaymxH2pvb01B5y3pZ8E
         WPLjF0biQ43xebNWQYJFjM92dvpLQ5pjjoLMKtwvRxY+KXR1jET0lQ8LMjLIoc9cpU0F
         8rbXInIPUuR2tWE2Tt6Bdn8aV1lby6dEW1280rzH58SnP4P3hpIvaWESmdDpklyw0sxv
         7xAQ==
X-Gm-Message-State: AOAM530LzBLXcxvCPA1hfcVIsEDIHBYdauHIQpO182HCTm9xlBtqMud2
        7/l+RPce7lFvCQHR7F08Oe+ccDAyx+snNq5OXK+/sgbpOut/Xw==
X-Google-Smtp-Source: ABdhPJxoEvSlfVG7oICEoQmecYUhOt4c7CbpPOIWdYZw7ZsFGZP9Jw6P0DQGaXW7Ny+DOc+ihi4tIJYGYfOU5OEP7oc=
X-Received: by 2002:a25:ac52:: with SMTP id r18mr5626572ybd.303.1615888367899;
 Tue, 16 Mar 2021 02:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135720.002213995@linuxfoundation.org> <20210315135720.418426545@linuxfoundation.org>
 <20210316095049.GB12946@amd>
In-Reply-To: <20210316095049.GB12946@amd>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Mar 2021 10:52:36 +0100
Message-ID: <CANn89i+kZv9H2fKgSVLh4iDMT0kEu286YySt-m3RnXJxBLmmWw@mail.gmail.com>
Subject: Re: [PATCH 4.19 012/120] tcp: annotate tp->write_seq lockless reads
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 10:50 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > From: Eric Dumazet <edumazet@google.com>
>
> Dup.
>
>
> > We need to add READ_ONCE() annotations, and also make
> > sure write sides use corresponding WRITE_ONCE() to avoid
> > store-tearing.
>
> > @@ -1037,7 +1037,7 @@ new_segment:
> >               sk->sk_wmem_queued += copy;
> >               sk_mem_charge(sk, copy);
> >               skb->ip_summed = CHECKSUM_PARTIAL;
> > -             tp->write_seq += copy;
> > +             WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
> >               TCP_SKB_CB(skb)->end_seq += copy;
> >               tcp_skb_pcount_set(skb, 0);
> >
>
> I wonder if this needs to do READ_ONCE, too?

No, because we hold the socket lock.

This is a backport to ease another backport, please try to review
patches when they hit mainline, if you have any concerns.

>
> > @@ -1391,7 +1391,7 @@ new_segment:
> >               if (!copied)
> >                       TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
> >
> > -             tp->write_seq += copy;
> > +             WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
> >               TCP_SKB_CB(skb)->end_seq += copy;
> >               tcp_skb_pcount_set(skb, 0);
> >
>
> And here.
>
> > @@ -2593,9 +2594,12 @@ int tcp_disconnect(struct sock *sk, int
> >       sock_reset_flag(sk, SOCK_DONE);
> >       tp->srtt_us = 0;
> >       tp->rcv_rtt_last_tsecr = 0;
> > -     tp->write_seq += tp->max_window + 2;
> > -     if (tp->write_seq == 0)
> > -             tp->write_seq = 1;
> > +
> > +     seq = tp->write_seq + tp->max_window + 2;
> > +     if (!seq)
> > +             seq = 1;
> > +     WRITE_ONCE(tp->write_seq, seq);
>
> And here.
>
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(co
> >       newtp->app_limited = ~0U;
> >
> >       tcp_init_xmit_timers(newsk);
> > -     newtp->write_seq = newtp->pushed_seq = treq->snt_isn + 1;
> > +     WRITE_ONCE(newtp->write_seq, newtp->pushed_seq = treq->snt_isn + 1);
>
> Would it be better to do assignment to pushed_seq outside of
> WRITE_ONCE macro? This is ... "interesting".
>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
