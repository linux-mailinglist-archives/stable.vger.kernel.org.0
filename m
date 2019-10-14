Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7709D6283
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfJNM1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 08:27:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38521 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730036AbfJNM1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 08:27:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id y18so10044383wrn.5
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 05:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=74yP2FxtDtG0Yd27NaPGtt7r14yMghW+Jf1gUnHQp+s=;
        b=tCsg8/BIBUlbpsqZtroC38Z3Xjzi5BfqfCZK8nUVkrfZgMA0s9XJgV+XCKUHQmJjOS
         8Pre32L6bDLw6peIdTPsF58olTmJjhfivaBr++af5pNg/9+qjNmqfFEsf+IQ1VVBGLTp
         3vu3ao5P8ytuIY5jSQ9X092ZW907OQbpp12cVZE27MDFNsIU6zZ83XWUif/2BtXIthew
         dqIuGlLkB08XeQhgPsQGDzuyuThKrY+xZTnpQJWnRnTvGZUQpERVY9XUJWusSXhKRreX
         kB/QTrjqhDPHiAUIfDeBzC+yW3dlxPfbX7x3X9572K/XH0SqNvjTaqEVlmdnNy2Z6KXR
         YNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=74yP2FxtDtG0Yd27NaPGtt7r14yMghW+Jf1gUnHQp+s=;
        b=J1krto/q0YbDxNgiAPeSe0iAxi2ELJPSo+/JlJ9tNYtIcOTdj74FuuiwOEFWnb5Lcg
         pebnld8W/wJkCXVfir8wiHz2evyJ7O2j8jrhQxFLc33HpxsfGV1vg+kQpvDoynjDubqc
         gVZQmcROHrpXtUJb+FlBVn4wKS2iSKC6LM+vXWHbZIhPdVF6Ba1oJV6apmBdWvPMGVO0
         3zTMerMflE44ZXgoJbAu6lPPWjtuOzXVOYIaZBSOXCeXSL3ijYBll+JwVPnN7jag8Wp9
         TNZNkqmbG8IAkoXtX689oYqi6H8br3q8zI2wiLilHf5+QgYIjYY2BERVTa57sGKefIYA
         UE6Q==
X-Gm-Message-State: APjAAAWLMeOcMkpMi4VzQn7OwMK6aCdnAm3QmsR9+bu/wyGJNujEwjW1
        pOaC5P0/5AD9nZGMoQ+pi84jQQ==
X-Google-Smtp-Source: APXvYqxxzyIg26hZjfXLFi87SCcAcVzu4Z2f8d7+IbSXeAsrXFC5DtJECFz6xeg5J3k8zXF/jzmTZQ==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr25686239wrs.384.1571056055517;
        Mon, 14 Oct 2019 05:27:35 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id u26sm18054666wrd.87.2019.10.14.05.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:27:34 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:27:32 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-crypto@vger.kernel.org, dsaxena@plexity.net,
        herbert@gondor.apana.org.au, mpm@selenic.com,
        romain.perier@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, ralph.siemsen@linaro.org,
        milan.stevanovic@se.com, ryan.harkin@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Fix RNG wait loop timeout
Message-ID: <20191014122732.d6ow5tbko5xdwd7g@holly.lan>
References: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:32:45PM +0530, Sumit Garg wrote:
> Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
> data rate which takes approx. 700us to produce 16 bytes of output data
> as per testing results. So configure the timeout as 1000us to also take
> account of lack of udelay()'s reliability.

What "lack of udelay()'s reliability" are you concerned about?


Daniel.

> 
> Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/char/hw_random/omap-rng.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index b27f396..e329f82 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -66,6 +66,13 @@
>  #define OMAP4_RNG_OUTPUT_SIZE			0x8
>  #define EIP76_RNG_OUTPUT_SIZE			0x10
>  
> +/*
> + * EIP76 RNG takes approx. 700us to produce 16 bytes of output data
> + * as per testing results. And to account for the lack of udelay()'s
> + * reliability, we keep the timeout as 1000us.
> + */
> +#define RNG_DATA_FILL_TIMEOUT			100
> +
>  enum {
>  	RNG_OUTPUT_0_REG = 0,
>  	RNG_OUTPUT_1_REG,
> @@ -176,7 +183,7 @@ static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
>  	if (max < priv->pdata->data_size)
>  		return 0;
>  
> -	for (i = 0; i < 20; i++) {
> +	for (i = 0; i < RNG_DATA_FILL_TIMEOUT; i++) {
>  		present = priv->pdata->data_present(priv);
>  		if (present || !wait)
>  			break;
> -- 
> 2.7.4
> 
