Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6462EA982
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbhAELFs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 5 Jan 2021 06:05:48 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:30751 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbhAELFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:05:48 -0500
X-Originating-IP: 90.89.98.255
Received: from xps13 (lfbn-tou-1-1535-bdcst.w90-89.abo.wanadoo.fr [90.89.98.255])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id EA857240014;
        Tue,  5 Jan 2021 11:05:04 +0000 (UTC)
Date:   Tue, 5 Jan 2021 12:05:03 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mtd: spinand: Fix OOB read"
Message-ID: <20210105120503.327f9560@xps13>
In-Reply-To: <31b5cdd8-db92-20bf-edfd-224f61fecea4@nbd.name>
References: <20210105101821.47138-1-nbd@nbd.name>
        <X/Q//pErSOfQj/Gd@kroah.com>
        <20210105114035.2c766901@xps13>
        <31b5cdd8-db92-20bf-edfd-224f61fecea4@nbd.name>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Felix,

Felix Fietkau <nbd@nbd.name> wrote on Tue, 5 Jan 2021 11:47:27 +0100:

> On 2021-01-05 11:40, Miquel Raynal wrote:
> > Hello,
> > 
> > Greg KH <gregkh@linuxfoundation.org> wrote on Tue, 5 Jan 2021 11:31:26
> > +0100:
> >   
> >> On Tue, Jan 05, 2021 at 11:18:21AM +0100, Felix Fietkau wrote:  
> >> > This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.
> >> > 
> >> > This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
> >> > commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
> >> > backport was touching spinand_read_from_cache_op.
> >> > It causes a crash on writing OOB data by attempting to write to read-only
> >> > kernel memory.
> >> > 
> >> > Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> >> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> > ---
> >> >  drivers/mtd/nand/spi/core.c | 4 ----
> >> >  1 file changed, 4 deletions(-)    
> >> 
> >> So the backport to 5.10.y broke, but not the backport to 4.19.y or
> >> 5.4.y?  Can you provide a "correct" backport for this instead of just
> >> removing this fix?  
> > 
> > Agreed, I think the proper way to handle the situation would be to move
> > these three lines to spinand_read_from_cache_op() instead of just
> > getting rid of them.  
> But they have a similar line in spinand_read_from_cache_op already (in
> addition to some extra code for dealing with MTD_OPS_AUTO_OOB).
> 
> Please take another look at your commit 3d1f08b032dc, it really looks to
> me like you were just adding back a part of what you removed there.
> Maybe the proper solution is to add back the rest of it as well (the
> part that deals with MTD_OPS_AUTO_OOB) and leave the stable kernels alone.

You are actually right, I've got confused by my own previous change.

The right thing to do is indeed to get rid of this patch in the stable
kernels.

Thanks for reporting,
Miquèl
