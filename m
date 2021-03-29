Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431BE34D7AD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhC2S73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhC2S7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704686191B;
        Mon, 29 Mar 2021 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617044343;
        bh=xdO+z4dhMu4WZwqstLnUEriFeGAdlgdGnkOuPeGS+5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0KJoIkDgu8yjGwER45JhHPURQp6vjAKnS2zZjZj3OFOB7eZhM8U7yW8uzvUMpTaYC
         0qDlWxduClCYRumSALVtnHxkldgjhsDHyHnoMTntrhVaj6JF+Qa+bLMo9Gh8r3AroZ
         F/gZ5cFFy98FnDaWzoc6cC3vNXpqtehLAwIvsfKw=
Date:   Mon, 29 Mar 2021 20:59:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Annaliese McDermond <nh6z@nh6z.net>
Cc:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "team@nwdigitalradio.com" <team@nwdigitalradio.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sc16is7xx: Defer probe if device read fails
Message-ID: <YGIjdAC1qXMp6scY@kroah.com>
References: <20210329154013.408967-1-nh6z@nh6z.net>
 <010101787ea4d8c4-08608e8d-9755-4a88-9908-af95233a4f8e-000000@us-west-2.amazonses.com>
 <YGIZ4bOX/4DF0KQ4@kroah.com>
 <D3421B6F-AD12-4B5E-AF02-9EFF80E79473@nh6z.net>
 <010101787f451ae7-57a585bf-f3c4-447c-bc86-077799736766-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <010101787f451ae7-57a585bf-f3c4-447c-bc86-077799736766-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 06:35:38PM +0000, Annaliese McDermond wrote:
> 
> 
> > On Mar 29, 2021, at 11:18 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Mon, Mar 29, 2021 at 03:40:35PM +0000, Annaliese McDermond wrote:
> >> A test was added to the probe function to ensure the device was
> >> actually connected and working before successfully completing a
> >> probe.  If the device was actually there, but the I2C bus was not
> >> ready yet for whatever reason, the probe fails permanently.
> >> 
> >> Change the probe so that we defer the probe on a regmap read
> >> failure so that we try the probe again when the dependent drivers
> >> are potentially loaded.  This should not affect the case where the
> >> device truly isn't present because the probe will never successfully
> >> complete.
> >> 
> >> Fixes: 2aa916e ("sc16is7xx: Read the LSR register for basic device presence check")
> > 
> > Please use the full 12 characters of the git commit id, as the
> > documentation asks for.  This should be:
> > 
> > Fixes: 2aa916e67db3 ("sc16is7xx: Read the LSR register for basic device presence check")
> 
> I’m sorry, I must have missed the section specifying that, and since I saw commits like
> 05962f95f9ac specifying 7 characters in their “fixes” line, I made the assumption that
> this was the correct length.
> 
> Would you like me to post a v2 patch with the hash changed?

Please do.

> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
> >> ---
> >> drivers/tty/serial/sc16is7xx.c | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> >> index f86ec2d2635b..9adb8362578c 100644
> >> --- a/drivers/tty/serial/sc16is7xx.c
> >> +++ b/drivers/tty/serial/sc16is7xx.c
> >> @@ -1196,7 +1196,7 @@ static int sc16is7xx_probe(struct device *dev,
> >> 	ret = regmap_read(regmap,
> >> 			  SC16IS7XX_LSR_REG << SC16IS7XX_REG_SHIFT, &val);
> >> 	if (ret < 0)
> >> -		return ret;
> >> +		return -EPROBE_DEFER;
> >> 
> >> 	/* Alloc port structure */
> >> 	s = devm_kzalloc(dev, struct_size(s, p, devtype->nr_uart), GFP_KERNEL);
> >> -- 
> >> 2.27.0
> > 
> > Any reason you did not cc: the tty maintainer with this change?
> 
> None other than I believed “serial drivers” to be more specific than “tty layer” when
> looking at the maintainers.  I’m happy to Cc Jiri if needed.

The tool, scripts/get_maintainer.pl is your friend, always run it on
your patch.

You also forgot to send it to me :)

thanks,

greg k-h
