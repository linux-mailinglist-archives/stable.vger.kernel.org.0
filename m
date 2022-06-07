Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE6853FAEA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbiFGKL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiFGKL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:11:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C9AA30AE;
        Tue,  7 Jun 2022 03:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B035CE1FFC;
        Tue,  7 Jun 2022 10:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40607C34115;
        Tue,  7 Jun 2022 10:11:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="X2K0Ykj+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654596680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1uLp6S7qDm+prOZPlj1/i8axFvtvjD7FOsjnFuZBDPg=;
        b=X2K0Ykj+oOpHR3dcG5mP2wE0U/B0IWXZSN2cK6HP/+Z47nOzBdxQe/OTHEAUhC2fHzSOmj
        jIPDtNllmaacdUUfHN2mDFVOK6uPL/GPUeuIT0uRqMSrNlkRWeR5jz3KgsarDoP6l96LeH
        h9K8wirp3B1eHUKd32vhgbIkA9q9XMM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d13f70d9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 10:11:19 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:11:14 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp8kQrBgE3WVqqC5@zx2c4.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
 <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
 <Yp8jQG30OWOG9C4j@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yp8jQG30OWOG9C4j@arm.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Catalin,

On Tue, Jun 07, 2022 at 11:06:56AM +0100, Catalin Marinas wrote:
> Hi Jason,
> 
> On Tue, Jun 07, 2022 at 10:51:41AM +0200, Jason A. Donenfeld wrote:
> > On Tue, Jun 7, 2022 at 10:47 AM Phil Elwell <phil@raspberrypi.com> wrote:
> > > Thanks for the quick response, but that doesn't work for me either. Let me say
> > > again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a
> > > universal problem, but merging either of these fixing patches would be fatal for us.
> > 
> > Alright, thanks. And I'm guessing you don't currently have a problem
> > *without* either of the fixing patches, because your device tree
> > doesn't use rng-seed. Is that right?
> > 
> > In anycase, I sent in a revert to get all the static branch stuff out
> > of stable -- https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
> > -- so the "urgency" of this should decrease and we can fix this as
> > normal during the 5.19 cycle.
> 
> Since the above revert got queued in -stable, I assume you don't need
> commit 73e2d827a501 ("arm64: Initialize jump labels before
> setup_machine_fdt()") in stable either.

I made the point here:
https://lore.kernel.org/stable/Yp8i9DH57dRGfTNf@kroah.com/T/#m8f33bc14b677980abe690e5c7a4909b5902010cc

> Do you plan to fix the crng_ready() static branch differently? If you
> do, I'd like to revert the corresponding arm64 commit as well. It seems
> to be harmless but I'd rather not keep it if no longer needed. So please
> keep me updated whatever you decide.

I sent a "backup commit" for that here: https://lore.kernel.org/all/20220607100210.683136-1-Jason@zx2c4.com/
But I would like a few days to see if there's some trivial way of not
needing that on arm32. If it turns out to be easy, then I'd prefer the
direct fix akin to the arm64 one. If it turns out to be not easy, then
I'll merge the backup commit. I'll keep you posted (and I assume anyway
you'll see the arm32 attempts progress or fail here, also).

Jason
