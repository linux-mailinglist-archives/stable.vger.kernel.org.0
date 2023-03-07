Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486346ADAB4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCGJny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjCGJnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:45 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E1F8A39E;
        Tue,  7 Mar 2023 01:43:32 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EF9851C0005;
        Tue,  7 Mar 2023 09:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678182210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01+uAnOiSLbTM0wZcSQJcnuJqtQP5yT5es3lE/RNx8s=;
        b=W0FOXboaN+ZfaE1tOFAvB0nH9CZUt2e57a9f90MZdoalOOiRKe0aTlMaeJ30NwVZqfyo7Z
        E7WglxyOR0vU8/phJe7AxiQe+XKeN5p2ay7pUIouDSX2Ay0fBGasMnn9/cSzAtIjyXvIQJ
        Rh4itmk/epniRXUBvtOCitKQ2WBfhBnYYLsISU4V8mS/NeEvdFBoWqyCIlFUXbetFBE4qd
        nqOOcIBvSesXGNQcH5WFlReYR0+9moZA4Qmn1GzlWA6Do6HpxR0cQvHIqFwiQwhzrl9oR6
        prAQn9sFF5bs4Bnu/mh0mzYOUwG2LOouY+sy65380JLuYEXYQye9zegYfMJQrw==
Date:   Tue, 7 Mar 2023 10:43:24 +0100
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
        stable@vger.kernel.org, Alexandre Bailon <abailon@baylibre.com>
Subject: Re: [PATCH v2 04/23] interconnect: imx: fix registration race
Message-ID: <20230307104324.121166d1@booty>
In-Reply-To: <20230306075651.2449-5-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
        <20230306075651.2449-5-johan+linaro@kernel.org>
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

On Mon,  6 Mar 2023 08:56:32 +0100
Johan Hovold <johan+linaro@kernel.org> wrote:

> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
> Cc: stable@vger.kernel.org      # 5.8
> Cc: Alexandre Bailon <abailon@baylibre.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

v2 works just as well, so my Tested-by is confirmed. Maybe it's useful
mentioning the hardware used for testing so:

[Tested on i.MX8MP using an MSC SM2-MB-EP1 Board]
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
