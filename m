Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E47653BD5
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiLVFuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 00:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLVFuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 00:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406FA1903A;
        Wed, 21 Dec 2022 21:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5806DB81C5A;
        Thu, 22 Dec 2022 05:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62572C433EF;
        Thu, 22 Dec 2022 05:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671688207;
        bh=rvy9/rPm/x49iOtpFVEv3WNErYHDHxMW8hxv3BT0guo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWnLwNlA2vlDTzocWm0yBlRPuMgd9z+Za4jmxl2ltdocQp3H4LYpXCjUFASeOL8qi
         POKPZoHEKehU4YMTiRXhC4glWliKjxMNQu/wqSv1ArTZgEyHLAQeCLPwcDuhSVKx3h
         Q+deEXqsSs+WSXD7q28JW0v8KQOqNj5btEQNtT68=
Date:   Thu, 22 Dec 2022 06:50:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y6PwDC0fRi+Volne@kroah.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 02:26:44AM +0000, Matthias Kaehlcke wrote:
> The primary task of the onboard_usb_hub driver is to control the
> power of an onboard USB hub. The driver gets the regulator from the
> device tree property "vdd-supply" of the hub's DT node. Some boards
> have device tree nodes for USB hubs supported by this driver, but
> don't specify a "vdd-supply". This is not an error per se, it just
> means that the onboard hub driver can't be used for these hubs, so
> don't create platform devices for such nodes.
> 
> This change doesn't completely fix the reported regression. It
> should fix it for the RPi 3 B Plus and boards with similar hub
> configurations (compatible DT nodes without "vdd-supply"), boards
> that actually use the onboard hub driver could still be impacted
> by the race conditions discussed in that thread. Not creating the
> platform devices for nodes without "vdd-supply" is the right
> thing to do, independently from the race condition, which will
> be fixed in future patch.
> 
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
> Changes in v2:
> - don't create platform devices when "vdd-supply" is missing,
>   rather than returning an error from _find_onboard_hub()
> - check for "vdd-supply" not "vdd" (Johan)
> - updated subject and commit message
> - added 'Link' tag (regzbot)
> 
>  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
