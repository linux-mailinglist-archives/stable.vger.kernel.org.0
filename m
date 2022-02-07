Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871B84ABFCE
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiBGNn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiBGNPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:15:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D540C043181;
        Mon,  7 Feb 2022 05:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6E31CE10D6;
        Mon,  7 Feb 2022 13:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7DFC004E1;
        Mon,  7 Feb 2022 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644239746;
        bh=zXYrLpAZeTwm5+3IK7PE3D59RW6jp3a6MSkVptywHIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxNmr2OA+S6gQ7lR3sbLytuNDcQdNquD9dzYAVK0VmOSaDd1Nk72ZX38DdQO7cl97
         GNy/kctaQ4czOxt2FuzARFCkhJXvzUHS1kMr04PK9Cr1Db9+JRRBEDqPFNIRmBLU0B
         sqxYqJCFEQyRp1bnshhEA7MNOPUyK/cDnSjJnx54=
Date:   Mon, 7 Feb 2022 14:15:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH for-stable] kbuild: Define
 LINUX_VERSION_{MAJOR,PATCHLEVEL,SUBLEVEL}
Message-ID: <YgEbf7oxjSIDQDJo@kroah.com>
References: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
 <YgEKBAWp+wAWLfFW@kroah.com>
 <4b23a6fe-32df-f20c-eb1b-eea3b01857d1@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b23a6fe-32df-f20c-eb1b-eea3b01857d1@flygoat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 12:47:41PM +0000, Jiaxun Yang wrote:
> 
> 
> 在 2022/2/7 12:01, Greg KH 写道:
> > On Mon, Feb 07, 2022 at 11:52:12AM +0000, Jiaxun Yang wrote:
> > > Since the SUBLEVEL overflowed LINUX_VERSION, we have no reliable
> > > way to tell the current SUBLEVEL in source code.
> > What in-kernel code needs to know the SUBLEVEL?
> Hi,
> 
> Ah sorry, to clarification, backport here means "Backport Project"
> (https://backports.wiki.kernel.org).
> 
> Though it is not in-tree, it is a vital part of kernel ecosystem to
> deliver some new drivers to stable kernels.
> 
> It relies on KERNEL_VERSION macros to enable compat code.
> 
> > 
> > > This brings significant difficulties for backport works to deal
> > > with changes in stable releases.
> > What backport issues?
> Context: https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t
> 
> We are nolonger able to detect linux version > 4.9.255 in source.

Why do you need to do so?

> > 
> > > Define those macros so we can continue to get proper SUBLEVEL
> > > in source without breaking stable ABI by refining KERNEL_VERSION
> > > bit fields.
> > > 
> > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > ---
> > > For some context: https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t
> > > ---
> > >   Makefile | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 99d37c23495e..8132f81d94d8 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1142,7 +1142,10 @@ endef
> > >   define filechk_version.h
> > >   	(echo \#define LINUX_VERSION_CODE $(shell                         \
> > >   	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
> > > -	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
> > > +	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'; \
> > > +	echo \#define LINUX_VERSION_MAJOR $(VERSION); \
> > > +	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL); \
> > > +	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL);)
> > This is already in Makefile, are you sure you just do not need to
> > backport
> I wish this can be a part of existing stable kernels so backport project
> can maintain flawless build againt stable kernels.

My point being that you should not try to duplicate changes that are
already in Linus's tree.  What I think you want is commit 88a686728b37
("kbuild: simplify access to the kernel's version") to be backported,
right?

If so, please provide a working backport for all affected kernels and we
will be glad to consider it.

thanks,

greg k-h
