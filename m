Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87E36488C8
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiLITE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 14:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLITE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 14:04:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE373DF83;
        Fri,  9 Dec 2022 11:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA926230A;
        Fri,  9 Dec 2022 19:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0F6C433EF;
        Fri,  9 Dec 2022 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670612664;
        bh=yUWQOgEIaDmtTjkbKrKQhx+5Ioj4N+tSig1q86SSvhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLMnJl1PGg+JaRv9e0cov1W2dQSwupzZoGE56bhg8Hwg4PA3WcR5BIYhw7mVCEttj
         iGHhEdfj7hyfUZz2uSLQ2iEXhc12d6p8wLdj2j//mBJ92/voNdjVjFS19amXkWVj5N
         pwtXFLpr2NIckxsu3ultA4YzewH8cWptBr78vn10xjt0vEsNQPo3+LW9G4GVoufS6I
         vrYW9c3eqMxE16+glX6oDbEE+Cq3QoLOFT5WB4a552VhRNK/nbES24rE8MK8ZRZZyI
         O2v1QfkwgNdjfj9R1IMi10JM9xKAljGWriKvqkNPillS6YZ5ZQo6P6X+K3YcZRJzJS
         yo5mmZFHUhc8Q==
Date:   Fri, 9 Dec 2022 11:04:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y5OGr59A9wo86rYY@sol.localdomain>
References: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 04:06:33PM +0100, Roberto Sassu wrote:
> +	/* key is used to store the sig and digest too. */
> +	key = kmalloc(key_max_len, GFP_KERNEL);
>  	if (!key)
>  		goto error_free_req;

Maybe just call this 'buf', as the key is just one of the purposes the buffer is
used for now.

> +	/* Cannot use one scatterlist. The first needs to be s->s_size long. */
> +	sg_set_buf(&src_sg[0], key, sig->s_size);
> +	sg_set_buf(&src_sg[1], key + sig->s_size, sig->digest_size);
>  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
>  				   sig->digest_size);

AFAIK, none of the crypto APIs that operate on 'scatterlist' are supposed to
care how the data is divided up into scatterlist elements.  So it sounds like
there is another bug that needs to be fixed.  It should be fixed, not worked
around.

- Eric
