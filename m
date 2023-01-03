Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9D65C540
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbjACRm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbjACRm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:42:26 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4348AE1C
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:42:25 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id g2so15194230ila.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SPDvhZ0E+hOADgQrqmkwdgK1yPO4Xou1kXlnqFtt01g=;
        b=EAge6w5ZGRKB9REw8JTGWI3X+y6NFbFLA4CE16oprx2LDBAocRw7kt+gIOO8EwJ8Xh
         Nu7M7XBLVpM+Cy2lG0rwHZyToFl76QRABNZe+cWQhJZWLQJXAwDky/V1pBvlz7Qqjiti
         72Mw4YvDaD59xF9DkPjKArKfamDrpeKUc3MlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPDvhZ0E+hOADgQrqmkwdgK1yPO4Xou1kXlnqFtt01g=;
        b=aslOvwZEp7S+vXTi4FoxoteGZhwLp+PT5E9JdnkgThseQx585w3SGFWONnM4YmZRrr
         w0HBl7VWZOID7UjB3xEfz43DlisLZ2e5gN3IpIPYarRBNa6LRV73NzkpRVRTmZndffSi
         rmT4gW+RSwxz78Dg0t8n7dyxUNCRyqYUHcZWcRLznYW2a+r2EAu/7WkZCye4hsuv1/pF
         yKp8W7dsjEc30sT7z3vmRYXIuk9VSsLgiG3oGkGb+q5/MOAefANTFXtjAWjKCTGkux0N
         uch0x7TrFB7zRZy2RDrh4XhbYPi4xu3n9fcuyzMrISaedJfvlmkFw485F5TSfzQr0Mpb
         439w==
X-Gm-Message-State: AFqh2kpbCcmjEBnwpX95hjkQF1Ok9LvhwmHRCgeEBYpswNRwFArwXaIg
        YyYLNtytzJhXFdPoIeU8W/gpLw==
X-Google-Smtp-Source: AMrXdXtVUcQIUZ2ljG4DSCmHOTMpzAcdwG1RqxZf8Z/PZEZhTzawDTPwIzAj5OqvwAYwVmdelSeFIg==
X-Received: by 2002:a92:d10f:0:b0:305:dee9:bcc6 with SMTP id a15-20020a92d10f000000b00305dee9bcc6mr27345476ilb.17.1672767744507;
        Tue, 03 Jan 2023 09:42:24 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id g14-20020a056e021a2e00b00304ae88ebebsm9792396ile.88.2023.01.03.09.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 09:42:24 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:42:23 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y7Ro/1idORXbhCnu@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <Y6W00vQm3jfLflUJ@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y6W00vQm3jfLflUJ@hovoldconsulting.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 03:01:54PM +0100, Johan Hovold wrote:
> On Thu, Dec 22, 2022 at 02:26:44AM +0000, Matthias Kaehlcke wrote:
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
> 
> Please try to remember to CC people providing feedback on your patches.

Ack

> > - updated subject and commit message
> > - added 'Link' tag (regzbot)
> > 
> >  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/drivers/usb/misc/onboard_usb_hub_pdevs.c b/drivers/usb/misc/onboard_usb_hub_pdevs.c
> > index ed22a18f4ab7..8cea53b0907e 100644
> > --- a/drivers/usb/misc/onboard_usb_hub_pdevs.c
> > +++ b/drivers/usb/misc/onboard_usb_hub_pdevs.c
> > @@ -101,6 +101,19 @@ void onboard_hub_create_pdevs(struct usb_device *parent_hub, struct list_head *p
> >  			}
> >  		}
> >  
> > +		/*
> > +		 * The primary task of the onboard_usb_hub driver is to control
> > +		 * the power of an USB onboard hub. Some boards have device tree
> > +		 * nodes for USB hubs supported by this driver, but don't
> > +		 * specify a "vdd-supply", which is needed by the driver. This is
> > +		 * not a DT error per se, it just means that the onboard hub
> > +		 * driver can't be used with these nodes, so don't create a
> > +		 * a platform device for such a node.
> > +		 */
> > +		if (!of_get_property(np, "vdd-supply", NULL) &&
> > +		    !of_get_property(npc, "vdd-supply", NULL))
> > +			goto node_put;
> 
> So as I mentioned elsewhere, this doesn't look right. It is the
> responsibility of the platform driver to manage its resources and it may
> not even need a supply.
> 
> I see now that you have already matched on the compatible property above
> so that you only create the platform device for the devices that (may)
> need it.
> 
> It seems the assumptions that this driver was written under needs to be
> revisited.

The assumption was that the driver should always be used when the DT has
nodes with the supported compatible strings. It turns out that is not
entirely correct, in rare cases (like the RPi 3 B Plus) the nodes weren't
added with the onboard_hub driver in mind and may lack DT properties that
are needed by the driver.

I see essentially two possible ways of dealing with DT nodes that don't
have all the information to make the onboard_hub driver do something useful:

1) don't instantiate the driver when certain DT properties don't exist (the
   approach of this patch)

2) instantiate the driver regardless. Not ideal, but such DTs should be
   relatively rare (+ CONFIG_USB_ONBOARD_HUB needs to be enabled for
   instantiation to happen), so maybe it's not a big deal
