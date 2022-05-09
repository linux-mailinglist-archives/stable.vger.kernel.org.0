Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77551F806
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiEIJWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiEIIy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:54:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADB1F7E20;
        Mon,  9 May 2022 01:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652086265; x=1683622265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S9s7rC9VDyNxRZwQA+/oFpvZqqXyo50hvVpPudqW0IM=;
  b=dj4/h2vTZldoUtsY5/VhpK7hWa6nWlulZdTuORR49Vx2Cxdx+xCAspPK
   17wIjVxRZER1K6BV/1gd7vSZSDyQ7WbgKT939Ap+ugsZO5sD6oa1LqAGW
   Fq/WN6E9OF85Np5fuxg+8GywUHTSMS8Vm+Mpp6Qix1RI4m5ssDGqZ/yjx
   TpL9Cdu/wus8hpogAvzh+9ZKWBWorF80IhINjQeF4i2hbHXCkEeZr74X9
   qkopurU7RZcOpCHpXtSOcKFI4+clyJygUud6+WoZSJdaUtInQiusB+qT4
   bKDgnWT24UwgYuC1CiOy3bhiM1b+g+ErsTcX6FrHbrSdN+/UJRTBi9F4D
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="266575974"
X-IronPort-AV: E=Sophos;i="5.91,210,1647327600"; 
   d="scan'208";a="266575974"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 01:51:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,210,1647327600"; 
   d="scan'208";a="550920210"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 01:51:02 -0700
Date:   Mon, 9 May 2022 09:50:58 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 10/12] crypto: qat - use memzero_explicit() for algs
Message-ID: <YnjV8qhj2AQEWEIH@silpixa00400314>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-11-giovanni.cabiddu@intel.com>
 <YnTo3zfXSXoEX2+R@kroah.com>
 <YnTwP/0WNvecE9SJ@silpixa00400314>
 <YnUy13JBMvhkxSgx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnUy13JBMvhkxSgx@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 04:38:15PM +0200, Greg KH wrote:
> On Fri, May 06, 2022 at 10:54:07AM +0100, Giovanni Cabiddu wrote:
> > On Fri, May 06, 2022 at 11:22:39AM +0200, Greg KH wrote:
> > > On Fri, May 06, 2022 at 09:23:25AM +0100, Giovanni Cabiddu wrote:
> > > > Use memzero_explicit(), instead of a memset(.., 0, ..) in the
> > > > implementation of the algorithms, for buffers containing sensitive
> > > > information to ensure they are wiped out before free.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > > > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > > > ---
> > > >  drivers/crypto/qat/qat_common/qat_algs.c      | 20 +++++++++----------
> > > >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++++++++----------
> > > >  2 files changed, 20 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> > > > index 873533dc43a7..c42df18e02b2 100644
> > > > --- a/drivers/crypto/qat/qat_common/qat_algs.c
> > > > +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> > > > @@ -637,12 +637,12 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
> > > >  	return 0;
> > > >  
> > > >  out_free_all:
> > > > -	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
> > > > +	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
> > > 
> > > This is for structure fields, why does memset() not work properly here?
> > > The compiler should always call this, it doesn't know what
> > > dma_free_coherent() does.  You are referencing this pointer after the
> > > memset() call so all should be working as intended here.
> > > 
> > > Because of this, I don't see why this change is needed.  Do you have
> > > reports of compilers not calling memset() for all of this properly?
> > Apologies, I had a wrong assumption.
> > Based on a comment in the memzero_explicit() documentation I assumed it
> > should be always used to zero sensitive data.
> > 
> >      * memzero_explicit - Fill a region of memory (e.g. sensitive
> >      *			  keying data) with 0s.
> 
> Yes, that's what it is for, when the compiler thinks it is "smarter than
> you" for stack variables.
> 
> It's great for functions like this:
> 	int foo(...)
> 	{
> 		struct key secret_key;
> 
> 		do something and set secret_key...
> 
> 		/* All done, clean up and return */
> 		memset(&secret_key, 0, sizeof(secret_key));
> 		return 0;
> 	}
> 
> For that, some compilers now go "hey, they just want to set this to 0
> and then never touch it again, that is pointless, let's not call
> memset() at all!".
> 
> But when you call:
> 	memset(foo->key, 0, sizeof(key));
> 	do_something_with_foo(foo);
> 
> the compiler can NOT go and ignore the call to memset() as it does not
> know what do_something_with_foo() does.  Or at least it better not.
> 
> Try out this with a small example and look at the asm output for proof.
Thanks for the explanation. It is clear now.

> 
> You aren't the first to be confused about this, I see this happening at
> least once a month with a patch to change code like you did.  Don't know
> why it keeps coming up, is this a checkpatch() recommentation?
It is not a checkpatch recommendation.
I got that assumption looking at kfree_sensitive() which contains a call
to memzero_explicit(). This was introduced in 2020 by
8982ae527fbe ("mm/slab: use memzero_explicit() in kzfree()" when the
function was still called kzfree().
I assume now that the call to memzero_explicit() in kfree_sensitive() is
also redundant, unless I'm missing something.

Regards,

-- 
Giovanni
