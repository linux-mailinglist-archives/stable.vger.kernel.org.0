Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D66469EA70
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 23:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjBUWxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 17:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjBUWxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 17:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DAC86B5;
        Tue, 21 Feb 2023 14:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49011B81109;
        Tue, 21 Feb 2023 22:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952D6C433EF;
        Tue, 21 Feb 2023 22:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677020006;
        bh=+RX3JMZc7Nwd1iiFGuXMv1Hbhi6XEC4r9f2VtvnEioY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdzKqXHWkBhzVd3VG2cZq2+iwt1+qtY/ba8tPrXhWOy3QFJopwOOQly+HP0fZY2aU
         Wb4y3bm6oZhXa7I4JXtgsMwkxQi2uTji6UGwZxYOed87/RHHfFUU3GzP4it0oHRy7B
         iQAuDi8tXn1bCj1SQVlczj9vIKNdqgRGxuzEDWEeN6+NHtNk1y69mfgR5Cy32l5DdQ
         rm919dICI2cJPkXmMnGP5Cgjq1yNsZ3dPVkhbhcRwHBvSOQO1fzvnTOam2WESThn3M
         hoZhRCV5JDlmjlLU2l+GEpCpz5BuqsJqQgn4bmoEBsk2oFiDAv6f7ZfDSFjdz4peCh
         ntdiK+gb7LxdA==
Date:   Wed, 22 Feb 2023 00:53:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jason@zx2c4.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y/VLYxAqmlF8nbw3@kernel.org>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
 <Y/ABPhpMQrQgQ72l@kernel.org>
 <03c045b5-73f8-0522-9966-472404068949@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03c045b5-73f8-0522-9966-472404068949@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 08:25:56PM -0600, Limonciello, Mario wrote:
> On 2/17/2023 16:05, Jarkko Sakkinen wrote:
> 
> > Perhaps tpm_amd_* ?
> 
> When Jason first proposed this patch I feel the intent was it could cover
> multiple deficiencies.
> But as this is the only one for now, sure re-naming it is fine.
> 
> >
> > Also, just a question: is there any legit use for fTPM's, which are not
> > updated? I.e. why would want tpm_crb to initialize with a dysfunctional
> > firmware?>
> > I.e. the existential question is: is it better to workaround the issue and
> > let pass through, or make the user aware that the firmware would really
> > need an update.
> >
> 
> On 2/17/2023 16:35, Jarkko Sakkinen wrote:
> > > 
> > > Hmm, no reply since Mario posted this.
> > > 
> > > Jarkko, James, what's your stance on this? Does the patch look fine from
> > > your point of view? And does the situation justify merging this on the
> > > last minute for 6.2? Or should we merge it early for 6.3 and then
> > > backport to stable?
> > > 
> > > Ciao, Thorsten
> > 
> > As I stated in earlier response: do we want to forbid tpm_crb in this case
> > or do we want to pass-through with a faulty firmware?
> > 
> > Not weighting either choice here I just don't see any motivating points
> > in the commit message to pick either, that's all.
> > 
> > BR, Jarkko
> 
> Even if you're not using RNG functionality you can still do plenty of other
> things with the TPM.  The RNG functionality is what tripped up this issue
> though.  All of these issues were only raised because the kernel started
> using it by default for RNG and userspace wants random numbers all the time.
> 
> If the firmware was easily updatable from all the OEMs I would lean on
> trying to encourage people to update.  But alas this has been available for
> over a year and a sizable number of OEMs haven't distributed a fix.
> 
> The major issue I see with forbidding tpm_crb is that users may have been
> using the fTPM for something and taking it away in an update could lead to a
> no-boot scenario if they're (for example) tying a policy to PCR values and
> can no longer access those.
> 
> If the consensus were to go that direction instead I would want to see a
> module parameter that lets users turn on the fTPM even knowing this problem
> exists so they could recover.  That all seems pretty expensive to me for
> this problem.

I agree with the last argument.

I re-read the commit message and https://www.amd.com/en/support/kb/faq/pa-410.

Why this scopes down to only rng? Should TPM2_CC_GET_RANDOM also blocked
from /dev/tpm0?

BR, Jarkko
