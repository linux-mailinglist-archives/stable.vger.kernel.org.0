Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E966B62CA
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 02:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCLB51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 20:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCLB50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 20:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B5834C37;
        Sat, 11 Mar 2023 17:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D537B8068D;
        Sun, 12 Mar 2023 01:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC61C433EF;
        Sun, 12 Mar 2023 01:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678586242;
        bh=E58Z7YyMw2+VrUg3nNps2xgiM/4r3tVM9SEVtSCiLOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFDWj44A130eYvpa3f53rhSqHlBAIhjQIsTdp4dDsMnei93kzgQkBfSUAKOvCQE/Z
         e5u5X5YEJTEHVXkaPQ1DVRWumOsmTFOmFoLGspN3JK1fyErzYJ4Pvc9JfZeuJ80w8D
         9xMCNlEkROGq9lHDjZtT6I2y4cfNqqCvRLwRCBIFuL7ZiFei0MKKu9OBv9hINlmkun
         40Bf0LQYfQ+t4FF32V2YaoYm9CoRddUSacyPH1opVflTE6sL5bsM9rhnHW5D5L4FxR
         QQrlUXzsuPwzIINYzdqOv2MSpdKWqWj89e+ijb0eyvh2O6SbeGV7Sacl2elApNseL7
         9IsvHeA9ZHFgw==
Date:   Sun, 12 Mar 2023 03:57:19 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        reach622@mailcuk.com, Bell <1138267643@qq.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <ZA0xf4N9taBe3HKj@kernel.org>
References: <20230228024439.27156-1-mario.limonciello@amd.com>
 <Y/1wuXbaPcG9olkt@kernel.org>
 <5e535bf9-c662-c133-7837-308d67dfac94@leemhuis.info>
 <85df6dda-c1c9-f08e-9e64-2007d44f6683@leemhuis.info>
 <ZA0sScO47IMKPhtG@kernel.org>
 <ZA0t/8Tz1Lbz25BZ@kernel.org>
 <CAHmME9pudxP07Jx77yUecDLqm2xku3cPJFtk=bY6ACmfL1j5xw@mail.gmail.com>
 <ZA0w9IjDqcm4YxhO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA0w9IjDqcm4YxhO@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DIET_1,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 03:55:03AM +0200, Jarkko Sakkinen wrote:
> On Sun, Mar 12, 2023 at 02:49:17AM +0100, Jason A. Donenfeld wrote:
> > On 3/12/23, Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > On Sun, Mar 12, 2023 at 03:35:08AM +0200, Jarkko Sakkinen wrote:
> > >> On Fri, Mar 10, 2023 at 06:43:47PM +0100, Thorsten Leemhuis wrote:
> > >> > [adding Linux to the list of recipients]
> > >> >
> > >> > On 08.03.23 10:42, Linux regression tracking (Thorsten Leemhuis) wrote:
> > >> > > Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> > >> > > for once, to make this easily accessible to everyone.
> > >> > >
> > >> > > Jarkko, thx for reviewing and picking below fix up. Are you planning
> > >> > > to
> > >> > > send this to Linus anytime soon, now that the patch was a few days in
> > >> > > next? It would be good to get this 6.1 regression finally fixed, it
> > >> > > already took way longer then the time frame
> > >> > > Documentation/process/handling-regressions.rst outlines for a case
> > >> > > like
> > >> > > this. But well, that's how it is sometimes...
> > >> >
> > >> > Linus, would you consider picking this fix up directly from here or
> > >> > from
> > >> > linux-next (8699d5244e37)? It's been in the latter for 9 days now
> > >> > afaics. And the issue seems to bug more than just one or two users, so
> > >> > it IMHO would be good to get this finally resolved.
> > >> >
> > >> > Jarkko didn't reply to my inquiry, guess something else keeps him busy.
> > >>
> > >> That's a bit arrogant. You emailed only 4 days ago.
> > >>
> > >> I'm open to do PR for rc3 with the fix, if it cannot wait to v6.4 pr.
> > >
> > > If this is about slow response with kernel bugzilla: it is not *enforced*
> > > part of the process. If it was, I would use it. Since it isn't, I don't
> > > really want to add any extra weight to my workflow.
> > >
> > > It's not only extra time but also it is not documented how exactly and in
> > > detail you would use it. For email we have all that documented. And when
> > > you don't have guidelines, then it is too flakky to use properly.
> > 
> > No interest in wading into a process argument. But if you're able to
> > send this for rc3, please please do so. Users keep getting hit by
> > this, some email me directly, and I keep replying saying the fix
> > should be released any day now. So let's make that happen.
> 
> Sure, that shouldn't be a problem. I'll queue this for rc3.

Considering "the process argument": I'm just saying that we have user
facing service that is not properly documented to the maintainers, that's
all.

BR, Jarkko
