Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DA82CF48F
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 20:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgLDTLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 14:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgLDTLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 14:11:02 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D77C061A52
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 11:10:16 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z136so6855977iof.3
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 11:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wV2zw39T+/M6f/BVtnO7Xjsvws9d6e6TeO11acbViOM=;
        b=TZPaaCT6AtDWpDrRLEFQjqC1AAK8M1f1NPuesOWhXsk2CMwaHMxmurUY8i2ho/fGMe
         NKK73YCx9pSrdZSq/DW6CNhl53ezVP/VvpNSHudtJmkud8va9lA7dj6UQjOd3DvULOkm
         x+hYYuk35kAZ3aalMOGnVG8CR4t4+X96KawaBVIFhnYfh5kfzD3HJtrWebz06/MNL2Ev
         oTs3MGBBbYLMhmo9q1XEz6wq++N2DoahjacOjcrKSghRgQYLSZXIBLcwk6gw6CN5WTsd
         VNpIcd7y7Ya1tYhYoNiWZDd/bikOoRwBZy1rL4usLdVbyl+buObEEPHHa5RGX9FCORij
         YGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wV2zw39T+/M6f/BVtnO7Xjsvws9d6e6TeO11acbViOM=;
        b=YJq2Wit1GLkuKtlrCkfc+GcvIOsvj3TI0ghgUlbMwQ4ryT2hzCsA94w4vJE76hy7qJ
         6BFrc065GugMtD7EDL5PiPdfuVyR43mpvxUaHudbyg0dFWBFwRtRya7t2Agrml48dc6d
         XsfRduZRrQL80+bRKM2k8rlHmBaIogiIct3S+8X8rdMcwid0/EbybMoXkrv+7Dg/42Bn
         aQg/ATHyvCkhhxlGXDJ3Ts7JeTS8Bd4mqQXT0DxuTRf8R3Dn8+E0l+uixCsOxCRvV7n0
         RX87fO1pNpM8iaUVjVpWynltwoCpGTXbDLU/HwkLoMID6yLvFVmjCa3bvTiIP9P1PFod
         DHqw==
X-Gm-Message-State: AOAM533tpFAz5SEk4159m0liY7kgGvThsdkQpPBf372bDBhyzPuvVHgM
        R+L/rE/k7ljPSnfJ8kRG0jNCbNcUdVlAYbVCMBF0Jw==
X-Google-Smtp-Source: ABdhPJw7ZxY6DIc+ReGLzFWFF9zz7LuyV0IuCWV+jyrBzOxXDqOKpAc4a3gmDnkre0qoKlQLvb4/ZxnxPyOlW79gJ/w=
X-Received: by 2002:a6b:c8c1:: with SMTP id y184mr8023478iof.99.1607109015532;
 Fri, 04 Dec 2020 11:10:15 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com>
In-Reply-To: <20201204180622.14285-1-abuehaze@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Dec 2020 20:10:04 +0100
Message-ID: <CANn89iL1BkSyE=iSigZxvVB4_59QjWBY_5GuSoH8rcAaZ84EUg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
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

On Fri, Dec 4, 2020 at 7:08 PM Hazem Mohamed Abuelfotoh
<abuehaze@amazon.com> wrote:
>
>     Previously receiver buffer auto-tuning starts after receiving
>     one advertised window amount of data.After the initial
>     receiver buffer was raised by
>     commit a337531b942b ("tcp: up initial rmem to 128KB
>     and SYN rwin to around 64KB"),the receiver buffer may
>     take too long for TCP autotuning to start raising
>     the receiver buffer size.
>     commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>     tried to decrease the threshold at which TCP auto-tuning starts
>     but it's doesn't work well in some environments
>     where the receiver has large MTU (9001) configured
>     specially within environments where RTT is high.
>     To address this issue this patch is relying on RCV_MSS
>     so auto-tuning can start early regardless
>     the receiver configured MTU.
>
>     Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
>     Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>
> Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 389d1b340248..f0ffac9e937b 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
>  static void tcp_init_buffer_space(struct sock *sk)
>  {
>         int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         int maxwin;
>
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>
> -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
> +       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * icsk->icsk_ack.rcv_mss);

So are you claiming icsk->icsk_ack.rcv_mss is related to MTU 9000 ?

RCV_MSS is not known until we receive actual packets... The initial
value is somthing like 536 if I am not mistaken.

I think your patch does not match the changelog.

>         tcp_mstamp_refresh(tp);
>         tp->rcvq_space.time = tp->tcp_mstamp;
>         tp->rcvq_space.seq = tp->copied_seq;
> --
> 2.16.6
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
>
>
>
