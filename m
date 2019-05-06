Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807B514616
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 10:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfEFIVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 04:21:41 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:46026 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfEFIVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 04:21:41 -0400
Received: by mail-ua1-f68.google.com with SMTP id o33so4325767uae.12;
        Mon, 06 May 2019 01:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S9nH2/USIL+iRP9MPRGrYGXOMekiKUf2TMy8HKrGO9M=;
        b=UmkW6A3vMKPdlQLG1SUllwXpusbPoWD9J/1Y9ETccVBn/vGpyGsy+dyJv7dn0puYG8
         cbH23D6UCvgL93GOanLGU6skr8E3n7nja5byu2XAlnlAg6/l3mp5xf0tZKVDTV7nmZy5
         v4X0xu8DLuGo2tszd1cR9j77l0R/SUu2LeLDOfo0yd4e+Kv1J4nKIPa1O3iIVI2GEfQe
         Rwb5PTrHc5GAsuI37NmI2650PojVUh7i/Zz8d7sp+jyWDOAlj3bqKTnVBN8z5/FPYv7s
         BlcUkFy0QOYHj8w6PMqJahzS9Ljla3k5wJhwSBG5FrEoUR5hZbVc7e+/HhArPFBbZOu3
         LPJg==
X-Gm-Message-State: APjAAAWfijWihe9lbo3VdgloQcZq5gOt0qkR4qI9lGxQ+lD6bPDqWO0+
        zadJN9Ujf50QrklrDnU/XRoNxzCnZ+RnsoEissY=
X-Google-Smtp-Source: APXvYqxqv+fTd1rbHutpVs13X+K+M5qGvWiddcVBn8JlEOm5/Dn/AUyXEdYY45zzfeEUqaRkut2w+Y+OOuVsebvtV54=
X-Received: by 2002:ab0:1646:: with SMTP id l6mr12236479uae.75.1557130900203;
 Mon, 06 May 2019 01:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190502143339.434882399@linuxfoundation.org> <20190502143346.636141727@linuxfoundation.org>
In-Reply-To: <20190502143346.636141727@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 6 May 2019 10:21:28 +0200
Message-ID: <CAMuHMdVQWLfBOCyXza0bwG5-4FJ5z2gLjpsPEj8FaQepd5_nMA@mail.gmail.com>
Subject: Re: [PATCH 5.0 100/101] leds: pca9532: fix a potential NULL pointer dereference
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 2, 2019 at 5:34 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> [ Upstream commit 0aab8e4df4702b31314a27ec4b0631dfad0fae0a ]
>
> In case of_match_device cannot find a match, return -EINVAL to avoid
> NULL pointer dereference.
>
> Fixes: fa4191a609f2 ("leds: pca9532: Add device tree support")
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>

> --- a/drivers/leds/leds-pca9532.c
> +++ b/drivers/leds/leds-pca9532.c
> @@ -513,6 +513,7 @@ static int pca9532_probe(struct i2c_client *client,
>         const struct i2c_device_id *id)
>  {
>         int devid;
> +       const struct of_device_id *of_id;
>         struct pca9532_data *data = i2c_get_clientdata(client);
>         struct pca9532_platform_data *pca9532_pdata =
>                         dev_get_platdata(&client->dev);
> @@ -528,8 +529,11 @@ static int pca9532_probe(struct i2c_client *client,
>                         dev_err(&client->dev, "no platform data\n");
>                         return -EINVAL;
>                 }
> -               devid = (int)(uintptr_t)of_match_device(
> -                       of_pca9532_leds_match, &client->dev)->data;
> +               of_id = of_match_device(of_pca9532_leds_match,
> +                               &client->dev);
> +               if (unlikely(!of_id))

This condition (1) can never be true, as of_pca9532_leds_match[]
populates the .data field of all entries, and (2) is already checked for
in pca9532_of_populate_pdata(), so pca9532_probe() would already
have aborted with -ENODEV before.

https://lore.kernel.org/lkml/CAMuHMdXELu2tcSB5C1yKUGft6sDGPAy997ApPzy17n0MssfyWA@mail.gmail.com/

So please stop backporting this to even more stable trees.
Thanks!

> +                       return -EINVAL;
> +               devid = (int)(uintptr_t) of_id->data;
>         } else {
>                 devid = id->driver_data;
>         }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
