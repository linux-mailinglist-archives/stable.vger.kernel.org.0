Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0E2D159A
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgLGQJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 11:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgLGQJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 11:09:01 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40EBC06138C
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 08:08:16 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id z5so13829722iob.11
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 08:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GHAU2BinNyNDb7vsAgSD/+Ah65+g0XBO6No6frCdNV8=;
        b=dIAj00jvl9AyxYBLDJoDIosD2BpLsPQqThlMSYgNfyquOCjddhWaOQOoYxFtaZ2IBM
         pKhyfgeQLY9PXQaVpB1af8DlmYdCzfgOc2muhBU6rUrEZIBfJhctC0bNCby1u0z8H1zm
         e1u+lz2qfMIbnUaFX+KYVFqnC8OM/XY0Vl6T4YbGeR846XROY6wPWlrneCuDK7KL5zFN
         /CKHNvkh1Qyw7zh3dY+vfIFVFGJa7tEcESgeE5k/Ud7sO4gkVhi4sX/IPm97ovJbhx2t
         xCaTYw0YgW7eFvGsHs+OcB3uFaWXZRyjwfZanndngF/4XPsO8DjsSDXYXDpl+9BcjeZj
         UBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GHAU2BinNyNDb7vsAgSD/+Ah65+g0XBO6No6frCdNV8=;
        b=uDAcO8iWxIE/oRpSlYDg6zB6E5PmkQxwljPf9McyPQA8A/M6x/rRjXv4miOuw034iJ
         fWQ8rOUqwAErJt/BZfx/jp2hCo1UHxgGbVRpPKEbj0bhfyPbd6Clravty0Zp/IT1/LmK
         vOVB07Id4L8BRz/K5f/43G9arBZfgRvBqoM9i0LMyIxk3ykKxdhWMDLM2WfvTPAIMNte
         orrCpGRvI0Ez3S7nvk1y7uZHXoaHvxwiyzX6MyCmXd5XMxh+j+HKpwpc28qh3vK7FmH6
         x3BlIAHzHLK6dBo3LqWLhEDnPajPq39BMQF/K+nMMJ5RMN0oWehv/O+Oi5JeStugQFL6
         bfLA==
X-Gm-Message-State: AOAM532P8WaInX0c3XvbAXCmQFL11TWhwwG3wTtXAPQKWzZX+/gF1ndi
        UPF5lhQ4fTBM2X3+jPBBkvxltepKHcSy8moEZaAKWw==
X-Google-Smtp-Source: ABdhPJw9GKpPdEroCKMl8B5LqRSKcvyuDKpo+WqAn9cMX5p4qKoawJ23gpLXE4rKZCDpi8MK1jAz/3DoxknRACb0OLo=
X-Received: by 2002:a6b:c8c1:: with SMTP id y184mr20498406iof.99.1607357295960;
 Mon, 07 Dec 2020 08:08:15 -0800 (PST)
MIME-Version: 1.0
References: <4ABEB85B-262F-4657-BB69-4F37ABC0AE3D@amazon.com>
 <20201207114049.7634-1-abuehaze@amazon.com> <CANn89iJb6snL7xCK=x=du_nH_4cCVyNz7zgPNm9AgZWW5m1ZJg@mail.gmail.com>
In-Reply-To: <CANn89iJb6snL7xCK=x=du_nH_4cCVyNz7zgPNm9AgZWW5m1ZJg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 17:08:04 +0100
Message-ID: <CANn89iKnOu4t6xL0SZnaks4CZZuQ-a30sMF=o8Wk8OKL3o6Dyg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix receive buffer autotuning to trigger for any
 valid advertised MSS
To:     Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Wei Wang <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 7, 2020 at 4:37 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Dec 7, 2020 at 12:41 PM Hazem Mohamed Abuelfotoh
> <abuehaze@amazon.com> wrote:
> >
> >     Previously receiver buffer auto-tuning starts after receiving
> >     one advertised window amount of data.After the initial
> >     receiver buffer was raised by
> >     commit a337531b942b ("tcp: up initial rmem to 128KB
> >     and SYN rwin to around 64KB"),the receiver buffer may
> >     take too long for TCP autotuning to start raising
> >     the receiver buffer size.
> >     commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
> >     tried to decrease the threshold at which TCP auto-tuning starts
> >     but it's doesn't work well in some environments
> >     where the receiver has large MTU (9001) especially with high RTT
> >     connections as in these environments rcvq_space.space will be the same
> >     as rcv_wnd so TCP autotuning will never start because
> >     sender can't send more than rcv_wnd size in one round trip.
> >     To address this issue this patch is decreasing the initial
> >     rcvq_space.space so TCP autotuning kicks in whenever the sender is
> >     able to send more than 5360 bytes in one round trip regardless the
> >     receiver's configured MTU.
> >
> >     Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> >     Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
> >
> > Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> > ---
> >  net/ipv4/tcp_input.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 389d1b340248..f0ffac9e937b 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
> >  static void tcp_init_buffer_space(struct sock *sk)
> >  {
> >         int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
> > +       struct inet_connection_sock *icsk = inet_csk(sk);
> >         struct tcp_sock *tp = tcp_sk(sk);
> >         int maxwin;
> >
> >         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
> >                 tcp_sndbuf_expand(sk);
> >
> > -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
> > +       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * icsk->icsk_ack.rcv_mss);
>
> I find using icsk->icsk_ack.rcv_mss misleading.
>
> I would either use TCP_MSS_DEFAULT , or maybe simply 0, since we had
> no samples yet, there is little point to use a magic value.

0 will not work, since we use a do_div(grow, tp->rcvq_space.space)

>
> Note that if a driver uses 16KB of memory to hold a 1500 bytes packet,
> then a 10 MSS GRO packet is consuming 160 KB of memory,
> which is bigger than tcp_rmem[1]. TCP could decide to drop these fat packets.
>
> I wonder if your patch does not work around a more fundamental issue,
> I am still unable to reproduce the issue.
