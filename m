Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D80665B56
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 13:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjAKM0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 07:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbjAKM0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 07:26:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E7AF5A
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 04:25:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E56A361CAB
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 12:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F9DC433F0;
        Wed, 11 Jan 2023 12:25:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SH1E+rYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673439953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+9n1uua4zWJT/BZyF0Y96QyxG38T8s3jc7xoj/TG0j8=;
        b=SH1E+rYLEbJcSKLaBqfV8UUNXRIMzVftLG/mb4iszRksixEf/mEgvM4A03N9iIhrtnbT4o
        ii8/J069qQiBcZYWEydUIVLYbMbCK+ZZ/uOBbSAEoL5OTY97oHay9xwImO+6OdUPkJX1f/
        PRr8LL8FcufgZOTKSkSPYYBEcyLN6vg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f8545635 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 11 Jan 2023 12:25:52 +0000 (UTC)
Date:   Wed, 11 Jan 2023 13:25:50 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
Message-ID: <Y76qzqeZBtjqFs1n@zx2c4.com>
References: <20230110160416.2590-1-Jason@zx2c4.com>
 <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com>
 <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
 <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 09:44:34AM +0100, Ard Biesheuvel wrote:
> On Tue, 10 Jan 2023 at 20:45, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > > > Thanks! IIRC, this applies to all current stable kernels (now that
> > > > you've sunsetted 4.9).
> > >
> > > It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> > > provide working backports for them?
> >
> > I did 5.4.y, which turned out to be hairy than I wanted. You and Ard
> > can decide if you want it or not. I'll leave 4.19 and 4.14 for another
> > day.
> 
> I appreciate you spending the effort, but I'm not convinced this is
> worth the risk. You are backporting new functionality (invoking the
> firmware's RNG protocol at boot on x86), and we might end up
> regressing on systems where the firmware's implementation is
> problematic, even if the patch by itself is correct. This applies to
> mixed mode especially, as the conversion between Win64 and i386
> calling conventions has kicked up some very surprising issues in the
> past.

Alright, yea, I was afraid that might be the case indeed. Oh well.

So this means that for the purposes of systemd's usage of this, 5.10+ is
the relevant cut-off. I'm noting it here because I'm sure I'll forget,
and the question is bound to come up down the road.

Jason
