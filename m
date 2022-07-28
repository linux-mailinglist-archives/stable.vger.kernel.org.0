Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE159583F38
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiG1MuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 08:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbiG1MuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 08:50:02 -0400
X-Greylist: delayed 604 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Jul 2022 05:49:58 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB93ED64;
        Thu, 28 Jul 2022 05:49:58 -0700 (PDT)
Date:   Thu, 28 Jul 2022 14:39:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1659011990; bh=mHeeMB1nB/QsiX2H/TWc7rHRm36suebQLzWsa5KfVVM=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Jm0y8vf64U+kIqrBzHfrWk+WWxPYIllrknoFGtmJOYWoIA5KWgMhnLaxITx1BhPCP
         K4RyrM+iMpVz2REhzt2nNgTPfEsIn1jWvfhlv3+TTBWX/lPpTEMv19RT+/kHTSP5WW
         c0PWd/7u8CEQiNFZ80Sm/xx8MyXGE/JfC0NdqSNwhUwl/QP3unNIJw4Gqg16Dt/K63
         m08rpMovF3o/I/3P1Iu41/CjlXEAEatbW+y1G8n/RKX2dqNP1tPa5imC4+UIKApbBu
         AsUESlQvds3I0SRu6LkxxJN99P/WiJh6YHlji/2Yp0Dc+en9tyf8o9fUMScLyFfy4M
         hCtM1oljeOdig==
From:   =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5Bv12_PATCH=5D_hwrng=3A_core_-_let_sleep?= =?US-ASCII?Q?_be_interrupted_when_unregistering_hwrng?=
In-Reply-To: <YuJjXI+tuiCcixbd@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com> <Yt+3ic4YYpAsUHMF@gondor.apana.org.au> <YuJjXI+tuiCcixbd@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <89068ADD-805B-4036-8CF5-2612E2E8D3FF@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 28 July 2022 12:22:20 CEST, Herbert Xu <herbert@gondor=2Eapana=2Eorg=2E=
au> wrote:
>From: Jason A=2E Donenfeld <Jason@zx2c4=2Ecom>
>
>There are two deadlock scenarios that need addressing, which cause
>problems when the computer goes to sleep, the interface is set down, and
>hwrng_unregister() is called=2E When the deadlock is hit, sleep is delaye=
d
>for tens of seconds, causing it to fail=2E These scenarios are:
>
>1) The hwrng kthread can't be stopped while it's sleeping, because it
>   uses msleep_interruptible() which does not react to kthread_stop=2E
>
>2) A normal user thread can't be interrupted by hwrng_unregister() while
>   it's sleeping, because hwrng_unregister() is called from elsewhere=2E
>
>We solve both issues by add a completion object called dying that
>fulfils waiters once we have started the process in hwrng_unregister=2E
>
>At the same time, we should cleanup a common and useless dmesg splat
>in the same area=2E
>
>Cc: <stable@vger=2Ekernel=2Eorg>
>Reported-by: Gregory Erwin <gregerwin256@gmail=2Ecom>
>Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random=2Ec")
>Link: https://lore=2Ekernel=2Eorg/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytG=
gDsFGTEjs0c00giw@mail=2Egmail=2Ecom/
>Link: https://lore=2Ekernel=2Eorg/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7=
EY8Hys_DVXtent3HA@mail=2Egmail=2Ecom/
>Link: https://bugs=2Earchlinux=2Eorg/task/75138
>Signed-off-by: Jason A=2E Donenfeld <Jason@zx2c4=2Ecom>
>Signed-off-by: Herbert Xu <herbert@gondor=2Eapana=2Eorg=2Eau>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=2Edk>
