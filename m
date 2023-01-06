Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2696603D7
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjAFQB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 11:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjAFQBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 11:01:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA6058D24;
        Fri,  6 Jan 2023 08:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3DF961787;
        Fri,  6 Jan 2023 16:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42071C433D2;
        Fri,  6 Jan 2023 16:01:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MJcD+P6R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673020904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBBdu/U+hz6Cjc+bNOWE5qE0BXhjUVEUBxjGp1oqy34=;
        b=MJcD+P6RLNx85zvcTDbwATN1tyZPlfMj+IMI/v6tpbViVXdxcmKNhOrtlI3XjusmCbv5+x
        J7TpkFOXiZ4iZ6OI5++8yRhz1LF/WD1nLP6TXO7dsHRPReRqLgS/U1bVqRxHu2ZlnLVq+g
        zbMdCIya0ydVUzw1sn2CPgnVex97g/c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d703d995 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 6 Jan 2023 16:01:44 +0000 (UTC)
Date:   Fri, 6 Jan 2023 17:01:42 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, tbroch@chromium.org,
        semenzato@chromium.org, dbasehore@chromium.org,
        keescook@chromium.org
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM
 suspend fails
Message-ID: <Y7hF5vG8rWjbCLyL@zx2c4.com>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
 <20230106030156.3258307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230106030156.3258307-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Todd & ChromeOS folks,

On Fri, Jan 06, 2023 at 04:01:56AM +0100, Jason A. Donenfeld wrote:
> TPM 1 is sometimes broken across system suspends, due to races or
> locking issues or something else that haven't been diagnosed or fixed
> yet, most likely having to do with concurrent reads from the TPM's
> hardware random number generator driver. These issues prevent the system
> from actually suspending, with errors like:
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
> In lieu of actually fixing the underlying bug, just allow system suspend
> to continue, so that laptops still go to sleep fine. Later, this can be
> reverted when the real bug is fixed.
> 
> Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
> Cc: stable@vger.kernel.org # 6.1+
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> This is basically untested and I haven't worked out if there are any
> awful implications of letting the system sleep when TPM suspend fails.
> Maybe some PCRs get cleared and that will make everything explode on
> resume? Maybe it doesn't matter? Somebody well versed in TPMology should
> probably [n]ack this approach.

When idling scrolling on my telephone to try to see what the
implications of skipping TPM_ORD_SAVESTATE could be, I stumbled across
some ChromeOS commits related to it, and realized that, ah-hah, finally
there's an obvious group of stakeholders who make heavy use of the TPM
and have likely amassed some expertise on it.

So I was wondering if you'd take a look at this patch briefly to make
sure it won't break ChromeOS laptops.

Jason
