Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C2435EEC
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 12:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJUKW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 06:22:28 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:34262 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhJUKW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 06:22:27 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 8DCFC92009C; Thu, 21 Oct 2021 12:20:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 86E0F92009B;
        Thu, 21 Oct 2021 12:20:05 +0200 (CEST)
Date:   Thu, 21 Oct 2021 12:20:05 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix assembly error from MIPSr2 code used within
 MIPS_ISA_ARCH_LEVEL
In-Reply-To: <alpine.DEB.2.21.2110210054080.31442@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2110211213090.31442@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2110210054080.31442@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Oct 2021, Maciej W. Rozycki wrote:

> The assembly architecture override is only there for the LLD/SCD 
> instructions, so fix the problem by wrapping these instructions on their 
> own only, following the practice established with commit cfd54de3b0e4 
> ("MIPS: Avoid move psuedo-instruction whilst using MIPS_ISA_LEVEL") and 
> commit 378ed6f0e3c5 ("MIPS: Avoid using .set mips0 to restore ISA").

 Scrap it!  There's so much accumulated cruft around the handling of LL/SC 
sequences that I forgot what the original intent was.  The whole sequence 
has to be assembled for an explicit 64-bit ISA of course as it's meant to 
work with 32-bit kernels.  The commits referred above are red herrings, 
and should not have been needed in the first place if not for the cruft.

 I don't think I'll get to cleaning up the cruft anytime soon, but I'll 
post v2 tonight to address this specific issue.  Long-term perhaps we can 
make some extraneous hacks (ones to address issues with earlier hacks) go 
away.

  Maciej
