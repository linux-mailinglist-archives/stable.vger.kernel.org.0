Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319D251DAD8
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbiEFOpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiEFOpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:45:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE276AA41;
        Fri,  6 May 2022 07:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312B2B8362A;
        Fri,  6 May 2022 14:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0842C385A8;
        Fri,  6 May 2022 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651848116;
        bh=od3kX4Z27CkDxo/vbf9pjAvwaN8dAIlOjZF+sSqzveA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=boy4pNpI+okadZ4mjJW1I1kB1vb5C/iW5X8eWe3lIB68oEFyvekqKKY6RQN7Bq4kZ
         7hD2BCyw0+IWOY+nvnnwpithMqsiZAovSJJxBpu1mEk8Cs4Ozh9YQWRorOA3QE8iw9
         YAN+oHAkjCmZWWx4P13lKR2Odq3va7umCAVZG6sM=
Date:   Fri, 6 May 2022 16:41:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 07/12] crypto: qat - set to zero DH parameters before free
Message-ID: <YnUzsAQd682pJjMt@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-8-giovanni.cabiddu@intel.com>
 <YnTpJkTXwmYyE9lQ@kroah.com>
 <YnTx7fs30scrrjmQ@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTx7fs30scrrjmQ@silpixa00400314>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 11:01:17AM +0100, Giovanni Cabiddu wrote:
> On Fri, May 06, 2022 at 11:23:50AM +0200, Greg KH wrote:
> > On Fri, May 06, 2022 at 09:23:22AM +0100, Giovanni Cabiddu wrote:
> > > Set to zero the DH context buffers containing the DH key before they are
> > > freed.
> > 
> > That says what, but not why.
> > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > > ---
> > >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > index d75eb77c9fb9..2fec89b8a188 100644
> > > --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > > @@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
> > >  static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
> > >  {
> > >  	if (ctx->g) {
> > > +		memzero_explicit(ctx->g, ctx->p_size);
> > >  		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
> > 
> > Why is a memset() not sufficient here?
> Based on the previous conversation a memset() should be sufficient.
> 
> > And what is this solving?  Who would get this stale data?
> This is to make sure the buffer containing sensitive data (i.e. a key)
> is not leaked out by a subsequent allocation.

But as all sane distros have CONFIG_INIT_ON_ALLOC_DEFAULT_ON enabled,
right?  That should handle any worries you have with secrets being on
the heap.  But even then, are you trying to protect yourself against
other kernel modules?  Think this through...

thanks,

greg k-h
