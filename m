Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652192A60E9
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgKDJuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgKDJuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:50:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4685022206;
        Wed,  4 Nov 2020 09:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604483450;
        bh=yoJtdRxBLu5Gkd9biPLrT1mjV1owIOhFjYFgVjOmkq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ck5gq18jALbodFtVh/J0/Im3El0+kbdbZY1AlOl0+Z0AzCePK8GShHxA83vtu4wJg
         r5aYCKzcrf5MVSHJDMaIZZHCchAO6/Zkk8I9hFQv6w6QafFd223/kwCZ6oJdwfSHhB
         y27MbyUNaYdgNrfQW1lUdBZ8mqbJL1nqGytcCnpE=
Date:   Wed, 4 Nov 2020 10:51:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone reset all tracing
Message-ID: <20201104095141.GA1673068@kroah.com>
References: <16044134474538@kroah.com>
 <20201104052914.156163-1-damien.lemoal@wdc.com>
 <20201104091015.GD1588160@kroah.com>
 <20201104091502.GA1646828@kroah.com>
 <BL0PR04MB6514A24DB438A568A9C27CB7E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20201104092742.GA1669921@kroah.com>
 <BL0PR04MB65143D636C72588134EC3E17E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB65143D636C72588134EC3E17E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 09:31:40AM +0000, Damien Le Moal wrote:
> On 2020/11/04 18:26, Greg Kroah-Hartman wrote:
> > On Wed, Nov 04, 2020 at 09:21:27AM +0000, Damien Le Moal wrote:
> >> On 2020/11/04 18:14, Greg Kroah-Hartman wrote:
> >>> On Wed, Nov 04, 2020 at 10:10:15AM +0100, Greg Kroah-Hartman wrote:
> >>>> On Wed, Nov 04, 2020 at 02:29:14PM +0900, Damien Le Moal wrote:
> >>>>> commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.
> >>>>>
> >>>>> In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector is
> >>>>> ignored and the operation is applied to all sequential zones. For these
> >>>>> commands, tracing the effect of the command using the command sector to
> >>>>> determine the target zone is thus incorrect.
> >>>>>
> >>>>> Fix null_zone_mgmt() zone condition tracing in the case of
> >>>>> REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are
> >>>>> not already empty.
> >>>>>
> >>>>> Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")
> >>>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>> ---
> >>>>>  drivers/block/null_blk_zoned.c | 14 ++++++++------
> >>>>>  1 file changed, 8 insertions(+), 6 deletions(-)
> >>>>
> >>>> Now queued up, thanks.
> >>>
> >>> Wait, no, I'll delay this one until the next round as it's not fixing
> >>> something introduced in this -rc series.
> >>
> >> Yes, that problem is older.
> >> The lock fix I sent goes on top of this one though. I can send the backport for
> >> the lock fix without this patch applied. Is that OK ?
> > 
> > If the order of the patches is needed, then yes, I can take both, please
> > submit them as a patch series so that I know this is needed.
> 
> OK. Sending that. Note that I still do not see Kanchan patch applied in stable
> 5.9.y branch, so I will do the backport assuming it is applied. Or I can send
> all 3 patches as the series. Which do you prefer ?

All 3 is great, to ensure I have them all as I don't know what you mean
by "Kanchan patch".

thanks,

greg k-h
