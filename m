Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D0624EDC
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiKKAUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiKKAUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:20:37 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C55242F42
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:20:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso6358758pjg.5
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rgBWPJbei+FelwuPjDXn2dCEJUPh8F3/6uN4AZp70/o=;
        b=ETy1FVWPcrAfX01GsufjlOq61UfvWACkc/LKVL66MjfHjAL8Mvu607O5U9QmA5KaRJ
         4iVw+0ZaYGBQeY246vJjOs+L0vrAMy1jViTZVtjzudQJ11osmTlfqAq8yJKRbW1zk8tI
         IDdPCv9LvmwB/SAiGsanFDk7hpN2aeztYysA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgBWPJbei+FelwuPjDXn2dCEJUPh8F3/6uN4AZp70/o=;
        b=F1mbBJu4nKG7+GRZ4JDAmqdIgvnQIGYWKFzCohfNCAQXxZsy2XaFAzDapSIntzkLEt
         1Si2v7ifTpaQEOWbSJiA02Yv1+5dZTv8x9CoU9MQCJnJdU9rfukDeDhj2SV7To3K1MwY
         Db5KI9nCQ5tCQO6xZ+eO51fttUWN4pZFrc1FD9lsbYzRVza02oUIoKBQPrbhO3W87DMX
         Uc6ejWLHyEr9aWL7UAi7fgnHumM2nYk5RqZul5e66jzCXQLVHBfNA6NrEG9xAjrXZRak
         aSyLUSZ0l+nO0dT0YAhx5MsiBa++ooRpe4VvCyQIwh22/tMJ4+ELF0HZc++s2kASGdht
         v7Hg==
X-Gm-Message-State: ACrzQf1HFGiakK1i3dpiGpqNzm7i/a3rJszvmvPs8hI1rLgLxkkVy5sL
        KQOn0VljWsDzUn4/LoiDdehrHnKxhkf4Ew==
X-Google-Smtp-Source: AMsMyM5zP6O0SX+e+k0GvFD3LtwU2AycxZU1aQrkd6tKJKqtjtOtQO0RNcPyMz97EXUWVCPAzOm6Rg==
X-Received: by 2002:a17:90a:194b:b0:212:e521:7cbd with SMTP id 11-20020a17090a194b00b00212e5217cbdmr2767295pjh.230.1668126035895;
        Thu, 10 Nov 2022 16:20:35 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:729a:7662:547f:f4a3])
        by smtp.gmail.com with ESMTPSA id u14-20020a170903124e00b001869394a372sm259473plh.201.2022.11.10.16.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 16:20:35 -0800 (PST)
Date:   Fri, 11 Nov 2022 09:20:32 +0900
From:   Hidenori Kobayashi <hidenorik@chromium.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Wolfram Sang <wsa@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
Message-ID: <20221111002032.b7j3cizpe5nbj6id@google.com>
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On Thu, Nov 10, 2022 at 05:20:39PM +0100, Ricardo Ribalda wrote:
> A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> power off a device that it has not powered on previously.
> 
> For devices operating in "full_power" mode, the first call to
> `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> will be turned on with `dev_pm_domain_attach`.
> 
> If probe fails or the device is removed the second call to
> `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> will not be turned off. This is, it will be left in a different power
> state. Lets fix it.
> 
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

It's much easier to read now. Thanks!

Reviewed-by: Hidenori Kobayashi <hidenorik@chromium.org>

> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index b4edf10e8fd0..6f4974c76404 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
>  {
>  	struct i2c_client	*client = i2c_verify_client(dev);
>  	struct i2c_driver	*driver;
> +	bool do_power_on;
>  	int status;
>  
>  	if (!client)
> @@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
>  	if (status < 0)
>  		goto err_clear_wakeup_irq;
>  
> -	status = dev_pm_domain_attach(&client->dev,
> -				      !i2c_acpi_waive_d0_probe(dev));
> +	do_power_on = !i2c_acpi_waive_d0_probe(dev);
> +	status = dev_pm_domain_attach(&client->dev, do_power_on);
>  	if (status)
>  		goto err_clear_wakeup_irq;
>  
> @@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
>  	if (status)
>  		goto err_release_driver_resources;
>  
> +	client->power_off_on_remove = do_power_on;
> +
>  	return 0;
>  
>  err_release_driver_resources:
>  	devres_release_group(&client->dev, client->devres_group_id);
>  err_detach_pm_domain:
> -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> +	dev_pm_domain_detach(&client->dev, do_power_on);
>  err_clear_wakeup_irq:
>  	dev_pm_clear_wake_irq(&client->dev);
>  	device_init_wakeup(&client->dev, false);
> @@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
>  
>  	devres_release_group(&client->dev, client->devres_group_id);
>  
> -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> +	dev_pm_domain_detach(&client->dev, client->power_off_on_remove);
>  
>  	dev_pm_clear_wake_irq(&client->dev);
>  	device_init_wakeup(&client->dev, false);
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index f7c49bbdb8a1..eba83bc5459e 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -326,6 +326,8 @@ struct i2c_driver {
>   *	calls it to pass on slave events to the slave driver.
>   * @devres_group_id: id of the devres group that will be created for resources
>   *	acquired when probing this device.
> + * @power_off_on_remove: Record if we have turned on the device before probing
> + *	so we can turn off the device at removal.
>   *
>   * An i2c_client identifies a single device (i.e. chip) connected to an
>   * i2c bus. The behaviour exposed to Linux is defined by the driver
> @@ -355,6 +357,8 @@ struct i2c_client {
>  	i2c_slave_cb_t slave_cb;	/* callback for slave mode	*/
>  #endif
>  	void *devres_group_id;		/* ID of probe devres group	*/
> +	bool power_off_on_remove;	/* if device needs to be turned	*/
> +					/* off by framework at removal	*/
>  };
>  #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
>  
> 
> -- 
> b4 0.11.0-dev-d93f8
> 
