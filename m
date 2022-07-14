Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ACD574C6D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiGNLsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiGNLsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:48:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE475A463;
        Thu, 14 Jul 2022 04:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A616B824A3;
        Thu, 14 Jul 2022 11:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051ABC34114;
        Thu, 14 Jul 2022 11:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657799283;
        bh=OYIOsndITZUylHXaFbdAXqi+tObMpDd4N1pmU9B5qYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BU5RqMC2H20MKgktAQXQMf8Vr4LLbRpMuGkENKg4y95+EPQDYYieK3kU+h7dMfA3M
         73WQxG+TiIP+gTOb8Ms+EQq3YpVxX0H+IlZrvCoyQ3eROBBRC/bDqlDll23RswRRkp
         YJiTcWSPyCODC+PjmHIdPTUovvwf33Fz2gUKuO5o=
Date:   Thu, 14 Jul 2022 13:48:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Message-ID: <YtACcLRLs3qlwbbV@kroah.com>
References: <20220713171241.184026-1-cascardo@canonical.com>
 <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net>
 <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:36:22PM +0200, Paolo Bonzini wrote:
> On 7/14/22 11:52, Peter Zijlstra wrote:
> > On Wed, Jul 13, 2022 at 02:12:41PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > The return thunk call makes the fastop functions larger, just like IBT
> > > does. Consider a 16-byte FASTOP_SIZE when CONFIG_RETHUNK is enabled.
> > > 
> > > Otherwise, functions will be incorrectly aligned and when computing their
> > > position for differently sized operators, they will executed in the middle
> > > or end of a function, which may as well be an int3, leading to a crash
> > > like:
> > 
> > Bah.. I did the SETcc stuff, but then forgot about the FASTOP :/
> > 
> >    af2e140f3420 ("x86/kvm: Fix SETcc emulation for return thunks")
> > 
> > > Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > ---
> > >   arch/x86/kvm/emulate.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index db96bf7d1122..d779eea1052e 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -190,7 +190,7 @@
> > >   #define X16(x...) X8(x), X8(x)
> > >   #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
> > > -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
> > > +#define FASTOP_SIZE (8 * (1 + (HAS_KERNEL_IBT | IS_ENABLED(CONFIG_RETHUNK))))
> > 
> > Would it make sense to do something like this instead?
> 
> Yes, definitely.  Applied with a small tweak to make FASTOP_LENGTH
> more similar to SETCC_LENGTH:
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index db96bf7d1122..0a15b0fec6d9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -189,8 +189,12 @@
>  #define X8(x...) X4(x), X4(x)
>  #define X16(x...) X8(x), X8(x)
> -#define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
> -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
> +#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
> +#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
> +			 IS_ENABLED(CONFIG_SLS))
> +#define FASTOP_LENGTH	(ENDBR_INSN_SIZE + 7 + RET_LENGTH)
> +#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
> +static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
>  struct opcode {
>  	u64 flags;
> @@ -442,8 +446,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>   * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
>   * INT3				[1 byte; CONFIG_SLS]
>   */
> -#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
> -			 IS_ENABLED(CONFIG_SLS))
>  #define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
>  #define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
>  static_assert(SETCC_LENGTH <= SETCC_ALIGN);
> 
> 
> Paolo
> 

Any hint as to _where_ this was applied to?  I'm trying to keep in sync
with what is going to Linus "soon" for issues that are affecting the
stable trees here.

Shouldn't this go through the x86-urgent tree with the other retbleed
fixes?

thanks,

greg k-h
