Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B8255D435
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344526AbiF1KwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbiF1KwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:52:10 -0400
X-Greylist: delayed 417 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Jun 2022 03:52:09 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0289724F3D;
        Tue, 28 Jun 2022 03:52:08 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1656413110; bh=mAaCfPe3fw1fuDEGDpxnsjtKUtYee9b2yyQePpQWJZI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=EckpsRugV1CYexE0vYH50nYaVQ7NY+FDxUfC5lx/gpbY4bebtiJylu+szLfvIn1js
         Xo7UEIlt4oCkyhqvR4LH0Ve1sv37XeOmxlcvLGHG8Vvm//NeWlI13mil3IDktthOlY
         6aqr6JtXCsVruTMhMug635wwGQD2hnsdkc8y5/CxRFIo6pvhjMEx0R3RF/ury2F8SN
         Eh10oU9s1ZkbLeMLAObgkkziUtaHKytxNey8e4Ogx7CTS1gT4g4MTzyJRMwf1XtBwx
         bwAF5wdfy7fhZrK9yf+OkFxwo4QZINUNYuSpBlcnC2GSK0bG9v8/ETTl2a4NotDbt5
         ifk5iV9mdSJVA==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
In-Reply-To: <20220627120735.611821-1-Jason@zx2c4.com>
References: <20220627113749.564132-1-Jason@zx2c4.com>
 <20220627120735.611821-1-Jason@zx2c4.com>
Date:   Tue, 28 Jun 2022 12:45:10 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y1xh9idl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

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
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsF=
GTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8H=
ys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
