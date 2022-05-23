Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57DD530FC8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiEWNHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 09:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiEWNG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 09:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2B51E71
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A8961338
        for <stable@vger.kernel.org>; Mon, 23 May 2022 13:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FCEC385A9
        for <stable@vger.kernel.org>; Mon, 23 May 2022 13:06:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a2zyAlPB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653311203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         resent-to:resent-from:resent-message-id;
        bh=sfnIy+09Ssy7T1PJm481y7E1lIpyQeDn1byhyR4bJSo=;
        b=a2zyAlPBaVqVG7pZSo3VSceItt0RuSnfRa5uVwSoGh/wLvCbDIrjFmdN0oUw4YavSAHIeF
        /1WpRmlhTySGgIpsAkGnv3DHTYyGEvz55wiz+uImNAcOFzCEcSoZNnH0YAXj6CLbo1Fq56
        e9OQh7gAQh9XtR5+5cN0VE6BYYFicr0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88704171 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 23 May 2022 13:06:43 +0000 (UTC)
Date:   Mon, 23 May 2022 14:54:45 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        linux-stable@vger.kernel.org
Subject: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YouECCoUA6eZEwKf@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

I think we're finally at a good point to begin backporting the work I've
done on random.c during the last 6 months. I've been maintaining
branches for this incrementally as code has been merged into mainline,
in order to make this moment easier than otherwise.

Assuming that Linus merges my PR for 5.19 [1] today, all of these
patches are (or will be in a few hours) in Linus' tree. I've tried to
backport most of the general scaffolding and design of the current state
of random.c, while not backporting any new features or unusual
functionality changes that might invite trouble. So, for example, the
backports switch to using a cryptographic hash function, but they don't
have changes like warning when the cycle counter is zero, attempting to
use jitter on early uses of /dev/urandom, reseeding on suspend/hibernate
notifications, or the vmgenid driver. Hopefully that strikes an okay
balance between getting the core backported so that fixes are
backportable, but not going too far by backporting new "nice to have"
but unessential features.

In this git repo [2], there are three branches: linux-5.15.y,
linux-5.17.y, and linux-5.18.y, which contain backports for everything
up to and including [1].

You'll probably want to backport this to earlier kernels as well. Given
that there hasn't been overly much work on the rng in the last few
years, it shouldn't be too hard to take my 5.15.y branch and fill in the
missing pieces there to bring it back. Given how much changes, you could
probably just take every random.c change for backporting to before 5.15.

There is one snag, which is that some of the work I did during the 5.17
cycle depends on crypto I added for WireGuard, which landed in 5.6. So
for 5.4 and prior, that will need backports. Fortunately, I've already
done this in [3], in the branch backport-5.4.y, which I've kept up to
date for a few years now. This occasion might mark the perfect excuse
we've been waiting for to just backport WireGuard too to 5.4 (which
might make the Android work a bit easier also) :-D.

Let me know if you have any questions, and feel free to poke me on IRC.
And if all of the above sounds terrible to you, and you'd rather just
not take any of this into stable, I guess that's a valid path to take
too.

Regards,
Jason

[1] https://lore.kernel.org/lkml/20220522214457.37108-1-Jason@zx2c4.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux.git/
