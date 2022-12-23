Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288FC654CF9
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 08:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLWHrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 02:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLWHrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 02:47:08 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1A825EA8;
        Thu, 22 Dec 2022 23:47:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1671781611; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WAmnG/7WmBojD5yX/BMhJvXhQP81hfEKSP6Bz+Ki3Tr1FisxiO0jZXfXvuyNae8hXIW4kbhLZdMeEt2TXQmLxnJw69ZimeiorMXRBd59rWNl14NMLIHBUZwgosrRQ1jQJ9xq+lIjkOQ+nx9//il/FWw/EqWM1peXWMdzWmmq02E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1671781611; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OPemjbTg3A1NAV8ZaqaXhvWUyc8aIggBEADkKRR9l40=; 
        b=DdicahY5LwXcRCIviVf8bCRVTGEzwGsuOKgQJQANy5AzOUVwSe8QG+I3RRb0df+9LoUiY03EO+aB9rvJXdrrXUP4iQ4QhYqGIq77DjpTYPo3FRxrOh7dqMensaoekocLNaRZCnm5M7MmsGBWJd9/sbP97uRAHtvIzhKY0O2NwZU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=icenowy.me;
        spf=pass  smtp.mailfrom=uwu@icenowy.me;
        dmarc=pass header.from=<uwu@icenowy.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1671781611;
        s=zmail; d=icenowy.me; i=uwu@icenowy.me;
        h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
        bh=OPemjbTg3A1NAV8ZaqaXhvWUyc8aIggBEADkKRR9l40=;
        b=V9DGAhl5Ovyl2TN1MqS2IxkBaHNh9hec2F5INe5PdvTAWx3TWrwpc3EKlLRHTfmq
        sOxMSTsSwvAZ+FMb4AptqhZZqsTlUnEPIScXFOeucCF4i7m+aEIIF2e2Xo3yzvjpq8D
        JaDObqqylLueTLy1YXfhyxUNgDRgOJElEBa55hoQ=
Received: from edelgard.fodlan.icenowy.me (120.85.98.209 [120.85.98.209]) by mx.zohomail.com
        with SMTPS id 167178160951175.93162783383423; Thu, 22 Dec 2022 23:46:49 -0800 (PST)
Message-ID: <aa9fdfc04c3b6a3bba688bac244a157242faab82.camel@icenowy.me>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create
 platform devices for DT nodes without 'vdd-supply'
From:   Icenowy Zheng <uwu@icenowy.me>
To:     Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Date:   Fri, 23 Dec 2022 15:46:45 +0800
In-Reply-To: <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
         <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
Organization: Anthon Open-Source Community
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=E5=9C=A8 2022-12-22=E6=98=9F=E6=9C=9F=E5=9B=9B=E7=9A=84 11:26 -0800=EF=BC=
=8CDoug Anderson=E5=86=99=E9=81=93=EF=BC=9A
> Hi,
>=20
> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
> wrote:
> >=20
> > The primary task of the onboard_usb_hub driver is to control the
> > power of an onboard USB hub. The driver gets the regulator from the
> > device tree property "vdd-supply" of the hub's DT node. Some boards
> > have device tree nodes for USB hubs supported by this driver, but
> > don't specify a "vdd-supply". This is not an error per se, it just
> > means that the onboard hub driver can't be used for these hubs, so
> > don't create platform devices for such nodes.
> >=20
> > This change doesn't completely fix the reported regression. It
> > should fix it for the RPi 3 B Plus and boards with similar hub
> > configurations (compatible DT nodes without "vdd-supply"), boards
> > that actually use the onboard hub driver could still be impacted
> > by the race conditions discussed in that thread. Not creating the
> > platform devices for nodes without "vdd-supply" is the right
> > thing to do, independently from the race condition, which will
> > be fixed in future patch.
> >=20
> > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > Link:
> > https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com=
/
> > Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >=20
> > Changes in v2:
> > - don't create platform devices when "vdd-supply" is missing,
> > =C2=A0 rather than returning an error from _find_onboard_hub()
> > - check for "vdd-supply" not "vdd" (Johan)
> > - updated subject and commit message
> > - added 'Link' tag (regzbot)
> >=20
> > =C2=A0drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> > =C2=A01 file changed, 13 insertions(+)
>=20
> I'm a tad bit skeptical.
>=20
> It somehow feels a bit too much like "inside knowledge" to add this
> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> keep the absolute minimum amount of stuff in it and all of the
> details
> be in the other file.
>=20
> If this was the only issue though, I'd be tempted to let it slide. As
> it is, I'm kinda worried that your patch will break Alexander Stein,
> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> CCed now). I believe those folks are using the USB hub driver
> primarily to drive a reset GPIO. Looking at the example in the
> bindings for one of them (genesys,gl850g.yaml), I even see that the
> reset-gpio is specified but not a vdd-supply. I think you'll break
> that?

Well technically in my final DT a regulator is included (to have the
Vbus enabled when enabling the hub), however I am still against this
patch, because the driver should work w/o vdd-supply (or w/o reset-
gpios), and changing this behavior is a DT binding stability breakage.

In addition the kernel never fails because of a lacking regulator
unless explicitly forbid dummy regulators.

BTW USB is a discoverable bus, and if a hub do not need special
handlement, it just does not need to appear in the DT, thus no onboard
hub DT node.

>=20
> In general, it feels like it should actually be fine to create the
> USB
> hub driver even if vdd isn't supplied. Sure, it won't do a lot, but
> it
> shouldn't actively hurt anything. You'll just be turning off and on
> bogus regulators and burning a few CPU cycles. I guess the problem is
> some race condition that you talk about in the commit message. I'd
> rather see that fixed... That being said, if we want to be more
> efficient and not burn CPU cycles and memory in Stefan Wahren's case,
> maybe the USB hub driver itself could return a canonical error value
> from its probe when it detects that it has no useful job and then
> "onboard_usb_hub_pdevs" could just silently bail out?

I agree.

