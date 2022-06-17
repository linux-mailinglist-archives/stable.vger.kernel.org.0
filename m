Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939CE54F29E
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 10:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380357AbiFQIQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 04:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380242AbiFQIQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 04:16:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266CE6830F
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 01:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF169B8213C
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 08:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2087FC3411B;
        Fri, 17 Jun 2022 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655453810;
        bh=nECfD3+zSMgN9sC0W52jYAuHzZmNWwa0MjxWHZmOFMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMBS3j0mT8A9iHrTbB16yuOfKuW/pi8opOjHF5oeoovkrwv5ze+loRQ8MgXPn9ot/
         Ce+fkm+5q0JoOeRhL+ZBxoS9mwqdQTYUfZrtBxXuxeqoOv5VzmoYkyateAgJabRmnC
         mS9BMLsEyM0/GeTHaI6nCbehqq55x70WmC2gBpMc=
Date:   Fri, 17 Jun 2022 10:16:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <Yqw4bzhjziySN54f@kroah.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
 <YpR8SHUGRFNyWEaT@kroah.com>
 <YpSel6PD4eKSToi8@zx2c4.com>
 <YqMJdDqMuq7hOilq@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqMJdDqMuq7hOilq@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 11:05:56AM +0200, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> On Mon, May 30, 2022 at 12:38:15PM +0200, Jason A. Donenfeld wrote:
> > Hey Greg,
> > 
> > I think if it's in 5.10, it makes sense to at least try to get it into
> > 5.4 and below for the same reasons. I'm traveling over the next week or
> > so, but I think I'll attempt to do a straight backport of it (sans-wg)
> > like I did for 5.10. As mentioned, it's harder, but that doesn't mean
> > it's impossible. I might give up in exasperation or perhaps find it too
> > onerous. But hopefully I'll be able to reuse the work I did for the
> > Android wg backports. Anyway, no guarantees -- it's not a trivial walk
> > in the park -- but I'll give it a shot and let you know if I can make it
> > work.
> 
> I'm glad I tried, because that turned out to be really easy, and none of
> the concerns I had about the crypto turned out to be valid at all. A lot
> of the hairiness with the 5.6-era crypto code was the way that
> lib/crypto/ interacted with kconfig and crypto/, and the way arch crypto
> interacted with that. But for blake2s, there was just a single commit to
> backport, which didn't need to interact with anything else, because
> there was nothing prior in the kernel regarding blake2s. So it wound up
> just being a boring lib/ commit, with no complications.
> 
> So with that out of the way, I succeeded in doing the remaining
> backports. You can pull from
> https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/ the
> following branches, with a linear series of commits on top of your
> latest:
> 
>     - linux-4.9.y
>     - linux-4.14.y
>     - linux-4.19.y
>     - linux-5.4.y
> 
> I've done an `allmodconfig` build test on these, and I've also booted a
> system on each of them. They contain the fixes that have landed since
> the previous tranche of backports, so that should bring all the
> backports up to date with each other.
> 
> And that means that moving forward, a `Cc: stable@vger.kernel.org` tag
> will hopefully apply evenly and without hassle to everything. More
> globally, I noticed when doing these backports what had been already
> backported and what hadn't, and it looks like a lot didn't easily apply
> before and so was dropped without being reworked, so over time fixes
> were lost. So I'm very happy to bring everything up to date finally.

All now queued up, thanks.

greg k-h
