Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86EF815F91F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgBNVzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730578AbgBNVyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:31 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648D32081E;
        Fri, 14 Feb 2020 21:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717270;
        bh=KC2EqCX36rIaa4NQzM328X7fLfPVUdGEtFfLUuvTpbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BW+jrXjButL3uDsrITGfSweEsGLI98mjkB4OM1FQXUSDM3aCqWYAq0SBqTkJW/MJG
         0gu6XycEZYffr55KhFzmj+dhPoEi3A+VsBhG4Dm0sc9BTfpC1n8tdc4GX8ul13Jd8k
         AIejd/6ZF/UKNaL4U0pDDpoWOIzaMQYMul/eXRl4=
Date:   Fri, 14 Feb 2020 16:46:00 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, yu kuai <yukuai3@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 418/542] pwm: Remove set but not set variable
 'pwm'
Message-ID: <20200214214600.GB4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-418-sashal@kernel.org>
 <20200214174014.lfnhsl6d7nyfkfbm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214174014.lfnhsl6d7nyfkfbm@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 06:40:14PM +0100, Uwe Kleine-König wrote:
> Hello Sasha,
> 
> On Fri, Feb 14, 2020 at 10:46:50AM -0500, Sasha Levin wrote:
> > From: yu kuai <yukuai3@huawei.com>
> > 
> > [ Upstream commit 9871abffc81048e20f02e15d6aa4558a44ad53ea ]
> > 
> > Fixes gcc '-Wunused-but-set-variable' warning:
> > 
> > 	drivers/pwm/pwm-pca9685.c: In function ‘pca9685_pwm_gpio_free’:
> > 	drivers/pwm/pwm-pca9685.c:162:21: warning: variable ‘pwm’ set but not used [-Wunused-but-set-variable]
> > 
> > It is never used, and so can be removed. In that case, hold and release
> > the lock 'pca->lock' can be removed since nothing will be done between
> > them.
> > 
> > Fixes: e926b12c611c ("pwm: Clear chip_data in pwm_put()")
> > Signed-off-by: yu kuai <yukuai3@huawei.com>
> > Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/pwm/pwm-pca9685.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
> > index 168684b02ebce..b07bdca3d510d 100644
> > --- a/drivers/pwm/pwm-pca9685.c
> > +++ b/drivers/pwm/pwm-pca9685.c
> > @@ -159,13 +159,9 @@ static void pca9685_pwm_gpio_set(struct gpio_chip *gpio, unsigned int offset,
> >  static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
> >  {
> >  	struct pca9685 *pca = gpiochip_get_data(gpio);
> > -	struct pwm_device *pwm;
> >  
> >  	pca9685_pwm_gpio_set(gpio, offset, 0);
> >  	pm_runtime_put(pca->chip.dev);
> > -	mutex_lock(&pca->lock);
> > -	pwm = &pca->chip.pwms[offset];
> > -	mutex_unlock(&pca->lock);
> 
> Even though I bet this change won't introduce a regression, it only
> fixes a harmless warning. So I wonder if it objectively qualifies to be
> applied for stable.

See my response to another one of these types of patches.  In order
words, I agree, these aren't needed unless they are prereqs for other
real fixes.

thanks,

greg k-h
