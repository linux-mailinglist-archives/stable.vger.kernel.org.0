Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9709B95806
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 09:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfHTHO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 03:14:57 -0400
Received: from first.geanix.com ([116.203.34.67]:55150 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfHTHO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 03:14:57 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id C1AE526E;
        Tue, 20 Aug 2019 07:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1566285291; bh=PMa6IhGgZRRpYUhyyn3xjfMgo0+dc2IG3GNNCA4vWlk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=IJEv8xHrD+0PI2nCxO8BhK3pCC7fYeytBjy0bP2YQjmcWb9jwk1bm1kHuEc7caaMs
         fyZ3qkUq9/BCAAKHn7rzrHB0eYHEMhWlnoxmlLHuPMOblZL+hbtVO0dIFQWVEwra2n
         yConhfjFgTMO5o99FTWMBA6bjw0XYYeYWHPzh1AYH4FFKSJBSZguZkhCTKaaZkUcXt
         8DzZcbZGpZdNEtAbF1XPFpJ28xT4clWRpCEsOEghmtdIvvX38EC3aZ/k4Sn+HnpBgt
         gOQax8VEvRKAtRwnLkneyGU8t+TK5ocld7pf1G4ZblJJdiE2bWGl1a+SNaHnNsAuf8
         3zy6fKkt/HMig==
Subject: Re: [PATCH 6/9] can: mcp251x: mcp251x_hw_reset(): allow more time
 after a reset
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     t.schluessler@krause.de, shc_work@mail.ru,
        linux-stable <stable@vger.kernel.org>
References: <20190819153818.29293-1-mkl@pengutronix.de>
 <20190819153818.29293-7-mkl@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <0ad8b13d-ea63-bc2e-55d2-fb279e51331f@geanix.com>
Date:   Tue, 20 Aug 2019 09:14:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819153818.29293-7-mkl@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 19/08/2019 17.38, Marc Kleine-Budde wrote:
> Some boards take longer than 5ms to power up after a reset, so allow
> some retries attempts before giving up.
> 
> Fixes: ff06d611a31c ("can: mcp251x: Improve mcp251x_hw_reset()")
> Cc: linux-stable <stable@vger.kernel.org>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ---
>   drivers/net/can/spi/mcp251x.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index 44b57187a6f3..db69c04bac2d 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -606,7 +606,7 @@ static int mcp251x_setup(struct net_device *net, struct spi_device *spi)
>   static int mcp251x_hw_reset(struct spi_device *spi)
>   {
>   	struct mcp251x_priv *priv = spi_get_drvdata(spi);
> -	u8 reg;
> +	unsigned long timeout;
>   	int ret;
>   
>   	/* Wait for oscillator startup timer after power up */
> @@ -620,10 +620,19 @@ static int mcp251x_hw_reset(struct spi_device *spi)
>   	/* Wait for oscillator startup timer after reset */
>   	mdelay(MCP251X_OST_DELAY_MS);
>   
> -	reg = mcp251x_read_reg(spi, CANSTAT);
> -	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
> -		return -ENODEV;
> -
> +	/* Wait for reset to finish */
> +	timeout = jiffies + HZ;
> +	while ((mcp251x_read_reg(spi, CANSTAT) & CANCTRL_REQOP_MASK) !=
> +	       CANCTRL_REQOP_CONF) {
> +		usleep_range(MCP251X_OST_DELAY_MS * 1000,
> +			     MCP251X_OST_DELAY_MS * 1000 * 2);
> +
> +		if (time_after(jiffies, timeout)) {
> +			dev_err(&spi->dev,
> +				"MCP251x didn't enter in conf mode after reset\n");
> +			return -EBUSY;
> +		}
> +	}
>   	return 0;
>   }
>   
> 
