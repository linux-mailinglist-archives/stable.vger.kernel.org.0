Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF723ACCC
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 04:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbfFJCJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 22:09:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:14172 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730055AbfFJCJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 22:09:36 -0400
X-UUID: 2cde18eed0df4227b97fb68957b1c25d-20190610
X-UUID: 2cde18eed0df4227b97fb68957b1c25d-20190610
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1896129777; Mon, 10 Jun 2019 10:09:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 10 Jun 2019 10:09:10 +0800
Received: from [172.21.77.4] (172.21.77.4) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 10 Jun 2019 10:09:09 +0800
Message-ID: <1560132549.16837.1.camel@mtksdaap41>
Subject: Re: [PATCH v1] clk: mediatek: mt8183: Register 13MHz clock earlier
 for clocksource
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Stephen Boyd <sboyd@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Rob Herring <robh@kernel.org>,
        Dehui Sun <dehui.sun@mediatek.com>,
        James Liao <jamesjj.liao@mediatek.com>,
        <srv_heupstream@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Fan Chen <fan.chen@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Mon, 10 Jun 2019 10:09:09 +0800
In-Reply-To: <20190607175922.6D5F5208C0@mail.kernel.org>
References: <1559877112-21064-1-git-send-email-weiyi.lu@mediatek.com>
         <20190607175922.6D5F5208C0@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-06-07 at 10:59 -0700, Stephen Boyd wrote:
> Quoting Weiyi Lu (2019-06-06 20:11:52)
> > diff --git a/drivers/clk/mediatek/clk-mt8183.c b/drivers/clk/mediatek/clk-mt8183.c
> > index 9d86510..a8f50bc 100644
> > --- a/drivers/clk/mediatek/clk-mt8183.c
> > +++ b/drivers/clk/mediatek/clk-mt8183.c
> > @@ -1167,37 +1169,62 @@ static int clk_mt8183_apmixed_probe(struct platform_device *pdev)
> >         return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
> >  }
> >  
> > +static struct clk_onecell_data *top_clk_data;
> > +
> > +static void clk_mt8183_top_init_early(struct device_node *node)
> > +{
> > +       int i;
> > +
> > +       if (!top_clk_data) {
> 
> Is this function ever called more than once? I believe the answer is no
> so this check should be removed.
> 

Thanks for reminding. I'll fix in next version.

> > +               top_clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> > +
> > +               for (i = 0; i < CLK_TOP_NR_CLK; i++)
> > +                       top_clk_data->clks[i] = ERR_PTR(-EPROBE_DEFER);
> > +       }
> > +
> > +       mtk_clk_register_factors(top_early_divs, ARRAY_SIZE(top_early_divs),
> > +                       top_clk_data);
> > +
> > +       of_clk_add_provider(node, of_clk_src_onecell_get, top_clk_data);
> > +}
> > +
> > +CLK_OF_DECLARE_DRIVER(mt8183_topckgen, "mediatek,mt8183-topckgen",
> > +                       clk_mt8183_top_init_early);
> > +
> >  static int clk_mt8183_top_probe(struct platform_device *pdev)
> >  {
> >         struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >         void __iomem *base;
> > -       struct clk_onecell_data *clk_data;
> >         struct device_node *node = pdev->dev.of_node;
> >  
> >         base = devm_ioremap_resource(&pdev->dev, res);
> >         if (IS_ERR(base))
> >                 return PTR_ERR(base);
> >  
> > -       clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> > +       if (!top_clk_data)
> > +               top_clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> 
> And then this can be removed because top_clk_data must be allocated at
> this point.
> 

I'll fix in next version. Many thanks.

> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek


