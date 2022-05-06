Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB651D445
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbiEFJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344584AbiEFJ1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:27:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA9764BE7;
        Fri,  6 May 2022 02:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76279B834B1;
        Fri,  6 May 2022 09:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2917C385AA;
        Fri,  6 May 2022 09:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651829037;
        bh=emgkTRX8avRNxyVSyZGlhR7HqlUX5lEQ6X8egOHIG3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g3adhw+cFQi+x+2/Vz8x+XMy/zRdkOQ9NSMLg/aAo+3Tv0C7JEtm8ZYt+tGlLfgkT
         /Pc31Xv0PiNtif5Uk/FCuxDrNoLw4bexKJwpanQxObc71a+Y1+WBXkXojg3CC3Es+S
         D6Dr8l1bOTP4jlwxxmOTnTmCixhM4EIMps9zSR1w=
Date:   Fri, 6 May 2022 11:23:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 07/12] crypto: qat - set to zero DH parameters before free
Message-ID: <YnTpJkTXwmYyE9lQ@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-8-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506082327.21605-8-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 09:23:22AM +0100, Giovanni Cabiddu wrote:
> Set to zero the DH context buffers containing the DH key before they are
> freed.

That says what, but not why.

> Cc: stable@vger.kernel.org
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> index d75eb77c9fb9..2fec89b8a188 100644
> --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> @@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
>  static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
>  {
>  	if (ctx->g) {
> +		memzero_explicit(ctx->g, ctx->p_size);
>  		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);

Why is a memset() not sufficient here?
And what is this solving?  Who would get this stale data?

thanks,

greg k-h
