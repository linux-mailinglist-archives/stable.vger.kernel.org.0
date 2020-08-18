Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5750F2480AD
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 10:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgHRIcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 04:32:21 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:35686 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726043AbgHRIcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 04:32:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 92E4E18029129;
        Tue, 18 Aug 2020 08:32:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3866:3867:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6742:7576:7903:8985:9025:10004:10400:10848:11232:11658:11914:12043:12048:12296:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21627:21788:21939:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: brick48_020b1d72701d
X-Filterd-Recvd-Size: 2975
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 18 Aug 2020 08:32:14 +0000 (UTC)
Message-ID: <3ae89ad82dca2cf0adeba9d7d07f3c76ce577c39.camel@perches.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
From:   Joe Perches <joe@perches.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Nick Desaulniers' <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <natechancellor@gmail.com>
Date:   Tue, 18 Aug 2020 01:32:12 -0700
In-Reply-To: <77557c29286140dea726cc334b4f59fc@AcuMS.aculab.com>
References: <20200815014006.GB99152@rani.riverdale.lan>
         <20200815020946.1538085-1-ndesaulniers@google.com>
         <202008150921.B70721A359@keescook>
         <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
         <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
         <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
         <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
         <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
         <20200816001917.4krsnrik7hxxfqfm@google.com>
         <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
         <20200816150217.GA1306483@rani.riverdale.lan>
         <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
         <CAKwvOd=Ns4_+amT8P-7yQ56xUdDmL=1zDUThF-OmFKhexhJPdg@mail.gmail.com>
         <77557c29286140dea726cc334b4f59fc@AcuMS.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-08-18 at 08:24 +0000, David Laight wrote:
> From: Nick Desaulniers
> > Sent: 17 August 2020 19:37
> ..
> > That said, this libcall optimization/transformation (sprintf->stpcpy)
> > does look useful to me.
> 
> I'd rather get a cow if I ask for a cow...
> 
> Maybe checkpatch (etc) could report places where snprintf()
> could be replaced by a simpler function.

You mean sprintf no?

Reminds me of seq_printf vs seq_puts...

https://lkml.org/lkml/2013/3/16/79


