Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B0E583F6B
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiG1NBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiG1NBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BF7120AD;
        Thu, 28 Jul 2022 06:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7019761CED;
        Thu, 28 Jul 2022 13:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC2FC433D6;
        Thu, 28 Jul 2022 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659013295;
        bh=E51/MNk2qxY6NPI0mcpHqIuA3fXm7V2GZ5k3k3ZJ0YE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iUaHHETyUcy1uQ4igxgOhyNGZ3EKoJgd9+BjFAdy7kAVl+yPNxZTwjk6V6NrzSSjS
         jeGyJIZ7dpu2/0DCcjAV45JBNKWcv7ZuhYKWnkaYMUg/716eiZaTFswd760svKwgq9
         QJYp0ON4Tz5UtETP1X/4LbVePITwsT03g88ADFIo2lpbZffWsz7vpqGGI0xAP+k4BE
         i7QcM8QXa+zOHNLXv6oGrqcxXQWitlL9tl8vB5BuiCHDpKuJg6mS/PgQerURanCtAu
         U8THRUaYcFCiTDtB+lJLjahfmSSYf0jPQz9odN5VrTA/ijM8Deauj9GKm/WkWCcJT0
         mEhPWojk+Ginw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v12 PATCH] hwrng: core - let sleep be interrupted when unregistering hwrng
References: <20220725215536.767961-1-Jason@zx2c4.com>
        <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
        <YuJjXI+tuiCcixbd@gondor.apana.org.au>
        <89068ADD-805B-4036-8CF5-2612E2E8D3FF@toke.dk>
Date:   Thu, 28 Jul 2022 16:01:29 +0300
In-Reply-To: <89068ADD-805B-4036-8CF5-2612E2E8D3FF@toke.dk> ("Toke
        \=\?utf-8\?Q\?H\=C3\=B8iland-J\=C3\=B8rgensen\=22's\?\= message of "Thu, 28 Jul 2022
 14:39:47 +0200")
Message-ID: <877d3xo0gm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> On 28 July 2022 12:22:20 CEST, Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
>>From: Jason A. Donenfeld <Jason@zx2c4.com>
>>
>>There are two deadlock scenarios that need addressing, which cause
>>problems when the computer goes to sleep, the interface is set down, and
>>hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
>>for tens of seconds, causing it to fail. These scenarios are:
>>
>>1) The hwrng kthread can't be stopped while it's sleeping, because it
>>   uses msleep_interruptible() which does not react to kthread_stop.
>>
>>2) A normal user thread can't be interrupted by hwrng_unregister() while
>>   it's sleeping, because hwrng_unregister() is called from elsewhere.
>>
>>We solve both issues by add a completion object called dying that
>>fulfils waiters once we have started the process in hwrng_unregister.
>>
>>At the same time, we should cleanup a common and useless dmesg splat
>>in the same area.
>>
>>Cc: <stable@vger.kernel.org>
>>Reported-by: Gregory Erwin <gregerwin256@gmail.com>
>>Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly
>> dumping into random.c")
>>Link:
>> https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs=
0c00giw@mail.gmail.com/
>>Link:
>> https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DV=
Xtent3HA@mail.gmail.com/
>>Link: https://bugs.archlinux.org/task/75138
>>Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

Acked-by: Kalle Valo <kvalo@kernel.org>

Herbert, feel free to take this via your tree. Thanks!

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
