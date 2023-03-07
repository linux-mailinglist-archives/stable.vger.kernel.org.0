Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358B56ADA98
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCGJnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCGJnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:02 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51CDA27D;
        Tue,  7 Mar 2023 01:42:59 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D1F0F60003;
        Tue,  7 Mar 2023 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678182178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/nrrM7GOwNypzZEIPS3KZcPQ6pGpKzGHZi2T20yll0=;
        b=PbqPkEUab+79Gt+LmPzjN2iHg5Z5eimhqS+BTKlPK6x8Q++UPNoN34mtHjZGL1mSJhlvU5
        G/a9FmDimWgcYRjPkydKswdoGfPhBW97D0ycBO9mwE6rwkeoTaqLPJTAJM05vnS3B4PcLo
        n5g/7H1ZfHQsSVpoGTiOGCpRpfGXv3mQw4L+iEmDyexWGDV/lbENpJlPYdpJolh9PxD2dS
        n26q2Py5+TfcpKQpmgPfYwI0G+cuyHQ4LamHDPTLJ4uL/M7zTaX3Y5OTD0B9d/cW7kggme
        BVm3zRagdt/UZu2aAgnrjpD3uRNAmAR1Xk5hGLVPPmKSSsJWqK7tFzWRCNWBQA==
Date:   Tue, 7 Mar 2023 10:42:53 +0100
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
Subject: Re: [PATCH v2 01/23] interconnect: fix mem leak when freeing nodes
Message-ID: <20230307104253.761c048f@booty>
In-Reply-To: <20230306075651.2449-2-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
        <20230306075651.2449-2-johan+linaro@kernel.org>
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

Hello Johan,

thanks for respinning.

On Mon,  6 Mar 2023 08:56:29 +0100
Johan Hovold <johan+linaro@kernel.org> wrote:

> The node link array is allocated when adding links to a node but is not
> deallocated when nodes are destroyed.
> 
> Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
> Cc: stable@vger.kernel.org      # 5.1
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

[Tested on i.MX8MP using an MSC SM2-MB-EP1 Board]
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
