Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB415D267
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 07:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgBNGuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 01:50:11 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:45688 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgBNGuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 01:50:11 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2Une-0004an-Um; Fri, 14 Feb 2020 14:50:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2Unc-0000JQ-Nb; Fri, 14 Feb 2020 14:50:04 +0800
Date:   Fri, 14 Feb 2020 14:50:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, Jason@zx2c4.com, ardb@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH stable] crypto: chacha20poly1305 - prevent integer
 overflow on large input
Message-ID: <20200214065004.2epehtcrvglicr5k@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206114201.25438-1-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This code assigns src_len (size_t) to sl (int), which causes problems
> when src_len is very large. Probably nobody in the kernel should be
> passing this much data to chacha20poly1305 all in one go anyway, so I
> don't think we need to change the algorithm or introduce larger types
> or anything. But we should at least error out early in this case and
> print a warning so that we get reports if this does happen and can look
> into why anybody is possibly passing it that much data or if they're
> accidently passing -1 or similar.
> 
> Fixes: d95312a3ccc0 ("crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine")
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> lib/crypto/chacha20poly1305.c | 3 +++
> 1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
