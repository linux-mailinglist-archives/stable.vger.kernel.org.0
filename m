Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655166C5F90
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 07:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCWGV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 02:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCWGVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 02:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1281E29D;
        Wed, 22 Mar 2023 23:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E73B81F67;
        Thu, 23 Mar 2023 06:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067F7C4339B;
        Thu, 23 Mar 2023 06:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679552480;
        bh=sD//P0ws33D7apLZ0glcbRKDxg6o55an2E7eoJyFSoo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GGwIlAsfgKMc67X6Fj/6uM4P1WAKyUm7RPbE/MmdFB8mXJH2t6AMb4p8/Z65CRez1
         gxIZBkFZBBSQR5mnhx7eNQgSFkBn26Op3K8NruLiHpsNb5r7+11ihEbQerj1OT3QiP
         gtqNBIe4zXOpOcd7FguKjCVDEmFARFVYr0griQleFVs7cuIudf+5GsLJsX96kygr3I
         A052sWdAlvQEjKzfGReWOEFv82y9+gQuThi1cjofzwA21Zeg3lIsiE2UseGxNEwgo0
         gOPWPDY7tRmMuCs8JHZrr6B6clviD3RxO/MxW4aqESXzTi9tvF1QA8g4VxS5GKhA8h
         x8k1Uk8qHdo0Q==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-17aaa51a911so21729060fac.5;
        Wed, 22 Mar 2023 23:21:19 -0700 (PDT)
X-Gm-Message-State: AO0yUKUHR4gqqDgfMnQXspftfFsNOSiYzLp9jyn8po6hbZn8sVMReFgG
        5IyGBMVeITwWsd/KPRhnki+rbUXTrlSct6gO1l4=
X-Google-Smtp-Source: AKy350aC/pHtQ1PJNQ2cj7Ju2QOfJqWWy/iLEQiSsNdLYt4Ac0Xw4rJt4QE6kBagah8v+Xo7GtJp9IBnVdQqJ06oHXg=
X-Received: by 2002:a05:6870:ea86:b0:17e:2e88:40dc with SMTP id
 s6-20020a056870ea8600b0017e2e8840dcmr627852oap.11.1679552479283; Wed, 22 Mar
 2023 23:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <ZBtE4XlqCXjFELHR@decadent.org.uk>
In-Reply-To: <ZBtE4XlqCXjFELHR@decadent.org.uk>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 23 Mar 2023 15:20:43 +0900
X-Gmail-Original-Message-ID: <CAK7LNASpaWkTn-WWN+5W-EA13ZfVDfSN+JFvBvckRe+i=2XQXA@mail.gmail.com>
Message-ID: <CAK7LNASpaWkTn-WWN+5W-EA13ZfVDfSN+JFvBvckRe+i=2XQXA@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix processing of CRCs on 32-bit build machines
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kbuild@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Ben Hutchings <ben@decadent.org.uk>=
 wrote:
>
> modpost now reads CRCs from .*.cmd files, parsing them using strtol().
> This is inconsistent with its parsing of Module.symvers and with their
> definition as *unsigned* 32-bit values.
>
> strtol() clamps values to [LONG_MIN, LONG_MAX], and when building on a
> 32-bit system this changes all CRCs >=3D 0x80000000 to be 0x7fffffff.
>
> Change extract_crcs_for_object() to use strtoul() instead.
>
> Cc: stable@vger.kernel.org
> Fixes: f292d875d0dc ("modpost: extract symbol versions from *.cmd files")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---


Applied to linux-kbuild/fixes.
Thanks.


>  scripts/mod/modpost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index efff8078e395..9466b6a2abae 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1733,7 +1733,7 @@ static void extract_crcs_for_object(const char *obj=
ect, struct module *mod)
>                 if (!isdigit(*p))
>                         continue;       /* skip this line */
>
> -               crc =3D strtol(p, &p, 0);
> +               crc =3D strtoul(p, &p, 0);
>                 if (*p !=3D '\n')
>                         continue;       /* skip this line */
>


--=20
Best Regards
Masahiro Yamada
