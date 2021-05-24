Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4ED38E86F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhEXONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhEXONL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 10:13:11 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720C0C06134B
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:11:40 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id f12so33790820ljp.2
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxFVfCbuSBreuDO3mJ9eqEuh3taUoOdaPE1ozDP14J0=;
        b=yFb9lCsRcwNUEwCnHxdHHbAwBCHX9AFWkTVDra9cpGbysaCf4lD0N0v1KI9YmXnmkc
         UL1b/E0rJbeMUg+cBLsm2sO/o1sP/fPhlhY0QUKcGymY5lUiWBGstJbfz/HRk3r0NvKp
         7f/SL0rEv7h7X3Gr1DZPKANbWkyzBM5l4rZ3ps9LXF54Hqc4DNsuQQfmIjPRin/l1RJI
         hK9+WeRKiu1a74CYuhPZV6QeUjd+VyLoEDUolO4nyT6nLBWDwLpxilJXFmttGANtgl14
         3dfEu/zakO0G/T186pE5NfTFWsovOlnVfMlDnlfCJ/DPNbbYqi1CNsy4b+aMCsWCnW9M
         FtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxFVfCbuSBreuDO3mJ9eqEuh3taUoOdaPE1ozDP14J0=;
        b=B72DFFyOH0qs+vH+dCcgZHAWr+oR3/80t5LPd2zzEPjB6PDd2lRnyNkNtWQJB4aLH8
         0klSHSmS+VUjhTa8vAjSpH+eQj3pdr+rN6mfqCnlwZouPRfiq00Kq3qsfvqcL47pTb6q
         zDeCVsZhoPY80E0alYf3iO1eFz9pwoZv/qH6IXT48Jzu/fnMN/eFhnAl2JNJHDZs1xf1
         Wrh8bUZUbcv/JK2bxh4zb64ayow8RD2+6vIAHpa/mJLdms5v1KZIO7bMlxK8QfbcEGfN
         dvhNpfr/0jdcN4u8zcTslxGTYBwPkokGP0FAow14mo12RK4BSfAyg4W6/kfKJfj6/fnw
         e/HQ==
X-Gm-Message-State: AOAM533oX3Xinn8mqIUOOKE2teherYdn4ZhYi5FoFEu2gfAs6Rj2vwNu
        eGLz0H4fl1qutXJ7kEr4oOXFxnd1Op32tP4Kxfadig==
X-Google-Smtp-Source: ABdhPJxkYrdw0tkQ65uF7FdwPLjrWDJyTMHDLIz8rx7KUQwRWOSy8sPwddeleLL4Jr0PCmVZUsojIIK/8+iy0FNksL0=
X-Received: by 2002:a05:651c:14c:: with SMTP id c12mr11360162ljd.72.1621865498847;
 Mon, 24 May 2021 07:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210521133026.17296-1-johan@kernel.org>
In-Reply-To: <20210521133026.17296-1-johan@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 24 May 2021 16:11:00 +0200
Message-ID: <CAPDyKFpw-ydfWXM0+Lz3KHq2X3f2S_47XA-43Rw4e6ZgOrobWw@mail.gmail.com>
Subject: Re: [PATCH] mmc: vub3000: fix control-request direction
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 May 2021 at 15:30, Johan Hovold <johan@kernel.org> wrote:
>
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
>
> Fix the SET_ROM_WAIT_STATES request which erroneously used
> usb_rcvctrlpipe().
>
> Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
> Cc: stable@vger.kernel.org      # 3.0
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/vub300.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
> index 739cf63ef6e2..4950d10d3a19 100644
> --- a/drivers/mmc/host/vub300.c
> +++ b/drivers/mmc/host/vub300.c
> @@ -2279,7 +2279,7 @@ static int vub300_probe(struct usb_interface *interface,
>         if (retval < 0)
>                 goto error5;
>         retval =
> -               usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
> +               usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
>                                 SET_ROM_WAIT_STATES,
>                                 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                                 firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
> --
> 2.26.3
>
