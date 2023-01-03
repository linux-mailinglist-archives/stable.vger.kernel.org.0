Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7021865C4D1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbjACRNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbjACRMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:12:46 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE4E0D
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:12:26 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id i83so16876521ioa.11
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=em3Ufd1K4FFk6wUY+M7YROP86iN6cIDpfsX/6JZ8LMs=;
        b=IxtRL1xI/M7DHv6CuM2XNgJ63pduHqi4eG8on4E2MOZfzDFgtSQ7zMJJJBh990hFZh
         WAkVgsQn71Z2e1DpUiHQwLMpfiHRniYn3qeCgE4Dw+j7gyxO7wsTBc19pQcUTmhVrx2d
         /tz4xiyHI9iTo95NWoWI3W3QryAVA5l3HhbbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=em3Ufd1K4FFk6wUY+M7YROP86iN6cIDpfsX/6JZ8LMs=;
        b=RkOiBzUTcsl0Dz5IPTCA3qNem3586hEc5ZzUschqIW0q/CKEaBbcJbac+Y9zFVEvGx
         vX6s5lSs1IWn1BL8OQ9PUrvAc1iwEzdZOyky041OwKqhSQh2w6r5Euyf6h0Iwdu+gZid
         oF4V74WjjiG8coq7rp6vWfEE3EEOc0NJquodA1Zh/3Lkd5B63ec87nu2oXxzR0hdSMwO
         GnU4w+YQTQtgJ1rTiL9WMGs4waCLNKE2sfyZlwtf3bcI9MmbVC2jqTduQUacAfuAEATk
         4l1uNpuUzVQdqNMxF20yp640Glu17jjjrE2ioTQQ41MMvbNKh70NytIfv4bCagRbI9UF
         CU0Q==
X-Gm-Message-State: AFqh2krw/RusPZj/zRkK+hvIlqTZDQkA52TfvYL4c1DiCu8AEZWsOWOJ
        YIcpj1SukzuwwXowry26btWjgA==
X-Google-Smtp-Source: AMrXdXtO9WUhdiUZPUG/gevDvi+yxjJQcLLm7WRVJWiMFvJt5PBubVlHOmNols6A6ArtSfWGZcVXRQ==
X-Received: by 2002:a5e:8d1a:0:b0:6e3:21fd:6783 with SMTP id m26-20020a5e8d1a000000b006e321fd6783mr27731823ioj.2.1672765945209;
        Tue, 03 Jan 2023 09:12:25 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id x6-20020a056602160600b006e00556dc9esm11407972iow.16.2023.01.03.09.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 09:12:24 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:12:24 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y7Rh+EkKKN5Gu8sz@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 11:26:26AM -0800, Doug Anderson wrote:
> Hi,
> 
> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org> wrote:
> >
> > The primary task of the onboard_usb_hub driver is to control the
> > power of an onboard USB hub. The driver gets the regulator from the
> > device tree property "vdd-supply" of the hub's DT node. Some boards
> > have device tree nodes for USB hubs supported by this driver, but
> > don't specify a "vdd-supply". This is not an error per se, it just
> > means that the onboard hub driver can't be used for these hubs, so
> > don't create platform devices for such nodes.
> >
> > This change doesn't completely fix the reported regression. It
> > should fix it for the RPi 3 B Plus and boards with similar hub
> > configurations (compatible DT nodes without "vdd-supply"), boards
> > that actually use the onboard hub driver could still be impacted
> > by the race conditions discussed in that thread. Not creating the
> > platform devices for nodes without "vdd-supply" is the right
> > thing to do, independently from the race condition, which will
> > be fixed in future patch.
> >
> > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> > Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >
> > Changes in v2:
> > - don't create platform devices when "vdd-supply" is missing,
> >   rather than returning an error from _find_onboard_hub()
> > - check for "vdd-supply" not "vdd" (Johan)
> > - updated subject and commit message
> > - added 'Link' tag (regzbot)
> >
> >  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> 
> I'm a tad bit skeptical.
> 
> It somehow feels a bit too much like "inside knowledge" to add this
> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> keep the absolute minimum amount of stuff in it and all of the details
> be in the other file.
> 
> If this was the only issue though, I'd be tempted to let it slide. As
> it is, I'm kinda worried that your patch will break Alexander Stein,
> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> CCed now). I believe those folks are using the USB hub driver
> primarily to drive a reset GPIO. Looking at the example in the
> bindings for one of them (genesys,gl850g.yaml), I even see that the
> reset-gpio is specified but not a vdd-supply. I think you'll break
> that?

Thanks for pointing that out. My assumption was that the regulator is
needed for the driver to do anything useful, but you are right, the
reset GPIO alone could be used in combination with an always-on regulator
to 'switch the hub on and off'.

> In general, it feels like it should actually be fine to create the USB
> hub driver even if vdd isn't supplied. Sure, it won't do a lot, but it
> shouldn't actively hurt anything. You'll just be turning off and on
> bogus regulators and burning a few CPU cycles. I guess the problem is
> some race condition that you talk about in the commit message. I'd
> rather see that fixed...

Yes, the race conditions needs to be fixed as well, I didn't have enough
time to write and test a patch before taking a longer break for the
holidays, so I only sent out this (supposed) partial mitigation.

> That being said, if we want to be more efficient and not burn CPU cycles
> and memory in Stefan Wahren's case, maybe the USB hub driver itself could
> return a canonical error value from its probe when it detects that it has
> no useful job and then "onboard_usb_hub_pdevs" could just silently bail
> out?

_probe() could return an error, however onboard_hub_create_pdevs() can't
rely on that, since the actual onboard_hub driver might not have been
loaded yet when the function is called.

It would be nice not to instantiate the pdev and onboard_hub USB instances
if the DT node has neither a 'vdd-supply' nor 'reset-gpios'. If we aren't
ok with doing that in onboard_hub_create_pdevs() then at least the 'raw'
platform device would be created. onboard_hub_probe() could still
bail if both properties are absent, _find_onboard_hub() would have to
check it again to avoid the deferred probing 'loop' for the USB instances.

Alternatively we could 'just' fix the race condition involving the 'attach
work' and the onboard_hub driver is fully instantiated even on (certain)
boards where it does nothing. It's relatively rare that USB hub nodes are
specified in the DT (unless the intention is to use this driver) and
CONFIG_USB_ONBOARD_HUB needs to be set for the instances to be created,
so maybe creating the useless instances is not such a big deal.
