Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674514AF465
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 15:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiBIOsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 09:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiBIOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 09:48:46 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963F8C06157B;
        Wed,  9 Feb 2022 06:48:48 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nfraprado)
        with ESMTPSA id 6C6821F45889
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644418126;
        bh=YWqRaMse8wkQ3xG+y49Y53HHw6xq39YdnDTzPQLGhG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DRpMhCDeuLo46HyugPFzku6BZLxKedezPp7Q8IOBKp0H0dDcL1tMLyifesywMEF7t
         G93lB0CMI7KtPFjzizw+1N7ON3aKdbniI8jYhWlp483pY4i3SBsZQrsMOv6z74OQso
         CC9PEB79/0BrfbQMlQNjRVtVhr9T4IMqMEHFVfmQBoUHkvH1ukOj0NrLNzo+IZ6h4j
         bego9MTTkEA8ptxEF4KnE4ykofQDZGjmH/OYYawLCaoEHuTihcQ/Ueseqb8poKxkL6
         qTFotTEkhgEC1qqKaA6c2bNfI5/hI/OTOpfgBMpMQaszyS4EX4gpNNfzI5g0bCHkcS
         psv46BxK3Z1iQ==
Date:   Wed, 9 Feb 2022 09:48:41 -0500
From:   =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4=?= Prado 
        <nfraprado@collabora.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chunkuang.hu@kernel.org, p.zabel@pengutronix.de, airlied@linux.ie,
        daniel@ffwll.ch, matthias.bgg@gmail.com, kernel@collabora.com,
        andrzej.hajda@intel.com, stable@vger.kernel.org,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: Re: [PATCH v4] drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with
 external bridge
Message-ID: <20220209144841.v2kjzy5kniukbunq@notapiano>
References: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Angelo,

On Mon, Jan 31, 2022 at 09:55:20AM +0100, AngeloGioacchino Del Regno wrote:
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
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>

Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>

Thanks,
Nícolas

> 
> ---
>  drivers/gpu/drm/mediatek/mtk_dsi.c | 167 +++++++++++++++--------------
>  1 file changed, 84 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
> index 5d90d2eb0019..bced4c7d668e 100644
> --- a/drivers/gpu/drm/mediatek/mtk_dsi.c
> +++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
> @@ -786,18 +786,101 @@ void mtk_dsi_ddp_stop(struct device *dev)
>  	mtk_dsi_poweroff(dsi);
>  }
>  
> +static int mtk_dsi_encoder_init(struct drm_device *drm, struct mtk_dsi *dsi)
> +{
> +	int ret;
> +
> +	ret = drm_simple_encoder_init(drm, &dsi->encoder,
> +				      DRM_MODE_ENCODER_DSI);
> +	if (ret) {
> +		DRM_ERROR("Failed to encoder init to drm\n");
> +		return ret;
> +	}
> +
> +	dsi->encoder.possible_crtcs = mtk_drm_find_possible_crtc_by_comp(drm, dsi->host.dev);
> +
> +	ret = drm_bridge_attach(&dsi->encoder, &dsi->bridge, NULL,
> +				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
> +	if (ret)
> +		goto err_cleanup_encoder;
> +
> +	dsi->connector = drm_bridge_connector_init(drm, &dsi->encoder);
> +	if (IS_ERR(dsi->connector)) {
> +		DRM_ERROR("Unable to create bridge connector\n");
> +		ret = PTR_ERR(dsi->connector);
> +		goto err_cleanup_encoder;
> +	}
> +	drm_connector_attach_encoder(dsi->connector, &dsi->encoder);
> +
> +	return 0;
> +
> +err_cleanup_encoder:
> +	drm_encoder_cleanup(&dsi->encoder);
> +	return ret;
> +}
> +
> +static int mtk_dsi_bind(struct device *dev, struct device *master, void *data)
> +{
> +	int ret;
> +	struct drm_device *drm = data;
> +	struct mtk_dsi *dsi = dev_get_drvdata(dev);
> +
> +	ret = mtk_dsi_encoder_init(drm, dsi);
> +	if (ret)
> +		return ret;
> +
> +	return device_reset_optional(dev);
> +}
> +
> +static void mtk_dsi_unbind(struct device *dev, struct device *master,
> +			   void *data)
> +{
> +	struct mtk_dsi *dsi = dev_get_drvdata(dev);
> +
> +	drm_encoder_cleanup(&dsi->encoder);
> +}
> +
> +static const struct component_ops mtk_dsi_component_ops = {
> +	.bind = mtk_dsi_bind,
> +	.unbind = mtk_dsi_unbind,
> +};
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
> +	dsi->next_bridge = devm_drm_of_get_bridge(dev, dev->of_node, 0, 0);
> +	if (IS_ERR(dsi->next_bridge))
> +		return PTR_ERR(dsi->next_bridge);
> +
> +	drm_bridge_add(&dsi->bridge);
> +
> +	ret = component_add(host->dev, &mtk_dsi_component_ops);
> +	if (ret) {
> +		DRM_ERROR("failed to add dsi_host component: %d\n", ret);
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
> @@ -938,73 +1021,14 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
>  
>  static const struct mipi_dsi_host_ops mtk_dsi_ops = {
>  	.attach = mtk_dsi_host_attach,
> +	.detach = mtk_dsi_host_detach,
>  	.transfer = mtk_dsi_host_transfer,
>  };
>  
> -static int mtk_dsi_encoder_init(struct drm_device *drm, struct mtk_dsi *dsi)
> -{
> -	int ret;
> -
> -	ret = drm_simple_encoder_init(drm, &dsi->encoder,
> -				      DRM_MODE_ENCODER_DSI);
> -	if (ret) {
> -		DRM_ERROR("Failed to encoder init to drm\n");
> -		return ret;
> -	}
> -
> -	dsi->encoder.possible_crtcs = mtk_drm_find_possible_crtc_by_comp(drm, dsi->host.dev);
> -
> -	ret = drm_bridge_attach(&dsi->encoder, &dsi->bridge, NULL,
> -				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
> -	if (ret)
> -		goto err_cleanup_encoder;
> -
> -	dsi->connector = drm_bridge_connector_init(drm, &dsi->encoder);
> -	if (IS_ERR(dsi->connector)) {
> -		DRM_ERROR("Unable to create bridge connector\n");
> -		ret = PTR_ERR(dsi->connector);
> -		goto err_cleanup_encoder;
> -	}
> -	drm_connector_attach_encoder(dsi->connector, &dsi->encoder);
> -
> -	return 0;
> -
> -err_cleanup_encoder:
> -	drm_encoder_cleanup(&dsi->encoder);
> -	return ret;
> -}
> -
> -static int mtk_dsi_bind(struct device *dev, struct device *master, void *data)
> -{
> -	int ret;
> -	struct drm_device *drm = data;
> -	struct mtk_dsi *dsi = dev_get_drvdata(dev);
> -
> -	ret = mtk_dsi_encoder_init(drm, dsi);
> -	if (ret)
> -		return ret;
> -
> -	return device_reset_optional(dev);
> -}
> -
> -static void mtk_dsi_unbind(struct device *dev, struct device *master,
> -			   void *data)
> -{
> -	struct mtk_dsi *dsi = dev_get_drvdata(dev);
> -
> -	drm_encoder_cleanup(&dsi->encoder);
> -}
> -
> -static const struct component_ops mtk_dsi_component_ops = {
> -	.bind = mtk_dsi_bind,
> -	.unbind = mtk_dsi_unbind,
> -};
> -
>  static int mtk_dsi_probe(struct platform_device *pdev)
>  {
>  	struct mtk_dsi *dsi;
>  	struct device *dev = &pdev->dev;
> -	struct drm_panel *panel;
>  	struct resource *regs;
>  	int irq_num;
>  	int ret;
> @@ -1021,19 +1045,6 @@ static int mtk_dsi_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	ret = drm_of_find_panel_or_bridge(dev->of_node, 0, 0,
> -					  &panel, &dsi->next_bridge);
> -	if (ret)
> -		goto err_unregister_host;
> -
> -	if (panel) {
> -		dsi->next_bridge = devm_drm_panel_bridge_add(dev, panel);
> -		if (IS_ERR(dsi->next_bridge)) {
> -			ret = PTR_ERR(dsi->next_bridge);
> -			goto err_unregister_host;
> -		}
> -	}
> -
>  	dsi->driver_data = of_device_get_match_data(dev);
>  
>  	dsi->engine_clk = devm_clk_get(dev, "engine");
> @@ -1098,14 +1109,6 @@ static int mtk_dsi_probe(struct platform_device *pdev)
>  	dsi->bridge.of_node = dev->of_node;
>  	dsi->bridge.type = DRM_MODE_CONNECTOR_DSI;
>  
> -	drm_bridge_add(&dsi->bridge);
> -
> -	ret = component_add(&pdev->dev, &mtk_dsi_component_ops);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to add component: %d\n", ret);
> -		goto err_unregister_host;
> -	}
> -
>  	return 0;
>  
>  err_unregister_host:
> @@ -1118,8 +1121,6 @@ static int mtk_dsi_remove(struct platform_device *pdev)
>  	struct mtk_dsi *dsi = platform_get_drvdata(pdev);
>  
>  	mtk_output_dsi_disable(dsi);
> -	drm_bridge_remove(&dsi->bridge);
> -	component_del(&pdev->dev, &mtk_dsi_component_ops);
>  	mipi_dsi_host_unregister(&dsi->host);
>  
>  	return 0;
> -- 
> 2.33.1
> 
> 
> -- 
> To unsubscribe, send mail to kernel-unsubscribe@lists.collabora.co.uk.
