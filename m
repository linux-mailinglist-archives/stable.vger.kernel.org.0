Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE672E83F2
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 15:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhAAOVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 09:21:06 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:52981 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbhAAOVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 09:21:05 -0500
Date:   Fri, 01 Jan 2021 14:20:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1609510821;
        bh=9IlciDeE4Mu3twWzeiCd2YETcAlvXlh3tCEyG5790LI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=UKlEtp1Db4Yg2xNY5Szd4Cw3GyCiUpXPUTLt/Y4On4yjy69Njs82wKN//q8RlbZz8
         zZM3aAgbzsbCDfVQyOMbXg5lYf76Aqtmhv5ZjMQejwMlv0ZZ5lVg1QVTWCXAzRFXxp
         UOi6a5lCu0vmBC+AZ4QaaG/bIfEBE/x/3+80S5DA=
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Add has_touchpad_switch
Message-ID: <_kQDaYPt7vh_mQfPr1tLJV2IP-p40OBPcU5zk-1xHhF9XJsm8Y-efANBgiRdWU-J2QTtOjmrfE0Tw6UrZpm6uG-zZGlfpaVOp9FuoKAbjzA=@protonmail.com>
In-Reply-To: <20210101061140.27547-1-jiaxun.yang@flygoat.com>
References: <20210101061140.27547-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi


2021. janu=C3=A1r 1., p=C3=A9ntek 7:11 keltez=C3=A9ssel, Jiaxun Yang =C3=
=ADrta:

> Newer ideapads (e.g.: Yoga 14s, 720S 14) comes with I2C HID
> Touchpad and do not use EC to switch touchpad. Reading VPCCMD_R_TOUCHPAD
> will return zero thus touchpad may be blocked. Writing VPCCMD_W_TOUCHPAD
> may cause a spurious key press.
>
> Add has_touchpad_switch to workaround these machines.
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: stable@vger.kernel.org # 5.4+

Interestingly, the Lenovo Yoga 540-14IKB 80X8 has an HID-over-I2C touchpad,
and yet it can be controlled by reading/writing the appropriate EC register=
s.


> ---
>  drivers/platform/x86/ideapad-laptop.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86=
/ideapad-laptop.c
> index 7598cd46cf60..b6a4db37d0fc 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -92,6 +92,7 @@ struct ideapad_private {
>  =09struct dentry *debug;
>  =09unsigned long cfg;
>  =09bool has_hw_rfkill_switch;
> +=09bool has_touchpad_switch;
>  =09const char *fnesc_guid;
>  };
>
> @@ -535,7 +536,9 @@ static umode_t ideapad_is_visible(struct kobject *kob=
j,
>  =09} else if (attr =3D=3D &dev_attr_fn_lock.attr) {
>  =09=09supported =3D acpi_has_method(priv->adev->handle, "HALS") &&
>  =09=09=09acpi_has_method(priv->adev->handle, "SALS");
> -=09} else
> +=09} else if (attr =3D=3D &dev_attr_touchpad.attr)
> +=09=09supported =3D priv->has_touchpad_switch;
> +=09else
>  =09=09supported =3D true;
>
>  =09return supported ? attr->mode : 0;
> @@ -867,6 +870,9 @@ static void ideapad_sync_touchpad_state(struct ideapa=
d_private *priv)
>  {
>  =09unsigned long value;
>
> +=09if (!priv->has_touchpad_switch)
> +=09=09return;
> +
>  =09/* Without reading from EC touchpad LED doesn't switch state */
>  =09if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
>  =09=09/* Some IdeaPads don't really turn off touchpad - they only
> @@ -989,6 +995,12 @@ static int ideapad_acpi_add(struct platform_device *=
pdev)
>  =09priv->platform_device =3D pdev;
>  =09priv->has_hw_rfkill_switch =3D dmi_check_system(hw_rfkill_list);
>
> +=09/* Most ideapads with I2C HID don't use EC touchpad switch */
> +=09if (acpi_dev_present("PNP0C50", NULL, -1))
> +=09=09priv->has_touchpad_switch =3D false;
> +=09else
> +=09=09priv->has_touchpad_switch =3D true;
> +

`priv->has_touchpad_switch =3D !acpi_dev_present(...)`
?


>  =09ret =3D ideapad_sysfs_init(priv);
>  =09if (ret)
>  =09=09return ret;
> @@ -1006,6 +1018,10 @@ static int ideapad_acpi_add(struct platform_device=
 *pdev)
>  =09if (!priv->has_hw_rfkill_switch)
>  =09=09write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
>
> +=09/* The same for Touchpad */
> +=09if (!priv->has_touchpad_switch)
> +=09=09write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
> +

Shouldn't it be the other way around: `if (priv->has_touchpad_switch)`?



>  =09for (i =3D 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
>  =09=09if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
>  =09=09=09ideapad_register_rfkill(priv, i);
> --
> 2.30.0


Regards,
Barnab=C3=A1s P=C5=91cze
