Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C551F7E4
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiEIJV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237941AbiEIJDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:03:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA1205463;
        Mon,  9 May 2022 01:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652086750; x=1683622750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rL6FppCh+odiZj/j2SRhUl205NpKRtoL86HcUFDQOLM=;
  b=UtPMkftlQ6sNcPI89axOAqPfTeT6CegBTNwwO+KNE7XxGfXcbz/NBF8b
   I5pOdE15mranfg8JVsK+R+QENRr0oLx5qgWN37sKGltJM6xLyJnp/DEKC
   mfsHRA63PC7GAZ0arM36OdRdsDnT925GdLYtlPtJzy0uKk+YbGN3fBOAR
   JpubTGL0RstzaCJX7AVxIaAdxPjHLjF+etfcpUKP0QfCow4eEO87r+P5C
   DZN5lk/Vpezzx6UY50fAt0jfPyCG5KFEHj8mi8MQArq+vgn+Ufta3x59M
   HNTo7xXr99LO9IA1ULiaXxhfpNqYUiESIAWauib1agAJ23ELMeDiiT0Ho
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="294210670"
X-IronPort-AV: E=Sophos;i="5.91,210,1647327600"; 
   d="scan'208";a="294210670"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 01:58:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,210,1647327600"; 
   d="scan'208";a="601864339"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 01:58:17 -0700
Date:   Mon, 9 May 2022 09:58:14 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 07/12] crypto: qat - set to zero DH parameters before free
Message-ID: <YnjXppYkVYNyWTFg@silpixa00400314>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-8-giovanni.cabiddu@intel.com>
 <YnTpJkTXwmYyE9lQ@kroah.com>
 <YnTx7fs30scrrjmQ@silpixa00400314>
 <YnUzsAQd682pJjMt@kroah.com>
 <Yna/2Iwdr8zcwi+q@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yna/2Iwdr8zcwi+q@sol.localdomain>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 07, 2022 at 11:52:08AM -0700, Eric Biggers wrote:
> On Fri, May 06, 2022 at 04:41:52PM +0200, Greg KH wrote:
> > On Fri, May 06, 2022 at 11:01:17AM +0100, Giovanni Cabiddu wrote:
> > > On Fri, May 06, 2022 at 11:23:50AM +0200, Greg KH wrote:
> > > > On Fri, May 06, 2022 at 09:23:22AM +0100, Giovanni Cabiddu wrote:
> > > > > Set to zero the DH context buffers containing the DH key before they are
> > > > > freed.
> > > > 
> > > > That says what, but not why.
> > > > 
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> > > > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > > > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > > > > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > > > > ---
> > > > >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > > > index d75eb77c9fb9..2fec89b8a188 100644
> > > > > --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > > > +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > > > @@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
> > > > >  static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
> > > > >  {
> > > > >  	if (ctx->g) {
> > > > > +		memzero_explicit(ctx->g, ctx->p_size);
> > > > >  		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
> > > > 
> > > > Why is a memset() not sufficient here?
> > > Based on the previous conversation a memset() should be sufficient.
> > > 
> > > > And what is this solving?  Who would get this stale data?
> > > This is to make sure the buffer containing sensitive data (i.e. a key)
> > > is not leaked out by a subsequent allocation.
> > 
> > But as all sane distros have CONFIG_INIT_ON_ALLOC_DEFAULT_ON enabled,
> > right?  That should handle any worries you have with secrets being on
> > the heap.  But even then, are you trying to protect yourself against
> > other kernel modules?  Think this through...
> > 
> 
> This patch looks fine to me; it's always recommended to zero out crypto keys at
> the end of their lifetime so that they can't be recovered from free memory if
> system memory is compromised before the memory happens to be allocated and
> overwritten again.  See the hundreds of existing callers of kfree_sensitive(),
> which exist for exactly this reason.
> 
> Note that preventing the key from being "leaked out by a subsequent allocation"
> is *not* the point, and thus CONFIG_INIT_ON_ALLOC_DEFAULT_ON is irrelevant.
I'm going to clarify the commit message and re-send it detached from the
set.

Regards,

-- 
Giovanni
