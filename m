Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE258229C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 11:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiG0JB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 05:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG0JBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 05:01:25 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C5811C0E;
        Wed, 27 Jul 2022 02:01:23 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGcun-004wPE-Pf; Wed, 27 Jul 2022 19:01:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Jul 2022 17:01:14 +0800
Date:   Wed, 27 Jul 2022 17:01:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <YuD+2nD/KNig52u2@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
 <Yt+/HvfC+OYRVrr+@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt+/HvfC+OYRVrr+@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 12:17:02PM +0200, Jason A. Donenfeld wrote:
>
> That won't be possible until 5.20, though, and this patch is needed to
> fix earlier kernels, so the intermediate step here is still required.
> But please keep this on the back burner of your mind. The 5.20
> enablement patch for that is here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git/commit/?h=for-next&id=a7c01fa93aeb03ab76cd3cb2107990dd160498e6

Actually, I don't think this will be needed if we switch over to
completions.  This is because we will no longer be using kthread_should_stop
to determine when we should exit the loop, instead it will be the
completion that has the final say.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
