Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ECB6D93BA
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjDFKK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 06:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbjDFKK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 06:10:26 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE043B5;
        Thu,  6 Apr 2023 03:10:25 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id bb36so2966611qtb.3;
        Thu, 06 Apr 2023 03:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680775825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JYPXgDX/Nfy87g0s7pL1XNdk5ri1X9AO3b/t8fNcmQ=;
        b=qO7RLs5sEqmG7jai5So9ohvNoJl6wDoc5spFeogqpnmuc7TwViTzrJ5zQJSfDxpox1
         S9TXPt4XEtSqXLXgASqEwVB3rO9fnwxs2Z0LSXCKMEpZILcWzIT3NgTxLZyJN8CXXGlB
         3dUFP9EgPoGekogN8EiMY9Nzj5ZuPhGO/+smv5MbDQwZt8qopOpcedK8god8KayhpNP+
         cOBUP7yArxxUOgb824mXdF5UXY3P3KEHB7VnlOTAeV5/c4k3Nf4njtFIRR6y2s59QqMN
         YL9iE7XdbvSw5G7BqXlVrLGtgRYGgPJ4ORcRoMGn3m0R0fiyHalO9laDRzn0O0MocwGG
         sU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680775825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JYPXgDX/Nfy87g0s7pL1XNdk5ri1X9AO3b/t8fNcmQ=;
        b=5CeWAln5fJqo+6WcHtmSHjHPegEozE8lZNKzjyoYvAkCnkRZ95w44xG/23E5NsZ+gU
         LAijjCPnIrrFE+/Ex7gdZzxmycd+tkIQ5kc8Q5Nv9oevP4uEMWphQrfa46Nm36V7ZWSc
         YQpAvKNaAoe/Hyeuasi6rVNLnxijbe9PoakDN+SCewBMSd6o+m4DuuN4naAlZ1H60clx
         NN3Qnxp7JN9LajN+Xd6NHg3rmfqWqGYzN1JXqWUuom8mvVTQyNkm+db+lpPyx/iN2f8d
         OQi9UCv0PBtKbTypbChg9zVhcPChTex6MlLnKwpuc5EJZl5fpziVYxXq6GNl+x2uTeEK
         UcYA==
X-Gm-Message-State: AAQBX9e8NMwfg6Ndcl47j6gFbToZjkHy8N+V4mpjOmWsEJKWzmFh+Zdr
        UkwV7QhFO9eucd4V+YPTIXm3D/bDwRqbXUV0KCQ=
X-Google-Smtp-Source: AKy350a6JgVWE3mUxuYvEyYT4UCWCRlFmDAUdy39pH+JJebrzroPmFFZzbnGM+53LnTJ/F03pipNMnvUny4O72USn3U=
X-Received: by 2002:a05:622a:1716:b0:3de:1720:b54b with SMTP id
 h22-20020a05622a171600b003de1720b54bmr2279520qtk.0.1680775824739; Thu, 06 Apr
 2023 03:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <79db8e82aadb0e174bc82b9996423c3503c8fb37.1680732084.git.jan.kundrat@cesnet.cz>
In-Reply-To: <79db8e82aadb0e174bc82b9996423c3503c8fb37.1680732084.git.jan.kundrat@cesnet.cz>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 6 Apr 2023 13:09:46 +0300
Message-ID: <CAHp75Veyu+-mJ6k+oRai3XatGY5fXi8E7f77V=_6ztzpzaxODQ@mail.gmail.com>
Subject: Re: [PATCH] serial: max310x: fix IO data corruption in batched operations
To:     =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jan.kundrat@cesnet.cz>
Cc:     linux-serial@vger.kernel.org,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Cosmin Tanislav <demonsingur@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 6, 2023 at 1:08=E2=80=AFAM Jan Kundr=C3=A1t <jan.kundrat@cesnet=
.cz> wrote:
>
> After upgrading from 5.16 to 6.1, our board with a MAX14830 started
> producing lots of garbage data over UART. Bisection pointed out commit
> 285e76fc049c as the culprit. That patch tried to replace hand-written
> code which I added in 2b4bac48c1084 ("serial: max310x: Use batched reads
> when reasonably safe") with the generic regmap infrastructure for
> batched operations.
>
> Unfortunately, the `regmap_raw_read` and `regmap_raw_write` which were
> used are actually functions which perform IO over *multiple* registers.
> That's not what is needed for accessing these Tx/Rx FIFOs; the
> appropriate functions are the `_noinc_` versions, not the `_raw_` ones.
>
> Fix this regression by using `regmap_noinc_read()` and
> `regmap_noinc_write()` along with the necessary `regmap_config` setup;
> with this patch in place, our board communicates happily again. Since
> our board uses SPI for talking to this chip, the I2C part is completely
> untested.

Make sense, thanks for fixing this!

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: 285e76fc049c serial: max310x: use regmap methods for SPI batch ope=
rations
> Signed-off-by: Jan Kundr=C3=A1t <jan.kundrat@cesnet.cz>
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/max310x.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
> index c82391c928cb..47520d4a381f 100644
> --- a/drivers/tty/serial/max310x.c
> +++ b/drivers/tty/serial/max310x.c
> @@ -529,6 +529,11 @@ static bool max310x_reg_precious(struct device *dev,=
 unsigned int reg)
>         return false;
>  }
>
> +static bool max310x_reg_noinc(struct device *dev, unsigned int reg)
> +{
> +       return reg =3D=3D MAX310X_RHR_REG;
> +}
> +
>  static int max310x_set_baud(struct uart_port *port, int baud)
>  {
>         unsigned int mode =3D 0, div =3D 0, frac =3D 0, c =3D 0, F =3D 0;
> @@ -658,14 +663,14 @@ static void max310x_batch_write(struct uart_port *p=
ort, u8 *txbuf, unsigned int
>  {
>         struct max310x_one *one =3D to_max310x_port(port);
>
> -       regmap_raw_write(one->regmap, MAX310X_THR_REG, txbuf, len);
> +       regmap_noinc_write(one->regmap, MAX310X_THR_REG, txbuf, len);
>  }
>
>  static void max310x_batch_read(struct uart_port *port, u8 *rxbuf, unsign=
ed int len)
>  {
>         struct max310x_one *one =3D to_max310x_port(port);
>
> -       regmap_raw_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
> +       regmap_noinc_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
>  }
>
>  static void max310x_handle_rx(struct uart_port *port, unsigned int rxlen=
)
> @@ -1480,6 +1485,10 @@ static struct regmap_config regcfg =3D {
>         .writeable_reg =3D max310x_reg_writeable,
>         .volatile_reg =3D max310x_reg_volatile,
>         .precious_reg =3D max310x_reg_precious,
> +       .writeable_noinc_reg =3D max310x_reg_noinc,
> +       .readable_noinc_reg =3D max310x_reg_noinc,
> +       .max_raw_read =3D MAX310X_FIFO_SIZE,
> +       .max_raw_write =3D MAX310X_FIFO_SIZE,
>  };
>
>  #ifdef CONFIG_SPI_MASTER
> @@ -1565,6 +1574,10 @@ static struct regmap_config regcfg_i2c =3D {
>         .volatile_reg =3D max310x_reg_volatile,
>         .precious_reg =3D max310x_reg_precious,
>         .max_register =3D MAX310X_I2C_REVID_EXTREG,
> +       .writeable_noinc_reg =3D max310x_reg_noinc,
> +       .readable_noinc_reg =3D max310x_reg_noinc,
> +       .max_raw_read =3D MAX310X_FIFO_SIZE,
> +       .max_raw_write =3D MAX310X_FIFO_SIZE,
>  };
>
>  static const struct max310x_if_cfg max310x_i2c_if_cfg =3D {
> --
> 2.39.2
>
>


--=20
With Best Regards,
Andy Shevchenko
