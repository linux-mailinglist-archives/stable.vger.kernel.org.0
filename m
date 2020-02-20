Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD601666FA
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 20:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgBTTPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 14:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgBTTPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 14:15:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82A6206E2;
        Thu, 20 Feb 2020 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582226116;
        bh=wuYgJdYmKiQd4r+UyQmCOa68AWBzeQV+TJZRUaxsiHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vamKU3a5baew9BfJzvbhFHb8QbsMKNRkpgWRf7kyQ3tUHggXWr7moIvwnPJDDNIdG
         mQtRAN6lBR8NNjgnZ/h18FTHAEsZWh26AEH7su4F4HrK13Qf2Rt+/3dzuRQl7oTS4f
         GM5YLQ5ezaSdf4JarVAEGbNUi5DQq0kj0xd/c+Kg=
Date:   Thu, 20 Feb 2020 20:15:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Orson Zhai <orson.unisoc@gmail.com>
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        John Stultz <john.stultz@linaro.org>, mingmin.ling@unisoc.com,
        orsonzhai@gmail.com, jingchao.ye@unisoc.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "PM / devfreq: Modify the device name as
 devfreq(X) for sysfs"
Message-ID: <20200220191513.GA3450796@kroah.com>
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
> This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
> 
> The name changing as devfreq(X) breaks some user space applications,
> such as Android HAL from Unisoc and Hikey [1].
> The device name will be changed unexpectly after every boot depending
> on module init sequence. It will make trouble to setup some system
> configuration like selinux for Android.
> 
> So we'd like to revert it back to old naming rule before any better
> way being found.
> 
> [1] https://lkml.org/lkml/2018/5/8/1042
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
> 
> ---
>  drivers/devfreq/devfreq.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index cceee8b..7dcf209 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  {
>  	struct devfreq *devfreq;
>  	struct devfreq_governor *governor;
> -	static atomic_t devfreq_no = ATOMIC_INIT(-1);
>  	int err = 0;
>  
>  	if (!dev || !profile || !governor_name) {
> @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
>  	atomic_set(&devfreq->suspend_count, 0);
>  
> -	dev_set_name(&devfreq->dev, "devfreq%d",
> -				atomic_inc_return(&devfreq_no));
> +	dev_set_name(&devfreq->dev, "%s", dev_name(dev));
>  	err = device_register(&devfreq->dev);
>  	if (err) {
>  		mutex_unlock(&devfreq->lock);
> -- 
> 2.7.4
> 

Thanks for this, I agree, this needs to get back to the way things were
as it seems to break too many existing systems as-is.

I'll queue this up in my tree now, thanks.

greg k-h
