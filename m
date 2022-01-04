Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1A484787
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiADSLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiADSLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:11:35 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC593C061784;
        Tue,  4 Jan 2022 10:11:35 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id p15so60070965ybk.10;
        Tue, 04 Jan 2022 10:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDjxJOHTwu52UjAT13U1oPRVxB66Qhtp1a0S6RDIgtw=;
        b=pR+/aDHumgms37I9W6niCPjlsTh8/Qzu9fJwd5zjLVxIKz67f3c7AXF2IzphnCHJzv
         UKP4zxVCspTn+JyfZZUOJVfrDTVE1dq+CPZWrznCRDRSF4En+CmAyKG3YV4/vPJINBQB
         1/j3z2KDTOPlZ9aEA8WhDcjjrfVJp4NUth41F+GuCY8Fv2f7VnhERM/fyY3+zxepeFl9
         9ZdWEYEDuWMRYkMTU+Kd6Dkp3oTbhLMwPXc8LFI02hzvN1HoOuTb7DpwNYpl3ju91qpm
         Sd8VEAGojgy1/VeaGjyZnH6ZP+vDruA9s4ByZEE2MijSrGs/+2UsRmMyIc4a0HetEJbO
         bzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDjxJOHTwu52UjAT13U1oPRVxB66Qhtp1a0S6RDIgtw=;
        b=j5wW8JCEn1UqXWvCHxI+3NUlDkqq5+8As4IFf9M4DpDPuuHtd1sw4Jy4LEWOcg8/k2
         VtXeLHCtD8u6wdNaRb4VaqeaU7P2SXtegcDaU+u2+uLeW9pMIMIxQR2WGcfouKTL0O8V
         wwkQD01OFylbJgNRCLGRVudM7kdQDWQWWxz22hg0kLIftivZ5RvZOEl1fE3AR6yfj0eF
         OUbucKv8esIj5fKONAXWr275fTWRB9SbmbrHqUpce4RzqYXbvF16sWThRtvm7OE/nr2+
         UNdSOonbj6WXeBr4SO2qAzIogHnjBF6qQnY8DtOdfN2v5OC5FYP6AI7WbeBwAM91zkCd
         yaqw==
X-Gm-Message-State: AOAM532jPOw7Vfg/2CYv3yjf9xNAj/BEbT/uDrSf3gzZN4BPvGiJ+wK0
        viYFtejECIxjedTRVVAa8Kvk62LiNa8vXjiBfLM=
X-Google-Smtp-Source: ABdhPJyIKCGaxPOaGgLHloiL4Xyerz+BXKXOhX1eomZTYiwdSrw2j33B+V4AyabGqfm9RAFUWKBKLxOlwyMFApq3nzc=
X-Received: by 2002:a25:e7cc:: with SMTP id e195mr52535370ybh.251.1641319894481;
 Tue, 04 Jan 2022 10:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20211222142025.30364-1-johan@kernel.org> <20211222142025.30364-3-johan@kernel.org>
In-Reply-To: <20211222142025.30364-3-johan@kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 4 Jan 2022 18:11:08 +0000
Message-ID: <CA+V-a8thJtWjL+2-TNdbZTe=hKCVYz2vwAL-uCNeW+-TmVKPVg@mail.gmail.com>
Subject: Re: [PATCH 2/4] media: davinci: vpif: fix unbalanced runtime PM enable
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
> Make sure to disable runtime PM before returning on probe errors.
>
> Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
> Cc: stable@vger.kernel.org      # 4.12: 4024d6f601e3c
> Cc: Kevin Hilman <khilman@baylibre.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/media/platform/davinci/vpif.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 9752a5ec36f7..1f5eacf48580 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -428,6 +428,7 @@ static int vpif_probe(struct platform_device *pdev)
>         static struct resource *res_irq;
>         struct platform_device *pdev_capture, *pdev_display;
>         struct device_node *endpoint = NULL;
> +       int ret;
>
>         vpif_base = devm_platform_ioremap_resource(pdev, 0);
>         if (IS_ERR(vpif_base))
> @@ -456,8 +457,8 @@ static int vpif_probe(struct platform_device *pdev)
>         res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>         if (!res_irq) {
>                 dev_warn(&pdev->dev, "Missing IRQ resource.\n");
> -               pm_runtime_put(&pdev->dev);
Maybe just add pm_runtime_disable(&pdev->dev); here, rest diff won't
be required.

Cheers,
Prabhakar

> -               return -EINVAL;
> +               ret = -EINVAL;
> +               goto err_put_rpm;
>         }
>
>         pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
> @@ -491,6 +492,12 @@ static int vpif_probe(struct platform_device *pdev)
>         }
>
>         return 0;
> +
> +err_put_rpm:
> +       pm_runtime_put(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +
> +       return ret;
>  }
>
>  static int vpif_remove(struct platform_device *pdev)
> --
> 2.32.0
>
