Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F365016AA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245071AbiDNPJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 11:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351923AbiDNObk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 10:31:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DB8BF50C;
        Thu, 14 Apr 2022 07:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 504B5CE29FC;
        Thu, 14 Apr 2022 14:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA04C385A5;
        Thu, 14 Apr 2022 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649946153;
        bh=6KHWLF00LdDXTDsdgdSMyyxznGVeWW993v3+X2qt0e0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PBEkFKJ1s98l6NEJRKoRHtb6+6FM5cxc40HbkdUTsgDlNZ9lDwiZj9gKVt3WfGzmA
         jfgjMH0c5qHiApceeazD6KGu81VEiZNHWnuWxSmjqxzhDqtIJ7M3TE/khjETpJKgdh
         mxCNH+MCaj8Z8YfclR5HtztOBmrv+BEwMghTBQeHuom4bXzQcD0ZKmESSsfbHb8Vaw
         fP+E5sZ8Df3HG4YtfBBrubMEWhmFa0HhiBTOxvGCH3juFQfuxX5RJ1bN+N1OGELF5m
         2YauZSbdnnJ6Fz676KPzz1WhebryuQpzkZqKkGi9NgB4mxFB0NwkwJBU7nNWripu9b
         ZGg7u+XCylsmw==
Received: by mail-oi1-f177.google.com with SMTP id w127so5511639oig.10;
        Thu, 14 Apr 2022 07:22:33 -0700 (PDT)
X-Gm-Message-State: AOAM533dNJsme3OKzY4RViw/q5z+ntiQMVNZbYwAW20wikOn/BHQfrYX
        I+dfR/+5Yv9iIfP2ErYyAFFnVwMdBdLa0vHcGKA=
X-Google-Smtp-Source: ABdhPJz0hXNO3bGfmO9eIett9cTqRcuRl2zxrNPqfzDqkzq9oHtV4CR9+PYBW8D9Xd8Z3skzhx8tw2bwUTQPDjfiDQc=
X-Received: by 2002:a05:6808:1513:b0:2fa:7a40:c720 with SMTP id
 u19-20020a056808151300b002fa7a40c720mr1452810oiw.126.1649946152949; Thu, 14
 Apr 2022 07:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org> <20220414110844.817011928@linuxfoundation.org>
 <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
 <Ylgi3Nh8mbAOvXi6@kroah.com> <CAMj1kXFwQ+WrM4G=xa5+1CVd0z3RDLRUbFnpYRirWVHwbtvXGg@mail.gmail.com>
 <Ylgty0IzV+5i4T0g@kroah.com>
In-Reply-To: <Ylgty0IzV+5i4T0g@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Apr 2022 16:22:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG_+e_oy91umztu5tD6T=jdLdUrFGL03ckVtBiJgY7qEw@mail.gmail.com>
Message-ID: <CAMj1kXG_+e_oy91umztu5tD6T=jdLdUrFGL03ckVtBiJgY7qEw@mail.gmail.com>
Subject: Re: [PATCH 4.19 208/338] ARM: ftrace: avoid redundant loads or
 clobbering IP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022 at 16:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 14, 2022 at 04:13:06PM +0200, Ard Biesheuvel wrote:
> > On Thu, 14 Apr 2022 at 15:57, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Apr 14, 2022 at 03:25:29PM +0200, Ard Biesheuvel wrote:
> > > > On Thu, 14 Apr 2022 at 15:23, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > > >
> > > > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > > > >
> > > >
> > > > NAK. Please don't backport these patches to -stable, I thought I had
> > > > been clear on this.
> > >
> > > I dropped the patches you asked to be dropped, but this is a different
> > > one and is already in the following releases:
> > >         5.10.110 5.15.33 5.16.19 5.17.2
> > >
> > > I can also drop it from here and the 5.4 queue if you do not want it
> > > there.
> > >
> >
> > This is not how I remember it:
> >
> > On Tue, 5 Apr 2022 at 18:52, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> > > > On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > > >
> > > > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > > > >
> > ..
> > > >
> > > > Please drop all the 32-bit ARM patches authored by me from the stable
> > > > queues except the ones that have fixes tags. These are highly likely
> > > > to cause an explosion of regressions, and they should have never been
> > > > selected, as I don't remember anyone proposing these for stable.
> > >
> > > From what I can tell, that is only this commit.  I'll go drop it from
> > > all trees, thanks.
> > >
> >
> > Can you *please* exclude all patches authored by me from consideration
> > by this bot? Consider this a blanket NAK to all AUTOSEL patches cc'ed
> > to me.
>
> Ick, I thought I dropped this from everywhere, very odd, sorry about
> that.  Ah, I dropped dd88b03ff0c8 ("ARM: ftrace: ensure that ADR takes
> the Thumb bit into account"), not this one.  {sigh}
>

Ah, that's the only one that did have a fixes: tag :-)
