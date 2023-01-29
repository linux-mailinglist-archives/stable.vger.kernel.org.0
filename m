Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6398568005D
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 18:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbjA2RJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 12:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2RJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 12:09:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46947C652;
        Sun, 29 Jan 2023 09:09:07 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hx15so6296770ejc.11;
        Sun, 29 Jan 2023 09:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bfLdSQqDxRQGeCe/h7f1wp4AyGL2GN6r31nH4LUfHC4=;
        b=UObinvVveCeYYhB2GznEucUqc/D2WRv+mJ5MWfPP5fZJKV9t39zDBPGyGWRYQ7pnh3
         ZMcMSKI3kNM48Qc7u0rdBuFxDFCnWwXwRokRdHwbdkBmk3s8H4zNYVjFIfACgFOcNVU+
         2ANXTPhIRwkcKw54R7RlvQzpiVyzJwqD/Ae6owdsDQ+uCkiPJUIab0J9ksVg1Wet3BIL
         dcblNhDicfAqAKhshc3nRLjOOasZBo5u3Gt2h0BcVvkZjGKqd0nlsjHmX7uUeISAeUUa
         cb63hhlN2BAgn/TYIbrSf1hmG8pY9xc0gk9DzaZ4JzrTT1IxDTgIkwg8Awr6F42MfoIZ
         4YhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bfLdSQqDxRQGeCe/h7f1wp4AyGL2GN6r31nH4LUfHC4=;
        b=J5/cZ3Ax5Ym8LH9B230Yk3UIBbvquX3N2tD/jU8xw3pTrZ8PSIpD5DUl8NZW8jo1yZ
         pBdPY+Auyj4aa7OseCaA6r6xOveWC1D0H6+05CLzKILxJubWvyrrgDhDlZynmDhvG3vS
         CubL87mL67zh4fwX/OzVTyqqQgUhbXR88QHv0uI4BaPbsKmZ/QkKVBDMDb4TINjWOy7f
         aCYcalXWhlmo60dQUKghEDOX9NkLC7kqGRJTFdEhqC6Y/62Nir9TGe97SIXVFSAAfZxd
         Vy8h6hp+oGFGWlgcYD+6VO0kq8ltfd2ZSfPpDoi3y2NNZc2UH5QFhG5+JmNTj2zcub6y
         DbMA==
X-Gm-Message-State: AO0yUKVC5nSlFr0ep3NY86YFb2g+pbimRvUJ0wSqToezfGxOfNiQjBuv
        GrpeU2OlUAJzCCrql/yvXLY=
X-Google-Smtp-Source: AK7set9ZxDHcjjoILQS39I59VVgCdpkwiyLUI2OWMbkZzLjM0RY0UXszWjvZ8JF73kprf5vXcNnnfg==
X-Received: by 2002:a17:906:2e92:b0:87b:d60a:fcbb with SMTP id o18-20020a1709062e9200b0087bd60afcbbmr8915268eji.47.1675012145571;
        Sun, 29 Jan 2023 09:09:05 -0800 (PST)
Received: from sakura.myxoz.lan (90-224-45-44-no2390.tbcn.telia.com. [90.224.45.44])
        by smtp.gmail.com with ESMTPSA id oy17-20020a170907105100b0087bd50f6986sm4126966ejb.42.2023.01.29.09.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 09:09:04 -0800 (PST)
Message-ID: <727b87ec3e93c6cfd9524d3947ca6e272cdf1a38.camel@gmail.com>
Subject: Re: [PATCHv2] fbcon: Check font dimension limits
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Date:   Sun, 29 Jan 2023 18:09:03 +0100
In-Reply-To: <20230129151740.x5p7jj2pbuilpzzt@begin>
References: <20230129151740.x5p7jj2pbuilpzzt@begin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2023-01-29 at 16:17 +0100, Samuel Thibault wrote:
> blit_x and blit_y are u32, so fbcon currently cannot support fonts
> larger than 32x32.
>=20
> The 32x32 case also needs shifting an unsigned int, to properly set
> bit
> 31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
> as reported on:
>=20
> http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07=
MB9830.namprd07.prod.outlook.com
> Kernel Branch: 6.2.0-rc5-next-20230124
> Kernel config:
> https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?us=
p=3Dsharing
> Reproducer:
> https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?us=
p=3Dsharing
>=20
> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Fixes: 2d2699d98492 ("fbcon: font setting should check limitation of
> driver")
> Cc: stable@vger.kernel.org
>=20
> ---
> v1 -> v2:
> - Use BIT macro instead of fixing bit test by hand.
> - Add Fixes and Cc: stable headers.
>=20
> Index: linux-6.0/drivers/video/fbdev/core/fbcon.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-6.0.orig/drivers/video/fbdev/core/fbcon.c
> +++ linux-6.0/drivers/video/fbdev/core/fbcon.c
> @@ -2489,9 +2489,12 @@ static int fbcon_set_font(struct vc_data
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 h > FB=
CON_SWAP(info->var.rotate, info->var.yres, info-
> >var.xres))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (font->width > 32 || font->=
height > 32)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Make sure drawing engi=
ne can handle the font */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!(info->pixmap.blit_x & (1=
 << (font->width - 1))) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(info->pix=
map.blit_y & (1 << (font->height - 1))))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!(info->pixmap.blit_x & BI=
T(font->width - 1)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(info->pix=
map.blit_y & BIT(font->height - 1)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Make sure driver can h=
andle the font length */

Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
--=20
~miko
