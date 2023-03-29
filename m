Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D996CD63C
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjC2JUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjC2JUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD93310CC;
        Wed, 29 Mar 2023 02:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3050061B38;
        Wed, 29 Mar 2023 09:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459E6C433EF;
        Wed, 29 Mar 2023 09:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680081607;
        bh=Duat8LbEKUF7NtbxrvgLRGKr5KTop238tLlGHRMMACQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvTe+ukcqXEkAP7T2H/khZZ7o0O1+kGvyGFjI8qbuD4JB/FvnAZmfLsm/JfbMmO+d
         3IT6tS6EMurGRWghQUjvpsvRd2R77bC3s4CMwl/cE1Iy3bClOhBqKxYjWh+orClkeL
         r3RSR7R161M5/brfIzpWiQyXEKJD8jAZdDjbZOoU=
Date:   Wed, 29 Mar 2023 11:20:05 +0200
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
Message-ID: <ZCQCxQDwR1N4KT4r@kroah.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
 <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
 <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
 <OS0PR01MB5922092AD985055F7376611486889@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <ZCP-bdhw585BSKdx@kroah.com>
 <OS0PR01MB5922F0F9BB4D42C3E14F1A7A86899@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OS0PR01MB5922F0F9BB4D42C3E14F1A7A86899@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 09:06:43AM +0000, Biju Das wrote:
> Hi Greg,
> 
> Thanks for the feedback.
> 
> > Subject: Re: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
> > 
> > On Tue, Mar 28, 2023 at 11:32:38AM +0000, Biju Das wrote:
> > > Hi Geert,
> > >
> > > Thanks for the feedback.
> > >
> > > > Subject: Re: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L
> > > > SCI
> > > >
> > > > On Tue, Mar 21, 2023 at 12:48 PM Biju Das
> > > > <biju.das.jz@bp.renesas.com>
> > > > wrote:
> > > > > SCI IP on RZ/G2L alike SoCs do not need regshift compared to other
> > > > > SCI IPs on the SH platform. Currently, it does regshift and
> > > > > configuring Rx wrongly. Drop adding regshift for RZ/G2L alike SoCs.
> > > > >
> > > > > Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value
> > > > > for SCI ports")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > > > ---
> > > > > v3->v4:
> > > > >  * Updated the fixes tag
> > > > >  * Replaced sci_port->is_rz_sci with dev->dev.of_node as regshift
> > > > > are only
> > > > needed
> > > > >    for sh770x/sh7750/sh7760, which don't use DT yet.
> > > > >  * Dropped is_rz_sci variable from struct sci_port.
> > > >
> > > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > >
> > > > One can wonder how this ever worked on DT-based H8/300...
> > >
> > > Yep, it is interesting to see whether SCI ever worked on DT-based
> > > H8/300 Assuming it has same register layout as RZ/G2L SoC.
> > 
> > This is already in Linus's tree now, right?
> 
> As per the discussion with Geert, It is been removed since 2022. Yes, It is present in backports.
> 
> Geert, please correct me If I am wrong.

Seems to not apply against 6.3-rc3 :(
