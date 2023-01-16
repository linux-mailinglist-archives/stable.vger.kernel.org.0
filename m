Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CAE66BD1B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 12:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjAPLoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 06:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjAPLo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 06:44:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15095582;
        Mon, 16 Jan 2023 03:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E475B80E70;
        Mon, 16 Jan 2023 11:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2C6C433F1;
        Mon, 16 Jan 2023 11:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673869464;
        bh=9+uZv8oHcvfhkUpzF32aFk09PFUDyRPKW4MrKkXFNU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OoC16Iu9Igo/uCtnzEL4nSzQlvs+o95rqrEoaryft5+sIJ79dXHMrGwtcWBGDbyqj
         FtdmcIWevSqpzLbBhMLlR3rL6J4KhdTiCcYQOLCRQhiq54YoeNVfHwWYsPLREopsr1
         MLSN9DDmPqZkP/6xihGQUyQwBgNp5eFjxG3JDC4PnreOXSMoJjTrIItT/3ZtNhNqw8
         9BpC+X9Yl18HFBWnXi4h0k5Mh0f9qPTsvCe9JskCi9t4jy1sfl6X6hsgeYZxUdCQgV
         5UDfbT4yRK0tIzIe+DM1qt+Zz2IWCIXSUiSV9MTqGxQjYan1F15W26UlkO8ttbVd1o
         l5H2T6jAkuzNw==
Date:   Mon, 16 Jan 2023 13:44:19 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM
 suspend fails
Message-ID: <Y8U4kwTPpMet13Ks@kernel.org>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
 <20230106030156.3258307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106030156.3258307-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 04:01:56AM +0100, Jason A. Donenfeld wrote:
> TPM 1 is sometimes broken across system suspends, due to races or
> locking issues or something else that haven't been diagnosed or fixed
> yet, most likely having to do with concurrent reads from the TPM's
> hardware random number generator driver. These issues prevent the system
> from actually suspending, with errors like:
> 
>   tpm tpm0: A TPM error (28) occurred continue selftest
>   ...

<REMOVE>

>   tpm tpm0: A TPM error (28) occurred attempting get random
>   ...
>   tpm tpm0: Error (28) sending savestate before suspend
>   tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
>   tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
>   tpm_tis 00:08: PM: failed to suspend: error 28
>   PM: Some devices failed to suspend, or early wake event detected

</REMOVE>

Unrelated to thix particular fix.

> This issue was partially fixed by 23393c646142 ("char: tpm: Protect
> tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
> directly because the TPM maintainers weren't available. However, it
> seems like this just addresses the most common cases of the bug, rather
> than addressing it entirely. So there are more things to fix still,
> apparently.
> 
> In lieu of actually fixing the underlying bug, just allow system suspend
> to continue, so that laptops still go to sleep fine. Later, this can be
> reverted when the real bug is fixed.
> 
> Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
> Cc: stable@vger.kernel.org # 6.1+
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> This is basically untested and I haven't worked out if there are any
> awful implications of letting the system sleep when TPM suspend fails.
> Maybe some PCRs get cleared and that will make everything explode on
> resume? Maybe it doesn't matter? Somebody well versed in TPMology should
> probably [n]ack this approach.
> 
>  drivers/char/tpm/tpm-interface.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index d69905233aff..6df9067ef7f9 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -412,7 +412,10 @@ int tpm_pm_suspend(struct device *dev)
>  	}
>  
>  suspended:
> -	return rc;
> +	if (rc)
> +		pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
> +		       chip->dev_num, rc);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
>  
> -- 
> 2.39.0
> 

This tpm_tis local issue, nothing to do with tpm_pm_suspend(). Executing
the selftest as part of wake up, is TPM 1.2 dTPM specific requirement, and
the call is located in tpm_tis_resume() [*].

[*] https://lore.kernel.org/lkml/Y8U1QxA4GYvPWDky@kernel.org/

BR, Jarkko
