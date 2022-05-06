Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA751D51B
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 12:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390772AbiEFKFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358846AbiEFKFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 06:05:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA155A2D5;
        Fri,  6 May 2022 03:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651831283; x=1683367283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v9a6QaqxlteklQ5eDNhQA4DeU/Xa34oGSnLKTwJy6DU=;
  b=JUVhfrYo5ayOFHdgpYwlnxBWbTIoF4PTT117/zFkqtE8Bh7DpO4qRexL
   t5GhcW0zsUyVYbYs58yB7FRgnbw+BKjLcBV+rVDrVSAXs5SbKxiOIl9Mm
   C5K4aOBS/zBwT4PiJeoYy6jTOVLrn8GIvAzuo1iEqF6yWDrldPWwWlYcE
   kVGl8IixDQkybWYY/UXNB8UgJxfzCUQdg8K8NWx+70o7nVNHact5jt3DQ
   R8IkTyHyMPRT2Kv75mU9i27GRHbSces+Fbt+a8GIwno1K9COg02haTH07
   8Q8EeLbF6NMKxaMWnDErw8gPjgbhvSVpRiTVDnqpMImB7YJUmcmjE3pMW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="250420256"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="250420256"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 03:01:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="695107850"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 03:01:20 -0700
Date:   Fri, 6 May 2022 11:01:17 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 07/12] crypto: qat - set to zero DH parameters before free
Message-ID: <YnTx7fs30scrrjmQ@silpixa00400314>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-8-giovanni.cabiddu@intel.com>
 <YnTpJkTXwmYyE9lQ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTpJkTXwmYyE9lQ@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 11:23:50AM +0200, Greg KH wrote:
> On Fri, May 06, 2022 at 09:23:22AM +0100, Giovanni Cabiddu wrote:
> > Set to zero the DH context buffers containing the DH key before they are
> > freed.
> 
> That says what, but not why.
> 
> > Cc: stable@vger.kernel.org
> > Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > ---
> >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > index d75eb77c9fb9..2fec89b8a188 100644
> > --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> > @@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
> >  static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
> >  {
> >  	if (ctx->g) {
> > +		memzero_explicit(ctx->g, ctx->p_size);
> >  		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
> 
> Why is a memset() not sufficient here?
Based on the previous conversation a memset() should be sufficient.

> And what is this solving?  Who would get this stale data?
This is to make sure the buffer containing sensitive data (i.e. a key)
is not leaked out by a subsequent allocation.
I will clarify it in the commit message.

Thanks,

-- 
Giovanni
