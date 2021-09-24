Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770644177E6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347148AbhIXPhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 11:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347147AbhIXPhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 11:37:16 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B17C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 08:35:43 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d21so28598399wra.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 08:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:content-transfer-encoding:date:message-id:cc:subject
         :from:to:references:in-reply-to;
        bh=JVNhvrxzYFDZ7bBWgidXT5nFQAi4+QcAVOQkD/BLu8Q=;
        b=KBpksAn/c/fKqCnWM5HbxfqSVuKwc0GLZzClgKXK6BT8gs9RHzxpdZ5VyBCUF3IrnH
         DGQxYa5P4fF6B3glAOPyRMBcaAPmI4p3a5koh++FtfNkrHodh55tL8sFLkaYjnmwdPjH
         xkiiZT4dQEF0zkuLo9LoHwvDNA/Db0qfRKp38KykP/3J7l5qrmiX/Wgyim0AVhAbMi/I
         ZxjAyMXEYMbihcXJCQ92AI3o79o5vGS+Py4cqpdVmB8yvBSsc5f0VcmWOaVd0SRoVdtF
         ADrhE/o/ufQGY7xrJs67CDDPytEyKjjitnnqrnOxxHNHXK3Wigjflny6uPBg2lXdUhku
         7GaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date
         :message-id:cc:subject:from:to:references:in-reply-to;
        bh=JVNhvrxzYFDZ7bBWgidXT5nFQAi4+QcAVOQkD/BLu8Q=;
        b=5SvWIr7CDpbiekcBk9G58dodRSYX+xsXMcqBki8x/gkpflf5BsE249mPF5zuSW2T0d
         xwI4S3Y7T0gulIUvyFMRnMH4ggNZBvuH7ma+IVXILU53XU8snHZ012QdTE1qKe06+k7p
         k+rBi9651z3cAWthh1HCjLkJ3Gy36e5yWxAHhcOSo+xXv8CkaTDtWQv9j0RWYx2+mmfQ
         KLyMVdN1V82ohKLYgQ7QfkIv6NsgL+IUFaI3JvUNiV9FUAUAne03piF3gnjGi5pIbwaJ
         iv9ft10Bx7OvuROs2cNW3CeYd7romIPWukM2U+tASiIelsbvG45uf7ZmeCsGHM3YmAu4
         iY9Q==
X-Gm-Message-State: AOAM532evFTKI3gW3LdjUPdzZiJqexLVK80RCYl1FRVPa1YWFd5SDCHq
        A9rkfrtarOuQRNESr2iJ4D2rwZWyY4a/wg==
X-Google-Smtp-Source: ABdhPJwTqF58DdSfpFVMHVGTH4JtU7e3HSshYC2w/C0XeJGXmO6mpX+jVbhWJYUtvBzMi298G9o+TQ==
X-Received: by 2002:a05:600c:b44:: with SMTP id k4mr754510wmr.44.1632497742032;
        Fri, 24 Sep 2021 08:35:42 -0700 (PDT)
Received: from localhost (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id d2sm8227048wrc.32.2021.09.24.08.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 08:35:41 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 24 Sep 2021 16:35:40 +0100
Message-Id: <CEI85GUCGPFO.2GIJLZMWZCXBJ@arch-thunder>
Subject: Re: [PATCH 2/3] usb: isp1760: do not sleep in field register poll
From:   "Rui Miguel Silva" <rui.silva@linaro.org>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
References: <20210727100516.4190681-1-rui.silva@linaro.org>
 <20210727100516.4190681-3-rui.silva@linaro.org>
In-Reply-To: <20210727100516.4190681-3-rui.silva@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
forgot to ask you, can you please merge this one to stable #5.14.y?
At the time I was not sure if it was getting in final 5.14 or not.

It applies clean on top of 5.14.7.
And without it, it triggers BUG sleep in atomic checks.

upstream commit:
41f673183862a1 usb: isp1760: do not sleep in field register poll
https://lore.kernel.org/r/20210727100516.4190681-3-rui.silva@linaro.org

fixes tag:
Fixes: 1da9e1c06873 ("usb: isp1760: move to regmap for register access")

Thanks in advance,
Cheers,
     Rui

On Tue Jul 27, 2021 at 11:05 AM WEST, Rui Miguel Silva wrote:

---- 8< ----------------------------------------------

> When polling for a setup or clear of a register field we were sleeping
> in atomic context but using a very tight sleep interval.
>
> Since the use cases for this poll mechanism are only in setup and
> stop paths, and in practice this poll is not used most of the times
> but needs to be there to comply to hardware setup times, remove the
> sleep time and make the poll loop tighter.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/usb/isp1760/isp1760-hcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/isp1760/isp1760-hcd.c b/drivers/usb/isp1760/isp1=
760-hcd.c
> index a745c4c2b773..a018394d54f8 100644
> --- a/drivers/usb/isp1760/isp1760-hcd.c
> +++ b/drivers/usb/isp1760/isp1760-hcd.c
> @@ -250,7 +250,7 @@ static int isp1760_hcd_set_and_wait(struct usb_hcd *h=
cd, u32 field,
>  	isp1760_hcd_set(hcd, field);
> =20
>  	return regmap_field_read_poll_timeout(priv->fields[field], val,
> -					      val, 10, timeout_us);
> +					      val, 0, timeout_us);
>  }
> =20
>  static int isp1760_hcd_set_and_wait_swap(struct usb_hcd *hcd, u32 field,
> @@ -262,7 +262,7 @@ static int isp1760_hcd_set_and_wait_swap(struct usb_h=
cd *hcd, u32 field,
>  	isp1760_hcd_set(hcd, field);
> =20
>  	return regmap_field_read_poll_timeout(priv->fields[field], val,
> -					      !val, 10, timeout_us);
> +					      !val, 0, timeout_us);
>  }
> =20
>  static int isp1760_hcd_clear_and_wait(struct usb_hcd *hcd, u32 field,
> @@ -274,7 +274,7 @@ static int isp1760_hcd_clear_and_wait(struct usb_hcd =
*hcd, u32 field,
>  	isp1760_hcd_clear(hcd, field);
> =20
>  	return regmap_field_read_poll_timeout(priv->fields[field], val,
> -					      !val, 10, timeout_us);
> +					      !val, 0, timeout_us);
>  }
> =20
>  static bool isp1760_hcd_is_set(struct usb_hcd *hcd, u32 field)
> --=20
> 2.32.0



