Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E9855C2FD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbiF1BxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 21:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243234AbiF1BxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 21:53:11 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BB065A7;
        Mon, 27 Jun 2022 18:53:10 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o60PU-00BwwO-6P; Tue, 28 Jun 2022 11:53:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jun 2022 09:53:00 +0800
Date:   Tue, 28 Jun 2022 09:53:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Gregory Erwin <gregerwin256@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
Message-ID: <Yrpe/D+PU078OoIn@gondor.apana.org.au>
References: <20220627113749.564132-1-Jason@zx2c4.com>
 <20220627120735.611821-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220627120735.611821-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 02:07:35PM +0200, Jason A. Donenfeld wrote:
> Even though hwrng provides a `wait` parameter, it doesn't work very well
> when waiting for a long time. There are numerous deadlocks that emerge
> related to shutdown. Work around this API limitation by waiting for a
> shorter amount of time and erroring more frequently. This commit also
> prevents hwrng from splatting messages to dmesg when there's a timeout
> and switches to using schedule_timeout_interruptible(), so that the
> kthread can be stopped.
> 
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/hw_random/core.c        |  5 +++--
>  drivers/net/wireless/ath/ath9k/rng.c | 20 +++-----------------
>  2 files changed, 6 insertions(+), 19 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
