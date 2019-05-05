Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DFB13E16
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 09:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfEEHMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 03:12:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:6018 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbfEEHMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 03:12:39 -0400
X-UUID: dce8b17933c94a388d6437c7946d45c9-20190505
X-UUID: dce8b17933c94a388d6437c7946d45c9-20190505
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <xiaolei.li@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1950714590; Sun, 05 May 2019 15:12:32 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by mtkmbs03n2.mediatek.inc
 (172.21.101.182) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Sun, 5 May
 2019 15:12:30 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 May 2019 15:12:29 +0800
Message-ID: <1557040349.26455.61.camel@mhfsdcap03>
Subject: Re: [PATCH v2 1/5] mtd: rawnand: mtk: Correct low level time
 calculation of r/w cycle
From:   xiaolei li <xiaolei.li@mediatek.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
CC:     <richard@nod.at>, <linux-mtd@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>
Date:   Sun, 5 May 2019 15:12:29 +0800
In-Reply-To: <20190430135910.1deddd51@xps13>
References: <20190430100250.28083-1-xiaolei.li@mediatek.com>
         <20190430100250.28083-2-xiaolei.li@mediatek.com>
         <20190430135910.1deddd51@xps13>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 260F786CC4C06C13C3A588B90F354AD8C336E0ABEC75E500A076A07C3F1060742000:8
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-04-30 at 13:59 +0200, Miquel Raynal wrote:
> Hi Xiaolei,
> 
> Xiaolei Li <xiaolei.li@mediatek.com> wrote on Tue, 30 Apr 2019 18:02:46
> +0800:
> 
> > At present, the flow of calculating AC timing of read/write cycle in SDR
> > mode is that:
> > At first, calculate high hold time which is valid for both read and write
> > cycle using the max value between tREH_min and tWH_min.
> > Secondly, calculate WE# pulse width using tWP_min.
> > Thridly, calculate RE# pulse width using the bigger one between tREA_max
> > and tRP_min.
> > 
> > But NAND SPEC shows that Controller should also meet write/read cycle time.
> > That is write cycle time should be more than tWC_min and read cycle should
> > be more than tRC_min. Obviously, we do not achieve that now.
> > 
> > This patch corrects the low level time calculation to meet minimum
> > read/write cycle time required. After getting the high hold time, WE# low
> > level time will be promised to meet tWP_min and tWC_min requirement,
> > and RE# low level time will be promised to meet tREA_max, tRP_min and
> > tRC_min requirement.
> > 
> > Fixes: edfee3619c49 ("mtd: nand: mtk: add ->setup_data_interface() hook")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xiaolei Li <xiaolei.li@mediatek.com>
> > ---
> >  drivers/mtd/nand/raw/mtk_nand.c | 24 +++++++++++++++++++++---
> >  1 file changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
> > index b6b4602f5132..4fbb0c6ecae3 100644
> > --- a/drivers/mtd/nand/raw/mtk_nand.c
> > +++ b/drivers/mtd/nand/raw/mtk_nand.c
> > @@ -508,7 +508,8 @@ static int mtk_nfc_setup_data_interface(struct nand_chip *chip, int csline,
> >  {
> >  	struct mtk_nfc *nfc = nand_get_controller_data(chip);
> >  	const struct nand_sdr_timings *timings;
> > -	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst, trlt;
> > +	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst = 0, trlt = 0;
> > +	u32 thold;
> >  
> >  	timings = nand_get_sdr_timings(conf);
> >  	if (IS_ERR(timings))
> > @@ -544,11 +545,28 @@ static int mtk_nfc_setup_data_interface(struct nand_chip *chip, int csline,
> >  	twh = DIV_ROUND_UP(twh * rate, 1000000) - 1;
> >  	twh &= 0xf;
> >  
> > -	twst = timings->tWP_min / 1000;
> > +	/* Calculate real WE#/RE# hold time in nanosecond */
> > +	thold = (twh + 1) * 1000000 / rate;
> > +	/* nanosecond to picosecond */
> > +	thold *= 1000;
> > +
> > +	/**
> 
>         /*
> 
> > +	 * WE# low level time should be expaned to meet WE# pulse time
> > +	 * and WE# cycle time at the same time.
> > +	 */
> > +	if (thold < timings->tWC_min)
> > +		twst = timings->tWC_min - thold;
> > +	twst = max(timings->tWP_min, twst) / 1000;
> >  	twst = DIV_ROUND_UP(twst * rate, 1000000) - 1;
> >  	twst &= 0xf;
> >  
> > -	trlt = max(timings->tREA_max, timings->tRP_min) / 1000;
> > +	/**
> 
> Ditto
OK.

> 
> > +	 * RE# low level time should be expaned to meet RE# pulse time,
> > +	 * RE# access time and RE# cycle time at the same time.
> > +	 */
> > +	if (thold < timings->tRC_min)
> > +		trlt = timings->tRC_min - thold;
> > +	trlt = max3(trlt, timings->tREA_max, timings->tRP_min) / 1000;
> >  	trlt = DIV_ROUND_UP(trlt * rate, 1000000) - 1;
> >  	trlt &= 0xf;
> >  
> 
> With this fixed:
> 
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> 
> Thanks,
> Miquèl

Thanks,
Xiaolei

