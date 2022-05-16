Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFEC528D44
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 20:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbiEPSke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 14:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbiEPSke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 14:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959913E5DF;
        Mon, 16 May 2022 11:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34AA36145D;
        Mon, 16 May 2022 18:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433D0C385AA;
        Mon, 16 May 2022 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652726431;
        bh=4Z8dljFEK+CxJQn6+iG6eW3CQq6VlhkH/Rc9gakRTF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tnjStv9U1eLgo1nSS3PCBMI6ILa+1wyiPymbjuZdJ+FV9bgRvbBzOYa4JtqjjD0qT
         MonodgTYXU5M0RYQh8sRn/BrNJseesEJtCLq495zUeQkBJPcml/zwu48KQzq7m3PR/
         6RN8XZ5EbrMVvPp4j9y18C+GqrYCs+9OYjOQQq5faOwwCZPOVcDeFA1+3+6Cu5gs84
         aOtgnf3ezxXgkBq+9ekFdHTOuPbcOdUWKG0v7YNufXtCVMBdhwTTYuam81kjGUpyAK
         GyXeglSRbESRwX6Q8mimoO7vK3JZUDSiDwO+vtBDmtPwc4EAV1xeB/1hvBVqlFU//J
         Z44McyAGwMahQ==
Date:   Mon, 16 May 2022 21:38:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de, jgg@ziepe.ca, jsnitsel@redhat.com,
        nayna@linux.vnet.ibm.com, alexander.steffen@infineon.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Message-ID: <YoKaQCIAscyFh7WM@kernel.org>
References: <20220513134152.270442-1-stefan.mahnke-hartmann@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513134152.270442-1-stefan.mahnke-hartmann@infineon.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 13, 2022 at 03:41:51PM +0200, Stefan Mahnke-Hartmann wrote:
> Under certain conditions uninitialized memory will be accessed.
> As described by TCG Trusted Platform Module Library Specification,
> rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
> requesting a capability, the TPM in field upgrade mode may return a
> zero length list.
> Check the property count in tpm2_get_tpm_pt().
> 
> Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
> ---
> Changelog:
>  * v2:
>    * Add inline comment to indicate the root cause to may access unitilized
>      memory.
>    * Change 'field upgrade mode' to lower case.
> 
>  drivers/char/tpm/tpm2-cmd.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 4704fa553098..04a3e23a4afc 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -400,7 +400,16 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  	if (!rc) {
>  		out = (struct tpm2_get_cap_out *)
>  			&buf.data[TPM_HEADER_SIZE];
> -		*value = be32_to_cpu(out->value);
> +		/*
> +		 * To prevent failing boot up of some systems, Infineon TPM2.0
> +		 * returns SUCCESS on TPM2_Startup in field upgrade mode. Also
> +		 * the TPM2_Getcapability command returns a zero length list
> +		 * in field upgrade mode.
> +		 */
> +		if (be32_to_cpu(out->property_cnt) > 0)
> +			*value = be32_to_cpu(out->value);
> +		else
> +			rc = -ENODATA;
>  	}
>  	tpm_buf_destroy(&buf);
>  	return rc;
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
