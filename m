Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A72476575
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfGZMN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:13:59 -0400
Received: from foss.arm.com ([217.140.110.172]:42330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfGZMN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 08:13:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1E78337;
        Fri, 26 Jul 2019 05:13:57 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0F5C3F694;
        Fri, 26 Jul 2019 05:13:56 -0700 (PDT)
Date:   Fri, 26 Jul 2019 13:13:54 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     will@kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/3] arm64: perf: Mark expected switch fall-through
Message-ID: <20190726121354.GB26088@lakrids.cambridge.arm.com>
References: <20190726112716.19104-1-anders.roxell@linaro.org>
 <20190726121056.GA26088@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190726121056.GA26088@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 01:10:57PM +0100, Mark Rutland wrote:
> On Fri, Jul 26, 2019 at 01:27:16PM +0200, Anders Roxell wrote:
> > When fall-through warnings was enabled by default, commit d93512ef0f0e
> > ("Makefile: Globally enable fall-through warning"), the following
> > warnings was starting to show up:
> > 
> > ../arch/arm64/kernel/hw_breakpoint.c: In function ‘hw_breakpoint_arch_parse’:
> > ../arch/arm64/kernel/hw_breakpoint.c:540:7: warning: this statement may fall
> >  through [-Wimplicit-fallthrough=]
> >     if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
> >        ^
> > ../arch/arm64/kernel/hw_breakpoint.c:542:3: note: here
> >    case 2:
> >    ^~~~
> > ../arch/arm64/kernel/hw_breakpoint.c:544:7: warning: this statement may fall
> >  through [-Wimplicit-fallthrough=]
> >     if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
> >        ^
> > ../arch/arm64/kernel/hw_breakpoint.c:546:3: note: here
> >    default:
> >    ^~~~~~~
> > 
> > Rework so that the compiler doesn't warn about fall-through. Rework so
> > the code looks like the arm code. Since the comment in the function
> > indicates taht this is supposed to behave the same way as arm32 because
> 
> Typo: s/taht/that/
> 
> > it handles 32-bit tasks also.
> > 
> > Cc: stable@vger.kernel.org # v3.16+
> > Fixes: 6ee33c2712fc ("ARM: hw_breakpoint: correct and simplify alignment fixup code")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> 
> The patch itself looks fine, but I don't think this needs a CC to
> stable, nor does it require that fixes tag, as there's no functional
> problem.

Hmm... I now see I spoke too soon, and this is making the 1-byte
breakpoint work at a 3-byte offset.

Given that:

Acked-by: Mark Rutland <mark.rutland@arm.com>

... and the fixes and stable tags are appropriate for that portion of
the patch.

Sorry for the noise.

Thanks,
Mark.


> > ---
> >  arch/arm64/kernel/hw_breakpoint.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
> > index dceb84520948..ea616adf1cf1 100644
> > --- a/arch/arm64/kernel/hw_breakpoint.c
> > +++ b/arch/arm64/kernel/hw_breakpoint.c
> > @@ -535,14 +535,17 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
> >  		case 0:
> >  			/* Aligned */
> >  			break;
> > -		case 1:
> > -			/* Allow single byte watchpoint. */
> > -			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
> > -				break;
> >  		case 2:
> >  			/* Allow halfword watchpoints and breakpoints. */
> >  			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_2)
> >  				break;
> > +			/* Fall through */
> > +		case 1:
> > +		case 3:
> > +			/* Allow single byte watchpoint. */
> > +			if (hw->ctrl.len == ARM_BREAKPOINT_LEN_1)
> > +				break;
> > +			/* Fall through */
> >  		default:
> >  			return -EINVAL;
> >  		}
> > -- 
> > 2.20.1
> > 
