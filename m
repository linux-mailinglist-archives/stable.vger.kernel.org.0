Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E165DCE4
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 20:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbjADThr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 14:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbjADTho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 14:37:44 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597646329
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 11:37:39 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id g2so16821596ila.4
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 11:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nSO9SsKkFS645whoBmF42/Je9/xfQ2j7vkQAqK0RKMY=;
        b=kq53WYymbNNRObAkxkyi8/aoPMrnrASRAmKR+fjFk2O3KaetpKGGv7ryYkhjKUfoSm
         zy/oX8wqM6ZKQpNvkrmwJE64p01W937ZRZnW9b/DCvNtSd74/Y+Bgh6SGLpm45W2n92O
         Va6ZvtBKQAOWtfYIzvgJh3ty8UeO4xgetRknc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSO9SsKkFS645whoBmF42/Je9/xfQ2j7vkQAqK0RKMY=;
        b=PM61ZEImmLzScrvwt6yi8CVcuIuBRWG2ZOEB8CrUrkqfR6gIgEUN+eH9O6oo8s5ZpY
         QTkdV76NvaSJDkSn5ASEqRFoNM9nO8EgAtIeGxqvFZROQck4Gd8G8q2YsKu25CHv+vIQ
         7TWg/PuxgzkH/NnQomRV+VIQSDE114UhZK8XKTmYVvIfG7OJ1+V7mEUUj4X5YO0+iTMH
         9qyRW8Eu94UYFLer7X92mgZMc1CfaIsZfiCtRFGTz1pFc+lIHNrbghjCCOs+dxD3OPhw
         k7s8NS/3MUQRBlM6HkCb8Q0XjF1B+DYFlenCWZGilF9CC0/FYF2A9XmVu7O+P98dRopa
         7Wfw==
X-Gm-Message-State: AFqh2koIDYP24GCISaYi3YhWuYSCZPm9+VGddcnWe+Jo9XuZxKuIt7Rn
        ZdFxR/BrTaAb4MM7aULCxZonQQ==
X-Google-Smtp-Source: AMrXdXstgyWSdSjbL8XY9C6fskus5zX1ACnnieCQ26fWlQDsxN0ig+ze1yeMHuNvtvAVzIZmBkiQqA==
X-Received: by 2002:a92:c151:0:b0:303:6dda:6748 with SMTP id b17-20020a92c151000000b003036dda6748mr31975882ilh.1.1672861058658;
        Wed, 04 Jan 2023 11:37:38 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id v17-20020a92ab11000000b0030bf7ae141esm9790673ilh.2.2023.01.04.11.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 11:37:38 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:37:37 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y7XVgfjLEDtWhMDB@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
 <Y7Rh+EkKKN5Gu8sz@google.com>
 <10807929.5MRjnR8RnV@steina-w>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <10807929.5MRjnR8RnV@steina-w>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 10:00:43AM +0100, Alexander Stein wrote:
> Hi Matthias,
> 
> Am Dienstag, 3. Januar 2023, 18:12:24 CET schrieb Matthias Kaehlcke:
> > On Thu, Dec 22, 2022 at 11:26:26AM -0800, Doug Anderson wrote:
> > > Hi,
> > > 
> > > On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org> 
> wrote:
> > > > The primary task of the onboard_usb_hub driver is to control the
> > > > power of an onboard USB hub. The driver gets the regulator from the
> > > > device tree property "vdd-supply" of the hub's DT node. Some boards
> > > > have device tree nodes for USB hubs supported by this driver, but
> > > > don't specify a "vdd-supply". This is not an error per se, it just
> > > > means that the onboard hub driver can't be used for these hubs, so
> > > > don't create platform devices for such nodes.
> > > > 
> > > > This change doesn't completely fix the reported regression. It
> > > > should fix it for the RPi 3 B Plus and boards with similar hub
> > > > configurations (compatible DT nodes without "vdd-supply"), boards
> > > > that actually use the onboard hub driver could still be impacted
> > > > by the race conditions discussed in that thread. Not creating the
> > > > platform devices for nodes without "vdd-supply" is the right
> > > > thing to do, independently from the race condition, which will
> > > > be fixed in future patch.
> > > > 
> > > > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > > > Link:
> > > > https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com
> > > > / Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > > ---
> > > > 
> > > > Changes in v2:
> > > > - don't create platform devices when "vdd-supply" is missing,
> > > > 
> > > >   rather than returning an error from _find_onboard_hub()
> > > > 
> > > > - check for "vdd-supply" not "vdd" (Johan)
> > > > - updated subject and commit message
> > > > - added 'Link' tag (regzbot)
> > > > 
> > > >  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > > 
> > > I'm a tad bit skeptical.
> > > 
> > > It somehow feels a bit too much like "inside knowledge" to add this
> > > here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> > > entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> > > keep the absolute minimum amount of stuff in it and all of the details
> > > be in the other file.
> > > 
> > > If this was the only issue though, I'd be tempted to let it slide. As
> > > it is, I'm kinda worried that your patch will break Alexander Stein,
> > > who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> > > CCed now). I believe those folks are using the USB hub driver
> > > primarily to drive a reset GPIO. Looking at the example in the
> > > bindings for one of them (genesys,gl850g.yaml), I even see that the
> > > reset-gpio is specified but not a vdd-supply. I think you'll break
> > > that?
> > 
> > Thanks for pointing that out. My assumption was that the regulator is
> > needed for the driver to do anything useful, but you are right, the
> > reset GPIO alone could be used in combination with an always-on regulator
> > to 'switch the hub on and off'.
> > 
> > > In general, it feels like it should actually be fine to create the USB
> > > hub driver even if vdd isn't supplied. Sure, it won't do a lot, but it
> > > shouldn't actively hurt anything. You'll just be turning off and on
> > > bogus regulators and burning a few CPU cycles. I guess the problem is
> > > some race condition that you talk about in the commit message. I'd
> > > rather see that fixed...
> > 
> > Yes, the race conditions needs to be fixed as well, I didn't have enough
> > time to write and test a patch before taking a longer break for the
> > holidays, so I only sent out this (supposed) partial mitigation.
> > 
> > > That being said, if we want to be more efficient and not burn CPU cycles
> > > and memory in Stefan Wahren's case, maybe the USB hub driver itself could
> > > return a canonical error value from its probe when it detects that it has
> > > no useful job and then "onboard_usb_hub_pdevs" could just silently bail
> > > out?
> > 
> > _probe() could return an error, however onboard_hub_create_pdevs() can't
> > rely on that, since the actual onboard_hub driver might not have been
> > loaded yet when the function is called.
> > 
> > It would be nice not to instantiate the pdev and onboard_hub USB instances
> > if the DT node has neither a 'vdd-supply' nor 'reset-gpios'. If we aren't
> > ok with doing that in onboard_hub_create_pdevs() then at least the 'raw'
> > platform device would be created. onboard_hub_probe() could still
> > bail if both properties are absent, _find_onboard_hub() would have to
> > check it again to avoid the deferred probing 'loop' for the USB instances.
> 
> I'm not really fond of checking for optional features like 'vdd-supply' and 
> 'reset-gpios'. This issue will pop up again if some new optional feature is 
> added again, e.g. power-domains.

It's not just any optional feature, it needs to be involved in controlling
power. I'm not super-exited about it either, but if we prefer not to
instantiate the drivers for certain DT nodes (TBD if that's a preference), we
need some sort of sentinel since the compatible string alone doesn't provide
enough information.

> > Alternatively we could 'just' fix the race condition involving the 'attach
> > work' and the onboard_hub driver is fully instantiated even on (certain)
> > boards where it does nothing. It's relatively rare that USB hub nodes are
> > specified in the DT (unless the intention is to use this driver) and
> > CONFIG_USB_ONBOARD_HUB needs to be set for the instances to be created,
> > so maybe creating the useless instances is not such a big deal.
> 
> IMHO creating a pdev shouldn't harm in any case. It's similar to having a DT 
> node without a corresponding driver enabled or even existing.

If we only want a 'raw' pdev (no instantiation of the onboard hub platform and
USB drivers) then a similar logic will be needed in the onboard hub driver(s).

So if we don't want any logic checking that at least one power related property
is defined then we have to accept that the onboard hub driver will be fully
instantiated even when it effectively does nothing.

If we add logic to the driver it needs to be checked in both the platform and
the USB driver (in the latter to avoid a deferred probe loop). It would be
simpler to just skip the creation of the 'raw' platform device in the first
place.

> Also adding USB devices to DT is something which is to be expected.
> usb-device.yaml exists since 2020 and the txt version since 2016.

Yes it it perfectly legal, so we need to handle this case somehow, and we
are currently discussing how to best do that :)

I still don't expect the combo of supported hub in the DT +
CONFIG_USB_ONBOARD_HUB=y/m to become super-popular, which could be an
argument for the option "just instantiate the drivers even if they do
nothing". Not my favorite option, but probably not that bad either.

> Unfortunately I'm not able to reproduce this issue on a different platform
> where the same HUB but no reset-gpios is required. I also noticed that
> onboard-usb-hub raises the error
> > Failed to attach USB driver: -22
> for each hub it is supposed to support.

Interesting

I also see the error with v6.2-rc1 but not a downstream v5.15 kernel which
runs most of the time on my boards. It turns out that with v6.2-rc1 the 'bus'
field of 'onboard_hub_usbdev_driver.drvwrap.driver' (passed to driver_attach())
is NULL, which causes driver_attach() / bus_for_each_dev() to return -EINVAL.

I did some testing (unbind/bind, unloading/reloading the driver) around the
'attach work' independently from your report. I couldn't repro a situation
where the onboard_hub USB devices aren't probed by the driver, which is what
the 'attach work' is supposed to solve. At some point I observed issues with
that in the past, which is why driver_attach() is called. The driver_attach()
call was added to the onboard_hub series in early 2021, by that time I was
probably testing with a v5.4 kernel, it's not unconceivable that the issue I
saw back then is fixed in newer kernels.

With that I was already considering to remove the 'attach work', the error you
reported reinforces that, since the driver_attach() call from the onboard_hub
driver does nothing in more recent kernels due to 'bus' being NULL.

Thanks

Matthias
