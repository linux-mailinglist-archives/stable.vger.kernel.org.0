Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E2A640DCC
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 19:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiLBStR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 13:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiLBStQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 13:49:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB29AE02F6;
        Fri,  2 Dec 2022 10:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB26B82237;
        Fri,  2 Dec 2022 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E162FC433D6;
        Fri,  2 Dec 2022 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006953;
        bh=D2D6Tjlx7oFG/USSfc9cdqvnPs4TmWMa9hoCFFB7rCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AxoQ4G/HkKoHIHFMoEK8UP5I/7i8em5CgYQ5B9cTiSt+wWri5g4h3G/GFFwWcUdSz
         NHVqmDnsJg00+O4z/3257nSKPFZZ4S05Snbd2zn5KWZYoKkPMm+59JCOjSn6TAgKrk
         q2yhYAViLBfLtK9s+lQXGC2//WBvihoQ2D04hgKFqyFnVRqyjkmGEM4rNi9FUJh/pi
         cNNexYEM3Y06nfuXFZU+JTMU7pLXdGgqar/bNEX4r24tUzt3XZsCrhy7vc+DP59Wuv
         chYRMkXrPcYp+p0nPGjWpjc5lB7rB7xv5wCM11qJYhnpjQsKNMQU5UrjrtCfuYCiA7
         v+k8SSmh6Luuw==
Date:   Fri, 2 Dec 2022 10:49:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] evm: Alloc evm_digest in evm_verify_hmac() if
 CONFIG_VMAP_STACK=y
Message-ID: <Y4pIpxbjBdajymBJ@sol.localdomain>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
 <20221201100625.916781-2-roberto.sassu@huaweicloud.com>
 <Y4j4MJzizgEHf4nv@sol.localdomain>
 <c8ef0ab69635b99d5175eaf4c96bb3a8957c6210.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ef0ab69635b99d5175eaf4c96bb3a8957c6210.camel@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 08:58:21AM +0100, Roberto Sassu wrote:
> On Thu, 2022-12-01 at 10:53 -0800, Eric Biggers wrote:
> > On Thu, Dec 01, 2022 at 11:06:24AM +0100, Roberto Sassu wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > 
> > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > mapping") checks that both the signature and the digest reside in the
> > > linear mapping area.
> > > 
> > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > stack support"), made it possible to move the stack in the vmalloc area,
> > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > adjacent pages.
> > > 
> > > Fix this by checking if CONFIG_VMAP_STACK is enabled. If yes, allocate an
> > > evm_digest structure, and use that instead of the in-stack counterpart.
> > > 
> > > Cc: stable@vger.kernel.org # 4.9.x
> > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >  security/integrity/evm/evm_main.c | 26 +++++++++++++++++++++-----
> > >  1 file changed, 21 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > > index 23d484e05e6f..7f76d6103f2e 100644
> > > --- a/security/integrity/evm/evm_main.c
> > > +++ b/security/integrity/evm/evm_main.c
> > > @@ -174,6 +174,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > >  	struct signature_v2_hdr *hdr;
> > >  	enum integrity_status evm_status = INTEGRITY_PASS;
> > >  	struct evm_digest digest;
> > > +	struct evm_digest *digest_ptr = &digest;
> > >  	struct inode *inode;
> > >  	int rc, xattr_len, evm_immutable = 0;
> > >  
> > > @@ -231,14 +232,26 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > >  		}
> > >  
> > >  		hdr = (struct signature_v2_hdr *)xattr_data;
> > > -		digest.hdr.algo = hdr->hash_algo;
> > > +
> > > +		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > > +			digest_ptr = kmalloc(sizeof(*digest_ptr), GFP_NOFS);
> > > +			if (!digest_ptr) {
> > > +				rc = -ENOMEM;
> > > +				break;
> > > +			}
> > > +		}
> > > +
> > > +		digest_ptr->hdr.algo = hdr->hash_algo;
> > > +
> > >  		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
> > > -				   xattr_value_len, xattr_data->type, &digest);
> > > +				   xattr_value_len, xattr_data->type,
> > > +				   digest_ptr);
> > >  		if (rc)
> > >  			break;
> > >  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
> > >  					(const char *)xattr_data, xattr_len,
> > > -					digest.digest, digest.hdr.length);
> > > +					digest_ptr->digest,
> > > +					digest_ptr->hdr.length);
> > >  		if (!rc) {
> > >  			inode = d_backing_inode(dentry);
> > >  
> > > @@ -268,8 +281,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > >  		else
> > >  			evm_status = INTEGRITY_FAIL;
> > >  	}
> > > -	pr_debug("digest: (%d) [%*phN]\n", digest.hdr.length, digest.hdr.length,
> > > -		  digest.digest);
> > > +	pr_debug("digest: (%d) [%*phN]\n", digest_ptr->hdr.length,
> > > +		 digest_ptr->hdr.length, digest_ptr->digest);
> > > +
> > > +	if (digest_ptr && digest_ptr != &digest)
> > > +		kfree(digest_ptr);
> > 
> > What is the actual problem here?  Where is a scatterlist being created from this
> > buffer?  AFAICS it never happens.
> 
> Hi Eric
> 
> it is in public_key_verify_signature(), called by asymmetric_verify()
> and integrity_digsig_verify().
> 

Hmm, that's several steps down the stack then.  And not something I had
expected.

Perhaps this should be fixed in public_key_verify_signature() instead?  It
already does a kmalloc(), so that allocation size just could be made a bit
larger to get space for a temporary copy of 's' and 'digest'.

Or at the very least, struct public_key_signature should have a *very* clear
comment saying that the 's' and 'digest' fields must be located in physically
contiguous memory...

- Eric
