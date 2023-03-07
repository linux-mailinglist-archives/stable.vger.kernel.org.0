Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B46AF6F0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 21:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCGUuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 15:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjCGUt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 15:49:59 -0500
X-Greylist: delayed 114698 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 12:49:58 PST
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B2BAA736;
        Tue,  7 Mar 2023 12:49:58 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D95EC164F;
        Tue,  7 Mar 2023 21:49:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678222195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Np+MDOSSlpkp1Rq4TktNEvvAl/yCZYPzzy7E0o+mWh4=;
        b=qilZoms0NZPHL0qz3yLstROfQ647WdWOcVeyNYrmA0l1rqR03Kr8XiRnxpYme6E4Iu4t55
        3xEEblVp8PaSXiVu6QEh8fzFnSkHTy1uuk2XtPl9wBSi6e38vkSU2ciGhn06bEyFtEzSLG
        ghTREMXmOEgC4qIKdnqW/QrtQOT02/Fn0PvbkLzLp9Kx2lwK7uhek76ZE+NmnGVAgmiuwB
        Oc23TGhqY7qgt05kUz3AFNgCEAuUVwwadydQpims2y7SytcJQQjQ0zfANNoJpaQwFDPF3H
        M67DahwCBSEABxSzpCk5cCGS7OLSpr1obSAXl75vSlJK7D9Kx9FqgEW0d2TuBg==
MIME-Version: 1.0
Date:   Tue, 07 Mar 2023 21:49:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mtd: core: provide unique name for nvmem device, take
 two
In-Reply-To: <20230306125805.678668-1-michael@walle.cc>
References: <20230306125805.678668-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <b112b0b996e6f60140aff8944428dc2c@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miquel,

Am 2023-03-06 13:58, schrieb Michael Walle:
> Commit c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> tries to give the nvmem device a unique name, but fails badly if the 
> mtd
> device doesn't have a "struct device" associated with it, i.e. if
> CONFIG_MTD_PARTITIONED_MASTER is not set. This will result in the name
> "(null)-user-otp", which is not unique. It seems the best we can do is
> to use the compatible name together with a unique identifier added by
> the nvmem subsystem by using NVMEM_DEVID_AUTO.
> 
> Fixes: c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/mtd/mtdcore.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 0feacb9fbdac..3fe2825a85a1 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -888,8 +888,7 @@ static struct nvmem_device
> *mtd_otp_nvmem_register(struct mtd_info *mtd,
> 
>  	/* OTP nvmem will be registered on the physical device */
>  	config.dev = mtd->dev.parent;
> -	config.name = kasprintf(GFP_KERNEL, "%s-%s", dev_name(&mtd->dev), 
> compatible);
> -	config.id = NVMEM_DEVID_NONE;
> +	config.name = compatible;

Damn.. although the commit message says it using NVMEM_DEVID_AUTO,
this is missing here. :/

Since you already picked it, should I send a follow up patch or can
you just drop this patch and I'll resend it?

-michael

>  	config.owner = THIS_MODULE;
>  	config.type = NVMEM_TYPE_OTP;
>  	config.root_only = true;
> @@ -905,7 +904,6 @@ static struct nvmem_device
> *mtd_otp_nvmem_register(struct mtd_info *mtd,
>  		nvmem = NULL;
> 
>  	of_node_put(np);
> -	kfree(config.name);
> 
>  	return nvmem;
>  }
