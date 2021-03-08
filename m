Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E66330BD8
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 11:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhCHK4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 05:56:22 -0500
Received: from elvis.franken.de ([193.175.24.41]:57506 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhCHK4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 05:56:06 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lJDYR-0003M5-01; Mon, 08 Mar 2021 11:56:03 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id D599DC12B6; Mon,  8 Mar 2021 11:54:37 +0100 (CET)
Date:   Mon, 8 Mar 2021 11:54:37 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        George Cherian <gcherian@marvell.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: mips/poly1305 - enable for all MIPS processors
Message-ID: <20210308105437.GB6622@alpha.franken.de>
References: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 02:16:04AM +0100, Maciej W. Rozycki wrote:
> The MIPS Poly1305 implementation is generic MIPS code written such as to 
> support down to the original MIPS I and MIPS III ISA for the 32-bit and 
> 64-bit variant respectively.  Lift the current limitation then to enable 
> code for MIPSr1 ISA or newer processors only and have it available for 
> all MIPS processors.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: a11d055e7a64 ("crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized implementation")
> Cc: stable@vger.kernel.org # v5.5+
> ---
> On Wed, 3 Mar 2021, Jason A. Donenfeld wrote:
> 
> > >> Would you mind sending this for 5.12 in an rc at some point, rather
> > >> than waiting for 5.13? I'd like to see this backported to 5.10 and 5.4
> > >> for OpenWRT.
> > >
> > > why is this so important for OpenWRT ? Just to select CRYPTO_POLY1305_MIPS
> > > ?
> > 
> > Yes. The performance boost on Octeon is significant for WireGuard users.
> 
>  But that's the wrong fix for that purpose.  I've skimmed over that module 
> and there's nothing MIPS64-specific there.  In fact it's plain generic 
> MIPS assembly, with some R2 optimisations enabled where applicable but not 
> necessary (and then R6 tweaks, but that's irrelevant here).
> 
>  As a matter of interest I have just built it successfully for a MIPS I 
> DECstation configuration:
> 
> $ file arch/mips/crypto/poly1305-mips.ko
> arch/mips/crypto/poly1305-mips.ko: ELF 32-bit LSB relocatable, MIPS, MIPS-I version 1 (SYSV), BuildID[sha1]=d36384d94f60ba7deff638ca8a24500120b45b56, not stripped
> $ 
> 
> Patch included, please apply.
> 
>  So while your change is surely right, what you want is this really.
> 
>   Maciej
> ---
>  arch/mips/crypto/Makefile |    4 ++--
>  crypto/Kconfig            |    2 +-
>  drivers/net/Kconfig       |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
