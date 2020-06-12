Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE711F741C
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 08:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFLGsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 02:48:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38964 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgFLGsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 02:48:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjdUL-0000qV-Lm; Fri, 12 Jun 2020 16:48:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2020 16:48:29 +1000
Date:   Fri, 12 Jun 2020 16:48:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Gerow <gerow@google.com>
Subject: Re: [PATCH] crypto: algboss - don't wait during notifier callback
Message-ID: <20200612064829.GD16987@gondor.apana.org.au>
References: <20200604185253.5119-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604185253.5119-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 11:52:53AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When a crypto template needs to be instantiated, CRYPTO_MSG_ALG_REQUEST
> is sent to crypto_chain.  cryptomgr_schedule_probe() handles this by
> starting a thread to instantiate the template, then waiting for this
> thread to complete via crypto_larval::completion.
> 
> This can deadlock because instantiating the template may require loading
> modules, and this (apparently depending on userspace) may need to wait
> for the crc-t10dif module (lib/crc-t10dif.c) to be loaded.  But
> crc-t10dif's module_init function uses crypto_register_notifier() and
> therefore takes crypto_chain.rwsem for write.  That can't proceed until
> the notifier callback has finished, as it holds this semaphore for read.
> 
> Fix this by removing the wait on crypto_larval::completion from within
> cryptomgr_schedule_probe().  It's actually unnecessary because
> crypto_alg_mod_lookup() calls crypto_larval_wait() itself after sending
> CRYPTO_MSG_ALG_REQUEST.
> 
> This only actually became a problem in v4.20 due to commit b76377543b73
> ("crc-t10dif: Pick better transform if one becomes available"), but the
> unnecessary wait was much older.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207159
> Reported-by: Mike Gerow <gerow@google.com>
> Fixes: 398710379f51 ("crypto: algapi - Move larval completion into algboss")
> Cc: <stable@vger.kernel.org> # v3.6+
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/algboss.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
