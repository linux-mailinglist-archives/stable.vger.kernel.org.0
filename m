Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF4A667B6
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 09:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfGLHXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 03:23:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56797 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726033AbfGLHXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 03:23:46 -0400
X-UUID: bdd7fe42907544eebcbbb88dcb5f0f9e-20190712
X-UUID: bdd7fe42907544eebcbbb88dcb5f0f9e-20190712
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <houlong.wei@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1226092318; Fri, 12 Jul 2019 15:23:40 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by mtkmbs08n1.mediatek.inc
 (172.21.101.55) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 12 Jul
 2019 15:23:38 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 12 Jul 2019 15:23:38 +0800
Message-ID: <1562916217.29653.4.camel@mhfsdcap03>
Subject: Re: [PATCH] [media] media: mtk-mdp: fix reference count on old
 device tree
From:   houlong wei <houlong.wei@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     Minghsiu Tsai =?UTF-8?Q?=28=E8=94=A1=E6=98=8E=E4=BF=AE=29?= 
        <Minghsiu.Tsai@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?= 
        <Andrew-CT.Chen@mediatek.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "djkurtz@chromium.org" <djkurtz@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 12 Jul 2019 15:23:37 +0800
In-Reply-To: <e4d178ae-f43e-21d0-b0ab-78cc2ac71e7e@gmail.com>
References: <20190621113250.4946-1-matthias.bgg@gmail.com>
         <e4d178ae-f43e-21d0-b0ab-78cc2ac71e7e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 2019-07-08 at 17:06 +0800, Matthias Brugger wrote:
> 
> On 21/06/2019 13:32, Matthias Brugger wrote:
> > of_get_next_child() increments the reference count of the returning
> > device_node. Decrement it in the check if we are using the old or the
> > new DTB.
> > 
> > Fixes: ba1f1f70c2c0 ("[media] media: mtk-mdp: Fix mdp device tree")
> > Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> 
> Any comments on that?
> 

Hi Matthias,
Thanks for fixing the bug. Sorry to reply late~

Acked-by: Houlong Wei <houlong.wei@mediatek.com>


> > ---
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> > index bbb24fb95b95..bafe53c5d54a 100644
> > --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> > @@ -118,7 +118,9 @@ static int mtk_mdp_probe(struct platform_device *pdev)
> >  	mutex_init(&mdp->vpulock);
> >  
> >  	/* Old dts had the components as child nodes */
> > -	if (of_get_next_child(dev->of_node, NULL)) {
> > +	parent = of_get_next_child(dev->of_node, NULL);
> > +	if (parent) {
> > +		of_node_put(parent);
> >  		parent = dev->of_node;
> >  		dev_warn(dev, "device tree is out of date\n");
> >  	} else {
> > 


