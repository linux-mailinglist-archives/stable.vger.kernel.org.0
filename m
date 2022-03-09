Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CA94D26F4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiCIDYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:24:06 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB1C1A383;
        Tue,  8 Mar 2022 19:23:09 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nRmul-0002y2-Dt; Wed, 09 Mar 2022 14:23:04 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Mar 2022 15:23:03 +1200
Date:   Wed, 9 Mar 2022 15:23:03 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - disable registration of algorithms
Message-ID: <Yigdl81rVqLZBWSG@gondor.apana.org.au>
References: <20220304175447.19601-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304175447.19601-1-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 05:54:47PM +0000, Giovanni Cabiddu wrote:
> The implementations of aead and skcipher in the QAT driver do not
> support properly requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
> If the HW queue is full, the driver returns -EBUSY but does not enqueue
> the request.
> This can result in applications like dm-crypt waiting indefinitely for a
> completion of a request that was never submitted to the hardware.
> 
> To avoid this problem, disable the registration of all crypto algorithms
> in the QAT driver by setting the number of crypto instances to 0 at
> configuration time.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_4xxx/adf_drv.c      | 7 +++++++
>  drivers/crypto/qat/qat_common/qat_crypto.c | 7 +++++++
>  2 files changed, 14 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
