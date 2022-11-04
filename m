Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDA619523
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 12:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKDLHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 07:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiKDLHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 07:07:13 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42B3299;
        Fri,  4 Nov 2022 04:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1667560030; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQvXSJoMiWutppm3+V1Jg+2WFdD9Jc+UkTVUcww0oEE=;
        b=2aC/ujuzUR78ygOvXGHxVELmP4qXSgyXdhjcoOEsZrwo5OknZVku98FKinPS4jvJrAHv/j
        WZmO4TOr4ljI0XwzbpdzrQXCohLu7fAm8zkN26h3EaULzGPkZfKYR2NCsTk4VW2aIKskRZ
        yrDVHs/Jhz97DogCk/HD+lIMR7n9IbI=
Date:   Fri, 04 Nov 2022 11:07:01 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v2] drm/ingenic: Fix missing platform_driver_unregister()
 call in ingenic_drm_init()
To:     Yuan Can <yuancan@huawei.com>
Cc:     airlied@gmail.com, daniel@ffwll.ch, sam@ravnborg.org,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Message-Id: <PJLTKR.334WYQIBFM522@crapouillou.net>
In-Reply-To: <20221104064512.8569-1-yuancan@huawei.com>
References: <20221104064512.8569-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Le ven. 4 nov. 2022 =E0 06:45:12 +0000, Yuan Can <yuancan@huawei.com> a=20
=E9crit :
> A problem about modprobe ingenic-drm failed is triggered with the=20
> following
> log given:
>=20
>  [  303.561088] Error: Driver 'ingenic-ipu' is already registered,=20
> aborting...
>  modprobe: ERROR: could not insert 'ingenic_drm': Device or resource=20
> busy
>=20
> The reason is that ingenic_drm_init() returns=20
> platform_driver_register()
> directly without checking its return value, if=20
> platform_driver_register()
> failed, it returns without unregistering ingenic_ipu_driver_ptr,=20
> resulting
> the ingenic-drm can never be installed later.
> A simple call graph is shown as below:
>=20
>  ingenic_drm_init()
>    platform_driver_register() # ingenic_ipu_driver_ptr are registered
>    platform_driver_register()
>      driver_register()
>        bus_add_driver()
>          priv =3D kzalloc(...) # OOM happened
>    # return without unregister ingenic_ipu_driver_ptr
>=20
> Fixing this problem by checking the return value of
> platform_driver_register() and do platform_unregister_drivers() if
> error happened.
>=20
> Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> Cc: stable@vger.kernel.org

Applied, thanks!

Cheers,
-Paul

> ---
> Changes in v2:
> - Add missing Cc: stable@vger.kernel.org
>=20
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c=20
> b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> index ab0515d2c420..4499a04f7c13 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -1629,7 +1629,11 @@ static int ingenic_drm_init(void)
>  			return err;
>  	}
>=20
> -	return platform_driver_register(&ingenic_drm_driver);
> +	err =3D platform_driver_register(&ingenic_drm_driver);
> +	if (IS_ENABLED(CONFIG_DRM_INGENIC_IPU) && err)
> +		platform_driver_unregister(ingenic_ipu_driver_ptr);
> +
> +	return err;
>  }
>  module_init(ingenic_drm_init);
>=20
> --
> 2.17.1
>=20


