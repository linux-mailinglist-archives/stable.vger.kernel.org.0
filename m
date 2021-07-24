Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248673D4563
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 08:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhGXGCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 02:02:32 -0400
Received: from out28-196.mail.aliyun.com ([115.124.28.196]:45053 "EHLO
        out28-196.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhGXGCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 02:02:32 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1627883|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0376676-0.000498982-0.961833;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.Kpjys0i_1627108981;
Received: from 192.168.88.130(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.Kpjys0i_1627108981)
          by smtp.aliyun-inc.com(10.147.43.95);
          Sat, 24 Jul 2021 14:43:02 +0800
Subject: Re: [PATCH 2/3] pinctrl: ingenic: Fix bias config for X2000(E)
To:     Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210717174836.14776-1-paul@crapouillou.net>
 <20210717174836.14776-2-paul@crapouillou.net>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <c699e0a3-aa97-e8d8-ddfb-154f6d9344ce@wanyeetech.com>
Date:   Sat, 24 Jul 2021 14:42:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210717174836.14776-2-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2021/7/18 上午1:48, Paul Cercueil wrote:
> The ingenic_set_bias() function's "bias" argument is not a
> "enum pin_config_param", so its value should not be compared against
> values of that enum.
>
> This should fix the bias config not working on the X2000(E) SoCs.
>
> Fixes: 943e0da15370 ("pinctrl: Ingenic: Add pinctrl driver for X2000.")
> Cc: <stable@vger.kernel.org> # v5.12
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>   drivers/pinctrl/pinctrl-ingenic.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)


Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com>


> diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
> index 126ca671c3cd..263498be8e31 100644
> --- a/drivers/pinctrl/pinctrl-ingenic.c
> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -3441,17 +3441,17 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
>   {
>   	if (jzpc->info->version >= ID_X2000) {
>   		switch (bias) {
> -		case PIN_CONFIG_BIAS_PULL_UP:
> +		case GPIO_PULL_UP:
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, true);
>   			break;
>   
> -		case PIN_CONFIG_BIAS_PULL_DOWN:
> +		case GPIO_PULL_DOWN:
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, true);
>   			break;
>   
> -		case PIN_CONFIG_BIAS_DISABLE:
> +		case GPIO_PULL_DIS:
>   		default:
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
>   			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
