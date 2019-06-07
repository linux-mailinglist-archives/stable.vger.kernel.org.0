Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9395393C8
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 19:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbfFGR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 13:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbfFGR7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 13:59:23 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5F5208C0;
        Fri,  7 Jun 2019 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559930362;
        bh=9dKMZGCodIC7GBJF2KTazZroE2B9B8QOzrgq3LpSTsQ=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=XfxpMEW6MNIwAhNik2mOzmu24+FyFp1A0uIkPo4OOO1D/9Ahk2YJUYbZwD0O9zBtn
         QAoVzL/Dqg/4eXuX9bHK0ezkVRuJncdkBsJ7JrDMJAaDJ2o5ycXYr4yU+AIQcWtHLh
         DTVFeJtIA/PeklsvZn15h5uskwVM/3/96b0yt+9w=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1559877112-21064-1-git-send-email-weiyi.lu@mediatek.com>
References: <1559877112-21064-1-git-send-email-weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Rob Herring <robh@kernel.org>, Weiyi Lu <weiyi.lu@mediatek.com>
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v1] clk: mediatek: mt8183: Register 13MHz clock earlier for clocksource
Cc:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Dehui Sun <dehui.sun@mediatek.com>
User-Agent: alot/0.8.1
Date:   Fri, 07 Jun 2019 10:59:21 -0700
Message-Id: <20190607175922.6D5F5208C0@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Weiyi Lu (2019-06-06 20:11:52)
> diff --git a/drivers/clk/mediatek/clk-mt8183.c b/drivers/clk/mediatek/clk=
-mt8183.c
> index 9d86510..a8f50bc 100644
> --- a/drivers/clk/mediatek/clk-mt8183.c
> +++ b/drivers/clk/mediatek/clk-mt8183.c
> @@ -1167,37 +1169,62 @@ static int clk_mt8183_apmixed_probe(struct platfo=
rm_device *pdev)
>         return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data=
);
>  }
> =20
> +static struct clk_onecell_data *top_clk_data;
> +
> +static void clk_mt8183_top_init_early(struct device_node *node)
> +{
> +       int i;
> +
> +       if (!top_clk_data) {

Is this function ever called more than once? I believe the answer is no
so this check should be removed.

> +               top_clk_data =3D mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> +
> +               for (i =3D 0; i < CLK_TOP_NR_CLK; i++)
> +                       top_clk_data->clks[i] =3D ERR_PTR(-EPROBE_DEFER);
> +       }
> +
> +       mtk_clk_register_factors(top_early_divs, ARRAY_SIZE(top_early_div=
s),
> +                       top_clk_data);
> +
> +       of_clk_add_provider(node, of_clk_src_onecell_get, top_clk_data);
> +}
> +
> +CLK_OF_DECLARE_DRIVER(mt8183_topckgen, "mediatek,mt8183-topckgen",
> +                       clk_mt8183_top_init_early);
> +
>  static int clk_mt8183_top_probe(struct platform_device *pdev)
>  {
>         struct resource *res =3D platform_get_resource(pdev, IORESOURCE_M=
EM, 0);
>         void __iomem *base;
> -       struct clk_onecell_data *clk_data;
>         struct device_node *node =3D pdev->dev.of_node;
> =20
>         base =3D devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(base))
>                 return PTR_ERR(base);
> =20
> -       clk_data =3D mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> +       if (!top_clk_data)
> +               top_clk_data =3D mtk_alloc_clk_data(CLK_TOP_NR_CLK);

And then this can be removed because top_clk_data must be allocated at
this point.

