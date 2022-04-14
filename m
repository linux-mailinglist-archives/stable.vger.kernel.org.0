Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321335016AC
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiDNPJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 11:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350144AbiDNOVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 10:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BB3BF019;
        Thu, 14 Apr 2022 07:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18ED061EDE;
        Thu, 14 Apr 2022 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A964C385A9;
        Thu, 14 Apr 2022 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649945598;
        bh=O2j8QmGGCbxSuuXx/g5kDa3DRaSfCxpFwD5IxKqExPA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OGCariBz9xUcR/9uWegnuZoa0AJblOM4su4snkh/cWQLrco1Hy3xxkJQ4un8mKZKI
         slaFL0BugVW9yG2QtLMjCJ9U74kc7ap/CwqSflHQg4uIYVcH0yq8GHpnvPmKeFmY7d
         A2v3Edpg+VDTOUYGQ/CL/Vwh3lG0zzm+nib2ZwQpS5j6+P58DRC6d+GXhRMhFLBEgC
         SPQvuM+GDuq6FDQePWpO/n80jdTym6xnHNGocNCxrTdUfrn7g+c/C19qwhF+UzbMAH
         kaB/xmPujNPsTiDuSKEKQjhSz9/qNPe234q0sOscj9yK7uE4KsMKoiFR16htrl36z0
         ZaGtvj0IEZeOQ==
Received: by mail-oo1-f50.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so891714oos.9;
        Thu, 14 Apr 2022 07:13:18 -0700 (PDT)
X-Gm-Message-State: AOAM531ZbIm7hXnU8BTmRUgbGrLEJBV4AsTIdoyfSt8pGUfqtlNMIxBS
        tLtBnb6qw7RzXwveBIxNb0hCcCsBkC7Y3n5TK+Y=
X-Google-Smtp-Source: ABdhPJzVObenFOQNGcxYgE0aDD4jEL5N64ZkM2Y91EDfGvnxH0aONGXpmnq0C6XLW//uOxlJxjSE12Xnef7TjPDpE6s=
X-Received: by 2002:a4a:95f3:0:b0:331:3e74:ed5d with SMTP id
 p48-20020a4a95f3000000b003313e74ed5dmr795426ooi.60.1649945597626; Thu, 14 Apr
 2022 07:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org> <20220414110844.817011928@linuxfoundation.org>
 <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com> <Ylgi3Nh8mbAOvXi6@kroah.com>
In-Reply-To: <Ylgi3Nh8mbAOvXi6@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Apr 2022 16:13:06 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFwQ+WrM4G=xa5+1CVd0z3RDLRUbFnpYRirWVHwbtvXGg@mail.gmail.com>
Message-ID: <CAMj1kXFwQ+WrM4G=xa5+1CVd0z3RDLRUbFnpYRirWVHwbtvXGg@mail.gmail.com>
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

On Thu, 14 Apr 2022 at 15:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 14, 2022 at 03:25:29PM +0200, Ard Biesheuvel wrote:
> > On Thu, 14 Apr 2022 at 15:23, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > >
> >
> > NAK. Please don't backport these patches to -stable, I thought I had
> > been clear on this.
>
> I dropped the patches you asked to be dropped, but this is a different
> one and is already in the following releases:
>         5.10.110 5.15.33 5.16.19 5.17.2
>
> I can also drop it from here and the 5.4 queue if you do not want it
> there.
>

This is not how I remember it:

On Tue, 5 Apr 2022 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> > On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > >
..
> >
> > Please drop all the 32-bit ARM patches authored by me from the stable
> > queues except the ones that have fixes tags. These are highly likely
> > to cause an explosion of regressions, and they should have never been
> > selected, as I don't remember anyone proposing these for stable.
>
> From what I can tell, that is only this commit.  I'll go drop it from
> all trees, thanks.
>

Can you *please* exclude all patches authored by me from consideration
by this bot? Consider this a blanket NAK to all AUTOSEL patches cc'ed
to me.
