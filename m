Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0561AB8B4
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 08:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437224AbgDPGxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 02:53:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437083AbgDPGws (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 02:52:48 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyOA-0005NM-R2; Thu, 16 Apr 2020 16:52:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:52:42 +1000
Date:   Thu, 16 Apr 2020 16:52:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] crypto: algapi - Avoid spurious modprobe on LOADED
Message-ID: <20200416065242.GA8061@gondor.apana.org.au>
References: <20200407051744.GA13037@gondor.apana.org.au>
 <20200407060240.175837-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407060240.175837-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 11:02:40PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently after any algorithm is registered and tested, there's an
> unnecessary request_module("cryptomgr") even if it's already loaded.
> Also, CRYPTO_MSG_ALG_LOADED is sent twice, and thus if the algorithm is
> "crct10dif", lib/crc-t10dif.c replaces the tfm twice rather than once.
> 
> This occurs because CRYPTO_MSG_ALG_LOADED is sent using
> crypto_probing_notify(), which tries to load "cryptomgr" if the
> notification is not handled (NOTIFY_DONE).  This doesn't make sense
> because "cryptomgr" doesn't handle this notification.
> 
> Fix this by using crypto_notify() instead of crypto_probing_notify().
> 
> Fixes: dd8b083f9a5e ("crypto: api - Introduce notifier for new crypto algorithms")
> Cc: <stable@vger.kernel.org> # v4.20+
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  crypto/algapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
