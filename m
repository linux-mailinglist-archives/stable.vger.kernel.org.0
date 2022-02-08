Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0EB4AD325
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349200AbiBHIWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiBHIVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:21:45 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE28C03F93C;
        Tue,  8 Feb 2022 00:21:06 -0800 (PST)
X-UUID: f5ad159b30bd4423b18ddcd008c7b17b-20220208
X-UUID: f5ad159b30bd4423b18ddcd008c7b17b-20220208
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <ck.hu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1936786812; Tue, 08 Feb 2022 16:21:02 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Feb 2022 16:21:00 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Feb
 2022 16:21:00 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Feb 2022 16:21:00 +0800
Message-ID: <20755168cc2be0d1bb5e40907cfe27cea25a9363.camel@mediatek.com>
Subject: Re: [PATCH v4] drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with
 external bridge
From:   CK Hu <ck.hu@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        <dri-devel@lists.freedesktop.org>
CC:     <chunkuang.hu@kernel.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <andrzej.hajda@intel.com>, <linux-mediatek@lists.infradead.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        <matthias.bgg@gmail.com>, <kernel@collabora.com>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 8 Feb 2022 16:20:58 +0800
In-Reply-To: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
References: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Angelo:

On Mon, 2022-01-31 at 09:55 +0100, AngeloGioacchino Del Regno wrote:
> DRM bridge drivers are now attaching their DSI device at probe time,
> which requires us to register our DSI host in order to let the bridge
> to probe: this recently started producing an endless -EPROBE_DEFER
> loop on some machines that are using external bridges, like the
> parade-ps8640, found on the ACER Chromebook R13.
> 
> Now that the DSI hosts/devices probe sequence is documented, we can
> do adjustments to the mtk_dsi driver as to both fix now and make sure
> to avoid this situation in the future: for this, following what is
> documented in drm_bridge.c, move the mtk_dsi component_add() to the
> mtk_dsi_ops.attach callback and delete it in the detach callback;
> keeping in mind that we are registering a drm_bridge for our DSI,
> which is only used/attached if the DSI Host is bound, it wouldn't
> make sense to keep adding our bridge at probe time (as it would
> be useless to have it if mtk_dsi_ops.attach() fails!), so also move
> that one to the dsi host attach function (and remove it in detach).
> 
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: AngeloGioacchino Del Regno <
> angelogioacchino.delregno@collabora.com>
> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
> 
> ---
>  drivers/gpu/drm/mediatek/mtk_dsi.c | 167 +++++++++++++++----------
> ----
>  1 file changed, 84 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c
> b/drivers/gpu/drm/mediatek/mtk_dsi.c
> index 5d90d2eb0019..bced4c7d668e 100644
> --- a/drivers/gpu/drm/mediatek/mtk_dsi.c
> +++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
> @@ -786,18 +786,101 @@ void mtk_dsi_ddp_stop(struct device *dev)
>  	mtk_dsi_poweroff(dsi);
>  }
>  
> 

[snip]

> +
>  static int mtk_dsi_host_attach(struct mipi_dsi_host *host,
>  			       struct mipi_dsi_device *device)
>  {
>  	struct mtk_dsi *dsi = host_to_dsi(host);
> +	struct device *dev = host->dev;
> +	int ret;
>  
>  	dsi->lanes = device->lanes;
>  	dsi->format = device->format;
>  	dsi->mode_flags = device->mode_flags;
> +	dsi->next_bridge = devm_drm_of_get_bridge(dev, dev->of_node, 0,
> 0);

The original would process panel. Why do you remove the panel part?
It's better that someone has a platform of DSI->Panel to test this
patch.

Regards,
CK

> +	if (IS_ERR(dsi->next_bridge))
> +		return PTR_ERR(dsi->next_bridge);
> +
> +	drm_bridge_add(&dsi->bridge);
> +
> +	ret = component_add(host->dev, &mtk_dsi_component_ops);
> +	if (ret) {
> +		DRM_ERROR("failed to add dsi_host component: %d\n",
> ret);
> +		drm_bridge_remove(&dsi->bridge);
> +		return ret;
> +	}
>  
>  	return 0;
>  }
>  
> +static int mtk_dsi_host_detach(struct mipi_dsi_host *host,
> +			       struct mipi_dsi_device *device)
> +{
> +	struct mtk_dsi *dsi = host_to_dsi(host);
> +
> +	component_del(host->dev, &mtk_dsi_component_ops);
> +	drm_bridge_remove(&dsi->bridge);
> +	return 0;
> +}
> +
>  static void mtk_dsi_wait_for_idle(struct mtk_dsi *dsi)
>  {
>  	int ret;
> @@ -938,73 +1021,14 @@ static ssize_t mtk_dsi_host_transfer(struct
> mipi_dsi_host *host,
>  
>  static const struct mipi_dsi_host_ops mtk_dsi_ops = {
>  	.attach = mtk_dsi_host_attach,
> +	.detach = mtk_dsi_host_detach,
>  	.transfer = mtk_dsi_host_transfer,
>  };
>  
> 

[snip]

> -
>  static int mtk_dsi_probe(struct platform_device *pdev)
>  {
>  	struct mtk_dsi *dsi;
>  	struct device *dev = &pdev->dev;
> -	struct drm_panel *panel;
>  	struct resource *regs;
>  	int irq_num;
>  	int ret;
> @@ -1021,19 +1045,6 @@ static int mtk_dsi_probe(struct
> platform_device *pdev)
>  		return ret;
>  	}
>  
> -	ret = drm_of_find_panel_or_bridge(dev->of_node, 0, 0,
> -					  &panel, &dsi->next_bridge);
> -	if (ret)
> -		goto err_unregister_host;
> -
> -	if (panel) {
> -		dsi->next_bridge = devm_drm_panel_bridge_add(dev,
> panel);
> -		if (IS_ERR(dsi->next_bridge)) {
> -			ret = PTR_ERR(dsi->next_bridge);
> -			goto err_unregister_host;
> -		}
> -	}
> -
>  	dsi->driver_data = of_device_get_match_data(dev);
>  
>  	dsi->engine_clk = devm_clk_get(dev, "engine");
> @@ -1098,14 +1109,6 @@ static int mtk_dsi_probe(struct
> platform_device *pdev)
>  	dsi->bridge.of_node = dev->of_node;
>  	dsi->bridge.type = DRM_MODE_CONNECTOR_DSI;
>  
> -	drm_bridge_add(&dsi->bridge);
> -
> -	ret = component_add(&pdev->dev, &mtk_dsi_component_ops);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to add component: %d\n",
> ret);
> -		goto err_unregister_host;
> -	}
> -
>  	return 0;
>  
>  err_unregister_host:
> @@ -1118,8 +1121,6 @@ static int mtk_dsi_remove(struct
> platform_device *pdev)
>  	struct mtk_dsi *dsi = platform_get_drvdata(pdev);
>  
>  	mtk_output_dsi_disable(dsi);
> -	drm_bridge_remove(&dsi->bridge);
> -	component_del(&pdev->dev, &mtk_dsi_component_ops);
>  	mipi_dsi_host_unregister(&dsi->host);
>  
>  	return 0;

