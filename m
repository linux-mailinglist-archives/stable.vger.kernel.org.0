Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB51051DAE7
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355291AbiEFOrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442377AbiEFOrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124236AA6B;
        Fri,  6 May 2022 07:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD5BB83411;
        Fri,  6 May 2022 14:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3941C385A9;
        Fri,  6 May 2022 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651848204;
        bh=/FwFSONd6d39Hoy10JYHeNaWhaiFHuAdGK6dR2gwgBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1fHn9BxyZUAEFzQcTqZZ55p7/F72YRj3WxYmxKwr8ONMH4DlPK2lHszkma1wpXKdE
         xuRlJmn/6Z15PdQzgIn0gLbZ5mt9uOlg3FPxNPqBwh59U0Vlfujcn+II4BjDF1DuMm
         1MN4ncK8LveCwspNlmOVTgBao+Us+StsYwsrE7SE=
Date:   Fri, 6 May 2022 16:43:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH v2 07/11] crypto: qat - set to zero DH parameters before
 free
Message-ID: <YnU0CaYETO57t3T+@kroah.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
 <20220506143903.31776-8-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506143903.31776-8-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 03:38:59PM +0100, Giovanni Cabiddu wrote:
> Set to zero the DH context buffers containing the DH key before they are
> freed.
> This is to make sure keys are not leaked out by a subsequent memory
> allocation.
> 
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
> index d75eb77c9fb9..25bbd22085c3 100644
> --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> @@ -421,14 +421,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
>  static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
>  {
>  	if (ctx->g) {
> +		memset(ctx->g, 0, ctx->p_size);
>  		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
>  		ctx->g = NULL;
>  	}
>  	if (ctx->xa) {
> +		memset(ctx->xa, 0, ctx->p_size);
>  		dma_free_coherent(dev, ctx->p_size, ctx->xa, ctx->dma_xa);
>  		ctx->xa = NULL;
>  	}
>  	if (ctx->p) {
> +		memset(ctx->p, 0, ctx->p_size);
>  		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
>  		ctx->p = NULL;
>  	}
> -- 
> 2.35.1
> 

As I just wrote, I do not think you need this.  If you do, please
explain what you are trying to protect the kernel from here.  Itself?

thanks,

greg k-h
