Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4804569C26
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 09:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiGGHtK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 7 Jul 2022 03:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbiGGHsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 03:48:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D50232EEC;
        Thu,  7 Jul 2022 00:48:42 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LdpRW5bldz1DDRG;
        Thu,  7 Jul 2022 15:47:51 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 15:48:40 +0800
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500008.china.huawei.com (7.185.36.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 15:48:40 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Thu, 7 Jul 2022 15:48:40 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Jason Andryuk <jandryuk@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm_tis: Hold locality open during probe
Thread-Topic: [PATCH] tpm_tis: Hold locality open during probe
Thread-Index: AQHYkVc7QBSxEshmGkyZ5C0kkbOHTA==
Date:   Thu, 7 Jul 2022 07:48:40 +0000
Message-ID: <5687473ad4da4c26a85b6d230cfc011a@huawei.com>
References: <20220706164043.417780-1-jandryuk@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.43]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/7/7 0:41, Jason Andryuk 写道:
> WEC TPMs (in 1.2 mode) and NTC (in 2.0 mode) have been observer to
> frequently, but intermittently, fail probe with:
> tpm_tis: probe of 00:09 failed with error -1
> 
> Added debugging output showed that the request_locality in
> tpm_tis_core_init succeeds, but then the tpm_chip_start fails when its
> call to tpm_request_locality -> request_locality fails.
> 
> The access register in check_locality would show:
> 0x80 TPM_ACCESS_VALID
> 0x82 TPM_ACCESS_VALID | TPM_ACCESS_REQUEST_USE
> 0x80 TPM_ACCESS_VALID
> continuing until it times out. TPM_ACCESS_ACTIVE_LOCALITY (0x20) doesn't
> get set which would end the wait.
> 
> My best guess is something racy was going on between release_locality's
> write and request_locality's write.  There is no wait in
> release_locality to ensure that the locality is released, so the
> subsequent request_locality could confuse the TPM?
> 
> tpm_chip_start grabs locality 0, and updates chip->locality.  Call that
> before the TPM_INT_ENABLE write, and drop the explicit request/release
> calls.  tpm_chip_stop performs the release.  With this, we switch to
> using chip->locality instead of priv->locality.  The probe failure is
> not seen after this.
> 
> commit 0ef333f5ba7f ("tpm: add request_locality before write
> TPM_INT_ENABLE") added a request_locality/release_locality pair around
> tpm_tis_write32 TPM_INT_ENABLE, but there is a read of
> TPM_INT_ENABLE for the intmask which should also have the locality
> grabbed.  tpm_chip_start is moved before that to have the locality open
> during the read.
> 
> Fixes: 0ef333f5ba7f ("tpm: add request_locality before write TPM_INT_ENABLE")

0ef333f5ba7f is probably not the commit that introduced the problem? As 
you said the problem was in 5.4 and the commit was merged in 5.16.

> CC: stable@vger.kernel.org
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> ---
> The probe failure was seen on 5.4, 5.15 and 5.17.
> 
> commit e42acf104d6e ("tpm_tis: Clean up locality release") removed the
> release wait.  I haven't tried, but re-introducing that would probably
> fix this issue.  It's hard to know apriori when a synchronous wait is
> needed, and they don't seem to be needed typically.  Re-introducing the
> wait would re-introduce a wait in all cases.
> 
> Surrounding the read of TPM_INT_ENABLE with grabbing the locality may
> not be necessary?  It looks like the code only grabs a locality for
> writing, but that asymmetry is surprising to me.
> 
> tpm_chip and tpm_tis_data track the locality separately.  Should the
> tpm_tis_data one be removed so they don't get out of sync?
> ---
>   drivers/char/tpm/tpm_tis_core.c | 20 ++++++++------------
>   1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index dc56b976d816..529c241800c0 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -986,8 +986,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>   		goto out_err;
>   	}
>   
> +	/* Grabs locality 0. */
> +	rc = tpm_chip_start(chip);
> +	if (rc)
> +		goto out_err;
> +
>   	/* Take control of the TPM's interrupt hardware and shut it off */
> -	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
> +	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(chip->locality), &intmask);
>   	if (rc < 0)
>   		goto out_err;
>   
> @@ -995,19 +1000,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>   		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
>   	intmask &= ~TPM_GLOBAL_INT_ENABLE;
>   
> -	rc = request_locality(chip, 0);
> -	if (rc < 0) {
> -		rc = -ENODEV;
> -		goto out_err;
> -	}
> -
> -	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
> -	release_locality(chip, 0);
> +	tpm_tis_write32(priv, TPM_INT_ENABLE(chip->locality), intmask);
>   
> -	rc = tpm_chip_start(chip);
> -	if (rc)
> -		goto out_err;
>   	rc = tpm2_probe(chip);
> +	/* Releases locality 0. */
>   	tpm_chip_stop(chip);
>   	if (rc)
>   		goto out_err;
> 


-- 
Regards
Chen Jun
