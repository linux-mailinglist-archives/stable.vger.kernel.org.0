Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F272D45B4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgLIPoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbgLIPoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 10:44:00 -0500
Date:   Wed, 9 Dec 2020 16:44:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607528599;
        bh=aQdUBcJzGs5sTFOVkJKkVgfaR/1cjLXqFj5iEQWhGWs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kuXo8ntCTJ9f422Po8LLL06bKV6gUowSc/t6knG0gvyJ5h3/ttKFIBgZoGkM5zNuO
         o1YQgS8WpLfaerJqM+LfKQAhxy78iDcq7EexAiTzGFnX56yAz3RCSqLWZOB2sjPOgt
         UujRul97sJl1QRGeq2f5T1xOSPGyqFKFzyeAUrTg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     Coiby Xu <coiby.xu@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <X9Dw4zxx331I7zAk@kroah.com>
References: <20201125141022.321643-1-coiby.xu@gmail.com>
 <X75zL12q+FF6KBHi@kroah.com>
 <B3Hx1v5x_ZWS8XSi8-0vZov1KLuINEHyS5yDUGBaoBN4d9wTi9OlCoFX1h6sqYG8dCZr_OKcKeImWX9eyKh8X4X3ZMdAUQ-KVwmG5e9LJeI=@protonmail.com>
 <X9B2B6KuzbP8Is+W@kroah.com>
 <CHTa60htGkyHzaM2En-TPXqyk1v3jVJUolGOMfHphEr_mMG5Z5f2K4mHTFilYR73bgpGEKNcGM1LFstJ7UhvbuJrgqr1-J2-YTZJenhK83Q=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CHTa60htGkyHzaM2En-TPXqyk1v3jVJUolGOMfHphEr_mMG5Z5f2K4mHTFilYR73bgpGEKNcGM1LFstJ7UhvbuJrgqr1-J2-YTZJenhK83Q=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 03:38:11PM +0000, Barnabás Pőcze wrote:
> 2020. december 9., szerda 8:00 keltezéssel, Greg KH írta:
> 
> > On Tue, Dec 08, 2020 at 09:59:20PM +0000, Barnabás Pőcze wrote:
> >
> > > 2020.  november 25., szerda 16:07 keltezéssel, Greg KH írta:
> > >
> > > > [...]
> > > >
> > > > > +static u8 polling_mode;
> > > > > +module_param(polling_mode, byte, 0444);
> > > > > +MODULE_PARM_DESC(polling_mode, "How to poll (default=0) - 0 disabled; 1 based on GPIO pin's status");
> > > >
> > > > Module parameters are for the 1990's, they are global and horrible to
> > > > try to work with. You should provide something on a per-device basis,
> > > > as what happens if your system requires different things here for
> > > > different devices? You set this for all devices :(
> > > > [...]
> > >
> > > Hi
> > > do you think something like what the usbcore has would be better?
> > > A module parameter like "quirks=<vendor-id>:<product-id>:<flags>[,<vendor-id>:<product-id>:<flags>]*"?
> >
> > Not really, that's just for debugging, and asking users to test
> > something, not for a final solution to anything.
> 
> My understanding is that this polling mode option is by no means intended
> as a final solution, it's purely for debugging/fallback:
> 
> "Polling mode could be a fallback solution for enthusiastic Linux users
> when they have a new laptop. It also acts like a debugging feature. If
> polling mode works for a broken touchpad, we can almost be certain
> the root cause is related to the interrupt or power setting."
> 
> What would you suggest instead of the module parameter?

a debugfs file?  That means it's only for debugging and you have to be
root to change the value.

thanks,

greg k-h
