Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E477715EE6F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgBNRkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:40:22 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56231 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730732AbgBNRkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 12:40:22 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1j2ewq-0003Dk-PF; Fri, 14 Feb 2020 18:40:16 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1j2ewo-0000El-ND; Fri, 14 Feb 2020 18:40:14 +0100
Date:   Fri, 14 Feb 2020 18:40:14 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yu kuai <yukuai3@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 418/542] pwm: Remove set but not set variable
 'pwm'
Message-ID: <20200214174014.lfnhsl6d7nyfkfbm@pengutronix.de>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-418-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214154854.6746-418-sashal@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

On Fri, Feb 14, 2020 at 10:46:50AM -0500, Sasha Levin wrote:
> From: yu kuai <yukuai3@huawei.com>
> 
> [ Upstream commit 9871abffc81048e20f02e15d6aa4558a44ad53ea ]
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> 	drivers/pwm/pwm-pca9685.c: In function ‘pca9685_pwm_gpio_free’:
> 	drivers/pwm/pwm-pca9685.c:162:21: warning: variable ‘pwm’ set but not used [-Wunused-but-set-variable]
> 
> It is never used, and so can be removed. In that case, hold and release
> the lock 'pca->lock' can be removed since nothing will be done between
> them.
> 
> Fixes: e926b12c611c ("pwm: Clear chip_data in pwm_put()")
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pwm/pwm-pca9685.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
> index 168684b02ebce..b07bdca3d510d 100644
> --- a/drivers/pwm/pwm-pca9685.c
> +++ b/drivers/pwm/pwm-pca9685.c
> @@ -159,13 +159,9 @@ static void pca9685_pwm_gpio_set(struct gpio_chip *gpio, unsigned int offset,
>  static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
>  {
>  	struct pca9685 *pca = gpiochip_get_data(gpio);
> -	struct pwm_device *pwm;
>  
>  	pca9685_pwm_gpio_set(gpio, offset, 0);
>  	pm_runtime_put(pca->chip.dev);
> -	mutex_lock(&pca->lock);
> -	pwm = &pca->chip.pwms[offset];
> -	mutex_unlock(&pca->lock);

Even though I bet this change won't introduce a regression, it only
fixes a harmless warning. So I wonder if it objectively qualifies to be
applied for stable.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
