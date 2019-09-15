Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF18B31F3
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfIOUQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 16:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfIOUQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 16:16:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F5D214AF;
        Sun, 15 Sep 2019 20:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568578610;
        bh=d/HrE/iGcEqOEmCdLte6zzmoLMwAvKRRiPAXELWKn3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPq2joGQ2Try6Oplud7Geb+58heA5O9WPpaFV+TgsTLEdLYxZJtAWLKcnE5WvUcgY
         51KdN4G0BdcTMn14Z9pd/5PzdnnYrnnj2ZYSQecLJdj/ECyqpPSRa2m6rBwH22i8jU
         od3ywG3yXgqXps+9ze5whibROFPS8x+liH1IgW64=
Date:   Sun, 15 Sep 2019 13:16:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: sun4i-ss: erase key after use
Message-ID: <20190915201648.GA1704@sol.localdomain>
Mail-Followup-To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        stable@vger.kernel.org
References: <20190915183536.3835-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915183536.3835-1-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 15, 2019 at 08:35:36PM +0200, Corentin Labbe wrote:
> When a TFM is unregistered, the sun4i-ss driver does not clean the key used,
> leaking it in memory.
> This patch adds this absent key cleaning.
> 
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org> # 4.3+
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> index fa4b1b47822e..60d99370a4ec 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -503,6 +503,8 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
>  void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
>  {
>  	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
> +
> +	memzero_explicit(op->key, op->keylen);
>  	crypto_free_sync_skcipher(op->fallback_tfm);
>  }
>  
> -- 
> 2.21.0
> 

It's already zeroed by the kzfree() in crypto_destroy_tfm().

- Eric
