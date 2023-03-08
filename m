Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027D76B0999
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCHNnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCHNmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:42:47 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8FC25E17;
        Wed,  8 Mar 2023 05:41:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8E10060008;
        Wed,  8 Mar 2023 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678282851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uq54rdNF8pNGVn5GJ1nrT1LIyoDomEfDdQ9IX1YDYyE=;
        b=aFA1Rk9DF2SSje9nGVeoy0YGK/bNL7k2oziRhg7LmshTp+CbhQaoKNrS4vbyD56YqTNTmR
        RwE2ddjKd7iuCXET0y3fCqSbka/7NUKJd3EbZP3mv7t9uLQpzMXEDNH8mTtDn68m2rYCip
        Td/FYd4UA5GQnxgBmpZalWkUe60H1waup7wAqpIZiAYQ3EIgjaCVnb7DxyyoT2m+rC78/C
        pQpFFeCT6eZ79pEvM32eoIcx13yySfmQ75Y8riP6wtj1nulGln+N1jXhJD2StBXgKkiZs3
        nd/1l/BRMOgmFxtaOn1kWGnAbp3aWGIMH+BxNUmFFnzFM1meQjGn588psQddDQ==
Date:   Wed, 8 Mar 2023 14:40:48 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mtd: core: provide unique name for nvmem device,
 take two
Message-ID: <20230308144048.473e2ec7@xps-13>
In-Reply-To: <20230308082021.870459-1-michael@walle.cc>
References: <20230308082021.870459-1-michael@walle.cc>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael,

michael@walle.cc wrote on Wed,  8 Mar 2023 09:20:18 +0100:

> Commit c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> tries to give the nvmem device a unique name, but fails badly if the mtd
> device doesn't have a "struct device" associated with it, i.e. if
> CONFIG_MTD_PARTITIONED_MASTER is not set. This will result in the name
> "(null)-user-otp", which is not unique. It seems the best we can do is
> to use the compatible name together with a unique identifier added by
> the nvmem subsystem by using NVMEM_DEVID_AUTO.
>=20
> Fixes: c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> v2:
>  - actually use NVMEM_DEVID_AUTO as described in the commit message
>=20

Thanks for the v2, as I want to share a clean immutable branch with
Greg, I made an exception in force pushing this patch in place of its
v1 counterpart.

>  drivers/mtd/mtdcore.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 0feacb9fbdac..8fc66cda4a09 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -888,8 +888,8 @@ static struct nvmem_device *mtd_otp_nvmem_register(st=
ruct mtd_info *mtd,
> =20
>  	/* OTP nvmem will be registered on the physical device */
>  	config.dev =3D mtd->dev.parent;
> -	config.name =3D kasprintf(GFP_KERNEL, "%s-%s", dev_name(&mtd->dev), com=
patible);
> -	config.id =3D NVMEM_DEVID_NONE;
> +	config.name =3D compatible;
> +	config.id =3D NVMEM_DEVID_AUTO;
>  	config.owner =3D THIS_MODULE;
>  	config.type =3D NVMEM_TYPE_OTP;
>  	config.root_only =3D true;
> @@ -905,7 +905,6 @@ static struct nvmem_device *mtd_otp_nvmem_register(st=
ruct mtd_info *mtd,
>  		nvmem =3D NULL;
> =20
>  	of_node_put(np);
> -	kfree(config.name);
> =20
>  	return nvmem;
>  }


Thanks,
Miqu=C3=A8l
