Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F096761DB
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjAUAEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 19:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjAUAET (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 19:04:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489921630A;
        Fri, 20 Jan 2023 16:04:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00BE2B81FA4;
        Sat, 21 Jan 2023 00:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515AAC433D2;
        Sat, 21 Jan 2023 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674259455;
        bh=iQb7Fc/u/8EmQtoJ7rN3tFo8n6W4Tiv/o4BAl7ymRus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HB+uNgKwCoCcYgYcMpRtfzWDeu2zVr2B0nX18L3kazH1qCLkmyM24gfj8k1ZMelrG
         Knk1Q7sxvMY3GnUW2DLmRNgaf6BsMAs8rQOaKqFUGti6PY64w5RyJDyVFhiyE0/hzV
         g5pEkJOThxPEuNBTE51aGRUh26H6itAvWFmebBrVd7V6pK9rDI5Ukl0VMV4mB/BPkN
         IZlCL8fcDJeRPsGcsT/n1zXbuFdc9TQO79PX1hrSXDIbohrL5LBO/c1jVJyH8sVUMb
         VfGCnrx3QmbGYdzQXGOaVJEha27fUo5bRGTAN8lOYdVnGZtgAfXtMxDz/LfOo5ulW1
         JX0MXuUkqzhpw==
Date:   Sat, 21 Jan 2023 00:03:57 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM
 suspend fails
Message-ID: <Y8sr7YJ8e8eSpPFv@kernel.org>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
 <20230106030156.3258307-1-Jason@zx2c4.com>
 <Y8U4kwTPpMet13Ks@kernel.org>
 <af2e5a17-514b-8759-2464-7ebb384a17ba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2e5a17-514b-8759-2464-7ebb384a17ba@suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 03:00:03PM +0100, Vlastimil Babka wrote:
> On 1/16/23 12:44, Jarkko Sakkinen wrote:
> > On Fri, Jan 06, 2023 at 04:01:56AM +0100, Jason A. Donenfeld wrote:
> >> TPM 1 is sometimes broken across system suspends, due to races or
> >> locking issues or something else that haven't been diagnosed or fixed
> >> yet, most likely having to do with concurrent reads from the TPM's
> >> hardware random number generator driver. These issues prevent the system
> >> from actually suspending, with errors like:
> >> 
> >>   tpm tpm0: A TPM error (28) occurred continue selftest
> >>   ...
> > 
> > <REMOVE>
> > 
> >>   tpm tpm0: A TPM error (28) occurred attempting get random
> >>   ...
> >>   tpm tpm0: Error (28) sending savestate before suspend
> >>   tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
> >>   tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
> >>   tpm_tis 00:08: PM: failed to suspend: error 28
> >>   PM: Some devices failed to suspend, or early wake event detected
> > 
> > </REMOVE>
> > 
> > Unrelated to thix particular fix.
> 
> Not sure I understand.
> AFAIK this is not a proper fix, but a workaround for when laptop suspend no
> longer works because TPM fails to suspend. The error messages quoted above
> are very much related to the problem of suspend not working, and this patch
> did work as advertised at least for me. I see errors but they don't prevent
> suspend anymore:
> 
> https://lore.kernel.org/all/58d7a42c-9e6b-ab2a-617f-d5e373bf63cb@suse.cz/
> 
> >> This issue was partially fixed by 23393c646142 ("char: tpm: Protect
> >> tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
> >> directly because the TPM maintainers weren't available. However, it
> >> seems like this just addresses the most common cases of the bug, rather
> >> than addressing it entirely. So there are more things to fix still,
> >> apparently.
> >> 
> >> In lieu of actually fixing the underlying bug, just allow system suspend
> >> to continue, so that laptops still go to sleep fine. Later, this can be
> >> reverted when the real bug is fixed.
> >> 
> >> Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
> >> Cc: stable@vger.kernel.org # 6.1+
> >> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> >> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >> ---
> >> This is basically untested and I haven't worked out if there are any
> >> awful implications of letting the system sleep when TPM suspend fails.
> >> Maybe some PCRs get cleared and that will make everything explode on
> >> resume? Maybe it doesn't matter? Somebody well versed in TPMology should
> >> probably [n]ack this approach.
> >> 
> >>  drivers/char/tpm/tpm-interface.c | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> >> index d69905233aff..6df9067ef7f9 100644
> >> --- a/drivers/char/tpm/tpm-interface.c
> >> +++ b/drivers/char/tpm/tpm-interface.c
> >> @@ -412,7 +412,10 @@ int tpm_pm_suspend(struct device *dev)
> >>  	}
> >>  
> >>  suspended:
> >> -	return rc;
> >> +	if (rc)
> >> +		pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
> >> +		       chip->dev_num, rc);
> >> +	return 0;
> >>  }
> >>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
> >>  
> >> -- 
> >> 2.39.0
> >> 
> > 
> > This tpm_tis local issue, nothing to do with tpm_pm_suspend(). Executing
> > the selftest as part of wake up, is TPM 1.2 dTPM specific requirement, and
> > the call is located in tpm_tis_resume() [*].
> > 
> > [*] https://lore.kernel.org/lkml/Y8U1QxA4GYvPWDky@kernel.org/
> 
> Yes the changelog at the top does say "due to races or locking issues or
> something else that haven't been diagnosed or fixed yet"
> 
> I don't know what causes the TPM to start returning error 28 on resume and
> never recover from it. But it didn't happen before hwrng started using the
> TPM. Before that, it was probably just the selftest ever doing anything with
> the TPM, and on its own I don't recall it ever (before 6.1) failing and
> preventing further suspend/resume.

Would it be possible to test this theory by commenting out tpm_add_hwrng()
call from tpm_chip_register()?

Since they are called sequentially any sort of concurrency issue can be
probably ruled out.

One thing that I noticed is that probably it would be more safe-play to
move tpm_add_hwrng() call after creating the character device, as there's
no need to do it before anything else.

BR, Jarkko
