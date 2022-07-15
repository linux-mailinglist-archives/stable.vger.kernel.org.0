Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B1657640E
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiGOPE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiGOPE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:04:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C65D2B275
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 08:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE10C62041
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 15:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8BEC34115;
        Fri, 15 Jul 2022 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657897497;
        bh=EdeUh0P60IsCGnV7exKNsrtWwGeoSTBn5VI20keVTwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EeI8LCuuUWb8H626KKDvo8ApeTyVnUbJMLT2oR6Mj3IO2rDBxLqb+Gq74agaQvewI
         sXH1M1yje0/fQNJbvWljIjYe62icqYROczaUIDdLwoxunWwmqkY+TtzMqVNgeSgfRZ
         VByBmwVwT+my55umvevJVSE4UlBUaZQdcQSWKpnE=
Date:   Fri, 15 Jul 2022 17:04:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd@lists.infradead.org, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting
Message-ID: <YtGCFmN+0/SYdvOz@kroah.com>
References: <20220614083138.3455683-1-s.hauer@pengutronix.de>
 <20220715142209.GA1688021@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715142209.GA1688021@roeck-us.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 07:22:09AM -0700, Guenter Roeck wrote:
> On Tue, Jun 14, 2022 at 10:31:38AM +0200, Sascha Hauer wrote:
> > The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:
> > 
> > | Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
> > | mode. This value is the number of GPMI_CLK cycles multiplied by 4096.
> > 
> > So instead of multiplying the value in cycles with 4096, we have to
> > divide it by that value. Use DIV_ROUND_UP to make sure we are on the
> > safe side, especially when the calculated value in cycles is smaller
> > than 4096 as typically the case.
> > 
> > This bug likely never triggered because any timeout != 0 usually will
> > do. In my case the busy timeout in cycles was originally calculated as
> > 2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
> > taken for the 16 bit wide register field, so the register value was
> > 0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
> > setting") however the value in cycles became 2384, which multiplied
> > with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
> > intermediate timeout when reading from NAND.
> > 
> > Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of an empirical derivation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> I see this patch was reverted in a set of rush stable releases,
> but I still see it in the mainline kernel. Is it going to be reverted
> there as well ?

A fix has been sent, it was said to be picked up hopefully next week:
	https://lore.kernel.org/all/20220701110341.3094023-1-s.hauer@pengutronix.de/

thanks,

greg k-h
