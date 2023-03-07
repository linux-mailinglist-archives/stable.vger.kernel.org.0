Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907E6ADAAB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCGJn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCGJnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:25 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A725963;
        Tue,  7 Mar 2023 01:43:22 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 32C2B240004;
        Tue,  7 Mar 2023 09:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678182200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMXF5RO797AntyK5sFhI5pkd/DTeetnKf/c/TJqL6/c=;
        b=GWpZU9zWyN/iCJJ1cfS24PN+Ci74T5kOXtq4AIkYR5gEfIB4PP2mhB4qRVE5fqYR6zj274
        oNA7/NYzdOsNuv3P0R1wxmc8ypQnIcClrvAaepx8kceDXZgMDv4xIQtSnwljVfAAggmkHK
        SyYf7gGzZEs0emflJ4A6tMfnfp2v3Ukfxa/6FQ6ij7Zf3KT96Liob/E1ekDBe0uoXnoOf4
        oFv7/a+W1XRcYsLoFHs0TB7JhHcNAzNqgvlrAhYComjyPvfxsxvt3ms2qE5bxaBAo3jqlB
        MH3JyEPpkyJ0QMp0/sOty/gotftm0STXCR71TLaCyF5ojlrua3Eeev90VGBgyQ==
Date:   Tue, 7 Mar 2023 10:43:15 +0100
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
Subject: Re: [PATCH v2 03/23] interconnect: fix provider registration API
Message-ID: <20230307104315.14ff7e4d@booty>
In-Reply-To: <20230306075651.2449-4-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
        <20230306075651.2449-4-johan+linaro@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  6 Mar 2023 08:56:31 +0100
Johan Hovold <johan+linaro@kernel.org> wrote:

> The current interconnect provider interface is inherently racy as
> providers are expected to be added before being fully initialised.
> 
> Specifically, nodes are currently not added and the provider data is not
> initialised until after registering the provider which can cause racing
> DT lookups to fail.
> 
> Add a new provider API which will be used to fix up the interconnect
> drivers.
> 
> The old API is reimplemented using the new interface and will be removed
> once all drivers have been fixed.
> 
> Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
> Fixes: 87e3031b6fbd ("interconnect: Allow endpoints translation via DT")
> Cc: stable@vger.kernel.org      # 5.1
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

[Tested on i.MX8MP using an MSC SM2-MB-EP1 Board]
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
