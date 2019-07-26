Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D99766CC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfGZNFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfGZNFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:05:30 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD94218D4;
        Fri, 26 Jul 2019 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564146328;
        bh=PlJaIXLsd7+ROMZXdVipGcdLV0hhbDgStYB8O8oFc0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdcUIdd1H+5eq9/3l9EYVMzYIHTMXpCifNslC1KeXnrHabpBGQVVegiqp1oaFoNRa
         dZ9wthH9uc5ZaCamXK2hqB0iYpN0Q6dAXK+IoCEFy4V5umgyxufnEdIhK/4CTLecCl
         7Ghvg4ElsJ5NFty0qQoUitUxckBHjJfa8psJi1lo=
Date:   Fri, 26 Jul 2019 14:05:24 +0100
From:   Will Deacon <will@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] arm64: perf: Mark expected switch fall-through
Message-ID: <20190726130523.ftmc2un7fwwcegrr@willie-the-truck>
References: <20190726112716.19104-1-anders.roxell@linaro.org>
 <20190726121056.GA26088@lakrids.cambridge.arm.com>
 <20190726121354.GB26088@lakrids.cambridge.arm.com>
 <20190726122728.jhn4e6wq7rcowyi4@willie-the-truck>
 <1549fe77-367f-fee1-c09c-e429fca91051@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1549fe77-367f-fee1-c09c-e429fca91051@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 01:38:24PM +0100, Robin Murphy wrote:
> On 26/07/2019 13:27, Will Deacon wrote:
> > On Fri, Jul 26, 2019 at 01:13:54PM +0100, Mark Rutland wrote:
> > > On Fri, Jul 26, 2019 at 01:10:57PM +0100, Mark Rutland wrote:
> > > > On Fri, Jul 26, 2019 at 01:27:16PM +0200, Anders Roxell wrote:
> > > > > When fall-through warnings was enabled by default, commit d93512ef0f0e
> > > > > ("Makefile: Globally enable fall-through warning"), the following
> > > > > warnings was starting to show up:
> > > > > 
> > > > > ../arch/arm64/kernel/hw_breakpoint.c: In function ‘hw_breakpoint_arch_parse’:
> > > > > ../arch/arm64/kernel/hw_breakpoint.c:540:7: warning: this statement may fall
> > > > >   through [-Wimplicit-fallthrough=]
> > > > >      if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
> > > > >         ^
> > > > > ../arch/arm64/kernel/hw_breakpoint.c:542:3: note: here
> > > > >     case 2:
> > > > >     ^~~~
> > > > > ../arch/arm64/kernel/hw_breakpoint.c:544:7: warning: this statement may fall
> > > > >   through [-Wimplicit-fallthrough=]
> > > > >      if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
> > > > >         ^
> > > > > ../arch/arm64/kernel/hw_breakpoint.c:546:3: note: here
> > > > >     default:
> > > > >     ^~~~~~~
> > > > > 
> > > > > Rework so that the compiler doesn't warn about fall-through. Rework so
> > > > > the code looks like the arm code. Since the comment in the function
> > > > > indicates taht this is supposed to behave the same way as arm32 because
> > > > 
> > > > Typo: s/taht/that/
> > > > 
> > > > > it handles 32-bit tasks also.
> > > > > 
> > > > > Cc: stable@vger.kernel.org # v3.16+
> > > > > Fixes: 6ee33c2712fc ("ARM: hw_breakpoint: correct and simplify alignment fixup code")
> > > > > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > > > 
> > > > The patch itself looks fine, but I don't think this needs a CC to
> > > > stable, nor does it require that fixes tag, as there's no functional
> > > > problem.
> > > 
> > > Hmm... I now see I spoke too soon, and this is making the 1-byte
> > > breakpoint work at a 3-byte offset.
> > 
> > I still don't think it's quite right though, since it forbids a 2-byte
> > watchpoint on a byte-aligned address.
> 
> Plus, AFAICS, a 1-byte watchpoint on a 2-byte-aligned address.
> 
> Not that I know anything about this code, but it does start to look like it
> might want rewriting without the offending switch statement anyway. At a
> glance, it looks like the intended semantic might boil down to:
> 
> 	if (hw->ctrl.len > offset)
> 		return -EINVAL;

Given that it's compat code, I think it's worth staying as close to the
arch/arm/ implementation as we can. Also, beware that the
ARM_BREAKPOINT_LEN_* definitions are masks because of the BAS fields in
the debug architecture.

Will
