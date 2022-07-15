Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1C8575B17
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 07:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiGOFtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 01:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGOFtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 01:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EBB5C356
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 22:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81636225E
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 05:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990CAC34115;
        Fri, 15 Jul 2022 05:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657864183;
        bh=x83VLxJPKHbGMJPFq42rSKpCidSJBC8OXcegnlkwv9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TjbN0bpJYSW+af+eGdQANhi9PBXvftOJ/NIngjruJT5fpgqSjQEcJkTYffjhgQJq0
         1ceN5Z4cCjak4RdUOJXqErmYB/Lqkh9NvijbBEXpC0JdAGyffAVvAVzk3DL+ztLbXk
         Dhr4ImVX9h2NVrDZ5gJfrpiaZymfOt5Vsu4xiWZA=
Date:   Fri, 15 Jul 2022 07:49:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel@pengutronix.de,
        stable@vger.kernel.org, k.drobinski@camlintechnologies.com
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
Message-ID: <YtD/9KJZwlVj+6hS@kroah.com>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
 <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 07:27:02AM +0200, Tomasz Moń wrote:
> On Mon, 2022-07-11 at 11:12 +0200, Tomasz Moń wrote:
> > On Fri, 2022-07-01 at 13:03 +0200, Sascha Hauer wrote:
> > > 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> > > value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> > > though: It is calculated based on the maximum page read time, but the
> > > timeout is also used for page write and block erase operations which
> > > require orders of magnitude bigger timeouts.
> > > 
> > > Fix this by calculating busy_timeout_cycles from the maximum of
> > > tBERS_max and tPROG_max.
> > 
> > 06781a5026350 was merged in v5.19-rc4 and then was picked up by several
> > stable kernels, including v5.15.51. After we have upgraded to v5.15.51
> > we have observed the issue that Sascha mentioned in his email [1].
> > 
> > As the v5.19-rc6 was released yesterday and this fix is still not
> > applied, the v5.19-rc6 (and all stable kernels that picked up the
> > backport) causes NAND flash data loss on imx targets.
> > 
> > I have backported this patch to our internal v5.15.51 based kernel on
> > 4th July 2022 and I can confirm that it does indeed solve the NAND data
> > loss on imx targets.
> > 
> > Is it possible for this patch to make it to the v5.19-rc7?
> 
> No response, so sending the email to more people so the voice is heard.
> Sorry if this is not the proper way, but I think the issue is serious.
> 
> Current prepatch kernels starting with v5.19-rc4 and stable kernels
> starting with v5.4.202. v5.10.127, v5.15.51, v5.18.8 contain a
>   "[PATCH] [REALLY REALLY BROKEN] mtd: rawnand: gpmi: Fix setting busy timeout setting"
> that is wreaking havoc to i.MX[678] or i.MX28 devices with NAND
>   "** THIS PATCH WILL CAUSE DATA LOSS ON YOUR NAND!! **" [1]
> 
> The solution is to either:
>   * Revert 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout
> setting") and all its cherry-picks to stable branches, *OR*
>   * Apply the fix ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout
> based on program/erase times") [2]
> 
> Please do whatever you see fit.

I can do do a stable release with this reverted, but I really expected
to see the fix in linux-next by now at the very least.  Does this driver
not have an active maintainer and subsystem maintainer for some reason?

thanks,

greg k-h
