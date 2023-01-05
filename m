Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956C065EF5A
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjAEOxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbjAEOx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCB85B16A;
        Thu,  5 Jan 2023 06:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 153E4B81AF7;
        Thu,  5 Jan 2023 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F176C433EF;
        Thu,  5 Jan 2023 14:53:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bCa54Qce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1672930399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wXtl0YIk8f5F9hz4Q5DT4Lbxgp1+7NErVmX1yTs2lA=;
        b=bCa54Qce/zw9oxX0JUjvVX0t9gwff2BIE1btUpipAPv9ZEfdumst+BeBDORKG22lal0dH0
        q/afhhv+DRbfXEdL0SzG5FiMccg5Si5YzV/OTYXvUwYRTtBeIpGPd0MUI86vSO7X5ZFeg8
        PAimxhfpwIW38jLFfWruqoQwMCIVlXQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7d15d76a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 5 Jan 2023 14:53:19 +0000 (UTC)
Date:   Thu, 5 Jan 2023 15:53:16 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Altmanninger <aclopte@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Disable hwrng for TPM 1 if PM_SLEEP is enabled
Message-ID: <Y7bkXAxIT+sp9fvb@zx2c4.com>
References: <370a2808-a19b-b512-4cd3-72dc69dfe8b0@suse.cz>
 <20230105144742.3219571-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105144742.3219571-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 03:47:42PM +0100, Jason A. Donenfeld wrote:
> TPM 1's support for its hardware RNG is broken across system suspends,
> due to races or locking issues or something else that haven't been
> diagnosed or fixed yet. These issues prevent the system from actually
> suspending. So disable the driver in this case. Later, when this is
> fixed properly, we can remove this.
> 
> Current breakage amounts to something like:
> 
>   tpm tpm0: A TPM error (28) occurred continue selftest
>   ...
>   tpm tpm0: A TPM error (28) occurred attempting get random
>   ...
>   tpm tpm0: Error (28) sending savestate before suspend
>   tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
>   tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
>   tpm_tis 00:08: PM: failed to suspend: error 28
>   PM: Some devices failed to suspend, or early wake event detected
> 
> This issue was partially fixed by 23393c646142 ("char: tpm: Protect
> tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
> directly because the TPM maintainers weren't available. However, it
> seems like this just addresses the most common cases of the bug, rather
> than addressing it entirely. So there are more things to fix still,
> apparently.
> 
> The hwrng driver appears already to be occasionally disabled due to
> other conditions, so this shouldn't be too large of a surprise.
> 
> Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
> Cc: stable@vger.kernel.org # 6.1+
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Quoting from my previous email:

| I spent a long time working through the TPM code when this came up
| during 6.1. I set up the TPM emulator with QEMU and reproduced this and
| had a whole test setup and S3 fuzzer. It took a long time, and when I was
| done, I paged it all out of my brain. When I found that patch from Jan
| that fixed the problem most of the time (but not all the time), I wasted
| tons of time trying to get the TPM maintainers to take the patch and
| send it to Linus as part of rc7 or rc8. But they all ignored me, and
| eventually Linus just took that patch directly.
| 
| So I don't think I want to go down another rabbit hole here, having
| experienced the TPM maintainers not really caring much, and that sucking
| away the remaining energy I had before to keep looking at the issue and
| its edge cases not handled by Jan's patch.
| 
| On the contrary, it'd make a big difference if the TPM maintainers could
| actually help analyze the code that they're most familiar with, so that
| we can get to the bottom of this. That's a lot better than some random
| drive-by patches from a non-TPM person like me; before the 6.1 bug, I'd
| never even looked at these drivers.
| 
| My plan is to therefore be available to help and analyze and test and
| maybe even write some code, if the TPM maintainers take the lead on
| getting to the bottom of this. But if this hits neglect again like last
| time, I'll just send a `depends on BROKEN if PM` patch to the TPM
| hw_random driver and see what happens... That's a really awful solution
| though, so I hope the maintainers will wake up this cycle.

Seeing as there's still no life from the TPM maintainers, here's the
patch to make the problem go away until they wake up. When they do wake
up, though, I will be available to start looking into this again in
whatever capacity I might be useful.

Jason
