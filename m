Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D0621CF0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKHTUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiKHTUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ABF6C71F;
        Tue,  8 Nov 2022 11:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D82BC6173F;
        Tue,  8 Nov 2022 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38587C433D6;
        Tue,  8 Nov 2022 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667935241;
        bh=JsQ7IAXX736if0do7+rF4cpmY09knimF5FgdWdfJoyw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=kJydPl/IMLM7XNIratGgzwUAdQghfjqRl2+WduMSRWC5jy/DtRlBTEvKIrx5KvmEq
         LZAkuMX4kptEzbGzus6JZC9LBfi7phAE8oFPJVGHMGlXa1+FWtw1bRbbJyksl54IEQ
         nVdBaNR7F7QnyKkwgGLcWhvxGNNu6NnVTXF+rLCuRokwr87SdVPzEtuIWQhu90EfTC
         WBtYOyAIOWcoU/l3i7rCM0gJpxqVoQtCBBmtKDyXqmRKEW2NfQrg1+AIrNELOOODS3
         vtNe180h7++z62MqK5xL6dm7o4yJKS20YKCFD+j3l09JJKXPPyvqSG/csqJqi85+nw
         21eQxdWkfTMyg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D596A5C1E87; Tue,  8 Nov 2022 11:20:39 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:20:39 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Maria Yu <quic_aiquny@quicinc.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: core: Make p->state in order in
 pinctrl_commit_state
Message-ID: <20221108192039.GH3907045@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221027065110.9395-1-quic_aiquny@quicinc.com>
 <CACRpkdbCwvGr4JA+=khynduWSZSbSN8D9dtsY0h_9LxkqJuQ_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbCwvGr4JA+=khynduWSZSbSN8D9dtsY0h_9LxkqJuQ_Q@mail.gmail.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 01:47:15PM +0100, Linus Walleij wrote:
> Hi Maria,
> 
> thanks for your patch!
> 
> On Thu, Oct 27, 2022 at 8:51 AM Maria Yu <quic_aiquny@quicinc.com> wrote:
> 
> > We've got a dump that current cpu is in pinctrl_commit_state, the
> > old_state != p->state while the stack is still in the process of
> > pinmux_disable_setting. So it means even if the current p->state is
> > changed in new state, the settings are not yet up-to-date enabled
> > complete yet.
> >
> > Currently p->state in different value to synchronize the
> > pinctrl_commit_state behaviors. The p->state will have transaction like
> > old_state -> NULL -> new_state. When in old_state, it will try to
> > disable all the all state settings. And when after new state settings
> > enabled, p->state will changed to the new state after that. So use
> > smp_mb to synchronize the p->state variable and the settings in order.
> > ---
> >  drivers/pinctrl/core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> > index 9e57f4c62e60..cd917a5b1a0a 100644
> > --- a/drivers/pinctrl/core.c
> > +++ b/drivers/pinctrl/core.c
> > @@ -1256,6 +1256,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
> >                 }
> >         }
> >
> > +       smp_mb();
> >         p->state = NULL;
> >
> >         /* Apply all the settings for the new state - pinmux first */
> > @@ -1305,6 +1306,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
> >                         pinctrl_link_add(setting->pctldev, p->dev);
> >         }
> >
> > +       smp_mb();
> >         p->state = state;
> >
> >         return 0;
> 
> Ow!
> 
> It's not often that I loop in Paul McKenney on patches, but this is in the core
> of the subsystem used across all architectures so if this is a generic problem
> of concurrency, I really want some professional concurrency person to
> look at it before I apply it.

Hello, Linus and Maria!

Insertion of unadorned and uncommented memory barriers does rouse more
than a bit of suspicion, to be sure.  ;-)

Could you please outline what ordering this smp_mb() is intended to
provide?  Yes, my guess is that the p->state change is to be seen as
happening after the prior memory accesses, but:

1.	What is the other side of the interaction doing?  My guess is
	that something is reading p->state and the referencing the same
	memory referenced prior to the pair of smp_mb() calls above.
	For example, are the other relevant memory references referenced
	by the pointer "p"?

	For example, what happens if two of the above updates happen in
	quick succession during the execution of a single instance of
	the other side of the interaction?

2.	Why smp_mb() rather than using smp_store_release() to update
	p->state?

3.	More generally, why unmarked accesses to p->state?  Are the
	other relevant accesses also unmarked?

	Please see these LWN articles for more on the potential dangers
	of unmarked accesses to shared variables:

	Who's afraid of a big bad optimizing compiler?
		https://lwn.net/Articles/793253/

	Calibrating your fear of big bad optimizing compilers
		https://lwn.net/Articles/799218/

4.	There are some tools that can help with this sort of ordering
	code, for example:

	Concurrency bugs should fear the big bad data-race detector (part 1)
		https://lwn.net/Articles/816850/
	Concurrency bugs should fear the big bad data-race detector (part 2)
		https://lwn.net/Articles/816854/

	For this tool (KCSAN) to find a problem, your testing must come
	close to making it happen.

	A design-level full-state-space tool may be found in
	tools/memotry-model.  This tool, as you might expect, is
	restricted to very short code fragments, but does fully handle
	concurrency.  It might take some work to squeeze what you have
	into the confines of this tool.

Again, to evaluate this change, I need to understand what it is trying
to accomplish.

							Thanx, Paul
