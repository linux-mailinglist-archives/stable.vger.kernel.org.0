Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3676341F73
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCSOcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhCSObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 10:31:55 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1920C06174A;
        Fri, 19 Mar 2021 07:31:54 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id A5F9B92009C; Fri, 19 Mar 2021 15:31:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id A1AC192009B;
        Fri, 19 Mar 2021 15:31:52 +0100 (CET)
Date:   Fri, 19 Mar 2021 15:31:52 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     YunQiang Su <wzssyqa@gmail.com>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX
 binaries
In-Reply-To: <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2103191500040.21463@angie.orcam.me.uk>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de> <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk> <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021, YunQiang Su wrote:

> The bad news is  that (Google's) Go has no runtime.

 Dynamic shared objects (libraries) were invented in early 1990s for two 
reasons:

1. To limit the use of virtual memory.  Memory conservation may not be as 
   important nowadays in many applications where vast amounts of RAM are 
   available, though of course this does not apply everywhere, and still 
   it has to be weighed up whether any waste of resources is justified and 
   compensated by a gain elsewhere.

2. To make it easy to replace a piece of code shared among many programs, 
   so that you don't have to relink them all (or recompile if sources are 
   available) when say an issue is found or a feature is added that is 
   transparent to applications (for instance a new protocol or a better 
   algorithm).  This still stands very much nowadays.

People went through great efforts to support shared libraries, sacrificed 
performance for it even back then when the computing power was much lower 
than nowadays.  Support was implemented in Linux for the a.out binary 
format even, despite the need to go through horrible hoops to get a.out 
shared libraries built.  Some COFF environments were adapted for shared 
library support too.

 I don't know why Google choose not to have their runtime support library 
(the Go library) as a dynamic shared object 20-something years on, but it 
comes at a price.  So you either have to relink (recompile) all the 
affected applications like in the old days or find a feasible workaround.

 As I noted in the discussion the use of FR=0 would be acceptable for FPXX 
binaries as far as I am concerned for R2 through R5, but not the FRE mode 
for R6.

  Maciej
