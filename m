Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF5586F03
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiHAQu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiHAQuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 12:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3268611809;
        Mon,  1 Aug 2022 09:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D87B7B815AB;
        Mon,  1 Aug 2022 16:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C446C433D7;
        Mon,  1 Aug 2022 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659372648;
        bh=JfFD7gSZ+NQJfP6dqs4qpKB1DvnASqty13HHPdaYeOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+b8UjKYX+T4BG5oHMytKVkdvT2C+FNtmgoTx/MloDWyxXs35mS2B+Uqg59x0MwEt
         D8xQKOC20iE92uRYMrInkx6pTy9big5IGZ+LerGkVALQz6wfPxjKual6v4AiZcuJL1
         E+hw9IIuHeNbZNypeaAG9PGImmqir1kmprcQV9GCb4uwj1E2OistxXN77tFO6xXvRv
         EWYI4QwoSpqrT3iddxsjNlHyd6NrYstymVNpszG0KrY1P/2yxF66ranJ5w3aJ1RvqK
         bD/QRNCi7zQvBmQdWGra5GpepRBMm5K8JCxy4pAXtKYc9a5cJVLTKWJWtlLU5WeCu7
         VUMR1l00UjfJw==
Date:   Mon, 1 Aug 2022 19:50:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     =?iso-8859-1?Q?M=E5rten?= Lindahl <marten.lindahl@axis.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, kernel@axis.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: Add check for Failure mode for TPM2 modules
Message-ID: <YugEY6Wec3DpW9o2@kernel.org>
References: <20220801135703.26754-1-marten.lindahl@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220801135703.26754-1-marten.lindahl@axis.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 03:57:03PM +0200, Mårten Lindahl wrote:
> In commit 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for
> TPM2 modules") it was said that:
> 
> "If the TPM is in Failure mode, it will successfully respond to both
> tpm2_do_selftest() and tpm2_startup() calls. Although, will fail to
> answer to tpm2_get_cc_attrs_tbl(). Use this fact to conclude that TPM
> is in Failure mode."
> 
> But a check was never added in the commit when calling
> tpm2_get_cc_attrs_tbl() to conclude that the TPM is in Failure mode.
> This commit corrects this by adding a check.
> 
> Fixes: 0aa698787aa2 ("tpm: Add Upgrade/Reduced mode support for TPM2 modules")
> Cc: stable@vger.kernel.org # v5.17+
> Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> 
> v4:
>  - Resend of patch because of invalid characters in Signed-off-by tag.
> 
> v3:
>  - Add Jarkkos Reviewed-by tag.
>  - Add Fixes tag and Cc.
> 
> v2:
>  - Add missed check for TPM error code.
> 
>  drivers/char/tpm/tpm2-cmd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index c1eb5d223839..65d03867e114 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -752,6 +752,12 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  	}
>  
>  	rc = tpm2_get_cc_attrs_tbl(chip);
> +	if (rc == TPM2_RC_FAILURE || (rc < 0 && rc != -ENOMEM)) {
> +		dev_info(&chip->dev,
> +			 "TPM in field failure mode, requires firmware upgrade\n");
> +		chip->flags |= TPM_CHIP_FLAG_FIRMWARE_UPGRADE;
> +		rc = 0;
> +	}
>  
>  out:
>  	/*
> -- 
> 2.30.2
> 

Thank you, applied.

BR, Jarkko
