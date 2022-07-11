Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C656D322
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 04:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiGKC61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 22:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKC61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 22:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EED183B2;
        Sun, 10 Jul 2022 19:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41CE610A5;
        Mon, 11 Jul 2022 02:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52FEC3411E;
        Mon, 11 Jul 2022 02:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657508305;
        bh=mmzu+3RIbbjsvsQseQSuOMNS9081b8ihQtLBFtiaV1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzZ6hq/CRotSlIG+f0arkyNzb7WiXnBJzvAMHuWRRWmOGNXfQlY7pwpiHfKeuf5Z8
         Teu6DUIpqLMMNseMOQE06CmlLm2U8FLkLV7eZcW7k3bsy7cWQJ8Unfp98rwFTJGZEk
         vqtgUC4WuakddfS83+qbHBpvuN04Y0sag2UzK6WLkzxYZEjtmarOwbCwfOpuiFDCbU
         P7yrgahApOBw0pIU1Ts59pns2O+YXyeqLremrQNz4za5Omuz/X0HhoSDeHEy+q81Rn
         ASk+hOP9LkCncwlJWhXN2zGzzs+GYa8xOuoP+UJYttruqYneXXTSOePYZ9ydSuC4dm
         1BUtvysP2ylKA==
Date:   Mon, 11 Jul 2022 05:58:20 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Chen Jun <chenjun102@huawei.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: Hold locality open during probe
Message-ID: <YsuRzGBss/lMG2+W@kernel.org>
References: <20220706164043.417780-1-jandryuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706164043.417780-1-jandryuk@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 06, 2022 at 12:40:43PM -0400, Jason Andryuk wrote:
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
>  drivers/char/tpm/tpm_tis_core.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index dc56b976d816..529c241800c0 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -986,8 +986,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  		goto out_err;
>  	}
>  
> +	/* Grabs locality 0. */
> +	rc = tpm_chip_start(chip);
> +	if (rc)
> +		goto out_err;
> +
>  	/* Take control of the TPM's interrupt hardware and shut it off */
> -	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
> +	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(chip->locality), &intmask);
>  	if (rc < 0)
>  		goto out_err;
>  
> @@ -995,19 +1000,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
>  	intmask &= ~TPM_GLOBAL_INT_ENABLE;
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
>  	rc = tpm2_probe(chip);
> +	/* Releases locality 0. */
>  	tpm_chip_stop(chip);
>  	if (rc)
>  		goto out_err;
> -- 
> 2.36.1
> 

Can you test against

https://lore.kernel.org/linux-integrity/20220629232653.1306735-1-LinoSanfilippo@gmx.de/T/#t

BR, Jarkko
