Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA336ADAA5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCGJnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCGJnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:18 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AFD30B13;
        Tue,  7 Mar 2023 01:43:15 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AEE37E0005;
        Tue,  7 Mar 2023 09:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678182194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fBXMFy24pB1L3M53iT14RCAKjfqpFvZO6FaFdhmAFPk=;
        b=gVTSj14MgoBG4gs3EBb/yS4z1UVGC9WxSCIkJr4xV9QLRIAWT4/qYoadkpXoySXjOiMDO5
        TFbuaNtobklneO5eVFomlh1zHpmNtpmaLafLZtFd+YONwhGkaZn2qfgNguB95FiyLrBF8e
        Y3729IfU6UNr94JzAgJWMqAOy1chLkJPj7nG6zA4Ll6Q/aBgHJiTiAl4WqFcxjtCD8Y26J
        A50G6X6U+5TMn8PQvoJ7FkW8mvvxC4l3jN7v5FtXKxpsOGIXEhDTXlHffEXM7fHSdohoUz
        VY2DDDCwyOy73TFdosMsPQXQ66tkdiS2Pfsmd60O20MbL0Hxf1IyoJClfNyTAA==
Date:   Tue, 7 Mar 2023 10:43:08 +0100
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Georgi Djakov <djakov@kernel.org>,
        "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        Artur =?UTF-8?Q?=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Jonathan Hunter" <jonathanh@nvidia.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/23] interconnect: fix icc_provider_del() error
 handling
Message-ID: <20230307104308.3bd7b595@booty>
In-Reply-To: <20230306075651.2449-3-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
        <20230306075651.2449-3-johan+linaro@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  6 Mar 2023 08:56:30 +0100
Johan Hovold <johan+linaro@kernel.org> wrote:

> The interconnect framework currently expects that providers are only
> removed when there are no users and after all nodes have been removed.
> 
> There is currently nothing that guarantees this to be the case and the
> framework does not do any reference counting, but refusing to remove the
> provider is never correct as that would leave a dangling pointer to a
> resource that is about to be released in the global provider list (e.g.
> accessible through debugfs).
> 
> Replace the current sanity checks with WARN_ON() so that the provider is
> always removed.
> 
> Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
> Cc: stable@vger.kernel.org      # 5.1: 680f8666baf6: interconnect: Make icc_provider_del() return void
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

[Tested on i.MX8MP using an MSC SM2-MB-EP1 Board]
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
