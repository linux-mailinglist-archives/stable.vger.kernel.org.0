Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B0C4C6938
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 11:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiB1LAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 06:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiB1K7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 05:59:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3721E23
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 02:58:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7919060B93
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A08C340E7;
        Mon, 28 Feb 2022 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646045908;
        bh=AivWMSOOKJzLw+LolXaKwUHv46VDl+J08D/IRUMsmjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4rYNpDhXFSxGvPXOwfecNabOvRHASx2aNif/vjwFk5+Kgp9Y2pirZAEHD3ozcdxo
         8rTwVzLXWXiYp2QrGt/f7kGmRE48rTg/KR6ys8oU20hiw64DVwZufGrWBb3w0Ub19S
         kNRc1nq8WaTzwbjpv6ipMAR6P9kLfyFthbmoZ0QE=
Date:   Mon, 28 Feb 2022 11:58:25 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Svenning =?iso-8859-1?Q?S=F8rensen?= <sss@secomea.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Sv: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging
 with more than two member" failed to apply to 5.16-stable tree
Message-ID: <Yhyq0c3aVhqNMF2P@kroah.com>
References: <164580577118139@kroah.com>
 <AM0PR08MB38593B3E0E9B6A861479A7F4B53E9@AM0PR08MB3859.eurprd08.prod.outlook.com>
 <YhnZBVVezubGkecl@kroah.com>
 <DB7PR08MB3867F9A962DA7A3B13408C12B53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
 <DB7PR08MB38675030606F175301EDE48AB53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB7PR08MB38675030606F175301EDE48AB53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 26, 2022 at 01:17:11PM +0000, Svenning Sørensen wrote:
> Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> plugged a packet leak between ports that were members of different bridges.
> Unfortunately, this broke another use case, namely that of more than two
> ports that are members of the same bridge.
> 
> After that commit, when a port is added to a bridge, hardware bridging
> between other member ports of that bridge will be cleared, preventing
> packet exchange between them.
> 
> Fix by ensuring that the Port VLAN Membership bitmap includes any existing
> ports in the bridge, not just the port being added.
> 
> Upstream commit 3d00827a90db6f79abc7cdc553887f89a2e0a184, backported to 5.16.
> 
> Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> Signed-off-by: Svenning Sørensen <sss@secomea.com>
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 8a04302018dc..7ab9ab58de65 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
>         struct dsa_switch *ds = dev->ds;
>         u8 port_member = 0, cpu_port;
>         const struct dsa_port *dp;
> -       int i;
> +       int i, j;
> 
>         if (!dsa_is_user_port(ds, port))
>                 return;
> @@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
>                         continue;
>                 if (!dp->bridge_dev || dp->bridge_dev != other_dp->bridge_dev)
>                         continue;
> +               if (other_p->stp_state != BR_STATE_FORWARDING)
> +                       continue;
> 
> -               if (other_p->stp_state == BR_STATE_FORWARDING &&
> -                   p->stp_state == BR_STATE_FORWARDING) {
> +               if (p->stp_state == BR_STATE_FORWARDING) {
>                         val |= BIT(port);
>                         port_member |= BIT(i);
>                 }
> 
> +               /* Retain port [i]'s relationship to other ports than [port] */
> +               for (j = 0; j < ds->num_ports; j++) {
> +                       const struct dsa_port *third_dp;
> +                       struct ksz_port *third_p;
> +
> +                       if (j == i)
> +                               continue;
> +                       if (j == port)
> +                               continue;
> +                       if (!dsa_is_user_port(ds, j))
> +                               continue;
> +                       third_p = &dev->ports[j];
> +                       if (third_p->stp_state != BR_STATE_FORWARDING)
> +                               continue;
> +                       third_dp = dsa_to_port(ds, j);
> +                       if (third_dp->bridge_dev == dp->bridge_dev)
> +                               val |= BIT(j);
> +               }
> +
>                 dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
>         }
> 
> --
> 2.20.1
> 

Patch is whitespace corrupted (tabs -> spaces) and can not be applied at
all :(

Please fix up and resend.

thanks,

greg k-h
