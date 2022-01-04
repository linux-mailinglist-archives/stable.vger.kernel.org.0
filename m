Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49FA4847DC
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiADSau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiADSau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:30:50 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B56C061761;
        Tue,  4 Jan 2022 10:30:50 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d1so90047199ybh.6;
        Tue, 04 Jan 2022 10:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2F5+r2qnamm9pjKbIg5LSzIszJLSrq7m3cZxipSvKE=;
        b=TN4VxYGMzUD4RETNa7ai5hfByT38ysDMkdVKGpipj3PslatigszUQqkp+wGXCE0pfg
         7M1KG9oYak9KTXuv29hQ6nu3ExP1zSMUgtp7YK7yhnk0yt/gd6Chdl9FZZA9RVkwW6uZ
         fZjafMgDxKuebcBZt6mBVm3+ciJMr5b5d431DvuORL/zwWwFmJACOdU7qoxTATr+/qB8
         4HFnpuLt1KM8p3xTEHbkAq93B6EfDCqeX/YhIysJhVMP/DsvAzFHvAP3VoL3B3Nb+FTG
         85Z++aoFYbDzGR1Bqdp/PvAUmppBYfGxckyVKhLHLogTuVfLLIYkwb0Z/4hjvn4RRNch
         qOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2F5+r2qnamm9pjKbIg5LSzIszJLSrq7m3cZxipSvKE=;
        b=CuUexJWlJwkEhterJjV0qShUtm5mohhUaXWgad2CWqcBvZiqrO3AHJljcJaA4T0whV
         tIJA6MrkXyRCvfgkXrGD8CfdZo0ej84Iibt+T03qDiE+CE+KDBU57Jg1AOjHvRWIDX1K
         hWXhVURWygzuVsZF+8quDGzI2cv4mBJW8NMT345DsweR0CBz4q2CAeSvx+KKVlhabm1n
         R6NB0jRn+BsaeJp5nvlHr/oQxei9/+MKUg+OqMp92Oa4UyuC9a9TW1wlg0+Xxe8wcUne
         u3SKS1J6OwAlIg/J1F+iSZvM7vHM96hpjm3t6XZqPJf8ewnqulyGD3Te9XJNhrla/7Ce
         NYCw==
X-Gm-Message-State: AOAM533VLQSeKvQfjwdbOF4zwMKXXUmKeXhrSUOgng9BFGVyh1TQjwXP
        gAQmfPrlVe00KhA9PFnl3L2nAxrNrtk/C/BQOHc=
X-Google-Smtp-Source: ABdhPJytwf9sQ5H2BvcajHaGlNSUd7bQ3zAvzTUgoRNM+IeHg7B0G24tMzMJWdxaTvGZSl0ALzIUQHqYqdV/OlR6StQ=
X-Received: by 2002:a25:c794:: with SMTP id w142mr33506683ybe.690.1641321049153;
 Tue, 04 Jan 2022 10:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20211222142025.30364-1-johan@kernel.org> <20211222142025.30364-4-johan@kernel.org>
In-Reply-To: <20211222142025.30364-4-johan@kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 4 Jan 2022 18:30:23 +0000
Message-ID: <CA+V-a8vGkHnGABm=AiNjkvp3S-JU8qkqQZoX=-ZkK4njUSAv8w@mail.gmail.com>
Subject: Re: [PATCH 3/4] media: davinci: vpif: fix use-after-free on driver unbind
To:     Johan Hovold <johan@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

Thank you for the patch.

On Wed, Dec 22, 2021 at 2:20 PM Johan Hovold <johan@kernel.org> wrote:
>
> The driver allocates and registers two platform device structures during
> probe, but the devices were never deregistered on driver unbind.
>
> This results in a use-after-free on driver unbind as the device
> structures were allocated using devres and would be freed by driver
> core when remove() returns.
>
> Fix this by adding the missing deregistration calls to the remove()
> callback and failing probe on registration errors.
>
> Note that the platform device structures must be freed using a proper
> release callback to avoid leaking associated resources like device
> names.
>
> Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
> Cc: stable@vger.kernel.org      # 4.12
> Cc: Kevin Hilman <khilman@baylibre.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/media/platform/davinci/vpif.c | 97 ++++++++++++++++++++-------
>  1 file changed, 71 insertions(+), 26 deletions(-)
>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
Prabhakar

> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 1f5eacf48580..4a260f4ed236 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -41,6 +41,11 @@ MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
>  #define VPIF_CH2_MAX_MODES     15
>  #define VPIF_CH3_MAX_MODES     2
>
> +struct vpif_data {
> +       struct platform_device *capture;
> +       struct platform_device *display;
> +};
> +
>  DEFINE_SPINLOCK(vpif_lock);
>  EXPORT_SYMBOL_GPL(vpif_lock);
>
> @@ -423,17 +428,31 @@ int vpif_channel_getfid(u8 channel_id)
>  }
>  EXPORT_SYMBOL(vpif_channel_getfid);
>
> +static void vpif_pdev_release(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +
> +       kfree(pdev);
> +}
> +
>  static int vpif_probe(struct platform_device *pdev)
>  {
>         static struct resource *res_irq;
>         struct platform_device *pdev_capture, *pdev_display;
>         struct device_node *endpoint = NULL;
> +       struct vpif_data *data;
>         int ret;
>
>         vpif_base = devm_platform_ioremap_resource(pdev, 0);
>         if (IS_ERR(vpif_base))
>                 return PTR_ERR(vpif_base);
>
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, data);
> +
>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_get(&pdev->dev);
>
> @@ -461,49 +480,75 @@ static int vpif_probe(struct platform_device *pdev)
>                 goto err_put_rpm;
>         }
>
> -       pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
> -                                   GFP_KERNEL);
> -       if (pdev_capture) {
> -               pdev_capture->name = "vpif_capture";
> -               pdev_capture->id = -1;
> -               pdev_capture->resource = res_irq;
> -               pdev_capture->num_resources = 1;
> -               pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
> -               pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
> -               pdev_capture->dev.parent = &pdev->dev;
> -               platform_device_register(pdev_capture);
> -       } else {
> -               dev_warn(&pdev->dev, "Unable to allocate memory for pdev_capture.\n");
> +       pdev_capture = kzalloc(sizeof(*pdev_capture), GFP_KERNEL);
> +       if (!pdev_capture) {
> +               ret = -ENOMEM;
> +               goto err_put_rpm;
>         }
>
> -       pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
> -                                   GFP_KERNEL);
> -       if (pdev_display) {
> -               pdev_display->name = "vpif_display";
> -               pdev_display->id = -1;
> -               pdev_display->resource = res_irq;
> -               pdev_display->num_resources = 1;
> -               pdev_display->dev.dma_mask = pdev->dev.dma_mask;
> -               pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
> -               pdev_display->dev.parent = &pdev->dev;
> -               platform_device_register(pdev_display);
> -       } else {
> -               dev_warn(&pdev->dev, "Unable to allocate memory for pdev_display.\n");
> +       pdev_capture->name = "vpif_capture";
> +       pdev_capture->id = -1;
> +       pdev_capture->resource = res_irq;
> +       pdev_capture->num_resources = 1;
> +       pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
> +       pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
> +       pdev_capture->dev.parent = &pdev->dev;
> +       pdev_capture->dev.release = vpif_pdev_release;
> +
> +       ret = platform_device_register(pdev_capture);
> +       if (ret)
> +               goto err_put_pdev_capture;
> +
> +       pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
> +       if (!pdev_display) {
> +               ret = -ENOMEM;
> +               goto err_put_pdev_capture;
>         }
>
> +       pdev_display->name = "vpif_display";
> +       pdev_display->id = -1;
> +       pdev_display->resource = res_irq;
> +       pdev_display->num_resources = 1;
> +       pdev_display->dev.dma_mask = pdev->dev.dma_mask;
> +       pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
> +       pdev_display->dev.parent = &pdev->dev;
> +       pdev_display->dev.release = vpif_pdev_release;
> +
> +       ret = platform_device_register(pdev_display);
> +       if (ret)
> +               goto err_put_pdev_display;
> +
> +       data->capture = pdev_capture;
> +       data->display = pdev_display;
> +
>         return 0;
>
> +err_put_pdev_display:
> +       platform_device_put(pdev_display);
> +err_put_pdev_capture:
> +       platform_device_put(pdev_capture);
>  err_put_rpm:
>         pm_runtime_put(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
> +       kfree(data);
>
>         return ret;
>  }
>
>  static int vpif_remove(struct platform_device *pdev)
>  {
> +       struct vpif_data *data = platform_get_drvdata(pdev);
> +
> +       if (data->capture)
> +               platform_device_unregister(data->capture);
> +       if (data->display)
> +               platform_device_unregister(data->display);
> +
>         pm_runtime_put(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
> +
> +       kfree(data);
> +
>         return 0;
>  }
>
> --
> 2.32.0
>
