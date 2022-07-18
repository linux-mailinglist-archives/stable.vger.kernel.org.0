Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10013578791
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiGRQjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiGRQi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:38:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BE4656F;
        Mon, 18 Jul 2022 09:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q498TUyBgFKahP8/Mq2OBXRnjBoiDJLsVpL5QujD8eg=; b=qicc0heer4g3rBVZzes21636YX
        z5abYKnvAGcm6lO029U6O0Kk4hFYne39T6B1xyn3/U92xzDWz9Ex5MPFRTUmxHEnhOqOD4FxatXt9
        C2DXdlsc12Luig8IxG2U5QN1W3er6+ldLP+AQk2J0EV5tG4nCjZ70XdHJXC3AAbNrzCAPS0HxA+44
        YcQk/ji8kH1A+uvhrcNFvPvU2AeJPMCWvJAfcZ4bwwTUPPHkXC4m/V9qWFwR1b4DvC1P5nYWxZqeg
        kwKBRMpbEzkNwYyzAGkE6dYnK/MaELLQcV1Bh/UxL8TsVVWw2MNBoj3UmalN2/Cbr2f6WfUHyYOs7
        DnJfNLSQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDTlT-00Cq9G-Lk; Mon, 18 Jul 2022 16:38:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 32FBB9802A7; Mon, 18 Jul 2022 18:38:35 +0200 (CEST)
Date:   Mon, 18 Jul 2022 18:38:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <YtWMiyem8+N4vbKE@worktop.programming.kicks-ass.net>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
 <YtWKK2ZLib1R7itI@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWKK2ZLib1R7itI@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 06:28:27PM +0200, Borislav Petkov wrote:
> On Mon, Jul 18, 2022 at 01:41:37PM +0200, Peter Zijlstra wrote:
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 10a3bfc1eb23..f934dcdb7c0d 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -297,6 +297,8 @@ do {									\
> >  	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
> >  			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
> >  			      X86_FEATURE_USE_IBRS_FW);			\
> > +	altnerative_msr_write(MSR_IA32_PRED_CMD, PRED_CMD_IBPB,		\
> > +			      X86_FEATURE_USE_IBPB_FW);			\
> >  } while (0)
> 
> So I'm being told we need to untrain on return from EFI to protect the
> kernel from it. Ontop of yours.

I don't think there's any credible way we can protect against EFI taking
over the system if it wants to. It runs at CPL0 and has access to the
direct map. If EFI wants it can take over the system without trying.

