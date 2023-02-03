Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1DF689EC2
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjBCQBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjBCQBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 11:01:35 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E369EE2;
        Fri,  3 Feb 2023 08:01:33 -0800 (PST)
Received: from booty (unknown [37.161.147.43])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3BEFB20007;
        Fri,  3 Feb 2023 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675440091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqeUY2vjR4owbFhVMWqoG7ucu+A1MAbmXZFL/6Sqg14=;
        b=Jm4+ERkEbhZiOGPRq71beJ/tzWo6Iqj308bxlDj8fSmPnNbOy6peySNR03AVqCv50vRbSr
        JUmdDAgDjynjXjd9tOGE8PpvfPfRbmQMm5o3L8GNhbCsXVXQ7141efCaqiy1BICPnH8hKX
        O/rJDzgU8LbYXpqI0cyzspnrHctWxd+9jn84cmuuNp2wXEYCCAvAC4j9JeEBvZFYc8O6tW
        J3mUNloNtXLKjQbKBlkuDeeqgzonx/FUaIaNivaqo1U0YGyHo6s0o6KkBGcbK9lYZj8Jjx
        lGjLlDrr6I0va7ekmfUKLE3bBx5f1gp433QFlCfQ5il1wTG9+3GpK+8ApFTppQ==
Date:   Fri, 3 Feb 2023 17:01:21 +0100
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Georgi Djakov <djakov@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Artur =?UTF-8?Q?=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Alexandre Bailon <abailon@baylibre.com>
Subject: Re: [PATCH 04/23] interconnect: imx: fix registration race
Message-ID: <20230203170121.187108bd@booty>
In-Reply-To: <20230201101559.15529-5-johan+linaro@kernel.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
        <20230201101559.15529-5-johan+linaro@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Johan,

On Wed,  1 Feb 2023 11:15:40 +0100
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
> Cc: Leonard Crestez <leonard.crestez@nxp.com>
> Cc: Alexandre Bailon <abailon@baylibre.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Georgi pointed me to this series after I reported a bug yesterday [0],
that I found on iMX8MP. So I ran some tests with my original, failing
tree, minus one patch with my debugging code to hunt for the bug, plus
patches 1-4 of this series.

The original code was failing approx 5~10% of the times. With your 4
patches applied it ran 139 times with zero errors, which looks great! I
won't be able to do more testing until next Monday to be extra sure.

[0]
https://lore.kernel.org/linux-arm-kernel/20230202175525.3dba79a7@booty/T/#u

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
