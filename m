Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007156569A2
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 11:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiL0Kwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 05:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiL0Kwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 05:52:39 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6471E3;
        Tue, 27 Dec 2022 02:52:37 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NhBB91s4Sz9xHvM;
        Tue, 27 Dec 2022 18:45:05 +0800 (CST)
Received: from [10.48.132.132] (unknown [10.48.132.132])
        by APP1 (Coremail) with SMTP id LxC2BwAXnAdPzqpjpWtJAA--.20242S2;
        Tue, 27 Dec 2022 11:52:13 +0100 (CET)
Message-ID: <ab3b1aee-2140-2899-f37e-8f71ea67ea20@huaweicloud.com>
Date:   Tue, 27 Dec 2022 11:51:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
References: <20221227094632.2797203-1-roberto.sassu@huaweicloud.com>
 <20221227094632.2797203-2-roberto.sassu@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <20221227094632.2797203-2-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwAXnAdPzqpjpWtJAA--.20242S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWfuF18KFWfWr48GF17KFg_yoWrAw4xpF
        Z8WrWUKry5Jrn2krZxCa18t3yrA3y8A3Wagw4fJw13CrnxZrWkGry29r47Wry7JrykXry8
        tr4kWws5Wr1DXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
        WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU13rcDUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4MKCgACsl
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/27/2022 10:46 AM, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> mapping") checks that both the signature and the digest reside in the
> linear mapping area.
> 
> However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> stack support"), made it possible to move the stack in the vmalloc area,
> which is not contiguous, and thus not suitable for sg_set_buf() which needs
> adjacent pages.
> 
> Always make a copy of the signature and digest in the same buffer used to
> store the key and its parameters, and pass them to sg_set_buf(). Prefer it
> to conditionally doing the copy if necessary, to keep the code simple. The
> buffer allocated with kmalloc() is in the linear mapping area.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>   crypto/asymmetric_keys/public_key.c | 39 ++++++++++++++++-------------
>   1 file changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 2f8352e88860..a479e32cb280 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -360,9 +360,10 @@ int public_key_verify_signature(const struct public_key *pkey,
>   	struct crypto_wait cwait;
>   	struct crypto_akcipher *tfm;
>   	struct akcipher_request *req;
> -	struct scatterlist src_sg[2];
> +	struct scatterlist src_sg;
>   	char alg_name[CRYPTO_MAX_ALG_NAME];
> -	char *key, *ptr;
> +	char *buf, *ptr;
> +	size_t buf_len;
>   	int ret;
>   
>   	pr_devel("==>%s()\n", __func__);
> @@ -400,34 +401,38 @@ int public_key_verify_signature(const struct public_key *pkey,
>   	if (!req)
>   		goto error_free_tfm;
>   
> -	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> -		      GFP_KERNEL);
> -	if (!key)
> +	buf_len = max_t(size_t, pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> +			sig->s_size + sig->digest_size);
> +
> +	buf = kmalloc(buf_len, GFP_KERNEL);
> +	if (!buf)
>   		goto error_free_req;
>   
> -	memcpy(key, pkey->key, pkey->keylen);
> -	ptr = key + pkey->keylen;
> +	memcpy(buf, pkey->key, pkey->keylen);
> +	ptr = buf + pkey->keylen;
>   	ptr = pkey_pack_u32(ptr, pkey->algo);
>   	ptr = pkey_pack_u32(ptr, pkey->paramlen);
>   	memcpy(ptr, pkey->params, pkey->paramlen);
>   
>   	if (pkey->key_is_private)
> -		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
> +		ret = crypto_akcipher_set_priv_key(tfm, buf, pkey->keylen);
>   	else
> -		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
> +		ret = crypto_akcipher_set_pub_key(tfm, buf, pkey->keylen);
>   	if (ret)
> -		goto error_free_key;
> +		goto error_free_buf;
>   
>   	if (strcmp(pkey->pkey_algo, "sm2") == 0 && sig->data_size) {
>   		ret = cert_sig_digest_update(sig, tfm);
>   		if (ret)
> -			goto error_free_key;
> +			goto error_free_buf;
>   	}
>   
> -	sg_init_table(src_sg, 2);
> -	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> -	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
> -	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
> +	memcpy(buf, sig->s, sig->s_size);
> +	memcpy(buf + sig->s_size, sig->digest, sig->digest_size);
> +
> +	sg_init_table(&src_sg, 1);
> +	sg_set_buf(&src_sg, buf, sig->s_size + sig->digest_size);

Ops, didn't commit the changes. Will send a new version soon.

Roberto

> +	akcipher_request_set_crypt(req, &src_sg, NULL, sig->s_size,
>   				   sig->digest_size);
>   	crypto_init_wait(&cwait);
>   	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> @@ -435,8 +440,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>   				      crypto_req_done, &cwait);
>   	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
>   
> -error_free_key:
> -	kfree(key);
> +error_free_buf:
> +	kfree(buf);
>   error_free_req:
>   	akcipher_request_free(req);
>   error_free_tfm:

