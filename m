Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4756D318
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 04:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGKCwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 22:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKCwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 22:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6082214D30;
        Sun, 10 Jul 2022 19:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 136C5B80AB1;
        Mon, 11 Jul 2022 02:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F1C3411E;
        Mon, 11 Jul 2022 02:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657507936;
        bh=rtRAmVZEp9dj+8QygihKY0XW9o1Kp3uAF6UYhqtKaTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uf2uYxA7bqVJllFAhJHoa5h35uD3EAZoKHaaXNlxhBEn5OlerMMuPzP/4WIxxMfLt
         xYD2/Ag7SQdK2GfU2lcpyBytfy/vrSxzJQWstyxn9ZXpZ6pekkmvmV4FH1E5ecZyZC
         vE1kr0sdrn629pzTV5GYBmlcGN5IUzkd5Ur8t13/JcRZP2rXu/2I2wGZFbnyDTJL+U
         IBZXU7m/u3MC1nepbDox0HrfjGhF32/HMAR4u4TpipVrwn3zZYkSlywA8AU+/6eFMC
         JJzDGAuXNqnAQLYYIoFIS7Hrj4NyrPOYAkhueZOfHU8c3d7d4c8vctz60cjDyVDcWm
         YwX8OIQxo78eA==
Date:   Mon, 11 Jul 2022 05:52:11 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     M??rten Lindahl <marten.lindahl@axis.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, kernel@axis.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] tpm: Add check for Failure mode for TPM2 modules
Message-ID: <YsuQW/N/lMtFT1U6@kernel.org>
References: <20220705132423.232603-1-marten.lindahl@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705132423.232603-1-marten.lindahl@axis.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 03:24:23PM +0200, M??rten Lindahl wrote:
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
> Signed-off-by: M??rten Lindahl <marten.lindahl@axis.com>

The characters here are messed up.

> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
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

BR, Jarkko
