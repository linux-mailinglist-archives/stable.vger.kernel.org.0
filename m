Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89C4619E9F
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiKDRZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiKDRYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:24:42 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2669E25DC
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:23:44 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-37063f855e5so49708877b3.3
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 10:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qjeSPcfZKsfnrVevxgSeMkvqmACOU3/OJEjGUxStCPE=;
        b=Hc8xWNdGHH0Jju5ZVWxwrwy0Q+Xj2WiAaA5nT4BYBXQuB/dJr4yeV2LKi4x0ezIguw
         k1c5MLbf0m3HIJeijOFHdpBa/gxkB9OZT7lkdubqxU/NgJ+/YlHnh9GOUiOItq+ca6tT
         PFGzH6AEIfHyF225+4Rw9fXgOQkZd8Ex7gzM1D+40FTDkWblJVLzI3H1nM3os7po/+fd
         9bTBlqch2pDoiZFxbbqtHweTj8t16Ml7kk8mz3NeQ0L9+2YZn4gmFFaFUxwAnPL/UU6t
         b1bsSXWNPMofYF44HsPlDOSVm5mves0msDE3R+QjkwJ1ajGGCtzRhtUm+Y8GinnOWgf2
         cr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjeSPcfZKsfnrVevxgSeMkvqmACOU3/OJEjGUxStCPE=;
        b=ha84+A1KedK15SPKNUYlD0QyTEoggjOODsfEuigbj6YrMsrN1TdIKxmiu88bQIv06g
         agKKSPeqarnfwnuVLbQqBY7kk2zrv9xZbim87rZw1Bg0gCrf0Y0I2Fq3rtF3OPOuhEKe
         COy+DDEAxEQkRENxTF7GUSBGNK9tYqpEUkEayt8GwUBtYYxu/noq4RESSD4C+o6cLCo4
         dr1h6VNkeDK3tuUyXugVFfA30x9vfEceYrBVBChe7Mt8qS7h5RaJz4kdjR9qLIPfj64H
         MdpioX+VifDfGDdhloswSFTySQik0lEpcw4+5fb4Us0gWrXDaUsY6CjIomfqdFze5QZD
         I23w==
X-Gm-Message-State: ACrzQf1O4p8QY2rUzWMvhPxfWsZ8YTJY9LWbQzJxEUQdDOVXDUN7p5S5
        sSxYVyQaqx8CkU0i+t9zGIAtICP9txfbMR7pfcD8VltFzbXVsw==
X-Google-Smtp-Source: AMsMyM7TAGfxSN3KjUNx0FJxNdz1y5kpNt0VqpDfMd/ts5Oq8a3j/gb56UqXzHwTXbEOlKxtO7l9CFhYqTv9xhWuC6w=
X-Received: by 2002:a81:5a86:0:b0:36f:cece:6efd with SMTP id
 o128-20020a815a86000000b0036fcece6efdmr34064709ywb.489.1667582623102; Fri, 04
 Nov 2022 10:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org> <20221102022056.996215743@linuxfoundation.org>
 <20221104171155.GA29661@duo.ucw.cz>
In-Reply-To: <20221104171155.GA29661@duo.ucw.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Nov 2022 10:23:32 -0700
Message-ID: <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 4, 2022 at 10:11 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
> >
> > Another syzbot report [1] with no reproducer hints
> > at a bug in ip6_gre tunnel (dev:ip6gretap0)
> >
> > Since ipv6 mcast code makes sure to read dev->mtu once
> > and applies a sanity check on it (see commit b9b312a7a451
> > "ipv6: mcast: better catch silly mtu values"), a remaining
> > possibility is that a layer is able to set dev->mtu to
> > an underflowed value (high order bit set).
> >
> > This could happen indeed in ip6gre_tnl_link_config_route(),
> > ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
> >
> > Make sure to sanitize mtu value in a local variable before
> > it is written once on dev->mtu, as lockless readers could
> > catch wrong temporary value.
>
> Ok, but now types seem to be confused:
>
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index 3a2741569b84..0d4cab94c5dd 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> >       struct net_device *tdev = NULL;
> >       struct __ip6_tnl_parm *p = &t->parms;
> >       struct flowi6 *fl6 = &t->fl.u.ip6;
> > -     unsigned int mtu;
> >       int t_hlen;
> > +     int mtu;
> >
> >       memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
> >       memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> > @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> >                       dev->hard_header_len = tdev->hard_header_len + t_hlen;
> >                       mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
>
> mtu is now signed, but we still do min_t on unsigned types.
>
> > -                     dev->mtu = mtu - t_hlen;
> > +                     mtu = mtu - t_hlen;
> >                       if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> > -                             dev->mtu -= 8;
> > +                             mtu -= 8;
> >
>
> I don't see overflow potential right away, but it may be worth fixing.
>

This was intended ( part of the fix) so that the following check is
going to catch 'negative' mtu

[1]
if (mtu < IPV6_MIN_MTU)
    mtu = IPV6_MIN_MTU;

Otherwise, if a fuzzer succeeds to get mtu = 0xFFFFFFC0,
sanity test [1] leaves the problematic mtu in dev->mtu.

Thanks.
