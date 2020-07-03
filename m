Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BAB213317
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 06:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgGCEs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 00:48:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40226 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgGCEs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 00:48:28 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jrDcc-00081K-3t; Fri, 03 Jul 2020 14:48:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2020 14:48:22 +1000
Date:   Fri, 3 Jul 2020 14:48:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     John Allen <john.allen@amd.com>
Cc:     linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net, bp@suse.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix use of merged scatterlists
Message-ID: <20200703044821.GC23200@gondor.apana.org.au>
References: <20200622202402.360064-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622202402.360064-1-john.allen@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 03:24:02PM -0500, John Allen wrote:
> Running the crypto manager self tests with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS may result in several types of errors
> when using the ccp-crypto driver:
> 
> alg: skcipher: cbc-des3-ccp encryption failed on test vector 0; expected_error=0, actual_error=-5 ...
> 
> alg: skcipher: ctr-aes-ccp decryption overran dst buffer on test vector 0 ...
> 
> alg: ahash: sha224-ccp test failed (wrong result) on test vector ...
> 
> These errors are the result of improper processing of scatterlists mapped
> for DMA.
> 
> Given a scatterlist in which entries are merged as part of mapping the
> scatterlist for DMA, the DMA length of a merged entry will reflect the
> combined length of the entries that were merged. The subsequent
> scatterlist entry will contain DMA information for the scatterlist entry
> after the last merged entry, but the non-DMA information will be that of
> the first merged entry.
> 
> The ccp driver does not take this scatterlist merging into account. To
> address this, add a second scatterlist pointer to track the current
> position in the DMA mapped representation of the scatterlist. Both the DMA
> representation and the original representation of the scatterlist must be
> tracked as while most of the driver can use just the DMA representation,
> scatterlist_map_and_copy() must use the original representation and
> expects the scatterlist pointer to be accurate to the original
> representation.
> 
> In order to properly walk the original scatterlist, the scatterlist must
> be walked until the combined lengths of the entries seen is equal to the
> DMA length of the current entry being processed in the DMA mapped
> representation.
> 
> Fixes: 63b945091a070 ("crypto: ccp - CCP device driver and interface support")
> Signed-off-by: John Allen <john.allen@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/crypto/ccp/ccp-dev.h |  1 +
>  drivers/crypto/ccp/ccp-ops.c | 37 +++++++++++++++++++++++++-----------
>  2 files changed, 27 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
