Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD1575CA6
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 09:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiGOHqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 03:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGOHqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 03:46:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E0577A6B
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 00:46:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oCG1x-0007Bp-CL; Fri, 15 Jul 2022 09:46:33 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oCG1v-0005yr-K1; Fri, 15 Jul 2022 09:46:31 +0200
Date:   Fri, 15 Jul 2022 09:46:31 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel@pengutronix.de,
        stable@vger.kernel.org, k.drobinski@camlintechnologies.com
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
Message-ID: <20220715074631.GA7333@pengutronix.de>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
 <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
 <YtD/9KJZwlVj+6hS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YtD/9KJZwlVj+6hS@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 07:49:40AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 15, 2022 at 07:27:02AM +0200, Tomasz Moń wrote:
> > On Mon, 2022-07-11 at 11:12 +0200, Tomasz Moń wrote:
> > > On Fri, 2022-07-01 at 13:03 +0200, Sascha Hauer wrote:
> > > > 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> > > > value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> > > > though: It is calculated based on the maximum page read time, but the
> > > > timeout is also used for page write and block erase operations which
> > > > require orders of magnitude bigger timeouts.
> > > > 
> > > > Fix this by calculating busy_timeout_cycles from the maximum of
> > > > tBERS_max and tPROG_max.
> > > 
> > > 06781a5026350 was merged in v5.19-rc4 and then was picked up by several
> > > stable kernels, including v5.15.51. After we have upgraded to v5.15.51
> > > we have observed the issue that Sascha mentioned in his email [1].
> > > 
> > > As the v5.19-rc6 was released yesterday and this fix is still not
> > > applied, the v5.19-rc6 (and all stable kernels that picked up the
> > > backport) causes NAND flash data loss on imx targets.
> > > 
> > > I have backported this patch to our internal v5.15.51 based kernel on
> > > 4th July 2022 and I can confirm that it does indeed solve the NAND data
> > > loss on imx targets.
> > > 
> > > Is it possible for this patch to make it to the v5.19-rc7?
> > 
> > No response, so sending the email to more people so the voice is heard.
> > Sorry if this is not the proper way, but I think the issue is serious.
> > 
> > Current prepatch kernels starting with v5.19-rc4 and stable kernels
> > starting with v5.4.202. v5.10.127, v5.15.51, v5.18.8 contain a
> >   "[PATCH] [REALLY REALLY BROKEN] mtd: rawnand: gpmi: Fix setting busy timeout setting"
> > that is wreaking havoc to i.MX[678] or i.MX28 devices with NAND
> >   "** THIS PATCH WILL CAUSE DATA LOSS ON YOUR NAND!! **" [1]
> > 
> > The solution is to either:
> >   * Revert 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout
> > setting") and all its cherry-picks to stable branches, *OR*
> >   * Apply the fix ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout
> > based on program/erase times") [2]
> > 
> > Please do whatever you see fit.
> 
> I can do do a stable release with this reverted, but I really expected
> to see the fix in linux-next by now at the very least.  Does this driver
> not have an active maintainer and subsystem maintainer for some reason?

My IRC history doesn't go back far enough, but if I recall correctly
Miquel is on vacation, he would have picked up this patch for linux-next
otherwise.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
