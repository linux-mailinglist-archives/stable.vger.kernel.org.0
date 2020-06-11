Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433AE1F6773
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgFKMH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 08:07:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:10467 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgFKMH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 08:07:29 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49jMzw5tJJz9v0md;
        Thu, 11 Jun 2020 14:07:24 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Yi22RzctTf1T; Thu, 11 Jun 2020 14:07:24 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49jMzw55Ymz9v0mc;
        Thu, 11 Jun 2020 14:07:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8A7B18B851;
        Thu, 11 Jun 2020 14:07:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id dffyQCk4gfMz; Thu, 11 Jun 2020 14:07:26 +0200 (CEST)
Received: from [10.25.210.22] (po15451.idsi0.si.c-s.fr [10.25.210.22])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5D7A58B850;
        Thu, 11 Jun 2020 14:07:26 +0200 (CEST)
Subject: Re: [PATCH V2] crypto: talitos - fix ECB and CBC algs ivsize
To:     Su Kang Yin <cantona@cantona.net>, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, christophe.leroy@c-s.fr,
        stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <cantona@cantona.net> <20200611115048.21677-1-cantona@cantona.net>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b7a3e181-5bf1-0040-bbd9-e262fddee57e@csgroup.eu>
Date:   Thu, 11 Jun 2020 14:07:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611115048.21677-1-cantona@cantona.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 11/06/2020 à 13:50, Su Kang Yin a écrit :
> commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> 
> This restore the CBC algs original ivsize of removes ECB's ones.
> 
> Fixes: e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> Signed-off-by: Su Kang Yin <cantona@cantona.net>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> Patch for 4.9 upstream.
> ---
>   drivers/crypto/talitos.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 8b383d3d21c2..059c2d4ad18f 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2631,17 +2631,16 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_name = "ecb(aes)",
>   			.cra_driver_name = "ecb-aes-talitos",
>   			.cra_blocksize = AES_BLOCK_SIZE,
>   			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>   				     CRYPTO_ALG_ASYNC,
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> -				.ivsize = AES_BLOCK_SIZE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>   				     DESC_HDR_SEL0_AESU,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>   		.alg.crypto = {
>   			.cra_name = "cbc(aes)",
> @@ -2665,16 +2664,17 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_name = "ctr(aes)",
>   			.cra_driver_name = "ctr-aes-talitos",
>   			.cra_blocksize = 1,
>   			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>   				     CRYPTO_ALG_ASYNC,
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> +				.ivsize = AES_BLOCK_SIZE,
>   				.setkey = ablkcipher_aes_setkey,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
>   				     DESC_HDR_SEL0_AESU |
>   				     DESC_HDR_MODE0_AESU_CTR,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
> 
