Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D772B53764F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiE3IL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 04:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiE3IL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 04:11:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B0826CF
        for <stable@vger.kernel.org>; Mon, 30 May 2022 01:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB1E60EDE
        for <stable@vger.kernel.org>; Mon, 30 May 2022 08:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1194C3411C;
        Mon, 30 May 2022 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653898315;
        bh=XEAdEJcFuXIrGVl8bQ9z0s9OymqcQ2jBUvMs4K9GuIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6Qe1+kRQv2BgdkbwdX2+oeYFwIdO7RBy83b/5oCqSp1O0O5iamcvQqKbH9Qio48S
         rixuwutxjzfZRpwN8MCPlt2JQt3GmLsGTeSIx3GIyukR9ZKGYof3rnshiomYyZlLXW
         LK+fVV76AO2lp09Guo8B/6LavxV8Ge0SVfzPcl3A=
Date:   Mon, 30 May 2022 10:11:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YpR8SHUGRFNyWEaT@kroah.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YouNwkU/8+hRwz9s@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 03:36:02PM +0200, Greg KH wrote:
> On Mon, May 23, 2022 at 02:54:45PM +0200, Jason A. Donenfeld wrote:
> > Hi Greg, Sasha,
> > 
> > I think we're finally at a good point to begin backporting the work I've
> > done on random.c during the last 6 months. I've been maintaining
> > branches for this incrementally as code has been merged into mainline,
> > in order to make this moment easier than otherwise.
> > 
> > Assuming that Linus merges my PR for 5.19 [1] today, all of these
> > patches are (or will be in a few hours) in Linus' tree. I've tried to
> > backport most of the general scaffolding and design of the current state
> > of random.c, while not backporting any new features or unusual
> > functionality changes that might invite trouble. So, for example, the
> > backports switch to using a cryptographic hash function, but they don't
> > have changes like warning when the cycle counter is zero, attempting to
> > use jitter on early uses of /dev/urandom, reseeding on suspend/hibernate
> > notifications, or the vmgenid driver. Hopefully that strikes an okay
> > balance between getting the core backported so that fixes are
> > backportable, but not going too far by backporting new "nice to have"
> > but unessential features.
> > 
> > In this git repo [2], there are three branches: linux-5.15.y,
> > linux-5.17.y, and linux-5.18.y, which contain backports for everything
> > up to and including [1].
> > 
> > You'll probably want to backport this to earlier kernels as well. Given
> > that there hasn't been overly much work on the rng in the last few
> > years, it shouldn't be too hard to take my 5.15.y branch and fill in the
> > missing pieces there to bring it back. Given how much changes, you could
> > probably just take every random.c change for backporting to before 5.15.
> > 
> > There is one snag, which is that some of the work I did during the 5.17
> > cycle depends on crypto I added for WireGuard, which landed in 5.6. So
> > for 5.4 and prior, that will need backports. Fortunately, I've already
> > done this in [3], in the branch backport-5.4.y, which I've kept up to
> > date for a few years now. This occasion might mark the perfect excuse
> > we've been waiting for to just backport WireGuard too to 5.4 (which
> > might make the Android work a bit easier also) :-D.
> > 
> > Let me know if you have any questions, and feel free to poke me on IRC.
> > And if all of the above sounds terrible to you, and you'd rather just
> > not take any of this into stable, I guess that's a valid path to take
> > too.
> 
> Let me look at this later this week after we get this next round of
> stable kernels out.  It's normally a nice calm period for the stable
> kernels so this might not be that bad.

This is all now merged into 5.10 and newer.

For 5.4 I just don't think it's worth the trouble.  Devices based on
that old kernel aren't going to want to deal with the churn like this,
and being forced to add the WG code to it also seems like a lot of
unnecessary work for everyone (including yourself.)

But, I do know that a lot of Android devices are still relying on 5.4,
they already have WG in their kernels so overall this might be a smaller
diff for them?

I don't really know, do you have any people/companies/devices using 5.4
that would want this all added that you can show it is worth it for?

thanks,

greg k-h
