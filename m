Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB19D55D369
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiF0GpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiF0GpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:45:10 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B603881;
        Sun, 26 Jun 2022 23:45:09 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o5iUW-00BVWd-7A; Mon, 27 Jun 2022 16:45:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jun 2022 14:45:00 +0800
Date:   Mon, 27 Jun 2022 14:45:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: sleep for less time when unregistering hwrng
Message-ID: <YrlR7O4roipJt4Nc@gondor.apana.org.au>
References: <YrYMqqqoK7HBAXgJ@zx2c4.com>
 <20220624204433.2371980-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624204433.2371980-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 24, 2022 at 10:44:33PM +0200, Jason A. Donenfeld wrote:
.
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 16f227b995e8..af1c1905bb7e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -513,8 +513,13 @@ static int hwrng_fillfn(void *unused)
>  			break;
>  
>  		if (rc <= 0) {
> -			pr_warn("hwrng: no data available\n");
> -			msleep_interruptible(10000);
> +			int i;
> +
> +			for (i = 0; i < 100; ++i) {
> +				if (kthread_should_stop() ||
> +				    msleep_interruptible(10000 / 100))
> +					goto out;
> +			}

Please use schedule_timeout_interruptible.  But if you're going
to make it interruptible it should probably at least try to do
something about signals rather than just ignore them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
