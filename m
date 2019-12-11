Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F71311AC83
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfLKNyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:54:50 -0500
Received: from first.geanix.com ([116.203.34.67]:59766 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKNyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:54:49 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 6CFA0490;
        Wed, 11 Dec 2019 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576072459; bh=gi9YBR0FWPCRe1040DQWod53uZI/5OOjfhulrQyejWA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hkIohwhqmdxT2dxMAfuHQuibjLyzVZ3tfm0ei8a8/l/Z9U9glNKX+1GB7IKr+txsS
         MQPlujZLtmcgf56LRH46hbblhYIW+4XXhmNQ/+nPFLEBSmmxzCt6UkX6wikve4ahrd
         Lj282jitRPrrshV3IzVLbacq6AAdofxyBIRgP3wjGa+lpnL4+9sYi+An05RG97iBvu
         Ne0mvXMawyBvRnBfLWW/KIQ/6XCkKB0uIQErG9RzhYb9+OtUh+p6nSONoHu16uWi3C
         gLcZ0b/Cw0Z3Le3z33M0PUY4+CPtOGjEo7JOAwnUWWJxJi+HTYE7J2Yc5IGgQxaWa4
         rqE4nRLRhbGlg==
Subject: Re: [PATCH v6 1/2] can: tcan4x5x: put the device out of standby
 before register access
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20191211135340.320004-1-sean@geanix.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <cd599c58-11f2-299d-9d24-9dd88775032d@geanix.com>
Date:   Wed, 11 Dec 2019 14:54:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191211135340.320004-1-sean@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Skip this one :)

On 11/12/2019 14.53, Sean Nyekjaer wrote:
> The m_can tries to detect if Non ISO Operation is available while in
> standby, this function results in the following error:
> 
> tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
> tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
> tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.
> 
> When the tcan device comes out of reset it comes out in standby mode.
> The m_can driver tries to access the control register but fails due to
> the device is in standby mode.
> 
> So this patch will put the tcan device in normal mode before the m_can
> driver does the initialization.
> 
> Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Changes since v3:
>   - added reset if the reset_gpio is not avaliable
> 
> Changes since v4:
>   - added error handling for the SPI I/O
> 
> Changes since v5:
>   - Removed braces for single statement if's
> 
>   drivers/net/can/m_can/tcan4x5x.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
> index c1b83dc26c3a..295dbb73c69e 100644
> --- a/drivers/net/can/m_can/tcan4x5x.c
> +++ b/drivers/net/can/m_can/tcan4x5x.c
> @@ -484,6 +484,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
>   	if (ret)
>   		goto out_power;
>   
> +	ret = tcan4x5x_init(mcan_class);
> +	if (ret)
> +		goto out_power;
> +
>   	ret = m_can_class_register(mcan_class);
>   	if (ret)
>   		goto out_power;
> 
