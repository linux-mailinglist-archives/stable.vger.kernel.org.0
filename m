Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8663D5016A6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbiDNPJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 11:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351520AbiDNObD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 10:31:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567EBB18AC;
        Thu, 14 Apr 2022 07:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14FEAB829D6;
        Thu, 14 Apr 2022 14:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFB0C385A1;
        Thu, 14 Apr 2022 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649946062;
        bh=YDYDFPVPbgvYlARnVyRhbh+J+bnyyYxSou9TPqho03c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qs2NagPvwtHQG7R7jJ7jO9sfi+oPMFDODvxho0GjrGS4oD1cR2VniprIHLZpcNTaW
         nwCAFPKRUNqdt0OvNCpRhyOvxjjo6I/nJTLZa085ss7fYgcawgfnHVG3NxhJP6BMVS
         DTrtwKRmOSFdPM/n1xSOpJjWkPHeYzGzzQSp+4P8=
Date:   Thu, 14 Apr 2022 16:20:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 208/338] ARM: ftrace: avoid redundant loads or
 clobbering IP
Message-ID: <Ylgty0IzV+5i4T0g@kroah.com>
References: <20220414110838.883074566@linuxfoundation.org>
 <20220414110844.817011928@linuxfoundation.org>
 <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
 <Ylgi3Nh8mbAOvXi6@kroah.com>
 <CAMj1kXFwQ+WrM4G=xa5+1CVd0z3RDLRUbFnpYRirWVHwbtvXGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFwQ+WrM4G=xa5+1CVd0z3RDLRUbFnpYRirWVHwbtvXGg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 04:13:06PM +0200, Ard Biesheuvel wrote:
> On Thu, 14 Apr 2022 at 15:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Apr 14, 2022 at 03:25:29PM +0200, Ard Biesheuvel wrote:
> > > On Thu, 14 Apr 2022 at 15:23, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > >
> > > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > > >
> > >
> > > NAK. Please don't backport these patches to -stable, I thought I had
> > > been clear on this.
> >
> > I dropped the patches you asked to be dropped, but this is a different
> > one and is already in the following releases:
> >         5.10.110 5.15.33 5.16.19 5.17.2
> >
> > I can also drop it from here and the 5.4 queue if you do not want it
> > there.
> >
> 
> This is not how I remember it:
> 
> On Tue, 5 Apr 2022 at 18:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> > > On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Ard Biesheuvel <ardb@kernel.org>
> > > >
> > > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > > >
> ..
> > >
> > > Please drop all the 32-bit ARM patches authored by me from the stable
> > > queues except the ones that have fixes tags. These are highly likely
> > > to cause an explosion of regressions, and they should have never been
> > > selected, as I don't remember anyone proposing these for stable.
> >
> > From what I can tell, that is only this commit.  I'll go drop it from
> > all trees, thanks.
> >
> 
> Can you *please* exclude all patches authored by me from consideration
> by this bot? Consider this a blanket NAK to all AUTOSEL patches cc'ed
> to me.

Ick, I thought I dropped this from everywhere, very odd, sorry about
that.  Ah, I dropped dd88b03ff0c8 ("ARM: ftrace: ensure that ADR takes
the Thumb bit into account"), not this one.  {sigh}

Let me try to drop this again...

greg k-h
