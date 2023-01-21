Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B656761E3
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 01:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjAUAHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 19:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjAUAHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 19:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6389C7B2FF;
        Fri, 20 Jan 2023 16:07:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF47B620BE;
        Sat, 21 Jan 2023 00:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A019C433EF;
        Sat, 21 Jan 2023 00:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674259631;
        bh=p3Y079nnkl3K5cMAQ/Y53zKuPpFrZ5vU9hR0A7lmpqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YELDPd1k9OyyD5e4D/rOONQPFPMDNok955AbR4Zgm2U5vhyJy8sg44W4YO/E92Una
         hCXxltJOYLqdhoVvJAsTFT52PYG25MDOtQFSZ0BJskTyh4A0/oR3nyoz+Imz6RXRP/
         AKsotEJ/KiBui8rBDxjyifweSTDzkG4dObOzfupoKA/tJepmJBzQyU1vp50XboctRB
         HV8zJ3Ytu5z4cgmmKOvUq84ZrjN9i1vO8dfKpyTD52tIbSACo0icjst2YFyyyQxZfc
         MpTnapVsEV/6HbuUi0ZZHwxuOTuddbzOJ5+iOssbDEqgDuiCiki3qsDVAShRbxOv6c
         LaHwJ+u0lRIpw==
Date:   Sat, 21 Jan 2023 00:07:08 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM
 suspend fails
Message-ID: <Y8ssrKlWh9rsptKe@kernel.org>
References: <Y7dPV5BK6jk1KvX+@zx2c4.com>
 <20230106030156.3258307-1-Jason@zx2c4.com>
 <Y8UG77zvJeic7Cyc@kernel.org>
 <CAHmME9oj5V9eWNtVPZ0HF6Kx0but-4KW-+yQnt_gyGj8w5QPbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oj5V9eWNtVPZ0HF6Kx0but-4KW-+yQnt_gyGj8w5QPbg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 03:03:17PM +0100, Jason A. Donenfeld wrote:
> Hi Jarkko,
> 
> On Mon, Jan 16, 2023 at 9:12 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index d69905233aff..6df9067ef7f9 100644
> > > --- a/drivers/char/tpm/tpm-interface.c
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -412,7 +412,10 @@ int tpm_pm_suspend(struct device *dev)
> > >       }
> > >
> > >  suspended:
> > > -     return rc;
> > > +     if (rc)
> > > +             pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
> > > +                    chip->dev_num, rc);
> > > +     return 0;
> > >  }
> > >  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
> > >
> > > --
> > > 2.39.0
> > >
> >
> > Let me read all the threads through starting from the original report. I've
> > had emails piling up because of getting sick before holiday, and holiday
> > season after that.
> >
> > This looks sane
> 
> No, not really. I mean, it was sane under the circumstances of, "I'm
> not going to spend time fixing this for real if the maintainers aren't
> around," and it fixed the suspend issue. But it doesn't actually fix
> any real tpm issue. The real issue, AFAICT, is there's some sort of
> race between the tpm rng read command and either suspend or wakeup or
> selftest. One of these is missing some locking. And then commands step
> on each other and the tpm gets upset. This is probably something that
> should be fixed. I assume the "Fixes: ..." tag will actually go quite
> far back, with recent things only unearthing a somewhat old bug. But
> just a hunch.
> 
> Jason

See my response to Vlastimil:

https://lore.kernel.org/linux-integrity/Y8sr7YJ8e8eSpPFv@kernel.org/

Can you try what happens if you do not call tpm_add_hwrng()?

BR, Jarkko
