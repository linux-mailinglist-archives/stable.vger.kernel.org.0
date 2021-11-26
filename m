Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA58545EAE0
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhKZKCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376511AbhKZKAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 05:00:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF0961107;
        Fri, 26 Nov 2021 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637920618;
        bh=9OYvcTu2WIu2aXhWr8kWuQT0PFnfR4TkpO1CH3AtbD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2JQapHHHBm5no9/x+I9vIg33t2GSTLnZFhZ7KJRqcgAS9DiUh461OXljhVdI9OnT
         9X+q8ekYjhRZ54xsFrRQG2gOEiPsjfJMaHybxzwLgLtmEZqlhaJLfvHy6o8KtbLT00
         AyQNaqAH5ToLTLUkmupRxR7S4xfy831s6eyZy01s=
Date:   Fri, 26 Nov 2021 10:56:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Brock <m.brock@vanmierlo.com>, stable@vger.kernel.org,
        Karoly Pados <pados@pados.hu>
Subject: Re: [PATCH] USB: serial: cp210x: fix CP2105 GPIO registration
Message-ID: <YaCvZl2W4ZkrVPX+@kroah.com>
References: <20211126094348.31698-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126094348.31698-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 10:43:48AM +0100, Johan Hovold wrote:
> When generalising GPIO support and adding support for CP2102N, the GPIO
> registration for some CP2105 devices accidentally broke. Specifically,
> when all the pins of a port are in "modem" mode, and thus unavailable
> for GPIO use, the GPIO chip would now be registered without having
> initialised the number of GPIO lines. This would in turn be rejected by
> gpiolib and some errors messages would be printed (but importantly probe
> would still succeed).
> 
> Fix this by initialising the number of GPIO lines before registering the
> GPIO chip.
> 
> Note that as for the other device types, and as when all CP2105 pins are
> muxed for LED function, the GPIO chip is registered also when no pins
> are available for GPIO use.
> 
> Reported-by: Maarten Brock <m.brock@vanmierlo.com>
> Link: https://lore.kernel.org/r/5eb560c81d2ea1a2b4602a92d9f48a89@vanmierlo.com
> Fixes: c8acfe0aadbe ("USB: serial: cp210x: implement GPIO support for CP2102N")
> Cc: stable@vger.kernel.org      # 4.19
> Cc: Karoly Pados <pados@pados.hu>
> Signed-off-by: Johan Hovold <johan@kernel.org>


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
