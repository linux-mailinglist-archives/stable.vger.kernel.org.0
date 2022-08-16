Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72530595BCE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiHPMdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiHPMdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4230E65BE;
        Tue, 16 Aug 2022 05:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 853D6B818CA;
        Tue, 16 Aug 2022 12:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760C8C433D6;
        Tue, 16 Aug 2022 12:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660653218;
        bh=/6unEP02pNwb2eleA4lMJeGKaROW9j+bphPNuUXBqiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cm0fRUkEQcxrU1IR1ahgSgiSvdJjnOCxyQBJ5HPL19p1qJkES2DQgVGhYZMxBZ7+5
         rfofEpdIDTvypGvc6cLzZP7DZtvKbgiXL00REfHavQvypgs+oTY24NiMoYOd6D07Y2
         3b6JttqDQHHdRnsELoTwouwC+z0WjEO29PntNdN8=
Date:   Tue, 16 Aug 2022 14:33:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <YvuOnkhj/Z8naRmN@kroah.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:28:36PM +0200, Peter Zijlstra wrote:
> 
> Replying here, because obviously there's no actual posting of this
> patch... :/

{sigh} True :(

> 
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -118,13 +118,28 @@
> >  #endif
> >  .endm
> >  
> > +.macro ISSUE_UNBALANCED_RET_GUARD
> > +	ANNOTATE_INTRA_FUNCTION_CALL
> > +	call .Lunbalanced_ret_guard_\@
> > +	int3
> > +.Lunbalanced_ret_guard_\@:
> > +	add $(BITS_PER_LONG/8), %_ASM_SP
> > +	lfence
> > +.endm
> > +
> >   /*
> >    * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
> >    * monstrosity above, manually.
> >    */
> > -.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
> > +.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2
> > +.ifb \ftr2
> >  	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
> > +.else
> > +	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", "", \ftr, "jmp .Lunbalanced_\@", \ftr2
> > +.endif
> >  	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
> > +.Lunbalanced_\@:
> > +	ISSUE_UNBALANCED_RET_GUARD
> >  .Lskip_rsb_\@:
> >  .endm
> 
> (/me deletes all the swear words and starts over)
> 
> This must absolutely be the most horrible patch you could come up with,
> no? I suppose that's the price of me taking PTO :-(
> 
> Could you please test this; I've only compiled it.
> 
> ---
> Subject: x86/nospec: Unwreck the RSB stuffing
> 
> Commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
> made a right mess of the RSB stuffing, rewrite the whole thing to not
> suck.
> 
> Thanks to Andrew for the enlightening comment about Post-Barrier RSB
> things so we can make this code less magical.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

I need an Intel person to test this as I have no idea how to do so as
this is an issue in Linus's tree.

thanks,

greg k-h
