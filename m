Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4403FB30B
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhH3JV4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Aug 2021 05:21:56 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47119 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbhH3JV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 05:21:56 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 2E0A5240007;
        Mon, 30 Aug 2021 09:20:59 +0000 (UTC)
Date:   Mon, 30 Aug 2021 11:20:57 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Frieder Schrempf <frieder@fris.de>, stable@vger.kernel.org,
        voice INTER connect GmbH <developer@voiceinterconnect.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>,
        YouChing Lin <ycllin@mxic.com.tw>
Subject: Re: [RESEND PATCH 5.10.x] mtd: spinand: Fix incorrect parameters
 for on-die ECC
Message-ID: <20210830112057.202355ef@xps13>
In-Reply-To: <35e30f69-c6f8-ac9c-2314-f566190ac2cb@kontron.de>
References: <20210830072108.13770-1-frieder@fris.de>
        <20210830104122.58f9cdaf@xps13>
        <35e30f69-c6f8-ac9c-2314-f566190ac2cb@kontron.de>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Frieder,

Frieder Schrempf <frieder.schrempf@kontron.de> wrote on Mon, 30 Aug
2021 11:18:50 +0200:

> On 30.08.21 10:41, Miquel Raynal wrote:
> > Hi Frieder,
> > 
> > Frieder Schrempf <frieder@fris.de> wrote on Mon, 30 Aug 2021 09:21:07
> > +0200:
> >   
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> The new generic NAND ECC framework stores the configuration and requirements
> >> in separate places since commit 93ef92f6f422 (" mtd: nand: Use the new generic ECC object ").
> >> In 5.10.x The SPI NAND layer still uses only the requirements to track the ECC
> >> properties. This mismatch leads to values of zero being used for ECC strength
> >> and step_size in the SPI NAND layer wherever nanddev_get_ecc_conf() is used and
> >> therefore breaks the SPI NAND on-die ECC support in 5.10.x.
> >>
> >> By using nanddev_get_ecc_requirements() instead of nanddev_get_ecc_conf() for
> >> SPI NAND, we make sure that the correct parameters for the detected chip are
> >> used. In later versions (5.11.x) this is fixed anyway with the implementation
> >> of the SPI NAND on-die ECC engine.
> >>
> >> Cc: stable@vger.kernel.org # 5.10.x
> >> Reported-by: voice INTER connect GmbH <developer@voiceinterconnect.de>
> >> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>  
> > 
> > Why not just reverting 9a333a72c1d0 ("mtd: spinand: Use
> > nanddev_get_ecc_conf() when relevant")? I think using this "new"
> > nanddev_get_ecc_requirements() helper because it fits the purpose even
> > if it is wrong [1] doesn't bring the right information. I know it is
> > strictly equivalent but I would personally prefer keeping the old
> > writing "nand->eccreq.xxxx".  
> 
> I think reverting 9a333a72c1d0 to use nand->eccreq.xxxx doesn't work as the eccreq member has already been removed in 93ef92f6f422 ("mtd: nand: Use the new generic ECC object"). So we would need to revert this commit, too. That would work for the SPI NAND layer, but might have implications on RAW NAND as it already uses the new generic ECC object with 'ctx.conf' and 'requirements'. At least I can't tell how this would affect the RAW NAND layer.

I missed that, you're right.

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

> 
> > 
> > [1] We don't want the requirements but the actual current configuration
> > here, which was the primary purpose of the initial patch which ended
> > being a mistake at that point in time because the SPI-NAND core was not
> > ready yet.
> > 
> > Thanks,
> > Miquèl  

Thanks,
Miquèl
