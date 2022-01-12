Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB548CB12
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356296AbiALSf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356295AbiALSf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:35:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DFFC06173F;
        Wed, 12 Jan 2022 10:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4839619FF;
        Wed, 12 Jan 2022 18:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB3BC36AE5;
        Wed, 12 Jan 2022 18:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642012526;
        bh=tR5cYmecoyO98RJuj0F+0SYvT7MUWJ1IrdeUSbPm5c8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tVXkyMo44DPuThg3+etMdPiKtsHEgk5EW6REFoIazT6KtZjfaTMsYYHZGV2LLp5J0
         PiAT8tOvCkp/Fhu2AfAzo3j5B2dPdFcWyZ47jQfXSrlS5DmDhPJd850uAPfUz0MaOB
         f2ICKV9/TM/PXXTy26JULoMRlCD361wcNnmDSS/aGAJpj6tNaqR+bNLhYiDGcXzOQB
         tyJfgFO6nyQenDbj92eww8zvFLjrBSo1DaPvVYPXD5imjt0fAniW3EX98r1RFfvKXL
         KxD4GlWlCGepG3nSKK0VLVMSLQCqK9IiiPQ+hZSmjQGmYhzXsibhjdsZfhyr2t2tJC
         JS8jm05kNnF2A==
Date:   Wed, 12 Jan 2022 20:35:15 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tstruk@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tpm: Fix error handling in async work
Message-ID: <Yd8fY/wixkXhXEFH@iki.fi>
References: <20220111055228.1830-1-tstruk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111055228.1830-1-tstruk@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 09:52:27PM -0800, Tadeusz Struk wrote:
> When an invalid (non existing) handle is used in a TPM command,
> that uses the resource manager interface (/dev/tpmrm0) the resource
> manager tries to load it from its internal cache, but fails and
> the tpm_dev_transmit returns an -EINVAL error to the caller.
> The existing async handler doesn't handle these error cases
> currently and the condition in the poll handler never returns
> mask with EPOLLIN set.
> The result is that the poll call blocks and the application gets stuck
> until the user_read_timer wakes it up after 120 sec.
> Change the tpm_dev_async_work function to handle error conditions
> returned from tpm_dev_transmit they are also reflected in the poll mask
> and a correct error code could passed back to the caller.
> 
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: <linux-integrity@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
> Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
> ---
> Changed in v2:
> - Updated commit message with better problem description
> - Fixed typeos.
> Changed in v3:
> - Added a comment to tpm_dev_async_work.
> - Updated commit message.
> ---
>  drivers/char/tpm/tpm-dev-common.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index c08cbb306636..50df8f09ff79 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -69,7 +69,13 @@ static void tpm_dev_async_work(struct work_struct *work)
>  	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
>  			       sizeof(priv->data_buffer));
>  	tpm_put_ops(priv->chip);
> -	if (ret > 0) {
> +
> +	/*
> +	 * If ret is > 0 then tpm_dev_transmit returned the size of the
> +	 * response. If ret is < 0 then tpm_dev_transmit failed and
> +	 * returned a return code.
> +	 */
> +	if (ret != 0) {
>  		priv->response_length = ret;
>  		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
>  	}
> -- 
> 2.30.2
> 

These look good to me! Thank you. I'm in process of compiling a test
kernel.

/Jarkko
