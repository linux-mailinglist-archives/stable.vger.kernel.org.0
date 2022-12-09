Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BE06483C2
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 15:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLIO2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 09:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIO2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 09:28:08 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B821DF1C;
        Fri,  9 Dec 2022 06:28:02 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NTCqM4hgPz9v7Gn;
        Fri,  9 Dec 2022 22:20:47 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwD343DORZNjNjDSAA--.62266S2;
        Fri, 09 Dec 2022 15:27:36 +0100 (CET)
Message-ID: <8ec1fb8eddf209a4f6b10bb3575334510f100c41.camel@huaweicloud.com>
Subject: Re: [PATCH] KEYS: asymmetric: Make a copy of sig and digest in
 vmalloced stack
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 09 Dec 2022 15:27:23 +0100
In-Reply-To: <3f1c74f320a288b6581241fc3039103cbcee7b27.camel@huaweicloud.com>
References: <20221208164610.867747-1-roberto.sassu@huaweicloud.com>
         <Y5JwpdGF50oFKw0z@sol.localdomain>
         <3f1c74f320a288b6581241fc3039103cbcee7b27.camel@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwD343DORZNjNjDSAA--.62266S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1xAr1UZF4UKFy5JF15twb_yoW5uF48pa
        95WF4DtFWUKr1UCr12v3WxKw1jyw1jkF129w4rAw15Crn0vryxC3y0kr45WF93Jr4kXFyx
        trW8WwsxZFn8XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
        AIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbG2NtUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQABBF1jj4Z3zQAAsJ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-12-09 at 15:15 +0100, Roberto Sassu wrote:
> On Thu, 2022-12-08 at 15:17 -0800, Eric Biggers wrote:
> > On Thu, Dec 08, 2022 at 05:46:10PM +0100, Roberto Sassu wrote:
> > > diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> > > index 2f8352e88860..307799ffbc3e 100644
> > > --- a/crypto/asymmetric_keys/public_key.c
> > > +++ b/crypto/asymmetric_keys/public_key.c
> > > @@ -363,7 +363,8 @@ int public_key_verify_signature(const struct public_key *pkey,
> > >  	struct scatterlist src_sg[2];
> > >  	char alg_name[CRYPTO_MAX_ALG_NAME];
> > >  	char *key, *ptr;
> > > -	int ret;
> > > +	char *sig_s, *digest;
> > > +	int ret, verif_bundle_len;
> > >  
> > >  	pr_devel("==>%s()\n", __func__);
> > >  
> > > @@ -400,8 +401,21 @@ int public_key_verify_signature(const struct public_key *pkey,
> > >  	if (!req)
> > >  		goto error_free_tfm;
> > >  
> > > -	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> > > -		      GFP_KERNEL);
> > > +	verif_bundle_len = pkey->keylen + sizeof(u32) * 2 + pkey->paramlen;
> > > +
> > > +	sig_s = sig->s;
> > > +	digest = sig->digest;
> > > +
> > > +	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > > +		if (!virt_addr_valid(sig_s))
> > > +			verif_bundle_len += sig->s_size;
> > > +
> > > +		if (!virt_addr_valid(digest))
> > > +			verif_bundle_len += sig->digest_size;
> > > +	}
> > > +
> > > +	/* key points to a buffer which could contain the sig and digest too. */
> > > +	key = kmalloc(verif_bundle_len, GFP_KERNEL);
> > >  	if (!key)
> > >  		goto error_free_req;
> > >  
> > > @@ -424,9 +438,24 @@ int public_key_verify_signature(const struct public_key *pkey,
> > >  			goto error_free_key;
> > >  	}
> > >  
> > > +	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > > +		ptr += pkey->paramlen;
> > > +
> > > +		if (!virt_addr_valid(sig_s)) {
> > > +			sig_s = ptr;
> > > +			memcpy(sig_s, sig->s, sig->s_size);
> > > +			ptr += sig->s_size;
> > > +		}
> > > +
> > > +		if (!virt_addr_valid(digest)) {
> > > +			digest = ptr;
> > > +			memcpy(digest, sig->digest, sig->digest_size);
> > > +		}
> > > +	}
> > > +
> > >  	sg_init_table(src_sg, 2);
> > > -	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> > > -	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
> > > +	sg_set_buf(&src_sg[0], sig_s, sig->s_size);
> > > +	sg_set_buf(&src_sg[1], digest, sig->digest_size);
> > >  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
> > >  				   sig->digest_size);
> > >  	crypto_init_wait(&cwait);
> > 
> > We should try to avoid adding error-prone special cases.  How about just doing
> > the copy of the signature and digest unconditionally?  That would be much
> > simpler.  It would even mean that the scatterlist would only need one element.
> 
> Took some time to figure out why Redzone was overwritten.
> 
> There must be two separate scatterlists. If you set the first only with
> the sum of the key length and digest length, mpi_read_raw_from_sgl()

Of signature length and digest length.

Roberto

> called by rsa_enc() is going to write before the d pointer in MPI.
> 
> 		for (x = 0; x < len; x++) {
> 			a <<= 8;
> 			a |= *buff++;
> 			if (((z + x + 1) % BYTES_PER_MPI_LIMB) == 0) {
> 				val->d[j--] = a;
> 				a = 0;
> 			}
> 		}
> 
> Roberto
> 
> > Also, the size of buffer needed is only
> > 
> > 	max(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> > 	    sig->s_size + sig->digest_size)
> > 
> > ... since the signature and digest aren't needed until the key was already used.
> > 
> > - Eric

