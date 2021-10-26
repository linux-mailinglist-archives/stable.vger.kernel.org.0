Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63B043B5D5
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 17:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhJZPnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 11:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbhJZPnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 11:43:13 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D199C061243
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 08:40:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x192so19843247lff.12
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 08:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1JXoWXHtBWdFbfIWUv0KF+B9dMJXWd2f8ajP40zMzQI=;
        b=N4tHnrxwkxS4Sc5sl/f/0SEe3Pp4vVuZ6s/k7hmHGNL551PiE4wHKyW4zy0hyGhhxo
         7QfTutXPaLHG3wKzcERDrA9JFL+LDQ8KHVTTun06JGw0CAdG5AZPK0D3UjLdly4KSPNc
         KWHJEfJnAs2hYsXMBgE+/71CwyuMx/CKc24GcHVFfJG51QRSSpnFej+iLnMXD/7XvmQ3
         P+Vqrn/17Y4lLbyi5M9Rv8yShy+sOIfniIOwk8H5H9RO0uj1/i72pA9LSazmfilg9eXz
         S9yqfJaDxOHLYR6QYmA1/9lFih3SMGBoe/cEQ/oa8Z3tybZPv+BQdgMCxYkBjoBrYh84
         sqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1JXoWXHtBWdFbfIWUv0KF+B9dMJXWd2f8ajP40zMzQI=;
        b=SDj217E62LHSr4TmgPr8BdBUmyPFmyHvF4hStyhCPSnQDAJQ57pDTmG/oGyH0kfBU4
         lqnhidi0bta7CcgXgBFQBoRTFdFPjDIM6NBKObMF9nFvWhXa8PNk/CI5M1aT+7WisrQa
         DHaB3Le5H9J30livK71DuI4ea0rfFKES8MV52nZgIATOqQm/C4RAbvn+aBbf7X4bQa13
         qz+Z82xvudtb1nIN0HnHUYKMsAYcOsFT9CrxdE2h1rorQLGooqHCN0e4SwHqX3aom2Qp
         qZ7CHXC20227zmO37DFkgUqINN+oMEEisyY/QPytH6NPcmZXzvYEYiEbIclxFj3AvlV7
         R+GA==
X-Gm-Message-State: AOAM533KQA5ikiiqHd5Q9RKCC0mpJtyJn/nNf1SCLERWsYaT5Hu6PJtp
        MBUTAbEYlXJlnCmvT8fO/mL/27tyYuoepwHkZbTh3fan6gM=
X-Google-Smtp-Source: ABdhPJz0FROLqXnyvZDXkAxN66AoCpWZjjmuKAfVBWLsqoaGSihYESsDj1l/RfrrIUnuyC77oIROLEwnaeVTC0+swUU=
X-Received: by 2002:a05:6512:1515:: with SMTP id bq21mr24048209lfb.71.1635262846881;
 Tue, 26 Oct 2021 08:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211025115608.5287-1-johan@kernel.org>
In-Reply-To: <20211025115608.5287-1-johan@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Oct 2021 17:40:09 +0200
Message-ID: <CAPDyKFoeqp2Ztw9AE3nMju2kav-04Ahd_F_H9tiyZchsNSjrvQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: vub300: fix control-message timeouts
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 at 13:56, Johan Hovold <johan@kernel.org> wrote:
>
> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.
>
> Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
> Cc: stable@vger.kernel.org      # 3.0
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied for fixes, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/vub300.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
> index 4950d10d3a19..97beece62fec 100644
> --- a/drivers/mmc/host/vub300.c
> +++ b/drivers/mmc/host/vub300.c
> @@ -576,7 +576,7 @@ static void check_vub300_port_status(struct vub300_mmc_host *vub300)
>                                 GET_SYSTEM_PORT_STATUS,
>                                 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                                 0x0000, 0x0000, &vub300->system_port_status,
> -                               sizeof(vub300->system_port_status), HZ);
> +                               sizeof(vub300->system_port_status), 1000);
>         if (sizeof(vub300->system_port_status) == retval)
>                 new_system_port_status(vub300);
>  }
> @@ -1241,7 +1241,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
>                                                 SET_INTERRUPT_PSEUDOCODE,
>                                                 USB_DIR_OUT | USB_TYPE_VENDOR |
>                                                 USB_RECIP_DEVICE, 0x0000, 0x0000,
> -                                               xfer_buffer, xfer_length, HZ);
> +                                               xfer_buffer, xfer_length, 1000);
>                         kfree(xfer_buffer);
>                         if (retval < 0)
>                                 goto copy_error_message;
> @@ -1284,7 +1284,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
>                                                 SET_TRANSFER_PSEUDOCODE,
>                                                 USB_DIR_OUT | USB_TYPE_VENDOR |
>                                                 USB_RECIP_DEVICE, 0x0000, 0x0000,
> -                                               xfer_buffer, xfer_length, HZ);
> +                                               xfer_buffer, xfer_length, 1000);
>                         kfree(xfer_buffer);
>                         if (retval < 0)
>                                 goto copy_error_message;
> @@ -1991,7 +1991,7 @@ static void __set_clock_speed(struct vub300_mmc_host *vub300, u8 buf[8],
>                 usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
>                                 SET_CLOCK_SPEED,
>                                 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                               0x00, 0x00, buf, buf_array_size, HZ);
> +                               0x00, 0x00, buf, buf_array_size, 1000);
>         if (retval != 8) {
>                 dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED"
>                         " %dkHz failed with retval=%d\n", kHzClock, retval);
> @@ -2013,14 +2013,14 @@ static void vub300_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                 usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
>                                 SET_SD_POWER,
>                                 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                               0x0000, 0x0000, NULL, 0, HZ);
> +                               0x0000, 0x0000, NULL, 0, 1000);
>                 /* must wait for the VUB300 u-proc to boot up */
>                 msleep(600);
>         } else if ((ios->power_mode == MMC_POWER_UP) && !vub300->card_powered) {
>                 usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
>                                 SET_SD_POWER,
>                                 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                               0x0001, 0x0000, NULL, 0, HZ);
> +                               0x0001, 0x0000, NULL, 0, 1000);
>                 msleep(600);
>                 vub300->card_powered = 1;
>         } else if (ios->power_mode == MMC_POWER_ON) {
> @@ -2275,14 +2275,14 @@ static int vub300_probe(struct usb_interface *interface,
>                                 GET_HC_INF0,
>                                 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                                 0x0000, 0x0000, &vub300->hc_info,
> -                               sizeof(vub300->hc_info), HZ);
> +                               sizeof(vub300->hc_info), 1000);
>         if (retval < 0)
>                 goto error5;
>         retval =
>                 usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
>                                 SET_ROM_WAIT_STATES,
>                                 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                               firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
> +                               firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
>         if (retval < 0)
>                 goto error5;
>         dev_info(&vub300->udev->dev,
> @@ -2297,7 +2297,7 @@ static int vub300_probe(struct usb_interface *interface,
>                                 GET_SYSTEM_PORT_STATUS,
>                                 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                                 0x0000, 0x0000, &vub300->system_port_status,
> -                               sizeof(vub300->system_port_status), HZ);
> +                               sizeof(vub300->system_port_status), 1000);
>         if (retval < 0) {
>                 goto error4;
>         } else if (sizeof(vub300->system_port_status) == retval) {
> --
> 2.32.0
>
