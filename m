Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D59582022
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 08:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiG0Gcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 02:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiG0Gca (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 02:32:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C078A3C8F7;
        Tue, 26 Jul 2022 23:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1952ACE0494;
        Wed, 27 Jul 2022 06:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDACC433D7;
        Wed, 27 Jul 2022 06:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658903546;
        bh=gEgOFPsMmRJx6jj4YarK7RCdoVSkbblwOCETzSo+oSg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h1uNbaWGtw+QdhjewkZDSEhWdKYeudY8yFtYw3zuJKnzo6suMlp6rNhDg5k8qAuch
         ODX+JuDGtV9y3ov5QGqpSo9mKRfjZOEvuqYHyT0BUnmxerwYPGuilVZ0EDQ76rXRQw
         mNDdeIHWxBJ2DR33ghFN9d68KjbOQKiEK9YtFIfQWvOzUyqif8ag1iG4e1+cp2Bg/8
         U9FNEQz7KqXxUHedlLy4f8sukLxPCp1bsOgk3yV2K8fMYOozqkZmzdju77WUMyAYiB
         dhhrESINw+cTrBgqxyAOyWXDAMl3JpQPnX2JhNd78ET6LK/bfrUpfbEcxUwQfSQfqk
         YgftOw1LATP1g==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when unregistering hwrng
References: <20220725215536.767961-1-Jason@zx2c4.com>
        <Yt+3ic4YYpAsUHMF@gondor.apana.org.au> <Yt+/HvfC+OYRVrr+@zx2c4.com>
Date:   Wed, 27 Jul 2022 09:32:20 +0300
In-Reply-To: <Yt+/HvfC+OYRVrr+@zx2c4.com> (Jason A. Donenfeld's message of
        "Tue, 26 Jul 2022 12:17:02 +0200")
Message-ID: <87zggvoykr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On Tue, Jul 26, 2022 at 05:44:41PM +0800, Herbert Xu wrote:
>> Thanks for all your effort in resolving this issue.
>> 
>> I think Valentin's concern is valid though.  The sleep/wakeup paradigm
>> in this patch-set is slightly unusual.
>> 
>> So what I've done is taken your latest patch, and incorporated
>> Valentin's suggestions on top of it.  I don't think there is an
>> issue with other drivers as neither approach really changes them.
>
> Thanks so much for taking charge of this patch. I really, really
> appreciate it. I'm also glad that we now have a working implementation
> of Valentin's suggestion.
>
> Just two small notes:
> - I had a hard time testing everything because I don't actually have an
>   ath9k, so I wound up playing with variations on
>   https://xn--4db.cc/vnRj8zQw/diff in case that helps. I assume you've
>   got your own way of testing things, but in case not, maybe that diff
>   is useful.
> - I'll mark this patch as "other tree" in the wireless tree's patchwork
>   now that you're on board so Kalle doesn't have to deal with it.

Please don't touch linux-wireless patchwork project, if other people
modify it we don't know what's happening. I prefer that I handle the
patches myself in patchwork as that way I'm best up-to-date.

But just so that I understand correctly, after Herbert's patch no ath9k
changes is needed anymore? That sounds great.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
