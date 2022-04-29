Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2858514201
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 07:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354296AbiD2Fxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 01:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349487AbiD2Fx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 01:53:29 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D80614E;
        Thu, 28 Apr 2022 22:50:11 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nkJVy-00896R-7Y; Fri, 29 Apr 2022 15:50:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Apr 2022 13:50:02 +0800
Date:   Fri, 29 Apr 2022 13:50:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     horia.geanta@nxp.com, gaurav.jain@nxp.com, V.Sethi@nxp.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Message-ID: <Ymt8ioIe0UU1NskR@gondor.apana.org.au>
References: <20220420120601.1015362-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220420120601.1015362-1-festevam@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 09:06:01AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6SX:
> 
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> 
> This error is due to an incorrect entropy delay for i.MX6SX.
> 
> Fix it by increasing the minimum entropy delay for i.MX6SX
> as done in U-Boot:
> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/
> 
> As explained in the U-Boot patch:
> 
> "RNG self tests are run to determine the correct entropy delay.
> Such tests are executed with different voltages and temperatures to identify
> the worst case value for the entropy delay. For i.MX6SX, it was determined
> that after adding a margin value of 1000 the minimum entropy delay should be
> at least 12000."
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> ---
> Changes since v4:
> - Change the function name to needs_entropy_delay_adjustment() - Vabhav
> - Improve the commit log by adding the explanation from the U-Boot
> patch - Vabhav
> 
>  drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
