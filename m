Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408ED649AE6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 10:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiLLJQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 04:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiLLJQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 04:16:02 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C2E0D1;
        Mon, 12 Dec 2022 01:15:55 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p4eu7-006PYn-Dc; Mon, 12 Dec 2022 17:15:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Dec 2022 17:15:19 +0800
Date:   Mon, 12 Dec 2022 17:15:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, dhowells@redhat.com,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y5bxJ5UZNPzxwtoy@gondor.apana.org.au>
References: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
 <Y5OGr59A9wo86rYY@sol.localdomain>
 <fa8a307541735ec9258353d8ccb75c20bb22aafe.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa8a307541735ec9258353d8ccb75c20bb22aafe.camel@huaweicloud.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 10:07:38AM +0100, Roberto Sassu wrote:
>
> The problem is a misalignment between req->src_len (set to sig->s_size
> by akcipher_request_set_crypt()) and the length of the scatterlist (if
> we set the latter to sig->s_size + sig->digest_size).
> 
> When rsa_enc() calls mpi_read_raw_from_sgl(), it passes req->src_len as
> argument, and the latter allocates the MPI according to that. However,
> it does parsing depending on the length of the scatterlist.
> 
> If there are two scatterlists, it is not a problem, there is no
> misalignment. mpi_read_raw_from_sgl() picks the first. If there is just
> one, mpi_read_raw_from_sgl() parses all data there.

Thanks for the explanation.  That's definitely a bug which should
be fixed either in the RSA code or in MPI.

I'll look into it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
