Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD1F649AB0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 10:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiLLJIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 04:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiLLJIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 04:08:21 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17477B1B;
        Mon, 12 Dec 2022 01:08:20 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NVwb538bmz9xFH5;
        Mon, 12 Dec 2022 17:01:05 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDnbwth75ZjYBEIAA--.129S2;
        Mon, 12 Dec 2022 10:07:55 +0100 (CET)
Message-ID: <fa8a307541735ec9258353d8ccb75c20bb22aafe.camel@huaweicloud.com>
Subject: Re: [PATCH v2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
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
Date:   Mon, 12 Dec 2022 10:07:38 +0100
In-Reply-To: <Y5OGr59A9wo86rYY@sol.localdomain>
References: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
         <Y5OGr59A9wo86rYY@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwDnbwth75ZjYBEIAA--.129S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy3uw1rGrWUZryxKrWfKrg_yoW8XF4Upw
        43Zr4DtrWDWrW8Cw1xua4xt3yFg3yYyFWUGa40k345urn8Wr9YkrykWayI9FWUtrykWrs2
        vrWUWan8Zr9xAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAEBF1jj4KGBgABsw
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-12-09 at 11:04 -0800, Eric Biggers wrote:
> On Fri, Dec 09, 2022 at 04:06:33PM +0100, Roberto Sassu wrote:
> > +	/* key is used to store the sig and digest too. */
> > +	key = kmalloc(key_max_len, GFP_KERNEL);
> >  	if (!key)
> >  		goto error_free_req;
> 
> Maybe just call this 'buf', as the key is just one of the purposes the buffer is
> used for now.

Yes, better.

> > +	/* Cannot use one scatterlist. The first needs to be s->s_size long. */
> > +	sg_set_buf(&src_sg[0], key, sig->s_size);
> > +	sg_set_buf(&src_sg[1], key + sig->s_size, sig->digest_size);
> >  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
> >  				   sig->digest_size);
> 
> AFAIK, none of the crypto APIs that operate on 'scatterlist' are supposed to
> care how the data is divided up into scatterlist elements.  So it sounds like
> there is another bug that needs to be fixed.  It should be fixed, not worked
> around.

The problem is a misalignment between req->src_len (set to sig->s_size
by akcipher_request_set_crypt()) and the length of the scatterlist (if
we set the latter to sig->s_size + sig->digest_size).

When rsa_enc() calls mpi_read_raw_from_sgl(), it passes req->src_len as
argument, and the latter allocates the MPI according to that. However,
it does parsing depending on the length of the scatterlist.

If there are two scatterlists, it is not a problem, there is no
misalignment. mpi_read_raw_from_sgl() picks the first. If there is just
one, mpi_read_raw_from_sgl() parses all data there.

Roberto

