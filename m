Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB91F205249
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 14:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgFWMVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 08:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgFWMVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 08:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDA020724;
        Tue, 23 Jun 2020 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592914876;
        bh=YYp3JubUqdWQPjC+CAvg39kVMSQhyok0576NIomUHF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hLt3v5w0V6/8jaopjj/3okLHjPn0PzrL3LzE+Re5/3cvCI8WVlpvxyloqTdQbBRNh
         ykTKxCQVKrev6Fd+StHDFR7wymXQAvhCkLOEhm+VB5hKx5wqL94vTDc3lY8+p6NNBj
         LDkY0IqidJlTgF7nNBvHuFMQQKbCUmxYDKAVxc+U=
Date:   Tue, 23 Jun 2020 14:21:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        stable@vger.kernel.org, thierry.reding@gmail.com
Subject: Re: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in
 calculation of duty cycle" failed to apply to 5.4-stable tree
Message-ID: <20200623122110.GA2332056@kroah.com>
References: <1592574307840@kroah.com>
 <20200623003943.GQ1931@sasha-vm>
 <20200623072534.pw4t4bi3klz57wce@taurus.defre.kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623072534.pw4t4bi3klz57wce@taurus.defre.kleine-koenig.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:25:34AM +0200, Uwe Kleine-König wrote:
> On Mon, Jun 22, 2020 at 08:39:43PM -0400, Sasha Levin wrote:
> > On Fri, Jun 19, 2020 at 03:45:07PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> 
> See below for a backport.
> 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From 9017dc4fbd59c09463019ce494cfe36d654495a8 Mon Sep 17 00:00:00 2001
> > > From: Paul Cercueil <paul@crapouillou.net>
> > > Date: Wed, 27 May 2020 13:52:23 +0200
> > > Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > > 
> > > Calculating the hardware value for the duty from the hardware value of
> > > the period resulted in a precision loss versus calculating it from the
> > > clock rate directly.
> > > 
> > > (Also remove a cast that doesn't really need to be here)
> > > 
> > > Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
> > > Cc: <stable@vger.kernel.org>
> > > Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> > 
> > I suspect that the fixes tag should have been pointing to ce1f9cece057
> > ("pwm: jz4740: Use clocks from TCU driver") instead.
> 
> No, f6b8a5700057 is right. The cast that was dropped isn't there, but
> the suboptimal calculation is.
> 
> The backport on top of 5.4.y looks as follows:
> 
> From b39d3d4c6ba4b7ba8b97a0f7e650924920e4d95c Mon Sep 17 00:00:00 2001
> From: Paul Cercueil <paul@crapouillou.net>
> Date: Wed, 27 May 2020 13:52:23 +0200
> Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> commit 9017dc4fbd59c09463019ce494cfe36d654495a8 upstream.
> 
> Calculating the hardware value for the duty from the hardware value of
> the period resulted in a precision loss versus calculating it from the
> clock rate directly.
> 
> Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> [ukl: backport to v5.4.y and adapt commit log accordingly]
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/pwm/pwm-jz4740.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> index 9d78cc21cb12..d0f5c69930d0 100644
> --- a/drivers/pwm/pwm-jz4740.c
> +++ b/drivers/pwm/pwm-jz4740.c
> @@ -108,8 +108,8 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
>  	if (prescaler == 6)
>  		return -EINVAL;
>  
> -	tmp = (unsigned long long)period * state->duty_cycle;
> -	do_div(tmp, state->period);
> +	tmp = (unsigned long long)rate * state->duty_cycle;
> +	do_div(tmp, NSEC_PER_SEC);
>  	duty = period - tmp;
>  
>  	if (duty >= period)
> 

Thanks, now queued up.

greg k-h
