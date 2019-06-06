Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49F836C9A
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 08:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfFFGxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 02:53:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38920 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfFFGxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 02:53:49 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmHS-0006ws-IC; Thu, 06 Jun 2019 14:53:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmHQ-0006kd-Kb; Thu, 06 Jun 2019 14:53:44 +0800
Date:   Thu, 6 Jun 2019 14:53:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ghash - fix unaligned memory access in
 ghash_setkey()
Message-ID: <20190606065344.rknt37tufeojyrbf@gondor.apana.org.au>
References: <20190530175039.195574-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530175039.195574-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 10:50:39AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Changing ghash_mod_init() to be subsys_initcall made it start running
> before the alignment fault handler has been installed on ARM.  In kernel
> builds where the keys in the ghash test vectors happened to be
> misaligned in the kernel image, this exposed the longstanding bug that
> ghash_setkey() is incorrectly casting the key buffer (which can have any
> alignment) to be128 for passing to gf128mul_init_4k_lle().
> 
> Fix this by memcpy()ing the key to a temporary buffer.
> 
> Don't fix it by setting an alignmask on the algorithm instead because
> that would unnecessarily force alignment of the data too.
> 
> Fixes: 2cdc6899a88e ("crypto: ghash - Add GHASH digest algorithm for GCM")
> Reported-by: Peter Robinson <pbrobinson@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Tested-by: Peter Robinson <pbrobinson@gmail.com>
> ---
>  crypto/ghash-generic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
