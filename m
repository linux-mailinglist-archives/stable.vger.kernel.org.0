Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451F66078B
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 21:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjAFUEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 15:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbjAFUEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 15:04:52 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D35881D7A
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 12:04:51 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n63so1243681iod.7
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 12:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MzDYy7xH3h8odSKsfYc3qRpLkXTC2bMipKsVQCeG9FI=;
        b=LppGhafXep900ETRX0WoS44tL4OJE5U/oiAMFVHG9hQ0mds8BDedt6H6Bw1FrzaM4t
         N4iN+eaxJ90iKHNasykQ02gS0Ik5BRQ9Gn/Ch5b5p8hIX+WAipztit/AA7bm7flrp2hU
         dq28Syy8Q+Mdab8MPFuej1FbyZ91btaR7d6dQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzDYy7xH3h8odSKsfYc3qRpLkXTC2bMipKsVQCeG9FI=;
        b=pTAnINg2to5lLRhNSUs5vvqPFmniH0as9ovlKE03Ya1JQTWAadALyXTmuGxujQDOMS
         v+2xUQ94ywFDWOxJPlo+C7w5MRNMcf0ORCgmwaHfjy2cPJ6TnFOYeelDVqUelMoG0aTU
         Swexs3fpTtBEVI8RB9Bhw5Vh76JuITxohOpHk73LvZcmD8us5vMhoTPjPGqIGMMrD4C5
         eTjVmX3lwDI3DWmB274Fp9AJ/vVGOqhNCuh+fvgjNAmvSzULuAriqz9t9AtoxFh3BPVM
         qO8CLvRSf3CJU7lsqX7JiyUCgWoHjppVN5lfPfLMc9LyYrcruBO1d1CcqTq07WrXF9x0
         Ojaw==
X-Gm-Message-State: AFqh2kq3XJUSsN4Iq7E4qAM3KHc3r9KHVNc43QUFtUqttn2X/V/6j9uG
        s6Sprz50ygdG/PeK1mJBwA/xsucRTXA3qGWTdg5yVA==
X-Google-Smtp-Source: AMrXdXt+OvGRW73oMucqsNbQBvW95NaKoS/i4Q0oSWPahJsIrZlzWwcHZyn2Uwc7cUnXowlDV8MNakYCs0MmrINVMWY=
X-Received: by 2002:a02:665f:0:b0:376:1ab0:7bd5 with SMTP id
 l31-20020a02665f000000b003761ab07bd5mr5197244jaf.8.1673035489129; Fri, 06 Jan
 2023 12:04:49 -0800 (PST)
MIME-Version: 1.0
References: <Y7dPV5BK6jk1KvX+@zx2c4.com> <20230106030156.3258307-1-Jason@zx2c4.com>
 <CAHk-=wjin0Rn6j+EvYV9pzrbA0G2xnHKdp_EAB6XnansQ8kpUA@mail.gmail.com>
In-Reply-To: <CAHk-=wjin0Rn6j+EvYV9pzrbA0G2xnHKdp_EAB6XnansQ8kpUA@mail.gmail.com>
From:   Luigi Semenzato <semenzato@chromium.org>
Date:   Fri, 6 Jan 2023 12:04:37 -0800
Message-ID: <CAA25o9Sbkg=qD+DH-aqXY9H5R_oBtePcnqagwAGCgoUk8D-Vyg@mail.gmail.com>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM suspend fails
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        tbroch@chromium.org, dbasehore@chromium.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think it's fine to go ahead with your change, for multiple reasons.

1. I doubt that any of the ChromeOS devices using TPM 1.2 are still
being updated.
2. If the SAVESTATE command fails, it is probably better to continue
the transition to S3, and fail at resume, than to block the suspend.
The suspend is often triggered by closing the lid, so users would not
see what's going on and might put their running laptop in a backpack,
where it could overheat.
3. I don't recall bugs due to failures of TPM suspend, and I didn't
find any such bug in our database.  Many (most?) ChromeOS devices left
the TPM powered on in S3, so didn't use the suspend/resume path.

Thank you for asking!


On Fri, Jan 6, 2023 at 11:00 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Jan 5, 2023 at 7:02 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > In lieu of actually fixing the underlying bug, just allow system suspend
> > to continue, so that laptops still go to sleep fine. Later, this can be
> > reverted when the real bug is fixed.
>
> So the patch looks fine to me, but since there's still the ChromeOS
> discussion pending I'll wait for that to finish.
>
> Perhaps re-send or at least remind me if/when it does?
>
> Also, a query about the printout:
>
> > +       if (rc)
> > +               pr_err("Unable to suspend tpm-%d (error %d), but continuing system suspend\n",
> > +                      chip->dev_num, rc);
>
> so I suspect that 99% of the time the dev_num isn't actually all that
> useful, but what *might* be useful is which tpm driver it is.
>
> Just comparing the error dmesg output you had:
>
>   ..
>   tpm tpm0: Error (28) sending savestate before suspend
>   tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
>   ..
>
> that "tpm tpm0" output is kind of useless compared to the "tpm_tis 00:08" one.
>
> So I think "dev_err(dev, ...)" would be more useful here.
>
> Finally - and maybe I'm just being difficult here, I will note here
> again that TPM2 devices don't have this issue, because the TPM2 path
> for suspend doesn't do any of this at all.
>
> It just does
>
>         tpm_transmit_cmd(..);
>
> with a TPM2_CC_SHUTDOWN TPM_SU_STATE command, and doesn't even check
> the return value. In fact, the tpm2 code *used* to have this comment:
>
>         /* In places where shutdown command is sent there's no much we can do
>          * except print the error code on a system failure.
>          */
>         if (rc < 0 && rc != -EPIPE)
>                 dev_warn(&chip->dev, "transmit returned %d while
> stopping the TPM",
>                          rc);
>
> but it was summarily removed when doing some re-organization around
> buffer handling.
>
> So just by looking at what tpm2 does, I'm not 100% convinced that tpm1
> should do this dance at all.
>
> But having a dev_err() is probably a good idea at least as a transitional thing.
>
>                   Linus
