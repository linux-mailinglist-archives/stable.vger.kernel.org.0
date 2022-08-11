Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8EC58F728
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 07:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiHKFCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 01:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiHKFCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 01:02:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65E67CB58;
        Wed, 10 Aug 2022 22:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9950DB81EF2;
        Thu, 11 Aug 2022 05:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0779AC433D6;
        Thu, 11 Aug 2022 05:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660194128;
        bh=sbr+S4YokhI1iJOsvmS4oDGxcnii+dV1h5gl6Iw/AfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NIeyuwHhlTo61IVf8eg9iytmLr2lKh3mKMzrSG5fMwp+fI9MZKC76CbHxxDyKzlYB
         BTsI72wfs9ugBB1cJ1phGLPFLsUSwAIpGcBk/k60FFZxJ8jzBgxvWAToQV5C6R45m1
         GC3lqoIg3kQmaxa+ghwiQ+DKLaAdYkpmIkvGcHLMBBeIyTbS12vgiCcejm0Uh/u/lG
         Ay7ZROaP8ZQHpc9108+U2VArdjDpLFEAdqs1jB59+FpWGGbCmgJvlkJtRa+Yk189c9
         5GqKRKo608Y4i4W1qDAtcGI4dMA1oCJ/K3p0i4spuzbtFtWlQ0AC3ERJtb7nz7EacH
         J7njQnuooYIPg==
Date:   Thu, 11 Aug 2022 08:02:02 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sven van Ashbrook <svenva@chromium.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Hao Wu <hao.wu@rubrik.com>, Yi Chou <yich@google.com>,
        Andrey Pronin <apronin@chromium.org>,
        James Morris <james.morris@microsoft.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix potential race condition in suspend/resume
Message-ID: <YvSNSs84wMRZ8Fa9@kernel.org>
References: <20220809193921.544546-1-svenva@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809193921.544546-1-svenva@chromium.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 07:39:18PM +0000, Sven van Ashbrook wrote:
> Concurrent accesses to the tpm chip are prevented by allowing only a
> single thread at a time to obtain a tpm chip reference through
> tpm_try_get_ops(). However, the tpm's suspend function does not use
> this mechanism, so when the tpm api is called by a kthread which
> does not get frozen on suspend (such as the hw_random kthread)
> it's possible that the tpm is used when already in suspend, or
> in use while in the process of suspending.
> 
> This is seen on certain ChromeOS platforms - low-probability warnings
> are generated during suspend. In this case, the tpm attempted to read data
> from a tpm chip on an already-suspended bus.
> 
>   i2c_designware i2c_designware.1: Transfer while suspended
> 
> Fix:
> 1. prevent concurrent execution of tpm accesses and suspend/
>    resume, by letting suspend/resume grab the tpm_mutex.
> 2. before commencing a tpm access, check if the tpm chip is already
>    suspended. Fail with -EAGAIN if so.
> 
> Tested by running 6000 suspend/resume cycles back-to-back on a
> ChromeOS "brya" device. The intermittent warnings reliably
> disappear after applying this patch. No system issues were observed.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: e891db1a18bf ("tpm: turn on TPM on suspend for TPM 1.x")
> Signed-off-by: Sven van Ashbrook <svenva@chromium.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 16 ++++++++++++++++
>  include/linux/tpm.h              |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 1621ce818705..16ca490fd483 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -82,6 +82,11 @@ static ssize_t tpm_try_transmit(struct tpm_chip *chip, void *buf, size_t bufsiz)
>  		return -E2BIG;
>  	}
>  
> +	if (chip->is_suspended) {
> +		dev_info(&chip->dev, "blocking transmit while suspended\n");
> +		return -EAGAIN;
> +	}
> +
>  	rc = chip->ops->send(chip, buf, count);
>  	if (rc < 0) {
>  		if (rc != -EPIPE)
> @@ -394,6 +399,8 @@ int tpm_pm_suspend(struct device *dev)
>  	if (!chip)
>  		return -ENODEV;
>  
> +	mutex_lock(&chip->tpm_mutex);
> +
>  	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
>  		goto suspended;
>  
> @@ -411,6 +418,11 @@ int tpm_pm_suspend(struct device *dev)
>  	}
>  
>  suspended:
> +	if (!rc)
> +		chip->is_suspended = true;
> +
> +	mutex_unlock(&chip->tpm_mutex);
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
> @@ -426,6 +438,10 @@ int tpm_pm_resume(struct device *dev)
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	mutex_lock(&chip->tpm_mutex);
> +	chip->is_suspended = false;
> +	mutex_unlock(&chip->tpm_mutex);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index d7c67581929f..0fbc1a43ae80 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -131,6 +131,8 @@ struct tpm_chip {
>  	int dev_num;		/* /dev/tpm# */
>  	unsigned long is_open;	/* only one allowed */
>  
> +	bool is_suspended;
> +
>  	char hwrng_name[64];
>  	struct hwrng hwrng;
>  
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 

What about adding TPM_CHIP_FLAG_SUSPENDED instead?

BR, Jarkko
