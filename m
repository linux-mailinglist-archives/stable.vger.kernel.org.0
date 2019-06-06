Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324FC36C94
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 08:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfFFGwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 02:52:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38804 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 02:52:20 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmG3-0006v0-6O; Thu, 06 Jun 2019 14:52:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmG3-0006j8-2N; Thu, 06 Jun 2019 14:52:19 +0800
Date:   Thu, 6 Jun 2019 14:52:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/sha2-ce - correct digest for empty data in
 finup
Message-ID: <20190606065219.cgwxy3rcnzzux3zc@gondor.apana.org.au>
References: <20190528143506.212198-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528143506.212198-1-lenaptr@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 03:35:06PM +0100, Elena Petrova wrote:
> The sha256-ce finup implementation for ARM64 produces wrong digest
> for empty input (len=0). Expected: the actual digest, result: initial
> value of SHA internal state. The error is in sha256_ce_finup:
> for empty data `finalize` will be 1, so the code is relying on
> sha2_ce_transform to make the final round. However, in
> sha256_base_do_update, the block function will not be called when
> len == 0.
> 
> Fix it by setting finalize to 0 if data is empty.
> 
> Fixes: 03802f6a80b3a ("crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
