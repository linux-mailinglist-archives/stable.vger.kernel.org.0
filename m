Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1391803F1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJQuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 12:50:24 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:58653 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726307AbgCJQuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 12:50:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 53E711802DEEB;
        Tue, 10 Mar 2020 16:50:23 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7576:8660:10004:10400:11232:11658:11914:12050:12114:12296:12297:12740:12760:12895:13069:13148:13230:13311:13357:13439:14181:14659:14721:21080:21433:21451:21627:21990:30012:30054:30060:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: list44_3299c48c4159
X-Filterd-Recvd-Size: 2580
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 16:50:21 +0000 (UTC)
Message-ID: <0fdd3a89033ce3d6e7ab6b12eddefc343ac43729.camel@perches.com>
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
From:   Joe Perches <joe@perches.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Date:   Tue, 10 Mar 2020 09:48:40 -0700
In-Reply-To: <CAK7LNARMsO0AeO8-kH4czMuW0Y_=dN+ZhtXNdRE7CWGvU2PNvA@mail.gmail.com>
References: <20200308073400.23398-1-natechancellor@gmail.com>
         <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
         <20200310012545.GA16822@ubuntu-m2-xlarge-x86>
         <c2a687d065c1463d8eea9947687b3b05@AcuMS.aculab.com>
         <CAK7LNARMsO0AeO8-kH4czMuW0Y_=dN+ZhtXNdRE7CWGvU2PNvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-03-11 at 00:30 +0900, Masahiro Yamada wrote:
> On Tue, Mar 10, 2020 at 8:31 PM David Laight <David.Laight@aculab.com> wrote:
> > From: Nathan Chancellor
> > > Sent: 10 March 2020 01:26
> > ...
> > > Sure, I can send v2 to do that but I think that sending 97 patches just
> > > casting the small values (usually less than twenty) to unsigned long
> > > then to the enum is rather frivolous. I audited at least ten to fifteen
> > > of these call sites when creating the clang patch and they are all
> > > basically false positives.
> > 
> > Such casts just make the code hard to read.
> > If misused casts can hide horrid bugs.
> > IMHO sprinkling the code with casts just to remove
> > compiler warnings will bite back one day.
> > 
> 
> I agree that too much casts make the code hard to read,
> but irrespective of this patch, there is no difference
> in the fact that we need a cast to convert
> (const void *) to a non-pointer value.
> 
> The difference is whether we use
> (uintptr_t) or (enum foo).

or hide it altogether in a macro like cast_to

#define cast_to(type, val)	\
	etc...

where cast_to could do the appropriate
intermediate cast if type is an enum
and sizeof(tupeof val) is larger than int


