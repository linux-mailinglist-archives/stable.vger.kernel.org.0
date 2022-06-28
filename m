Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFC55C203
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiF1KwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiF1KwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:52:09 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3186524F39;
        Tue, 28 Jun 2022 03:52:08 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o68p3-00C8tL-Fx; Tue, 28 Jun 2022 20:51:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jun 2022 18:51:57 +0800
Date:   Tue, 28 Jun 2022 18:51:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
Message-ID: <YrrdTcRCKBt15HLz@gondor.apana.org.au>
References: <20220627113749.564132-1-Jason@zx2c4.com>
 <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk>
 <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
 <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
 <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 12:48:50PM +0200, Jason A. Donenfeld wrote:
>
> $ curl https://lore.kernel.org/lkml/20220627104955.534013-1-Jason@zx2c4.com/raw
> | git am
> 
> That one, if you want to give it a spin and see if that 5-6s is back
> to ~1s or less.

Whatever caused kthread_should_stop to return true should have
woken the thread and caused schedule_timeout to return.

If it's not waking the thread up then we should find out why.

Oh wait you're checking kthread_should_stop before the schedule
call instead of afterwards, that would do it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
