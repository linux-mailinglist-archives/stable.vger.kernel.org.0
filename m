Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC14D619EDE
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiKDRgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKDRgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:36:08 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED344199E
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:36:06 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r3so6614745yba.5
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 10:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3Gzf6/nexPToRji6N5bO/dL9FXtbk5UeonSa66mO0w=;
        b=RJ1/fYDFtRMRRV1tOozcs1tCUlJ4hIhtltYrdQ8trNvIMsH4D9xeKDU3XEN/RzhS0P
         NNo829xVbvZ4/m7TXi3cpBgoKHU8V2tcxJsuByE4wjNfre3z1+xmXKMZBeVVVI9bSHzT
         MgV++LB+c3iLth3betc4rykAI+DMJsn4nWT5tzbd1f8DGkM8bXTye3sNhGnVShHnUt5e
         Lzq12o38A6inUoSZAiQ+AXiUMD6dxklJA9dx/jqp3t4dAwD6timxHAThVx8/iwmAoZ6M
         NVId/Z27xUnrIAwuzFJnocW/z6hHoPBWiE6arMLAvadcW7QSxurqlWgFejl/vFCYWMhj
         qvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3Gzf6/nexPToRji6N5bO/dL9FXtbk5UeonSa66mO0w=;
        b=VKSKkuWMnwdLNeP8KEYKd/LK7j7uRNnRJmkSsmQME13D9WY6+ltsMjamPYduyFOA5l
         mlqR5uibs/cgeMX8otEpTSBPtMmLqs5v4RImqVtPwU7xxA8/K1sbttiF/KQGrUmg9iOC
         RHpH8m0EcjeGKcgI3cjGUuqNIWWIoIAKpRW5X9cSN8wjQmr8jz6BBnzJuPL4FaQvIX6n
         o8U1GF1jz3v2gZNh6chHBA4gRJtbJrmP60tKr66Oq55PMbFC1cTY7Jv9ADqiKSQVqVJf
         6zLFY5ChISh4+0KM9dhRLUHVFXyta1sqobT4uSIHU+6e1dN63ZHe3qPoTanJdDQHq/k4
         BBfw==
X-Gm-Message-State: ANoB5pl5LuKW2t0ATCUpSDzO4Jfjbk63AbPDpOhC5OBXTy3cIOr9Jqxb
        PB6wlJgnufSVN8RhzAAaupZnH5qBGfoJh3HM/9QIkg==
X-Google-Smtp-Source: AA0mqf5NoDRt6raEcSo5u5nI7z7HAfUPqxb4X7Rxa/1vFG+y2xtdXFj/Z2GR+JHJyyOUNnt5FRnDr6Eq3QJM396H2KE=
X-Received: by 2002:a25:b83:0:b0:6d3:bb1d:305e with SMTP id
 125-20020a250b83000000b006d3bb1d305emr2472905ybl.598.1667583365610; Fri, 04
 Nov 2022 10:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org> <20221102022056.996215743@linuxfoundation.org>
 <20221104171155.GA29661@duo.ucw.cz> <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
 <20221104173140.GA980@duo.ucw.cz>
In-Reply-To: <20221104173140.GA980@duo.ucw.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Nov 2022 10:35:54 -0700
Message-ID: <CANn89iLUdwSytmjOO8TT0pPYTshxc5sZD9H7O0pqU+hPXBc4AQ@mail.gmail.com>
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

On Fri, Nov 4, 2022 at 10:31 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > > > [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
> > > >
> > > > Another syzbot report [1] with no reproducer hints
> > > > at a bug in ip6_gre tunnel (dev:ip6gretap0)
> > > >
> > > > Since ipv6 mcast code makes sure to read dev->mtu once
> > > > and applies a sanity check on it (see commit b9b312a7a451
> > > > "ipv6: mcast: better catch silly mtu values"), a remaining
> > > > possibility is that a layer is able to set dev->mtu to
> > > > an underflowed value (high order bit set).
> > > >
> > > > This could happen indeed in ip6gre_tnl_link_config_route(),
> > > > ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
> > > >
> > > > Make sure to sanitize mtu value in a local variable before
> > > > it is written once on dev->mtu, as lockless readers could
> > > > catch wrong temporary value.
> > >
> > > Ok, but now types seem to be confused:
> > >
> > > > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > > > index 3a2741569b84..0d4cab94c5dd 100644
> > > > --- a/net/ipv6/ip6_tunnel.c
> > > > +++ b/net/ipv6/ip6_tunnel.c
> > > > @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> > > >       struct net_device *tdev = NULL;
> > > >       struct __ip6_tnl_parm *p = &t->parms;
> > > >       struct flowi6 *fl6 = &t->fl.u.ip6;
> > > > -     unsigned int mtu;
> > > >       int t_hlen;
> > > > +     int mtu;
> > > >
> > > >       memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
> > > >       memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> > > > @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> > > >                       dev->hard_header_len = tdev->hard_header_len + t_hlen;
> > > >                       mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
> > >
> > > mtu is now signed, but we still do min_t on unsigned types.
> > >
> > > > -                     dev->mtu = mtu - t_hlen;
> > > > +                     mtu = mtu - t_hlen;
> > > >                       if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> > > > -                             dev->mtu -= 8;
> > > > +                             mtu -= 8;
> > > >
> > >
> > > I don't see overflow potential right away, but it may be worth fixing.
> > >
> >
> > This was intended ( part of the fix) so that the following check is
> > going to catch 'negative' mtu
> >
> > [1]
> > if (mtu < IPV6_MIN_MTU)
> >     mtu = IPV6_MIN_MTU;
> >
> > Otherwise, if a fuzzer succeeds to get mtu = 0xFFFFFFC0,
> > sanity test [1] leaves the problematic mtu in dev->mtu.
>
> This is the line I'm complaining about (1525 in 5.10):
>
> mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
>
> I don't think it does any harm, but it looks wrong/confusing.
>

So you are confused by :

some_integer_var = some_unsigned_int_expression;

I do not see any issue with that.

Thanks.
