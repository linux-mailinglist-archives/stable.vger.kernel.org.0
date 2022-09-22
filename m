Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2115E5EB6
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiIVJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIVJhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:37:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1F0D432B;
        Thu, 22 Sep 2022 02:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C0DDB801BD;
        Thu, 22 Sep 2022 09:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC277C433D6;
        Thu, 22 Sep 2022 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663839451;
        bh=68ySCIxRmNzmM3z0fmeMnKAIKzjyC2S4WAIN1dwhsLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1jHtW3mtP+b15+EV6oWLDdp5rpoT/hgiDRlnSDv0fF1VtacDZ4PilkCUW1KTO43j
         aVPL8tAGNCQXcHHleoTCzclUdLpCzTgiVMoI2EsV39JkEJlXCJfGNM1Zc2ZkCpVrw3
         nFnG4iY2VI0Cu0v845RF8tk3AzNbZuTDDMiMX6hMODHQRt4baJ2o9GN6DD7nS7fe6Q
         +Q56lC3mycM55r2xrWb9H5lCRabIYuBAhsBUzX6x2d0Fcm3wSQXeWYQlAYFPPu/WoO
         xG7KjmNFTGkpOjNR8RuzIjH421Rm8XZfK3L34GQjpf3OJC7n2prRzjwmcR8hm8ydm/
         VYhfiiytl2KIg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1obIeG-0001V7-6V; Thu, 22 Sep 2022 11:37:36 +0200
Date:   Thu, 22 Sep 2022 11:37:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Message-ID: <Yyws4Pd4bAl3iq2e@hovoldconsulting.com>
References: <20220822151027.27026-1-johan@kernel.org>
 <YymBM1wJLAsBDU4E@hovoldconsulting.com>
 <YywfxwBmdmvQ0i21@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YywfxwBmdmvQ0i21@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 10:41:43AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 20, 2022 at 11:00:35AM +0200, Johan Hovold wrote:
> > Mauro and Hans,
> > 
> > On Mon, Aug 22, 2022 at 05:10:27PM +0200, Johan Hovold wrote:
> > > Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
> > > type") tried to add an endpoint type sanity check for the single
> > > isochronous endpoint but instead broke the driver by checking the wrong
> > > descriptor or random data beyond the last endpoint descriptor.
> > > 
> > > Make sure to check the right endpoint descriptor.
> > > 
> > > Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
> > > Cc: Oliver Neukum <oneukum@suse.com>
> > > Cc: stable@vger.kernel.org	# 5.9
> > > Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > > 
> > > It's been two months and two completely ignored reminders so resending.
> > > 
> > > Can someone please pick this fix up and let me know when that has been
> > > done?
> > 
> > It's been another month so sending yet another reminder. This driver as
> > been broken since 5.9 and I posted this fix almost four months ago and
> > have sent multiple reminders since.
> > 
> > Can someone please pick this one and the follow-up cleanups up?
> 
> I've taken this one in my tree now.  Which one were the "follow-up"
> cleanups?

Thanks. These are the follow-up cleanups:

	https://lore.kernel.org/lkml/20220822151456.27178-1-johan@kernel.org/

Perhaps we should start taking USB related changes like this through the
USB tree by default. Posting patches to the media subsystem feels like
shooting patches at a black hole.

Johan
