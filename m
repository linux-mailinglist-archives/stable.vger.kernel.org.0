Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05F9687D0E
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 13:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjBBMRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 07:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBMRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 07:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B476FD38;
        Thu,  2 Feb 2023 04:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42DF461AF9;
        Thu,  2 Feb 2023 12:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95437C433EF;
        Thu,  2 Feb 2023 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675340227;
        bh=kXuVYOYprEDAERc9ptWyMD0dUfVOl7wsMQbwhSMi7eU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEfzBbqOC8Hqklq9IWsxlHAenMXr143GgEE5GC9FLVByvD6w1OGp/BLIRQJPl2zKP
         RggMPeisymcQZCUneIu57XG3OcHTXx2kc2kK5Ui9PJENo8x0zJxUhniILVKlK1eYKa
         rZ1nov43rLlcQLG6F5iPV76qXesHS70hea+0Wv2i6C1gDLfDtshPHM2StvWUZzRgSi
         WTjuJ7xer7xYwz6L954tuYZCRhrXZ0VuZCX+FYEeWHUQTDqXdvbJW7BK166IrAqeUQ
         FRzV48SorFgR73bQnAmPJE1wUylAP6HohDjXIV+Oqqk25lSkzQCJyrA909aw9CKgSw
         PW4i3J7MnChhQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pNYWw-0001UF-Bx; Thu, 02 Feb 2023 13:17:31 +0100
Date:   Thu, 2 Feb 2023 13:17:30 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Artur =?utf-8?B?xZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 15/23] interconnect: exynos: fix registration race
Message-ID: <Y9up2gKUpZXhI+J8@hovoldconsulting.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-16-johan+linaro@kernel.org>
 <e706bb89-bb79-33e3-f319-268ec4695015@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e706bb89-bb79-33e3-f319-268ec4695015@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 12:04:49PM +0100, Krzysztof Kozlowski wrote:
> On 01/02/2023 11:15, Johan Hovold wrote:

> > @@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
> >  	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
> >  	struct icc_node *parent_node, *node = priv->node;
> >  
> > +	icc_provider_deregister(&priv->provider);
> > +
> >  	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
> >  	if (parent_node && !IS_ERR(parent_node))
> >  		icc_link_destroy(node, parent_node);
> >  
> >  	icc_nodes_remove(&priv->provider);
> > -	icc_provider_del(&priv->provider);
> >  
> >  	return 0;
> >  }
> > @@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
> >  	provider->inter_set = true;
> >  	provider->data = priv;
> >  
> > -	ret = icc_provider_add(provider);
> > -	if (ret < 0)
> > -		return ret;
> > +	icc_provider_init(provider);
> >  
> >  	icc_node = icc_node_create(pdev->id);
> > -	if (IS_ERR(icc_node)) {
> > -		ret = PTR_ERR(icc_node);
> > -		goto err_prov_del;
> > -	}
> > +	if (IS_ERR(icc_node))
> > +		return PTR_ERR(icc_node);
> >  
> >  	priv->node = icc_node;
> >  	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
> > @@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
> >  			goto err_pmqos_del;
> >  	}
> >  
> > +	ret = icc_provider_register(provider);
> > +	if (ret < 0)
> > +		goto err_pmqos_del;
> 
> If I understand correctly there is no need for icc_link_destroy() in
> error path here, right? Even in case of probe retry (defer or whatever
> reason) - the link will be removed with icc_nodes_remove()?

Correct, it is no longer needed after the first patch in this series.

The exynos driver was the only driver that bothered to remove links
explicitly, all the others expected the interconnect framework to do so
when destroying nodes even if that was not case until now.

Johan
