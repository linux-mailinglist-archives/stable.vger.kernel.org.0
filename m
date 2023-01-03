Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D55465C4FE
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjACRYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACRYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:24:15 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3740FCDF
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:24:14 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p9so99454iod.13
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T7dmA84w3bRzXW/+7JvJv3lBPrlPni3+L5B2EiLqjzs=;
        b=HaikNhqMYcPo5xuwBKG7cwjWvKFCOOmvJw1IsYi8vkBGZWDLbs9JJ8jLLXay6t7+nK
         Ypuz69wv9Q5zuYsbyXWbA9A81hcKRFuUIjFUdQuar0vxYcDp0PsylG/BQE0UEOzKoEgx
         oKEAnVq7txmdLck92GYB85mdGUC/aX14qXTFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7dmA84w3bRzXW/+7JvJv3lBPrlPni3+L5B2EiLqjzs=;
        b=M/IM0sN8OuWzzk0wnLPZ4Tvf8VhFPgVYgbF35Py4AQFE0D8S8phaL79ITFeruGSyNw
         xhGmRS7KfC1Nw2apC6uMUAEuqLYm5ytXf7VeRURjL2Zpea7Os8crEQP/16cIp/uUgAas
         l29aMtgnOllH8nVAxi++uTA4ujLPYhN6CLTchmvvQ2CUn8mYKiz3lFJQfCYwHq2SQoev
         55bSIDQZfsN/Q11YnxjMbm2yrVc4TIZeBcGvsW5wmEAVWqjSfBHwvIBrUguaa71GBkpi
         ujYDlTT4KCaLh0anSkOFXjaeYu5IPJ6grSllCDv5XP5iex6G+wk2/6jzM662dnqxeFlf
         tDTg==
X-Gm-Message-State: AFqh2kobcNXnaeQgJslKlFwVMvGB9u36qbD8ljWx3jYagObCtICqNXEQ
        FHL6LfOuFt1omkOG1sYz3cEYBw==
X-Google-Smtp-Source: AMrXdXuRZdbq/DIt8eHUsPJSrdouqm5esuV5HBMhdjurPwNG6mkPv2+TqfK3QDR5UG0nw/6UPQySHQ==
X-Received: by 2002:a05:6602:21cf:b0:6de:3a45:7d41 with SMTP id c15-20020a05660221cf00b006de3a457d41mr29038572ioc.15.1672766654072;
        Tue, 03 Jan 2023 09:24:14 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id w26-20020a05660205da00b006df3382b659sm11755461iox.42.2023.01.03.09.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 09:24:13 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:24:13 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Icenowy Zheng <uwu@icenowy.me>
Cc:     Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y7RkvfV/+b0z77b4@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
 <aa9fdfc04c3b6a3bba688bac244a157242faab82.camel@icenowy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa9fdfc04c3b6a3bba688bac244a157242faab82.camel@icenowy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 03:46:45PM +0800, Icenowy Zheng wrote:
> 在 2022-12-22星期四的 11:26 -0800，Doug Anderson写道：
> > Hi,
> > 
> > On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
> > wrote:
> > > 
> > > The primary task of the onboard_usb_hub driver is to control the
> > > power of an onboard USB hub. The driver gets the regulator from the
> > > device tree property "vdd-supply" of the hub's DT node. Some boards
> > > have device tree nodes for USB hubs supported by this driver, but
> > > don't specify a "vdd-supply". This is not an error per se, it just
> > > means that the onboard hub driver can't be used for these hubs, so
> > > don't create platform devices for such nodes.
> > > 
> > > This change doesn't completely fix the reported regression. It
> > > should fix it for the RPi 3 B Plus and boards with similar hub
> > > configurations (compatible DT nodes without "vdd-supply"), boards
> > > that actually use the onboard hub driver could still be impacted
> > > by the race conditions discussed in that thread. Not creating the
> > > platform devices for nodes without "vdd-supply" is the right
> > > thing to do, independently from the race condition, which will
> > > be fixed in future patch.
> > > 
> > > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > > Link:
> > > https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> > > Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > 
> > > Changes in v2:
> > > - don't create platform devices when "vdd-supply" is missing,
> > >   rather than returning an error from _find_onboard_hub()
> > > - check for "vdd-supply" not "vdd" (Johan)
> > > - updated subject and commit message
> > > - added 'Link' tag (regzbot)
> > > 
> > >  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > 
> > I'm a tad bit skeptical.
> > 
> > It somehow feels a bit too much like "inside knowledge" to add this
> > here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> > entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> > keep the absolute minimum amount of stuff in it and all of the
> > details
> > be in the other file.
> > 
> > If this was the only issue though, I'd be tempted to let it slide. As
> > it is, I'm kinda worried that your patch will break Alexander Stein,
> > who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> > CCed now). I believe those folks are using the USB hub driver
> > primarily to drive a reset GPIO. Looking at the example in the
> > bindings for one of them (genesys,gl850g.yaml), I even see that the
> > reset-gpio is specified but not a vdd-supply. I think you'll break
> > that?
> 
> Well technically in my final DT a regulator is included (to have the
> Vbus enabled when enabling the hub), however I am still against this
> patch, because the driver should work w/o vdd-supply (or w/o reset-
> gpios), and changing this behavior is a DT binding stability breakage.

Agreed that the driver should work with either 'vdd-supply' or
'reset-gpios' missing, however it won't do anything useful if neither
of them is specified. So if the driver wasn't instantiated in this
case there would be no behavioral change or DT binding stability
breakage.

> In addition the kernel never fails because of a lacking regulator
> unless explicitly forbid dummy regulators.

It wouldn't be an actual failure if the driver really has nothing to
do, userspace wouldn't see any differences, besides missing sysfs
entries for the onboard_hub pdev and USB devices.

> BTW USB is a discoverable bus, and if a hub do not need special
> handlement, it just does not need to appear in the DT, thus no onboard
> hub DT node.

That was my assumption when writing this driver, however there are
rare cases where hub nodes are specified without intention to use the
onboard_hub driver:

https://lore.kernel.org/all/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/

> > In general, it feels like it should actually be fine to create the
> > USB
> > hub driver even if vdd isn't supplied. Sure, it won't do a lot, but
> > it
> > shouldn't actively hurt anything. You'll just be turning off and on
> > bogus regulators and burning a few CPU cycles. I guess the problem is
> > some race condition that you talk about in the commit message. I'd
> > rather see that fixed... That being said, if we want to be more
> > efficient and not burn CPU cycles and memory in Stefan Wahren's case,
> > maybe the USB hub driver itself could return a canonical error value
> > from its probe when it detects that it has no useful job and then
> > "onboard_usb_hub_pdevs" could just silently bail out?
> 
> I agree.
> 
