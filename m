Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947522F1923
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbhAKPFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:05:33 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:43418 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726459AbhAKPFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:05:33 -0500
Received: from cpc79921-stkp12-2-0-cust288.10-2.cable.virginm.net ([86.16.139.33] helo=[192.168.0.18])
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1kyykV-0008FJ-EB; Mon, 11 Jan 2021 15:04:51 +0000
Subject: Re: [PATCH] i2c: tegra-bpmp: ignore DMA safe buffer flag
To:     Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com
Cc:     talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org
References: <20210111142713.3641208-1-mperttunen@nvidia.com>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <16a0be21-2cbe-dd0e-aed7-b84f6abcacac@codethink.co.uk>
Date:   Mon, 11 Jan 2021 15:04:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111142713.3641208-1-mperttunen@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/01/2021 14:27, Mikko Perttunen wrote:
> From: Muhammed Fazal <mfazale@nvidia.com>
> 
> Ignore I2C_M_DMA_SAFE flag as it does not make a difference
> for bpmp-i2c, but causes -EINVAL to be returned for valid
> transactions.
> 
> Signed-off-by: Muhammed Fazal <mfazale@nvidia.com>
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> This fixes failures seen with PMIC probing tools on
> Tegra186+ boards.
> 
>   drivers/i2c/busses/i2c-tegra-bpmp.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c b/drivers/i2c/busses/i2c-tegra-bpmp.c
> index ec7a7e917edd..998d4b21fb59 100644
> --- a/drivers/i2c/busses/i2c-tegra-bpmp.c
> +++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
> @@ -80,6 +80,9 @@ static int tegra_bpmp_xlate_flags(u16 flags, u16 *out)
>   		flags &= ~I2C_M_RECV_LEN;
>   	}
>   
> +	if (flags & I2C_M_DMA_SAFE)
> +		flags &= ~I2C_M_DMA_SAFE;
> +

Just a comment, you can do without the test here.
Just doing this would have been fine:

	flags &= ~I2C_M_DMA_SAFE;



-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
