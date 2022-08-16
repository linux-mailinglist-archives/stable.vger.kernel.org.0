Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3DC5953E0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiHPHfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiHPHec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:34:32 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5262D4763;
        Mon, 15 Aug 2022 21:15:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNnyh-00BTJZ-RG; Tue, 16 Aug 2022 14:14:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 12:14:55 +0800
Date:   Tue, 16 Aug 2022 12:14:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hector Martin <marcan@marcan.st>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     tj@kernel.org, will@kernel.org, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        boqun.feng@gmail.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marcan@marcan.st, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvsZvwxACuGw3KIt@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815175810.17780-1-marcan@marcan.st>
X-Newsgroups: apana.lists.os.linux.kernel
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hector Martin <marcan@marcan.st> wrote:
>
> This has been broken since the dawn of time, and it was incompletely
> fixed by 346c09f80459, which added the necessary barriers in the work
> execution path but failed to account for the missing barrier in the
> test_and_set_bit() failure case. Fix it by switching to
> atomic_long_fetch_or(), which does have unconditional barrier semantics
> regardless of whether the bit was already set or not (this is actually
> just test_and_set_bit() minus the early exit path).

test_and_set_bit is supposed to contain a full memory barrier.
If it doesn't then your arch is broken and needs to be fixed.

Changing this one spot is pointless because such assumptions
are all over the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
