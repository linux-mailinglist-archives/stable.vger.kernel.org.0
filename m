Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0965551D504
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiEFJ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiEFJ54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:57:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF28867D28;
        Fri,  6 May 2022 02:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651830853; x=1683366853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D2fOVPqK96/pXvpwlXxzgoBM06E6UgVfGVY77Vl/uHI=;
  b=GOG57SAghjmheKyF65U2OmRp+KyJ1fnXS9a838VpTSmFys8gqEN9R2ve
   M0Zkffb4CC/F3U22lUSzFL4BJWrJVwtyTlrEIjUjTx5ySYmCg7n5Gofxi
   y7ARIkgDWSBbhKc50mZP0gi68RWxpJoZLVstfaDAmY1b8Oxb4+Ms6+48K
   hBRQry5vTRflHxJKJ5jFtTROP+zjX1a9eQTQe0BVohsCrODlEitm+l5GE
   fwF7ATFI3RMeTwAjcqMUsX0grdA/yeP/18lgWEb8rfq+ktdXvRo8l87Bm
   Y47JJNEiaN8ScZzH61KfHa2y8eSP8VqzC5dOfGEzgl5oiw5jWS1Ai7jA2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="331407505"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="331407505"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 02:54:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="621757997"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 02:54:10 -0700
Date:   Fri, 6 May 2022 10:54:07 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 10/12] crypto: qat - use memzero_explicit() for algs
Message-ID: <YnTwP/0WNvecE9SJ@silpixa00400314>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-11-giovanni.cabiddu@intel.com>
 <YnTo3zfXSXoEX2+R@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTo3zfXSXoEX2+R@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 11:22:39AM +0200, Greg KH wrote:
> On Fri, May 06, 2022 at 09:23:25AM +0100, Giovanni Cabiddu wrote:
> > Use memzero_explicit(), instead of a memset(.., 0, ..) in the
> > implementation of the algorithms, for buffers containing sensitive
> > information to ensure they are wiped out before free.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > ---
> >  drivers/crypto/qat/qat_common/qat_algs.c      | 20 +++++++++----------
> >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++++++++----------
> >  2 files changed, 20 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> > index 873533dc43a7..c42df18e02b2 100644
> > --- a/drivers/crypto/qat/qat_common/qat_algs.c
> > +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> > @@ -637,12 +637,12 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
> >  	return 0;
> >  
> >  out_free_all:
> > -	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
> > +	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
> 
> This is for structure fields, why does memset() not work properly here?
> The compiler should always call this, it doesn't know what
> dma_free_coherent() does.  You are referencing this pointer after the
> memset() call so all should be working as intended here.
> 
> Because of this, I don't see why this change is needed.  Do you have
> reports of compilers not calling memset() for all of this properly?
Apologies, I had a wrong assumption.
Based on a comment in the memzero_explicit() documentation I assumed it
should be always used to zero sensitive data.

     * memzero_explicit - Fill a region of memory (e.g. sensitive
     *			  keying data) with 0s.

I'm going to drop this patch.

Thanks,

-- 
Giovanni
