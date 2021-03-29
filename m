Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F0434D347
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhC2PFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:05:53 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38156 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhC2PFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:05:41 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 1CE7692009C; Mon, 29 Mar 2021 17:05:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 19CA892009B;
        Mon, 29 Mar 2021 17:05:40 +0200 (CEST)
Date:   Mon, 29 Mar 2021 17:05:40 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     yunqiang.su@cipunited.com
cc:     'YunQiang Su' <wzssyqa@gmail.com>,
        'Thomas Bogendoerfer' <tsbogend@alpha.franken.de>,
        'linux-mips' <linux-mips@vger.kernel.org>,
        'Jiaxun Yang' <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?'Philippe_Mathieu-Daud=C3=A9'?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: =?UTF-8?Q?Re=3A_=E5=9B=9E=E5=A4=8D=3A_=5BPATCH_v7_RESEND=5D_MIP?=
 =?UTF-8?Q?S=3A_force_use_FR=3D0_or_FRE_for_FPXX_binaries?=
In-Reply-To: <000b01d71eb6$0c210250$246306f0$@cipunited.com>
Message-ID: <alpine.DEB.2.21.2103291246290.18977@angie.orcam.me.uk>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de> <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk> <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com>
 <alpine.DEB.2.21.2103191500040.21463@angie.orcam.me.uk> <000b01d71eb6$0c210250$246306f0$@cipunited.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021, yunqiang.su@cipunited.com wrote:

> >  I don't know why Google choose not to have their runtime support library
> > (the Go library) as a dynamic shared object 20-something years on, but it
> > comes at a price.  So you either have to relink (recompile) all the
> affected
> > applications like in the old days or find a feasible workaround.
> > 
> 
> I also have no idea why (even hate).
> While there do be some program languages created in recently years, prefer
> static link.

 Hmm, lost wisdom, or an orchestrated effort?  Or a false illusion that 
since we're virtually fully open source now, we can always rebuild the 
world?  Well, indeed this is technically possible, but whether it is 
feasible is another matter.  Your case serves as a counterexample.

> >  As I noted in the discussion the use of FR=0 would be acceptable for FPXX
> > binaries as far as I am concerned for R2 through R5, but not the FRE mode
> for
> > R6.
> 
> There will no FPXX for r6. All of (if not mistake) R6 O32 is FP64.
> FRE here is only for compatible with pre-R6 objects.

 That doesn't seem like a good choice to me.

 While R6 programs are indeed best built as FP64, libraries are best built 
as FPXX, so that users can link or load with whatever binary modules they 
have, including pre-R6 ones.  As much as we may dislike it sources will 
not always be available or rebuilding them may be beyond the capabilities 
of whoever has the binaries, so I think the system should be as permissive 
as possible.  So you may end up with running code that is largely R6 
(libraries), and partly pre-R6 (application code) that ends up linked as 
FPXX.

 And the kernel has to support it in the best way possible too and avoid 
slow emulation where not necessary e.g. in R6 libm code used in the FPXX 
arrangement, which the FRE mode will inevitably lead to.

  Maciej
