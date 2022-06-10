Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8B5460FA
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 11:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348227AbiFJJHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348568AbiFJJGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 05:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B3C279E51
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 02:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F25BB61C31
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 09:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA39EC34114;
        Fri, 10 Jun 2022 09:06:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ClNZxPm+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654851966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOg+JTZzwuVxw2GANpYtpJycY6arHT3Bg57VdAVMWA0=;
        b=ClNZxPm+3ZHiA77M8beEQ9MHAw+XQnR9hhGMxWv189uwbOSSnQ6kTeeANJDs6WBRSG1rKS
        ys4SYtzCMafa9Kp1arHxU99wRV/kBeUsaQ7gYRpycZZfinmnFu478bve57sDQD/QpOEe3D
        qCl+BdBQK1FTNlyuUzMwEEX9Vatvuy8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bbb859dd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 10 Jun 2022 09:06:05 +0000 (UTC)
Date:   Fri, 10 Jun 2022 11:05:56 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YqMJdDqMuq7hOilq@zx2c4.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
 <YpR8SHUGRFNyWEaT@kroah.com>
 <YpSel6PD4eKSToi8@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YpSel6PD4eKSToi8@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 30, 2022 at 12:38:15PM +0200, Jason A. Donenfeld wrote:
> Hey Greg,
> 
> I think if it's in 5.10, it makes sense to at least try to get it into
> 5.4 and below for the same reasons. I'm traveling over the next week or
> so, but I think I'll attempt to do a straight backport of it (sans-wg)
> like I did for 5.10. As mentioned, it's harder, but that doesn't mean
> it's impossible. I might give up in exasperation or perhaps find it too
> onerous. But hopefully I'll be able to reuse the work I did for the
> Android wg backports. Anyway, no guarantees -- it's not a trivial walk
> in the park -- but I'll give it a shot and let you know if I can make it
> work.

I'm glad I tried, because that turned out to be really easy, and none of
the concerns I had about the crypto turned out to be valid at all. A lot
of the hairiness with the 5.6-era crypto code was the way that
lib/crypto/ interacted with kconfig and crypto/, and the way arch crypto
interacted with that. But for blake2s, there was just a single commit to
backport, which didn't need to interact with anything else, because
there was nothing prior in the kernel regarding blake2s. So it wound up
just being a boring lib/ commit, with no complications.

So with that out of the way, I succeeded in doing the remaining
backports. You can pull from
https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/ the
following branches, with a linear series of commits on top of your
latest:

    - linux-4.9.y
    - linux-4.14.y
    - linux-4.19.y
    - linux-5.4.y

I've done an `allmodconfig` build test on these, and I've also booted a
system on each of them. They contain the fixes that have landed since
the previous tranche of backports, so that should bring all the
backports up to date with each other.

And that means that moving forward, a `Cc: stable@vger.kernel.org` tag
will hopefully apply evenly and without hassle to everything. More
globally, I noticed when doing these backports what had been already
backported and what hadn't, and it looks like a lot didn't easily apply
before and so was dropped without being reworked, so over time fixes
were lost. So I'm very happy to bring everything up to date finally.

Regards,
Jason
