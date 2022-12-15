Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6DA64DE1B
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 16:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLOPx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 10:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLOPxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 10:53:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BD72EF06;
        Thu, 15 Dec 2022 07:53:24 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h7so3525161wrs.6;
        Thu, 15 Dec 2022 07:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTWgsmHzTpWzuS0tKmgJigWFWKRfgqTH1SBAQ502e+g=;
        b=eYiRYnrI/nKK/cdpAqy8ak3Tnp2FJcuwrjoAX4qiAfvNTptOTEtdNNj59Qy6R47Z2j
         djPHkrFx8D4YUoZb5skDMZY0DVVtxdqVUtN1IsY4kHDeZq4jLGSkwAJhd0yp4srnnc+u
         tSuODM7zXEIBCPOBY1asEKGT4hzNTMgOr/6GbaS4YzaIz/IvEYioCLFRY9JXSjQ7Lyfx
         0sEZDnioSpD4WG7nXHfuw6b2QgqLV5asdXKERgYkFo4okluWNx9Iqw2GsehncBB0rLTb
         /6N1NbLSnZom1wEcK1a/W/Xq5/gfhrB3/SKQYN2GXTT4XEOnWG7nJtoJ4p7q7OECvSXU
         fo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTWgsmHzTpWzuS0tKmgJigWFWKRfgqTH1SBAQ502e+g=;
        b=CcPFzDCLEoyLcfsMK74tK5FpTcT9KKZQfV0rG8a0zea32JmNYMgy0NrgrM7dKcZv0S
         /PhnGVNw9et1J7x9Hu66p5CLQ3d2Najtjjq02WFEjWpplOR7ZS0EzscZpgz02s5aS7/f
         yDmpu4abHN6fbvFIDQGRvm7TVGZrhMyVv0Gc4ysyhZeVZ3NE0zsLWQgeiMD7aj1vTjry
         9L2wFa3M5SrV/YwF7xm0WuFtBh1PnIFxbItXWT6v04t7CBBnQIo5m+N2sjQ8MDXPhOWy
         0e76XcM0xPiJuWG+c262QHAnRx2nkZWQeaHiP1zvmNouvAWGpIXEe2ng9+Bjw9NzkQ0F
         X+JA==
X-Gm-Message-State: ANoB5pmSwEMCd87DuyGtG+bK5dadSlk+kyDQVvxRX+JJIq6Fa/gdS/Bb
        Bqg4ycFzn96JIOU9spaaRN5iXnqoHSX3Na/BsNQ=
X-Google-Smtp-Source: AA0mqf7r1a6ytYJwksHN8ZnDH6v4+9MK7b3XilbDkJleWeSy1X2tBR8BZSlTJnV3VgVE1VhnH0M7RNyFu0Mf/NbeODw=
X-Received: by 2002:adf:f54e:0:b0:242:1534:7b57 with SMTP id
 j14-20020adff54e000000b0024215347b57mr31697395wrp.404.1671119602509; Thu, 15
 Dec 2022 07:53:22 -0800 (PST)
MIME-Version: 1.0
References: <20221201231141.112916-1-jason.gerecke@wacom.com>
In-Reply-To: <20221201231141.112916-1-jason.gerecke@wacom.com>
From:   Jason Gerecke <killertofu@gmail.com>
Date:   Thu, 15 Dec 2022 07:53:11 -0800
Message-ID: <CANRwn3RNC_iHG_XRHv486FNY+uZ6WxjUvSghb=K=vUHOJTPkWA@mail.gmail.com>
Subject: Re: [PATCH] HID: wacom: Ensure bootloader PID is usable in hidraw mode
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        "Tobita, Tatsunosuke" <tatsunosuke.tobita@wacom.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@joshua-dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 1, 2022 at 3:11 PM Jason Gerecke <killertofu@gmail.com> wrote:
>
> From: Jason Gerecke <killertofu@gmail.com>
>
> Some Wacom devices have a special "bootloader" mode that is used for
> firmware flashing. When operating in this mode, the device cannot be
> used for input, and the HID descriptor is not able to be processed by
> the driver. The driver generates an "Unknown device_type" warning and
> then returns an error code from wacom_probe(). This is a problem because
> userspace still needs to be able to interact with the device via hidraw
> to perform the firmware flash.
>
> This commit adds a non-generic device definition for 056a:0094 which
> is used when devices are in "bootloader" mode. It marks the devices
> with a special BOOTLOADER type that is recognized by wacom_probe() and
> wacom_raw_event(). When we see this type we ensure a hidraw device is
> created and otherwise keep our hands off so that userspace is in full
> control.
>
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Tested-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/hid/wacom_sys.c | 8 ++++++++
>  drivers/hid/wacom_wac.c | 4 ++++
>  drivers/hid/wacom_wac.h | 1 +
>  3 files changed, 13 insertions(+)
>
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 634263e4556b..fb538a6c4add 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -155,6 +155,9 @@ static int wacom_raw_event(struct hid_device *hdev, s=
truct hid_report *report,
>  {
>         struct wacom *wacom =3D hid_get_drvdata(hdev);
>
> +       if (wacom->wacom_wac.features.type =3D=3D BOOTLOADER)
> +               return 0;
> +
>         if (size > WACOM_PKGLEN_MAX)
>                 return 1;
>
> @@ -2785,6 +2788,11 @@ static int wacom_probe(struct hid_device *hdev,
>                 return error;
>         }
>
> +       if (features->type =3D=3D BOOTLOADER) {
> +               hid_warn(hdev, "Using device in hidraw-only mode");
> +               return hid_hw_start(hdev, HID_CONNECT_HIDRAW);
> +       }
> +
>         error =3D wacom_parse_and_register(wacom, false);
>         if (error)
>                 return error;
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 0f3d57b42684..9312d611db8e 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -4882,6 +4882,9 @@ static const struct wacom_features wacom_features_0=
x3dd =3D
>  static const struct wacom_features wacom_features_HID_ANY_ID =3D
>         { "Wacom HID", .type =3D HID_GENERIC, .oVid =3D HID_ANY_ID, .oPid=
 =3D HID_ANY_ID };
>
> +static const struct wacom_features wacom_features_0x94 =3D
> +       { "Wacom Bootloader", .type =3D BOOTLOADER };
> +
>  #define USB_DEVICE_WACOM(prod)                                         \
>         HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
>         .driver_data =3D (kernel_ulong_t)&wacom_features_##prod
> @@ -4955,6 +4958,7 @@ const struct hid_device_id wacom_ids[] =3D {
>         { USB_DEVICE_WACOM(0x84) },
>         { USB_DEVICE_WACOM(0x90) },
>         { USB_DEVICE_WACOM(0x93) },
> +       { USB_DEVICE_WACOM(0x94) },
>         { USB_DEVICE_WACOM(0x97) },
>         { USB_DEVICE_WACOM(0x9A) },
>         { USB_DEVICE_WACOM(0x9F) },
> diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
> index 5ca6c06d143b..16f221388563 100644
> --- a/drivers/hid/wacom_wac.h
> +++ b/drivers/hid/wacom_wac.h
> @@ -243,6 +243,7 @@ enum {
>         MTTPC,
>         MTTPC_B,
>         HID_GENERIC,
> +       BOOTLOADER,
>         MAX_TYPE
>  };
>
> --
> 2.38.1
>
Haven't seen any action on this so sending it out again.

Jason
---
Now instead of four in the eights place /
you=E2=80=99ve got three, =E2=80=98Cause you added one  /
(That is to say, eight) to the two,     /
But you can=E2=80=99t take seven from three,    /
So you look at the sixty-fours....
