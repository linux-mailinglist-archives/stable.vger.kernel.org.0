Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C467312EF2
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfECNZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 09:25:41 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38092 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbfECNZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 09:25:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMRNL-0005m0-P4; Fri, 03 May 2019 14:08:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMRNI-0003By-3L; Fri, 03 May 2019 14:08:48 +0800
Date:   Fri, 3 May 2019 14:08:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto4xx: fix ctr-aes missing output IV
Message-ID: <20190503060847.egfmvu2heoq62hsr@gondor.apana.org.au>
References: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 22, 2019 at 01:25:58PM +0200, Christian Lamparter wrote:
> Commit 8efd972ef96a ("crypto: testmgr - support checking skcipher output IV")
> caused the crypto4xx driver to produce the following error:
> 
> | ctr-aes-ppc4xx encryption test failed (wrong output IV)
> | on test vector 0, cfg="in-place"
> 
> This patch fixes this by reworking the crypto4xx_setkey_aes()
> function to:
> 
>  - not save the iv for ECB (as per 18.2.38 CRYP0_SA_CMD_0:
>    "This bit mut be cleared for DES ECB mode or AES ECB mode,
>    when no IV is used.")
> 
>  - instruct the hardware to save the generated IV for all
>    other modes of operations that have IV and then supply
>    it back to the callee in pretty much the same way as we
>    do it for cbc-aes already.
> 
>  - make it clear that the DIR_(IN|OUT)BOUND is the important
>    bit that tells the hardware to encrypt or decrypt the data.
>    (this is cosmetic - but it hopefully prevents me from
>     getting confused again).
> 
>  - don't load any bogus hash when we don't use any hash
>    operation to begin with.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_alg.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
