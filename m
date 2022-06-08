Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A41542E25
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiFHKoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 06:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbiFHKoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 06:44:24 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 03:44:22 PDT
Received: from proxmox1.postmarketos.org (proxmox1.postmarketos.org [IPv6:2a01:4f8:a0:821d::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 315A812D172;
        Wed,  8 Jun 2022 03:44:22 -0700 (PDT)
Received: from [192.168.0.33] (cpc78119-cwma10-2-0-cust590.7-3.cable.virginm.net [81.96.50.79])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by proxmox1.postmarketos.org (Postfix) with ESMTPSA id B972514009C;
        Wed,  8 Jun 2022 10:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=postmarketos.org;
        s=donut; t=1654683902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzmXENU7s14JgyqydKEh7VchsTErwIFffsmGrZ6wfH4=;
        b=Fq+3VF03/b5siWKm7/IKQFQyJc2S1qH0JEok+wV9QQIVPgAKmWf1a1lw7PIn/6cdDtVZqm
        FdPYSRzyW938m4/98+1qf9YIIrN3cvdRjbhU1jtWYctNKXpdtfMJn5SGJO/E9aoSFDqdMq
        AqqbyY3AiT8UU8FpO+7Np3oI/M/EuWo=
Message-ID: <c5c7e071-a645-39a2-c3dc-897173e8c971@postmarketos.org>
Date:   Wed, 8 Jun 2022 11:25:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.18 579/879] pinctrl/rockchip: support deferring other
 gpio params
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220607165002.659942637@linuxfoundation.org>
 <20220607165019.660801561@linuxfoundation.org>
From:   Caleb Connolly <kc@postmarketos.org>
In-Reply-To: <20220607165019.660801561@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This commit contains a bug which was fixed in commit
42d90a1e5caf ("pinctrl/rockchip: support setting input-enable param")

It uses bitwise OR to check non-bitwise values (see below).


On 07/06/2022 18:01, Greg Kroah-Hartman wrote:
> From: Caleb Connolly <kc@postmarketos.org>
> 
> [ Upstream commit 8ce5ef64546850294b021497046588a7abcebe96 ]
> 
> Add support for deferring other params like PIN_CONFIG_INPUT_ENABLE.
> This will be used to add support for PIN_CONFIG_INPUT_ENABLE to the
> driver.
> 
> Fixes: e7165b1dff06 ("pinctrl/rockchip: add a queue for deferred pin output settings on probe")
> Fixes: 59dd178e1d7c ("gpio/rockchip: fetch deferred output settings on probe")
> Signed-off-by: Caleb Connolly <kc@postmarketos.org>
> Link: https://lore.kernel.org/r/20220328005005.72492-2-kc@postmarketos.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpio/gpio-rockchip.c       | 24 ++++++++-----
>   drivers/pinctrl/pinctrl-rockchip.c | 54 ++++++++++++++++--------------
>   drivers/pinctrl/pinctrl-rockchip.h |  7 ++--
>   3 files changed, 50 insertions(+), 35 deletions(-)

[snip]

> @@ -2143,6 +2144,25 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
>   		param = pinconf_to_config_param(configs[i]);
>   		arg = pinconf_to_config_argument(configs[i]);
>   
> +		if (param == (PIN_CONFIG_OUTPUT | PIN_CONFIG_INPUT_ENABLE)) {
Should be if (param == PIN_CONFIG_OUTPUT || param == PIN_CONFIG_INPUT_ENABLE) {
> +			/*
> +			 * Check for gpio driver not being probed yet.
> +			 * The lock makes sure that either gpio-probe has completed
> +			 * or the gpio driver hasn't probed yet.
> +			 */
> +			mutex_lock(&bank->deferred_lock);
> +			if (!gpio || !gpio->direction_output) {
> +				rc = rockchip_pinconf_defer_pin(bank, pin - bank->pin_base, param,
> +								arg);
> +				mutex_unlock(&bank->deferred_lock);
> +				if (rc)
> +					return rc;
> +
> +				break;
> +			}
> +			mutex_unlock(&bank->deferred_lock);
> +		}
> +
>   		switch (param) {
>   		case PIN_CONFIG_BIAS_DISABLE:
>   			rc =  rockchip_set_pull(bank, pin - bank->pin_base,
> @@ -2171,22 +2191,6 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
>   			if (rc != RK_FUNC_GPIO)
>   				return -EINVAL;
>   
> -			/*
> -			 * Check for gpio driver not being probed yet.
> -			 * The lock makes sure that either gpio-probe has completed
> -			 * or the gpio driver hasn't probed yet.
> -			 */
> -			mutex_lock(&bank->deferred_lock);
> -			if (!gpio || !gpio->direction_output) {
> -				rc = rockchip_pinconf_defer_output(bank, pin - bank->pin_base, arg);
> -				mutex_unlock(&bank->deferred_lock);
> -				if (rc)
> -					return rc;
> -
> -				break;
> -			}
> -			mutex_unlock(&bank->deferred_lock);
> -
>   			rc = gpio->direction_output(gpio, pin - bank->pin_base,
>   						    arg);
>   			if (rc)
> @@ -2500,7 +2504,7 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
>   			pdesc++;
>   		}
>   
> -		INIT_LIST_HEAD(&pin_bank->deferred_output);
> +		INIT_LIST_HEAD(&pin_bank->deferred_pins);
>   		mutex_init(&pin_bank->deferred_lock);
>   	}
>   
> @@ -2763,7 +2767,7 @@ static int rockchip_pinctrl_remove(struct platform_device *pdev)
>   {
>   	struct rockchip_pinctrl *info = platform_get_drvdata(pdev);
>   	struct rockchip_pin_bank *bank;
> -	struct rockchip_pin_output_deferred *cfg;
> +	struct rockchip_pin_deferred *cfg;
>   	int i;
>   
>   	of_platform_depopulate(&pdev->dev);
> @@ -2772,9 +2776,9 @@ static int rockchip_pinctrl_remove(struct platform_device *pdev)
>   		bank = &info->ctrl->pin_banks[i];
>   
>   		mutex_lock(&bank->deferred_lock);
> -		while (!list_empty(&bank->deferred_output)) {
> -			cfg = list_first_entry(&bank->deferred_output,
> -					       struct rockchip_pin_output_deferred, head);
> +		while (!list_empty(&bank->deferred_pins)) {
> +			cfg = list_first_entry(&bank->deferred_pins,
> +					       struct rockchip_pin_deferred, head);
>   			list_del(&cfg->head);
>   			kfree(cfg);
>   		}
> diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
> index 91f10279d084..98a01a616da6 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.h
> +++ b/drivers/pinctrl/pinctrl-rockchip.h
> @@ -171,7 +171,7 @@ struct rockchip_pin_bank {
>   	u32				toggle_edge_mode;
>   	u32				recalced_mask;
>   	u32				route_mask;
> -	struct list_head		deferred_output;
> +	struct list_head		deferred_pins;
>   	struct mutex			deferred_lock;
>   };
>   
> @@ -247,9 +247,12 @@ struct rockchip_pin_config {
>   	unsigned int		nconfigs;
>   };
>   
> -struct rockchip_pin_output_deferred {
> +enum pin_config_param;
> +
> +struct rockchip_pin_deferred {
>   	struct list_head head;
>   	unsigned int pin;
> +	enum pin_config_param param;
>   	u32 arg;
>   };
>   
