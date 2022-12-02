Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5173E64016C
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 08:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiLBH6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 02:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiLBH6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 02:58:53 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6E950FA;
        Thu,  1 Dec 2022 23:58:50 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NNlWj3P8nz9xFQc;
        Fri,  2 Dec 2022 15:51:45 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDHsm8gsIlj1LiyAA--.51906S2;
        Fri, 02 Dec 2022 08:58:32 +0100 (CET)
Message-ID: <c8ef0ab69635b99d5175eaf4c96bb3a8957c6210.camel@huaweicloud.com>
Subject: Re: [PATCH v2 1/2] evm: Alloc evm_digest in evm_verify_hmac() if
 CONFIG_VMAP_STACK=y
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 02 Dec 2022 08:58:21 +0100
In-Reply-To: <Y4j4MJzizgEHf4nv@sol.localdomain>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
         <20221201100625.916781-2-roberto.sassu@huaweicloud.com>
         <Y4j4MJzizgEHf4nv@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwDHsm8gsIlj1LiyAA--.51906S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4DKry8Wr4Uur4DtryfCrg_yoW5Zw1Upa
        1kKa10qr4rJr1SkF1aya1Yya1rKrW0qry2gws8Aw1YyF9xZrnYy34xAFy7WryFkry8WF1x
        tFWSqrn8C3WqyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAOBF1jj4ItyAABsf
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-12-01 at 10:53 -0800, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 11:06:24AM +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > mapping") checks that both the signature and the digest reside in the
> > linear mapping area.
> > 
> > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > stack support"), made it possible to move the stack in the vmalloc area,
> > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > adjacent pages.
> > 
> > Fix this by checking if CONFIG_VMAP_STACK is enabled. If yes, allocate an
> > evm_digest structure, and use that instead of the in-stack counterpart.
> > 
> > Cc: stable@vger.kernel.org # 4.9.x
> > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/integrity/evm/evm_main.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > index 23d484e05e6f..7f76d6103f2e 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -174,6 +174,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  	struct signature_v2_hdr *hdr;
> >  	enum integrity_status evm_status = INTEGRITY_PASS;
> >  	struct evm_digest digest;
> > +	struct evm_digest *digest_ptr = &digest;
> >  	struct inode *inode;
> >  	int rc, xattr_len, evm_immutable = 0;
> >  
> > @@ -231,14 +232,26 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  		}
> >  
> >  		hdr = (struct signature_v2_hdr *)xattr_data;
> > -		digest.hdr.algo = hdr->hash_algo;
> > +
> > +		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > +			digest_ptr = kmalloc(sizeof(*digest_ptr), GFP_NOFS);
> > +			if (!digest_ptr) {
> > +				rc = -ENOMEM;
> > +				break;
> > +			}
> > +		}
> > +
> > +		digest_ptr->hdr.algo = hdr->hash_algo;
> > +
> >  		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
> > -				   xattr_value_len, xattr_data->type, &digest);
> > +				   xattr_value_len, xattr_data->type,
> > +				   digest_ptr);
> >  		if (rc)
> >  			break;
> >  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
> >  					(const char *)xattr_data, xattr_len,
> > -					digest.digest, digest.hdr.length);
> > +					digest_ptr->digest,
> > +					digest_ptr->hdr.length);
> >  		if (!rc) {
> >  			inode = d_backing_inode(dentry);
> >  
> > @@ -268,8 +281,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  		else
> >  			evm_status = INTEGRITY_FAIL;
> >  	}
> > -	pr_debug("digest: (%d) [%*phN]\n", digest.hdr.length, digest.hdr.length,
> > -		  digest.digest);
> > +	pr_debug("digest: (%d) [%*phN]\n", digest_ptr->hdr.length,
> > +		 digest_ptr->hdr.length, digest_ptr->digest);
> > +
> > +	if (digest_ptr && digest_ptr != &digest)
> > +		kfree(digest_ptr);
> 
> What is the actual problem here?  Where is a scatterlist being created from this
> buffer?  AFAICS it never happens.

Hi Eric

it is in public_key_verify_signature(), called by asymmetric_verify()
and integrity_digsig_verify().

Roberto

