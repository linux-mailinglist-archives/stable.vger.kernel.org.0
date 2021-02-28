Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073CE326FFE
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 02:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhB1Bsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Feb 2021 20:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhB1Bsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Feb 2021 20:48:38 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51F9CC06174A;
        Sat, 27 Feb 2021 17:47:58 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 28FC092009C; Sun, 28 Feb 2021 02:47:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 1D05492009B;
        Sun, 28 Feb 2021 02:47:56 +0100 (CET)
Date:   Sun, 28 Feb 2021 02:47:56 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     YunQiang Su <wzssyqa@gmail.com>
cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips <linux-mips@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] MIPS: introduce config option to force use FR=0 for
 FPXX binary
In-Reply-To: <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2102280217220.44210@angie.orcam.me.uk>
References: <20210222034342.13136-1-yunqiang.su@cipunited.com> <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Feb 2021, YunQiang Su wrote:

> YunQiang Su <yunqiang.su@cipunited.com> 于2021年2月22日周一 上午11:45写道：
> >
> > some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are still FP32.
> >
> > Since FPXX binary can work with both FR=1 and FR=0, we introduce a
> > config option CONFIG_MIPS_O32_FPXX_USE_FR0 to force it to use FR=0 here.
> 
> As the diffination, .gnu.attribution 4,0 is the same as no
> .gnu.attribution section.
> Its meaning is that the binary has no float operation at all.

 Nope, quoting include/elf/mips.h from GNU binutils:

  /* Not tagged or not using any ABIs affected by the differences.  */
  Val_GNU_MIPS_ABI_FP_ANY = 0,

which means that the object file *either* does not use FP *or* has not 
been tagged at all, as the GNU linker does not tell these two cases apart 
internally (yes, quite useless semantics, but there you go; I think the 
enumeration constant of 0 shouldn't have been chosen for any explicit tag, 
or possibly for double float instead, so this is an ABI design mistake).

 Any object produced before mid 2007, specifically this GNU binutils 
commit:

commit 2cf19d5cb991a88bdc71d0852de8206d9510678f
Author: Joseph Myers <joseph@codesourcery.com>
Date:   Fri Jun 29 16:41:32 2007 +0000

will not have been tagged for FP use and therefore the traditional 
MIPS/Linux psABI of double float has to be assumed.

 This is also the correct interpretation for objects produced by Golang, 
which I have concluded are actually just fine according to the traditional 
psABI definition.  It looks to me like the bug is solely in the linker, 
due to this weird interpretation quoted above and unforeseen consequences 
for FPXX links invented much later.

 Yes, the two cases (not tagged vs tagged as 0) ought to be told apart and 
I outlined a solution (needed for different reasons, but with the same 
motivation) for the GNU linker in the course of the discussion around NaN 
interlinking design, but that has never materialised before I effectively 
left the MIPS world, only remaining active in a limited manner for legacy 
MIPS platforms (that is ISAs I-IV).

  Maciej
