Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3B2EE9A3
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbhAGXOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 18:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGXOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 18:14:06 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8860BC0612F4;
        Thu,  7 Jan 2021 15:13:26 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4DBhpy0bPXzQjkp;
        Fri,  8 Jan 2021 00:12:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1610061174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d1Fq6KxGLHplkkxd0vbq2wU9v0Nhdb37sYwiuaI4yJk=;
        b=V/gvRFxz7swGJ6D2ePbo8B3HYAygZwc/aaREj8U1jiGizX+upWi6Ni1o2CyZlJRQTufKfh
        HoFATmdJVfmHRmbAarKFH4PmPSXEg4aDBaZfAROlPC6s7gnnFx/qEiXRRRkoRrNmah1vvE
        iawzv1Py15vZFFOl16r7VzlNciWqphYOU31uQ8XeGqumyNCj8X0lSx7J6Igh2Q59QlTgAx
        r+yFvBdHJOmQSQgEK/0x/D6jUVjkt1yK7bhUHuTHjIjlQUx949WHrgk9SlA0i0msYd6bvs
        myJbFgwL/ncafEAGn4l6csMoDzqgWDGZdZfI58yYo8eyObEdyQhxxwltZrLAzw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 0DG01k1dgDeq; Fri,  8 Jan 2021 00:12:52 +0100 (CET)
Subject: Re: [PATCH] phy: lantiq: rcu-usb2: wait after clock enable
To:     Mathias Kresin <dev@kresin.me>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
References: <20210107224901.2102479-1-dev@kresin.me>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <c82d382e-d918-0a01-d973-88496e6d8ba0@hauke-m.de>
Date:   Fri, 8 Jan 2021 00:12:51 +0100
MIME-Version: 1.0
In-Reply-To: <20210107224901.2102479-1-dev@kresin.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.91 / 15.00 / 15.00
X-Rspamd-Queue-Id: 1541B1847
X-Rspamd-UID: dc5c31
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 11:49 PM, Mathias Kresin wrote:
> Commit 65dc2e725286 ("usb: dwc2: Update Core Reset programming flow.")
> revealed that the phy isn't ready immediately after enabling it's
> clocks. The dwc2_check_core_version() fails and the dwc2 usb driver
> errors out.
> 
> Add a short delay to let the phy get up and running. There isn't any
> documentation how much time is required, the value was chosen based on
> tests.
> 
> Cc: <stable@vger.kernel.org> # v5.7+
> Signed-off-by: Mathias Kresin <dev@kresin.me>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

I do not know how long you have to wait here, but this looks ok, when it 
works.

Hauke

> ---
>   drivers/phy/lantiq/phy-lantiq-rcu-usb2.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
> index a7d126192cf1..29d246ea24b4 100644
> --- a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
> +++ b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
> @@ -124,8 +124,16 @@ static int ltq_rcu_usb2_phy_power_on(struct phy *phy)
>   	reset_control_deassert(priv->phy_reset);
>   
>   	ret = clk_prepare_enable(priv->phy_gate_clk);
> -	if (ret)
> +	if (ret) {
>   		dev_err(dev, "failed to enable PHY gate\n");
> +		return ret;
> +	}
> +
> +	/*
> +	 * at least the xrx200 usb2 phy requires some extra time to be
> +	 * operational after enabling the clock
> +	 */
> +	usleep_range(100, 200);
>   
>   	return ret;
>   }
> 

