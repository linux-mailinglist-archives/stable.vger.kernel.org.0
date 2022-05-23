Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC03530BD3
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 11:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiEWI4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 04:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiEWI4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 04:56:14 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA9B7FE;
        Mon, 23 May 2022 01:56:04 -0700 (PDT)
X-UUID: 06f49cb5f32b4d2297c06a9166530d90-20220523
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:fbc0daff-b31d-4f7e-a043-af2a02a861df,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:2a19b09,CLOUDID:dc28467a-5ef6-470b-96c9-bdb8ced32786,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:0,BEC:nil
X-UUID: 06f49cb5f32b4d2297c06a9166530d90-20220523
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 984592553; Mon, 23 May 2022 16:55:59 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 23 May 2022 16:55:56 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 May 2022 16:55:52 +0800
Message-ID: <e48b8f9194df9add1849a50186570f30f086262f.camel@mediatek.com>
Subject: Re: [PATCH 1/2] usb: xhci-mtk: fix fs isoc's transfer error
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     Mathias Nyman <mathias.nyman@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        <stable@vger.kernel.org>
Date:   Mon, 23 May 2022 16:55:52 +0800
In-Reply-To: <7781eaaf-ad09-7283-dbb8-69d0fb3f1d14@collabora.com>
References: <20220512064931.31670-1-chunfeng.yun@mediatek.com>
         <7781eaaf-ad09-7283-dbb8-69d0fb3f1d14@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-05-18 at 14:01 +0200, AngeloGioacchino Del Regno wrote:
> Il 12/05/22 08:49, Chunfeng Yun ha scritto:
> > Due to the scheduler allocates the optimal bandwidth for FS ISOC
> > endpoints,
> > this may be not enough actually and causes data transfer error, so
> > come up
> > with an estimate that is no less than the worst case bandwidth used
> > for
> > any one mframe, but may be an over-estimate.
> > 
> > Fixes: 451d3912586a ("usb: xhci-mtk: update fs bus bandwidth by
> > bw_budget_table")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> 
> Hello Chunfeng,
> I agree this is "a fix"... but is it the best fix?
> 
> Shooting the bandwidth very high will have power consumption
> consequences, are
> those measurable?
This is usually limited into one interval; e.g. the last interval
transfers 8 bytes in fact, but I assume it may transfer 188 bytes, I
think the consumption increase can be ignored.

> And if they are, what is the expected power consumption increase in
> percentage
> (and/or microamperes)? Also, out of the expected increase, have you
> got any
> measurement for that?
> 
> Assuming that the measurement is done for one SoC, it's possible to
> make some
> assumption about a different part.
> 
> Regards,
> Angelo
> 
> > ---
> >   drivers/usb/host/xhci-mtk-sch.c | 16 +++++++---------
> >   1 file changed, 7 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/usb/host/xhci-mtk-sch.c
> > b/drivers/usb/host/xhci-mtk-sch.c
> > index f3139ce7b0a9..953d2cd1d4cc 100644
> > --- a/drivers/usb/host/xhci-mtk-sch.c
> > +++ b/drivers/usb/host/xhci-mtk-sch.c

