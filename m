Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC8651D449
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbiEFJ03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbiEFJ03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:26:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFACD64718;
        Fri,  6 May 2022 02:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FE42B834B4;
        Fri,  6 May 2022 09:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E22C385AA;
        Fri,  6 May 2022 09:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651828964;
        bh=vSZ//zBN1YkYsZ0VDmT9OtaFF8zAYa+8GNnMRMqi+tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x7F9pJdAyCIHh2KcUIJZ0kjvG2wmcZGDUrXcdlOz0uZmkALAl9KlqUGlDubwIvHRF
         s7qRDtTk4HHPL7ACI8GmTjAOJgj3O+OlLPw5iC1W49z5aXuZTqnshSBTGo/uRKeDfS
         lK43A5WMSGzZ+uZN2ekGVc7LQVFk37c0vPamIL1g=
Date:   Fri, 6 May 2022 11:22:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 10/12] crypto: qat - use memzero_explicit() for algs
Message-ID: <YnTo3zfXSXoEX2+R@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-11-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506082327.21605-11-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 09:23:25AM +0100, Giovanni Cabiddu wrote:
> Use memzero_explicit(), instead of a memset(.., 0, ..) in the
> implementation of the algorithms, for buffers containing sensitive
> information to ensure they are wiped out before free.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c      | 20 +++++++++----------
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++++++++----------
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index 873533dc43a7..c42df18e02b2 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -637,12 +637,12 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
>  	return 0;
>  
>  out_free_all:
> -	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
> +	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));

This is for structure fields, why does memset() not work properly here?
The compiler should always call this, it doesn't know what
dma_free_coherent() does.  You are referencing this pointer after the
memset() call so all should be working as intended here.

Because of this, I don't see why this change is needed.  Do you have
reports of compilers not calling memset() for all of this properly?

thanks,

greg k-h
