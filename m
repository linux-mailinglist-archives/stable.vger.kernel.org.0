Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081C82F41E2
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAMCkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 21:40:00 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54024 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbhAMCkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 21:40:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0ULZwVnh_1610505555;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0ULZwVnh_1610505555)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Jan 2021 10:39:16 +0800
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
References: <20210112161044.3101-1-toke@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <d7a50628-5559-a054-bc47-2d45746eb503@linux.alibaba.com>
Date:   Wed, 13 Jan 2021 10:39:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112161044.3101-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I have fixed this problem last week. Still thanks for your fixing.
patch is here: https://lkml.org/lkml/2021/1/7/201

Best regards,
Tianjia

On 1/13/21 12:10 AM, Toke Høiland-Jørgensen wrote:
> When public_key_verify_signature() is called from
> asymmetric_key_verify_signature(), the pkey_algo field of struct
> public_key_signature will be NULL, which causes a NULL pointer dereference
> in the strcmp() check. Fix this by adding a NULL check.
> 
> One visible manifestation of this is that userspace programs (such as the
> 'iwd' WiFi daemon) will be killed when trying to verify a TLS key using the
> keyctl(2) interface.
> 
> Cc: stable@vger.kernel.org
> Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   crypto/asymmetric_keys/public_key.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 8892908ad58c..35b09e95a870 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -356,7 +356,7 @@ int public_key_verify_signature(const struct public_key *pkey,
>   	if (ret)
>   		goto error_free_key;
>   
> -	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
> +	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
>   		ret = cert_sig_digest_update(sig, tfm);
>   		if (ret)
>   			goto error_free_key;
> 
