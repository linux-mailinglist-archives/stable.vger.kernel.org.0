Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498A2F1951
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbhAKPPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729295AbhAKPPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:15:41 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA04C061786;
        Mon, 11 Jan 2021 07:15:01 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o19so78906lfo.1;
        Mon, 11 Jan 2021 07:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AjtuZDdcWOc1/aa559ej/SsGKfJvStJlSBlf/+tuqFA=;
        b=IDPaeXPlFe/R9pS10V9hjQdlj+S47fDehlQSxYLZ7jj/yBD7pn3TAw+7g+/3Iw/Dco
         b9pe7BZE9sPZoZfqLZLh3xoCpKeMvutiK7qcFt2aWSOktto9q1nSiZL4dtY5dOR3HypW
         gwfGRWRagM48GipIVOgvPpX1MTGgeNVLmsVypdwNQFLIlh5l5h6hmGW7AA/DCf0v8Hkz
         UrO8uEYYlBeinK2HxQS//MpYUKTaoHKClbczwORmsA7vmu5r3oRPxOnVn8abTeThC1u0
         mXXOlhmRgdTyT3HsoP/i/oXZ52zE+Ox53uWjCIQ2p1HFEyC+Ek6RmzbSRXjRSUr7mrD+
         BZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjtuZDdcWOc1/aa559ej/SsGKfJvStJlSBlf/+tuqFA=;
        b=sAsa4iVCHAW/FvwyJxOeW4x3s+71FvSZOn6dtmV4XcaTO/3ecQwNuvnAFHNR2TTwP/
         CZHUL45qa3swJyuXS+t8mhtoI6CYRlZ3dHO6th7kYhjJWzPQGWBsAWALr9WfkmQVYOby
         yzxVN+G0tt4aLV4TbRWaI2dUCO9qqdh3RZXPDWbtjQXmu16GDKPyZQuCO2oh6HO1lT4L
         77xAf8wqzr8oaueGGgg5lGC1gvzuFKptpjcSOWE98SIH313k4KL4WxIpVhaDVcvs9Ujb
         TB3IiA7rWjQyHo7DkLDZUS+Nx9VrimED+0wElbg2E/Ii5WdUtI+F3lRYTMjL1CxyyqNO
         vPRw==
X-Gm-Message-State: AOAM531CunFpyTGY9LFPoA5JU68NINHV6ZSktw4jFoP6pJnPaBVT5caX
        ljsTiX0Vtl7YHBG7H31Ic6Dkya095Ow=
X-Google-Smtp-Source: ABdhPJwYAi44DlFlpntPHSRlq0LUv5Am5FXiHbfev4FoJCgQ1QQ7fNoxfmGX4Nl6deNcgFvTcxIHbQ==
X-Received: by 2002:a19:e210:: with SMTP id z16mr35086lfg.640.1610378099532;
        Mon, 11 Jan 2021 07:14:59 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id y23sm3484025ljc.119.2021.01.11.07.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 07:14:58 -0800 (PST)
Subject: Re: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
To:     Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com, wsa@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210111135547.3613092-1-mperttunen@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b7f69fb9-2960-f994-51d8-afd86af26bba@gmail.com>
Date:   Mon, 11 Jan 2021 18:14:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20210111135547.3613092-1-mperttunen@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.01.2021 16:55, Mikko Perttunen пишет:
> Upon a communication error, the interrupt handler can call
> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
> unless the current transaction was marked atomic. Since
> tegra_i2c_disable_packet_mode is only called from the interrupt path,
> make it use atomic waiting always.
> 
> Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> This fixes constant spew for me while HDMI is connected to a
> powered off television.
> 
>  drivers/i2c/busses/i2c-tegra.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 6f08c0c3238d..4a7ff1840565 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -528,12 +528,12 @@ static void tegra_i2c_vi_init(struct tegra_i2c_dev *i2c_dev)
>  
>  static int tegra_i2c_poll_register(struct tegra_i2c_dev *i2c_dev,
>  				   u32 reg, u32 mask, u32 delay_us,
> -				   u32 timeout_us)
> +				   u32 timeout_us, bool force_atomic)
>  {
>  	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
>  	u32 val;
>  
> -	if (!i2c_dev->atomic_mode)
> +	if (!i2c_dev->atomic_mode && !force_atomic)
>  		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
>  						  delay_us, timeout_us);
>  
> @@ -560,7 +560,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
>  	val |= mask;
>  	i2c_writel(i2c_dev, val, offset);
>  
> -	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000);
> +	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000, false);
>  	if (err) {
>  		dev_err(i2c_dev->dev, "failed to flush FIFO\n");
>  		return err;
> @@ -569,7 +569,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
>  	return 0;
>  }
>  
> -static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
> +static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev, bool force_atomic)
>  {
>  	int err;
>  
> @@ -579,7 +579,7 @@ static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
>  	i2c_writel(i2c_dev, I2C_MSTR_CONFIG_LOAD, I2C_CONFIG_LOAD);
>  
>  	err = tegra_i2c_poll_register(i2c_dev, I2C_CONFIG_LOAD, 0xffffffff,
> -				      1000, I2C_CONFIG_LOAD_TIMEOUT);
> +				      1000, I2C_CONFIG_LOAD_TIMEOUT, force_atomic);
>  	if (err) {
>  		dev_err(i2c_dev->dev, "failed to load config\n");
>  		return err;
> @@ -684,7 +684,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
>  	if (i2c_dev->multimaster_mode && i2c_dev->hw->has_slcg_override_reg)
>  		i2c_writel(i2c_dev, I2C_MST_CORE_CLKEN_OVR, I2C_CLKEN_OVERRIDE);
>  
> -	err = tegra_i2c_wait_for_config_load(i2c_dev);
> +	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
>  	if (err)
>  		return err;
>  
> @@ -707,7 +707,7 @@ static int tegra_i2c_disable_packet_mode(struct tegra_i2c_dev *i2c_dev)
>  	if (cnfg & I2C_CNFG_PACKET_MODE_EN)
>  		i2c_writel(i2c_dev, cnfg & ~I2C_CNFG_PACKET_MODE_EN, I2C_CNFG);
>  
> -	return tegra_i2c_wait_for_config_load(i2c_dev);
> +	return tegra_i2c_wait_for_config_load(i2c_dev, true);
>  }
>  
>  static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
> @@ -1090,7 +1090,7 @@ static int tegra_i2c_issue_bus_clear(struct i2c_adapter *adap)
>  	      I2C_BC_TERMINATE;
>  	i2c_writel(i2c_dev, val, I2C_BUS_CLEAR_CNFG);
>  
> -	err = tegra_i2c_wait_for_config_load(i2c_dev);
> +	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
>  	if (err)
>  		return err;
>  
> 

What about a simpler variant:

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 6f08c0c3238d..0727383f4940 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -533,7 +533,7 @@ static int tegra_i2c_poll_register(struct
tegra_i2c_dev *i2c_dev,
 	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
 	u32 val;

-	if (!i2c_dev->atomic_mode)
+	if (!i2c_dev->atomic_mode && !in_irq())
 		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
 						  delay_us, timeout_us);

