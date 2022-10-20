Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802FC6058F1
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiJTHqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 03:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiJTHqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 03:46:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64206148FFA;
        Thu, 20 Oct 2022 00:46:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so1712302wms.0;
        Thu, 20 Oct 2022 00:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEyeAqRkz8ofVgcg3/w5/1i7hyOQQ7idefgTfAJdXBA=;
        b=hEm1IpxaWE2L7Eu+1FXjU4xARijFwJiRezVcpAN8LvztZOmcmf5UMeNzJIsGAHNStS
         GJvsug79uDSID7yxrGnqitO5AS8WhrhOFqCYLHeJdTe9mHx/L3VeywC20Ow90NgeVuOJ
         IGLre+lmBJNGL8nbT7lPc3y/3bHDdsordGbJTugTfAWGthwjO4kSx1eKKHh7dLzRED0R
         u/2mzANKneQkAE3cC4GSHMP3sZ0f6wWbWu4Kk7WnfUmrOQBK9D1fmqCRdlMuNa+VBeWd
         60y3OuxfGkIjF7mZRIGeLpFO5QEyWeksnBkczvSV6K/66gT5FKoPmJ9SAoW7Iv7g4g+V
         2+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEyeAqRkz8ofVgcg3/w5/1i7hyOQQ7idefgTfAJdXBA=;
        b=g2K3AEsl4PlmqIWLysjZO8dA7+pMcEuFh+/q6noS5s3ImJcNWoQ4YwAIscaZD7KI2L
         0T8sunqH3rE3OnzVtTvIggfiVwKm45QZJXZ1nzXttEVG3BF2E0GJjM4wEP9/JP4kK6X6
         AchP0+Fk5BcXw9T513tp25by/YJXQdAVFKHO78CDUCjJtfMbJaStqVKSyonGuqgcxEDQ
         QDaz52bCLqzqOGfPMvlgtxF3ppzqpci9/bMmCzKnwGDA+RhB4n44LZw4obBaVuIpenz3
         YbRaMRkBuERvAaO5lmKgAHHm6xnrlYLdwEGFsPgriXJ4LoPMb2udBcRAn270dlZCPTuP
         PO4w==
X-Gm-Message-State: ACrzQf3GmkHS9G1jbM8za4HiFdfklpTG6Q1Yf97hloqjSd4srEPHyiSW
        TQ16yRs9pLZ8XWxVuLMlygP12pm4PTAXUkt5Zuw=
X-Google-Smtp-Source: AMsMyM7foOl//px0n7jl3Vt65n1YnsctUT9xAkTfMET5Nopr3O+wC1Zh2V8CGM5ugkwnsDIRtm3in3v0vqFWNk2VCH4=
X-Received: by 2002:a05:600c:198d:b0:3b4:a62c:a085 with SMTP id
 t13-20020a05600c198d00b003b4a62ca085mr27820940wmq.140.1666251989062; Thu, 20
 Oct 2022 00:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <1664416817-31590-1-git-send-email-u0084500@gmail.com>
In-Reply-To: <1664416817-31590-1-git-send-email-u0084500@gmail.com>
From:   ChiYuan Huang <u0084500@gmail.com>
Date:   Thu, 20 Oct 2022 15:46:17 +0800
Message-ID: <CADiBU38+r48uxAasbHSCEFvJc2w4_-nz8vHpAX=OOBq2NPE81Q@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: mt6360: add bound check in regmap read/write function
To:     lee@kernel.org
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

cy_huang <u0084500@gmail.com> =E6=96=BC 2022=E5=B9=B49=E6=9C=8829=E6=97=A5 =
=E9=80=B1=E5=9B=9B =E4=B8=8A=E5=8D=8810:00=E5=AF=AB=E9=81=93=EF=BC=9A
>
> From: ChiYuan Huang <cy_huang@richtek.com>
>
> Fix the potential risk for null pointer if bank index is over the maximum=
.
>
> Refer to the discussion list for the experiment result on mt6370.
> https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-84=
0-g3.rt/
> If not to check the bound, there is the same issue on mt6360.
>
> Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/w=
rite)
> Cc: stable@vger.kernel.org
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
> ---
> Since v2:
> - Assign i2c bank variable after bank index is already checked.
>
> ---
>  drivers/mfd/mt6360-core.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
Any comment?
> diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
> index 6eaa677..d3b32eb 100644
> --- a/drivers/mfd/mt6360-core.c
> +++ b/drivers/mfd/mt6360-core.c
> @@ -402,7 +402,7 @@ static int mt6360_regmap_read(void *context, const vo=
id *reg, size_t reg_size,
>         struct mt6360_ddata *ddata =3D context;
>         u8 bank =3D *(u8 *)reg;
>         u8 reg_addr =3D *(u8 *)(reg + 1);
> -       struct i2c_client *i2c =3D ddata->i2c[bank];
> +       struct i2c_client *i2c;
>         bool crc_needed =3D false;
>         u8 *buf;
>         int buf_len =3D MT6360_ALLOC_READ_SIZE(val_size);
> @@ -410,6 +410,11 @@ static int mt6360_regmap_read(void *context, const v=
oid *reg, size_t reg_size,
>         u8 crc;
>         int ret;
>
> +       if (bank >=3D MT6360_SLAVE_MAX)
> +               return -EINVAL;
> +
> +       i2c =3D ddata->i2c[bank];
> +
>         if (bank =3D=3D MT6360_SLAVE_PMIC || bank =3D=3D MT6360_SLAVE_LDO=
) {
>                 crc_needed =3D true;
>                 ret =3D mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
> @@ -453,13 +458,18 @@ static int mt6360_regmap_write(void *context, const=
 void *val, size_t val_size)
>         struct mt6360_ddata *ddata =3D context;
>         u8 bank =3D *(u8 *)val;
>         u8 reg_addr =3D *(u8 *)(val + 1);
> -       struct i2c_client *i2c =3D ddata->i2c[bank];
> +       struct i2c_client *i2c;
>         bool crc_needed =3D false;
>         u8 *buf;
>         int buf_len =3D MT6360_ALLOC_WRITE_SIZE(val_size);
>         int write_size =3D val_size - MT6360_REGMAP_REG_BYTE_SIZE;
>         int ret;
>
> +       if (bank >=3D MT6360_SLAVE_MAX)
> +               return -EINVAL;
> +
> +       i2c =3D ddata->i2c[bank];
> +
>         if (bank =3D=3D MT6360_SLAVE_PMIC || bank =3D=3D MT6360_SLAVE_LDO=
) {
>                 crc_needed =3D true;
>                 ret =3D mt6360_xlate_pmicldo_addr(&reg_addr, val_size - M=
T6360_REGMAP_REG_BYTE_SIZE);
> --
> 2.7.4
>
