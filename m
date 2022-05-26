Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC505350E9
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiEZOoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 10:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiEZOoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 10:44:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9840CEBB1
        for <stable@vger.kernel.org>; Thu, 26 May 2022 07:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2280BB820F3
        for <stable@vger.kernel.org>; Thu, 26 May 2022 14:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E10C385A9;
        Thu, 26 May 2022 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653576253;
        bh=D4EvrFv8pQHYNnVQGXyPw69smb/EYs75xEETJy+q9Wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WYgvFQTJx04M7UnwhXIucUbb64dEFTRYtIsR650gLCbaUwV/EtHe+X5yFhvELbSmP
         SLsIGHmokcEZh9s5paazIlMawbV301dPj03XhkVmRclNxAoPAaYLlNtQEa7ZI+wbEt
         tR9eAnMlBr0WZQCjM73xB5UvOWfX6wLdA5taWgzo=
Date:   Thu, 26 May 2022 16:44:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <Yo+SOpVZisR8iGG1@kroah.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YouNwkU/8+hRwz9s@kroah.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

I get build errors in the 5.15 and 5.10 trees when applying these
patches.

Here's the 5.10 error:
In file included from ../crypto/testmgr.c:32:
../include/crypto/drbg.h:139:38: error: field 'random_ready' has incomplete type
  139 |         struct random_ready_callback random_ready;
      |                                      ^~~~~~~~~~~~


And the same error in 5.15.

So obviously I can't take them, I'm doing a simple 'make allmodconfig'
build for these trees on x86-64.

For 5.18 and 5.17, wow, lots of patches, but sure, let's see what
happens, I've queued them up now.

thanks,

greg k-h
