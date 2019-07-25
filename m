Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071E57516D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 16:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387850AbfGYOkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 10:40:10 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52211 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387834AbfGYOkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 10:40:09 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4E0F860012;
        Thu, 25 Jul 2019 14:40:06 +0000 (UTC)
Date:   Thu, 25 Jul 2019 13:32:37 +0200
From:   "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 0/1] This patch fixes connection detection for monitors
 w/o DDC.
Message-ID: <20190725113237.d2dwxzientte4j3n@flea>
References: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

65;5603;1c
On Thu, Jul 25, 2019 at 11:05:23AM +0000, Oleksandr Suvorov wrote:
>
> Even in source code of this driver there is an author's description:
>     /*
>      * Even if we have an I2C bus, we can't assume that the cable
>      * is disconnected if drm_probe_ddc fails. Some cables don't
>      * wire the DDC pins, or the I2C bus might not be working at
>      * all.
>      */
>
> That's true. DDC and VGA channels are independent, and therefore
> we cannot decide whether the monitor is connected or not,
> depending on the information from the DDC.
>
> So the monitor should always be considered connected.

Well, no. Like you said, we cannot decided whether is connected or
not.

> Thus there is no reason to use connector detect callback for this
> driver: DRM sub-system considers monitor always connected if there
> is no detect() callback registered with drm_connector_init().
>
> How to reproduce the bug:
> * setup: i.MX8QXP, LCDIF video module + gpu/drm/mxsfb driver,
>   adv712x VGA DAC + dumb-vga-dac driver, VGA-connector w/o DDC;
> * try to use drivers chain mxsfb-drm + dumb-vga-dac;
> * any DRM applications consider the monitor is not connected:
>   ===========
>   $ weston-start
>   $ cat /var/log/weston.log
>       ...
>       DRM: head 'VGA-1' found, connector 32 is disconnected.
>       ...
>   $ cat /sys/devices/platform/5a180000.lcdif/drm/card0/card0-VGA-1/status
>   unknown

And that's exactly what's being reported here: we cannot decide if it
is connected or not, so it's unknown.

If weston chooses to ignore connectors that are in an unknown state,
I'd say it's weston's problem, since it's much broader than this
particular device.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
