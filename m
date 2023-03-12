Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF676B62B8
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 02:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjCLBma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 20:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLBm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 20:42:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99045F233;
        Sat, 11 Mar 2023 17:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 976FAB8068D;
        Sun, 12 Mar 2023 01:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E686DC433EF;
        Sun, 12 Mar 2023 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678585346;
        bh=wUakJ7d0HbSZhIrhO9DVWzZ/2h8eQTKDi+fI693Cr30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ch326AjbxbMSEMXe9KnB8d04VQwHPj80azI3Vu8SbpX4zCMm+r0weNDwkhi8EC3XW
         SprH+bZ7DDn+2qpy4SMZJqHhRvY9A1YBH7isAzLDoZjzqFaZwDgYjYfWPTo7r2Kkbc
         9mmFV5liiRtNkwq49J2sr6Wj7Qw9aNsYoT1heX52FZFraZ5Xk2VyPnHjAfUmDsnAFk
         XcXblm62/SPPlFnqwrvNhY6pmgoRZ2nNnawd1Os9W6TrIEsRMKoxZwxQQr0gp4APuH
         Lmu+a9vC33gmgy3OZQhRTSCVzAYEp+5ulBMHM0q/OwcFpaR5d3P8WCcwtLunsr1UcW
         lIWVuI0768e6g==
Date:   Sun, 12 Mar 2023 03:42:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        reach622@mailcuk.com, Bell <1138267643@qq.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <ZA0t/8Tz1Lbz25BZ@kernel.org>
References: <20230228024439.27156-1-mario.limonciello@amd.com>
 <Y/1wuXbaPcG9olkt@kernel.org>
 <5e535bf9-c662-c133-7837-308d67dfac94@leemhuis.info>
 <85df6dda-c1c9-f08e-9e64-2007d44f6683@leemhuis.info>
 <ZA0sScO47IMKPhtG@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA0sScO47IMKPhtG@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DIET_1,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 03:35:08AM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 10, 2023 at 06:43:47PM +0100, Thorsten Leemhuis wrote:
> > [adding Linux to the list of recipients]
> > 
> > On 08.03.23 10:42, Linux regression tracking (Thorsten Leemhuis) wrote:
> > > Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> > > for once, to make this easily accessible to everyone.
> > > 
> > > Jarkko, thx for reviewing and picking below fix up. Are you planning to
> > > send this to Linus anytime soon, now that the patch was a few days in
> > > next? It would be good to get this 6.1 regression finally fixed, it
> > > already took way longer then the time frame
> > > Documentation/process/handling-regressions.rst outlines for a case like
> > > this. But well, that's how it is sometimes...
> > 
> > Linus, would you consider picking this fix up directly from here or from
> > linux-next (8699d5244e37)? It's been in the latter for 9 days now
> > afaics. And the issue seems to bug more than just one or two users, so
> > it IMHO would be good to get this finally resolved.
> > 
> > Jarkko didn't reply to my inquiry, guess something else keeps him busy.
> 
> That's a bit arrogant. You emailed only 4 days ago.
> 
> I'm open to do PR for rc3 with the fix, if it cannot wait to v6.4 pr.

If this is about slow response with kernel bugzilla: it is not *enforced*
part of the process. If it was, I would use it. Since it isn't, I don't
really want to add any extra weight to my workflow.

It's not only extra time but also it is not documented how exactly and in
detail you would use it. For email we have all that documented. And when
you don't have guidelines, then it is too flakky to use properly.

BR, Jarkko
