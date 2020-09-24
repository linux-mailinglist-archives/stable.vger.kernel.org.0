Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEE27743E
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgIXOo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 10:44:26 -0400
Received: from elvis.franken.de ([193.175.24.41]:55226 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgIXOo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 10:44:26 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kLRmK-0005vQ-02; Thu, 24 Sep 2020 15:59:20 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 3CD9EC101A; Thu, 24 Sep 2020 15:54:29 +0200 (CEST)
Date:   Thu, 24 Sep 2020 15:54:29 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH 4.19 66/81] MIPS: Disable Loongson MMI instructions for
 kernel build
Message-ID: <20200924135429.GC13973@alpha.franken.de>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214845.344235056@linuxfoundation.org>
 <20200826210628.GA173536@roeck-us.net>
 <20200903092621.GB2220117@kroah.com>
 <CAAdtpL5ZPh4dBTVg57iF+PzOGFujvaNFxN4F_nEtAbB+=OGvhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdtpL5ZPh4dBTVg57iF+PzOGFujvaNFxN4F_nEtAbB+=OGvhg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 07, 2020 at 05:35:26AM +0200, Philippe Mathieu-Daudé wrote:
> On Thu, Sep 3, 2020 at 11:28 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Aug 26, 2020 at 02:06:28PM -0700, Guenter Roeck wrote:
> > > Hi,
> > >
> > > On Wed, Oct 16, 2019 at 02:51:17PM -0700, Greg Kroah-Hartman wrote:
> > > > From: Paul Burton <paul.burton@mips.com>
> > > >
> > > > commit 2f2b4fd674cadd8c6b40eb629e140a14db4068fd upstream.
> > > >
> > > > GCC 9.x automatically enables support for Loongson MMI instructions when
> > > > using some -march= flags, and then errors out when -msoft-float is
> > > > specified with:
> > > >
> > > >   cc1: error: ‘-mloongson-mmi’ must be used with ‘-mhard-float’
> > > >
> > > > The kernel shouldn't be using these MMI instructions anyway, just as it
> > > > doesn't use floating point instructions. Explicitly disable them in
> > > > order to fix the build with GCC 9.x.
> > > >
> > >
> > > I still see this problem when trying to compile fuloong2e_defconfig with
> > > gcc 9.x or later. Reason seems to be that the patch was applied to
> > > arch/mips/loongson64/Platform, but fuloong2e_defconfig uses
> > > arch/mips/loongson2ef/Platform.
> > >
> > > Am I missing something ?
> >
> > I don't know, sorry, that would be something that Paul understands.
> >
> > Paul?
> 
> Cc'ing Thomas who now maintains this.

I've queued a patch to fix this in mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
