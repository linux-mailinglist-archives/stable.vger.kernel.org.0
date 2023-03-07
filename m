Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F8D6ADBC6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 11:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCGKZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 05:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGKZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 05:25:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F586BB87;
        Tue,  7 Mar 2023 02:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5212612E3;
        Tue,  7 Mar 2023 10:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC0EC433D2;
        Tue,  7 Mar 2023 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678184710;
        bh=o0cPSYc9dA2JP/bjbrLx4zaWDnAO4a0TM9HJToYkFC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QtWHQrqrPpYYuL+tYw6B20SoFnnMuZlXGWUo1tmwGYtM9LbrgbLDHRuR2/7waceJp
         uqHcowVk17L36ZDRcn2z+gb1O1uU5yzGuWcVRR3OPWlJRcLaXDr7Sprc/3saM+aL4D
         cs0pgxKZgrHmwOnnXIaoUcSHi2lT1y8ydDaVU4a63ElLP22IftdVuOTwfC2RwnVmuo
         a47TtvmhAb+BZsVqnLfkLsxk0Te6HLNSt2fAtj+JQEsDd7bOuRj2no4HxaLirFkVTJ
         xJ9Vxe5NlWbpMsiLxGccCR0UMWDw8fwR/Snqfz76vCySfz4OLZKM6cPLw4813EIwtY
         ZO+EkS5hv0jvg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pZUW0-0000uQ-Ma; Tue, 07 Mar 2023 11:25:52 +0100
Date:   Tue, 7 Mar 2023 11:25:52 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Luca Ceresoli <luca.ceresoli@bootlin.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alexandre Bailon <abailon@baylibre.com>
Subject: Re: [PATCH v2 04/23] interconnect: imx: fix registration race
Message-ID: <ZAcRMNTyDrqVMxIm@hovoldconsulting.com>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
 <20230306075651.2449-5-johan+linaro@kernel.org>
 <20230307104324.121166d1@booty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307104324.121166d1@booty>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 10:43:24AM +0100, Luca Ceresoli wrote:
> On Mon,  6 Mar 2023 08:56:32 +0100
> Johan Hovold <johan+linaro@kernel.org> wrote:
> 
> > The current interconnect provider registration interface is inherently
> > racy as nodes are not added until the after adding the provider. This
> > can specifically cause racing DT lookups to fail.
> > 
> > Switch to using the new API where the provider is not registered until
> > after it has been fully initialised.
> > 
> > Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
> > Cc: stable@vger.kernel.org      # 5.8
> > Cc: Alexandre Bailon <abailon@baylibre.com>
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> > Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> 
> v2 works just as well, so my Tested-by is confirmed. Maybe it's useful
> mentioning the hardware used for testing so:
> 
> [Tested on i.MX8MP using an MSC SM2-MB-EP1 Board]
> Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

Thanks for reconfirming. Looks like Georgi has picked these up for
6.3-rc now.

Johan
