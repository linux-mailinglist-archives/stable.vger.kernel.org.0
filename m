Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0580C33FBBD
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 00:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCQXP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 19:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhCQXPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 19:15:23 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A396DC06174A;
        Wed, 17 Mar 2021 16:15:23 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 7439192009C; Thu, 18 Mar 2021 00:15:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 6E68B92009B;
        Thu, 18 Mar 2021 00:15:21 +0100 (CET)
Date:   Thu, 18 Mar 2021 00:15:21 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips@vger.kernel.org, jiaxun.yang@flygoat.com,
        f4bug@amsat.org, stable@vger.kernel.org
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX
 binaries
In-Reply-To: <20210315145850.GA12494@alpha.franken.de>
Message-ID: <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021, Thomas Bogendoerfer wrote:

> > In Golang, now we add the FP32 annotation, so the future golang programs
> > won't have this problem. While for the existing binaries, we need a
> > kernel workaround.
> 
> what about just rebuilding them ? They are broken, so why should we fix
> broken user binaries with kernel hacks ?

 I agree.

 I went ahead and double-checked myself what the situation is here since I 
could not have otherwise obtained the answer to the question I asked, and 
indeed as I suspected even the simplest Go program will include a dynamic 
libgo reference (`libgo.so.17' with the snapshot of GCC 11 I have built 
for the MIPS target).  So a userland workaround is as simple as relinking 
this single library for the FP32 model.  This will make the dynamic loader 
force the FR=0 mode for all the executables that load the library.

 Since as YunQiang says they're going to rebuild Golang with FP32 
annotation anyway, which will naturally apply to the dynamic libgo library 
as well, this will fix the problem with the existing binaries in the 
current distribution.  Given that this is actually a correct fix (another 
one is required for the linker bug) I see no reason to clutter the kernel 
with a hack.  Especially as users will have to update a component anyway, 
in this case the Go runtime rather than the kernel (which is better even, 
as you don't have to reboot).

 Once Golang has been modernised to use the FPXX mode the problem will go 
away, and given the frequent version bumps in libgo's soname the current 
breakage won't be an issue for whatever future version of Debian includes 
it as the whole distribution will of course have been rebuilt against the 
new library and any old broken executables kept by the user with a system 
upgrade will continue using the old FP32 dynamic library.

> > Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
> > behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
> > we force it to use FR=0 or FRE (for R6 CPU).
> 
> I'm not sure, if I want to take this patch.
> 
> Maciej, what's your take on this ?

 Given what I have written previously and especially above I maintain my 
objection.  I don't understand why we're supposed to do people's homework 
though and solve their problems.

  Maciej
