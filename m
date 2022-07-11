Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3461570AD5
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 21:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiGKThu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 15:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiGKTht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 15:37:49 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC04D4E8;
        Mon, 11 Jul 2022 12:37:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id o7so10367205lfq.9;
        Mon, 11 Jul 2022 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A4JHArgc2s+5GOoOO0PJp9b8nXcn+f7ATVJu+wNYsfs=;
        b=NfanDx12r4uhByK5iiL46uu291qZuQ5alGkeu5IpNfs8e/gi4JYrK8qwf1dRqZsLke
         YSyess7cxeV4ScILCMLP3WlCOa2HEmGoKfAecI8q0qfEKnG63/KWd8dfcNxltD6DuOwW
         spFsYDxap2S4f59Kn+3+mBctYh9oG+lqgm6NVzCu5jZ2eEX6kvOPDiAQQMqDKjGZqlrs
         A9xZV18QAQvF4dqUzoLg4K5GYyi9lJSiHFAULvUfRQeFt0l/93jBvO85N5pNH6wEKh2H
         ktL40jfzeZjLQANyTChfh6W87/WoFnWvvKtq9m4N+kCUQGsuZrx2cxdj7tGFQZQNijx9
         dU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A4JHArgc2s+5GOoOO0PJp9b8nXcn+f7ATVJu+wNYsfs=;
        b=oEeWcxaF3YxqfQ61F6vD6o+mnlR0zCa/nRlSTtwM2Ib89amyoPhoDNk73S3KP76l52
         g/LUy8DM6J+EDyQtgH/BzGil+0JNtokq00Mt3ofpe+1NU1o5hBSOCHJNakMyCRK7zqLV
         /+p02NhQvf7z+xnYwzlQe5RHl7K475O8RoXeGtnC29O1RCrKxTODAm4zm40CYzTXBz9u
         dRF6ImnJHR89MLjR8D4JQIl8fc0vkvS+QLoUScsJLrQhzuHe39/OtSBCzRRlRasM6af3
         s0Jj9To+eUD/mMBgRaNIvcUdSCt3s/2kJv69+QXSv+CDgmaKN7JPKf1PW4iG3mnr09Q3
         EoGg==
X-Gm-Message-State: AJIora8CpicU5B1lr6AXV9eFQCXnhLDXvQVP2cKy3EyLwaYHlfg9BXhU
        XmzbRvRPaQ5nb5B4Vwn1IAYJBnlffhE8qNHo3rY+/SIW
X-Google-Smtp-Source: AGRyM1sMwO67XvFDpUPQu55Ww7kgydNlRu3c4ksRjw2L2Rwm5rYXBIR26iJ5nby2ARhw7odTnRvHGp114MVUeMBQRFw=
X-Received: by 2002:a05:6512:1312:b0:47f:7bd3:1427 with SMTP id
 x18-20020a056512131200b0047f7bd31427mr11963717lfu.128.1657568266717; Mon, 11
 Jul 2022 12:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164043.417780-1-jandryuk@gmail.com> <YsuRzGBss/lMG2+W@kernel.org>
In-Reply-To: <YsuRzGBss/lMG2+W@kernel.org>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Mon, 11 Jul 2022 15:37:34 -0400
Message-ID: <CAKf6xpvY0Tj4HGpbshWonnpJLf_08+9pARONt2uHi-m92aqJmQ@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: Hold locality open during probe
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Chen Jun <chenjun102@huawei.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 10:58 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> On Wed, Jul 06, 2022 at 12:40:43PM -0400, Jason Andryuk wrote:
> > WEC TPMs (in 1.2 mode) and NTC (in 2.0 mode) have been observer to
> > frequently, but intermittently, fail probe with:
> > tpm_tis: probe of 00:09 failed with error -1
> >
> > Added debugging output showed that the request_locality in
> > tpm_tis_core_init succeeds, but then the tpm_chip_start fails when its
> > call to tpm_request_locality -> request_locality fails.
> >
> > The access register in check_locality would show:
> > 0x80 TPM_ACCESS_VALID
> > 0x82 TPM_ACCESS_VALID | TPM_ACCESS_REQUEST_USE
> > 0x80 TPM_ACCESS_VALID
> > continuing until it times out. TPM_ACCESS_ACTIVE_LOCALITY (0x20) doesn't
> > get set which would end the wait.
> >
> > My best guess is something racy was going on between release_locality's
> > write and request_locality's write.  There is no wait in
> > release_locality to ensure that the locality is released, so the
> > subsequent request_locality could confuse the TPM?
> >
> > tpm_chip_start grabs locality 0, and updates chip->locality.  Call that
> > before the TPM_INT_ENABLE write, and drop the explicit request/release
> > calls.  tpm_chip_stop performs the release.  With this, we switch to
> > using chip->locality instead of priv->locality.  The probe failure is
> > not seen after this.
> >
> > commit 0ef333f5ba7f ("tpm: add request_locality before write
> > TPM_INT_ENABLE") added a request_locality/release_locality pair around
> > tpm_tis_write32 TPM_INT_ENABLE, but there is a read of
> > TPM_INT_ENABLE for the intmask which should also have the locality
> > grabbed.  tpm_chip_start is moved before that to have the locality open
> > during the read.
> >
> > Fixes: 0ef333f5ba7f ("tpm: add request_locality before write TPM_INT_ENABLE")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> > ---
> > The probe failure was seen on 5.4, 5.15 and 5.17.
> >
> > commit e42acf104d6e ("tpm_tis: Clean up locality release") removed the
> > release wait.  I haven't tried, but re-introducing that would probably
> > fix this issue.  It's hard to know apriori when a synchronous wait is
> > needed, and they don't seem to be needed typically.  Re-introducing the
> > wait would re-introduce a wait in all cases.
> >
> > Surrounding the read of TPM_INT_ENABLE with grabbing the locality may
> > not be necessary?  It looks like the code only grabs a locality for
> > writing, but that asymmetry is surprising to me.
> >
> > tpm_chip and tpm_tis_data track the locality separately.  Should the
> > tpm_tis_data one be removed so they don't get out of sync?
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 20 ++++++++------------
> >  1 file changed, 8 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index dc56b976d816..529c241800c0 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -986,8 +986,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
> >               goto out_err;
> >       }
> >
> > +     /* Grabs locality 0. */
> > +     rc = tpm_chip_start(chip);
> > +     if (rc)
> > +             goto out_err;
> > +
> >       /* Take control of the TPM's interrupt hardware and shut it off */
> > -     rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
> > +     rc = tpm_tis_read32(priv, TPM_INT_ENABLE(chip->locality), &intmask);
> >       if (rc < 0)
> >               goto out_err;
> >
> > @@ -995,19 +1000,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
> >                  TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
> >       intmask &= ~TPM_GLOBAL_INT_ENABLE;
> >
> > -     rc = request_locality(chip, 0);
> > -     if (rc < 0) {
> > -             rc = -ENODEV;
> > -             goto out_err;
> > -     }
> > -
> > -     tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
> > -     release_locality(chip, 0);
> > +     tpm_tis_write32(priv, TPM_INT_ENABLE(chip->locality), intmask);
> >
> > -     rc = tpm_chip_start(chip);
> > -     if (rc)
> > -             goto out_err;
> >       rc = tpm2_probe(chip);
> > +     /* Releases locality 0. */
> >       tpm_chip_stop(chip);
> >       if (rc)
> >               goto out_err;
> > --
> > 2.36.1
> >
>
> Can you test against
>
> https://lore.kernel.org/linux-integrity/20220629232653.1306735-1-LinoSanfilippo@gmx.de/T/#t

I applied on top of 5.15.53, and the probe on boot still fails.
Manually probing works intermittently.

Regards,
Jason
