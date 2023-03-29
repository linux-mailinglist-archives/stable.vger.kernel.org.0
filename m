Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3546CD5CA
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjC2JCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjC2JCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:02:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104844490;
        Wed, 29 Mar 2023 02:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA7261C04;
        Wed, 29 Mar 2023 09:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBDAC433D2;
        Wed, 29 Mar 2023 09:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680080496;
        bh=uPahMJ4y9euWngEtuJcPodqtosHgcr2IzBxPNbo0yQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M4cevX5jveBKVTBBED49BC8ZZ1bQNvH8pBy2Rv+CXL/fVKY+uSi9UO7apcTHQjn0G
         dKlk6Fz7AsGe2oqyyUxi2YsxIjLiOxJJ+zkEJ21hNrwiQ8ADkA8zWoS9kNiRlP2cK0
         daHMlXx7DyeFSGhQF4O0taL7PWUVJ6WnRDZ8m2H4=
Date:   Wed, 29 Mar 2023 11:01:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Message-ID: <ZCP-bdhw585BSKdx@kroah.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
 <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 11:32:38AM +0000, Biju Das wrote:
> Hi Geert,
> 
> Thanks for the feedback.
> 
> > Subject: Re: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
> > 
> > On Tue, Mar 21, 2023 at 12:48 PM Biju Das <biju.das.jz@bp.renesas.com>
> > wrote:
> > > SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
> > > IPs on the SH platform. Currently, it does regshift and configuring Rx
> > > wrongly. Drop adding regshift for RZ/G2L alike SoCs.
> > >
> > > Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value for
> > > SCI ports")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > > v3->v4:
> > >  * Updated the fixes tag
> > >  * Replaced sci_port->is_rz_sci with dev->dev.of_node as regshift are only
> > needed
> > >    for sh770x/sh7750/sh7760, which don't use DT yet.
> > >  * Dropped is_rz_sci variable from struct sci_port.
> > 
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > 
> > One can wonder how this ever worked on DT-based H8/300...
> 
> Yep, it is interesting to see whether SCI ever worked on DT-based H8/300
> Assuming it has same register layout as RZ/G2L SoC.

This is already in Linus's tree now, right?

confused,

greg k-h
