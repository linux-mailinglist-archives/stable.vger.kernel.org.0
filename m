Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997486448C
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfGJJoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 05:44:08 -0400
Received: from anchovy3.45ru.net.au ([203.30.46.155]:41377 "EHLO
        anchovy3.45ru.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJJoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 05:44:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 05:44:07 EDT
Received: (qmail 20338 invoked by uid 5089); 10 Jul 2019 09:37:26 -0000
Received: by simscan 1.2.0 ppid: 20261, pid: 20262, t: 0.0524s
         scanners: regex: 1.2.0 attach: 1.2.0 clamav: 0.88.3/m:40/d:1950
Received: from unknown (HELO ?192.168.0.128?) (preid@electromag.com.au@203.59.235.95)
  by anchovy2.45ru.net.au with ESMTPA; 10 Jul 2019 09:37:25 -0000
Subject: Re: [PATCH 1/2] gpio: em: remove the gpiochip before removing the irq
 domain
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
References: <20190710090852.9239-1-brgl@bgdev.pl>
From:   Phil Reid <preid@electromag.com.au>
Message-ID: <510f14c9-fc3b-734c-53ff-cbf4a7579e32@electromag.com.au>
Date:   Wed, 10 Jul 2019 17:37:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710090852.9239-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

G'day Bartosz,

One comment below

On 10/07/2019 17:08, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> In commit 8764c4ca5049 ("gpio: em: use the managed version of
> gpiochip_add_data()") we implicitly altered the ordering of resource
> freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
> internally, we now can potentially use the irq_domain after it was
> destroyed in the remove() callback (as devm resources are freed after
> remove() has returned).
> 
> Use devm_add_action() to keep the ordering right and entirely kill
> the remove() callback in the driver.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/gpio/gpio-em.c | 35 +++++++++++++++++------------------
>   1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
> index b6af705a4e5f..c88028ac66f2 100644
> --- a/drivers/gpio/gpio-em.c
> +++ b/drivers/gpio/gpio-em.c
> @@ -259,6 +259,13 @@ static const struct irq_domain_ops em_gio_irq_domain_ops = {
>   	.xlate	= irq_domain_xlate_twocell,
>   };
>   
> +static void em_gio_irq_domain_remove(void *data)
> +{
> +	struct irq_domain *domain = data;
> +
> +	irq_domain_remove(domain);
> +}
> +
>   static int em_gio_probe(struct platform_device *pdev)
>   {
>   	struct em_gio_priv *p;
> @@ -333,39 +340,32 @@ static int em_gio_probe(struct platform_device *pdev)
>   		return -ENXIO;
>   	}
>   
> +	ret = devm_add_action(&pdev->dev,
> +			      em_gio_irq_domain_remove, p->irq_domain);

Could devm_add_action_or_reset be used?

> +	if (ret) {
> +		irq_domain_remove(p->irq_domain);
> +		return ret;
> +	}
> +
>   	if (devm_request_irq(&pdev->dev, irq[0]->start,
>   			     em_gio_irq_handler, 0, name, p)) {
>   		dev_err(&pdev->dev, "failed to request low IRQ\n");
> -		ret = -ENOENT;
> -		goto err1;
> +		return -ENOENT;
>   	}
>   
>   	if (devm_request_irq(&pdev->dev, irq[1]->start,
>   			     em_gio_irq_handler, 0, name, p)) {
>   		dev_err(&pdev->dev, "failed to request high IRQ\n");
> -		ret = -ENOENT;
> -		goto err1;
> +		return -ENOENT;
>   	}
>   
>   	ret = devm_gpiochip_add_data(&pdev->dev, gpio_chip, p);
>   	if (ret) {
>   		dev_err(&pdev->dev, "failed to add GPIO controller\n");
> -		goto err1;
> +		return ret;
>   	}
>   
>   	return 0;
> -
> -err1:
> -	irq_domain_remove(p->irq_domain);
> -	return ret;
> -}
> -
> -static int em_gio_remove(struct platform_device *pdev)
> -{
> -	struct em_gio_priv *p = platform_get_drvdata(pdev);
> -
> -	irq_domain_remove(p->irq_domain);
> -	return 0;
>   }
>   
>   static const struct of_device_id em_gio_dt_ids[] = {
> @@ -376,7 +376,6 @@ MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
>   
>   static struct platform_driver em_gio_device_driver = {
>   	.probe		= em_gio_probe,
> -	.remove		= em_gio_remove,
>   	.driver		= {
>   		.name	= "em_gio",
>   		.of_match_table = em_gio_dt_ids,
> 


-- 
Regards
Phil Reid

