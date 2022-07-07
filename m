Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057C656A1CF
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiGGMRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 08:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiGGMRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 08:17:04 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7D8237CF;
        Thu,  7 Jul 2022 05:17:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bn33so603636ljb.13;
        Thu, 07 Jul 2022 05:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qfuJzO7Or1hWutQ+055wT2mkGtRVlLJZKOvJBQUacs4=;
        b=nhjLdyUgzSBGyn9ZAj9Ub70NCHUDRm68Jc3D8pHg16pEAyy4eIBz8CFJ92r42zwS5U
         QJ52CTfsvnFoJha09WyzpHei+Ry/IBYgzRaPd8LKbawqC9/7HNj6RlwhJTX/4hXNuxrU
         rfd4g0b7g5vksVaBDympNxGUSHaHqAOOe9CAogCovSJUVS3shKhWOH5XgnasXrza/ABq
         rbG8LTAKWsNs07O/K6K9Ly4yZVcMM1ntnpR71nN0rKxtS6qYTfJxak3yo8/oa3C5+vgA
         8YA9yU4OQHAVr7iSC5uNFke6y12oFkObkS/KpknxC+of6uHN4U5pgUuZwQAd8bYOo5vL
         VOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qfuJzO7Or1hWutQ+055wT2mkGtRVlLJZKOvJBQUacs4=;
        b=k/LYaWKFOrCcInpi+XbpkND47J0vykzuniQJ0xEaxg1/oC/Ba9otzOdAwF+VaEWW6y
         iutk1q3Nwa8yxebg9j0cOr7PArab13Pn2521thaw9CPgbj7f+8wro3K+pQqZL/Vyk5Pr
         N6hlvHzPR1GV1h8XpVWHb8Nmaq10xlxwXMVxqh78Qr1XiRu7LIDKAbub1q7i2zYZseVL
         fvpTo/eLtcKaR4q2NXoCeQWdvnJZSiY8bchdj3P++qiO2VWtFadSEFg8eFB7FznPGQ4j
         pikXqDhZuxPFiyP68GnBYtkCn2UY8hfqsBJP1+8w0ldo9UtlxqOfz3qH92yKev5R86Fc
         Arog==
X-Gm-Message-State: AJIora91DAwIXo02dbrMpgNBdTheDve+ZVsS9QNXKWlbEWoijrKJ7+Hn
        mZvcWKt4BzPx6M3pXs+vSEJbBzqeaRvuOLoHQctOU45UUKA=
X-Google-Smtp-Source: AGRyM1s+RbuwD2N4/3CLcjeaFbbM5o6RlMijDKSoUc4v3+elnXOrfUTLZJKzeYT7+jrC2vqoDXH+dHqmr0CFLZgOaNE=
X-Received: by 2002:a2e:8608:0:b0:25d:3cb6:c306 with SMTP id
 a8-20020a2e8608000000b0025d3cb6c306mr6265880lji.389.1657196221230; Thu, 07
 Jul 2022 05:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164043.417780-1-jandryuk@gmail.com> <5687473ad4da4c26a85b6d230cfc011a@huawei.com>
In-Reply-To: <5687473ad4da4c26a85b6d230cfc011a@huawei.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Thu, 7 Jul 2022 08:16:49 -0400
Message-ID: <CAKf6xpu6Pg7fdg4F5Qk4twinCjaOxYQpwq+N=1+WX19nT=xmOg@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: Hold locality open during probe
To:     "chenjun (AM)" <chenjun102@huawei.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 7, 2022 at 3:48 AM chenjun (AM) <chenjun102@huawei.com> wrote:
>
> =E5=9C=A8 2022/7/7 0:41, Jason Andryuk =E5=86=99=E9=81=93:
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
> > continuing until it times out. TPM_ACCESS_ACTIVE_LOCALITY (0x20) doesn'=
t
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
> > Fixes: 0ef333f5ba7f ("tpm: add request_locality before write TPM_INT_EN=
ABLE")
>
> 0ef333f5ba7f is probably not the commit that introduced the problem? As
> you said the problem was in 5.4 and the commit was merged in 5.16.

I was imprecise with my versions.  0ef333f5ba7f was backported to
stable-5.4.y as 13af3a9b1ba6 in 5.4.174.  I was running 5.4.163 on
some systems without problem, but the probe failures started after
jumping to 5.4.200.

Other systems showing the probe failures were 5.15.29 (which has
0ef333f5ba7f backported as ea1fd8364c9f 5.15.17) and 5.17.y (5.17.5 I
think) from a Fedora 36 USB drive.

Other machines run fine with 0ef333f5ba7f which is part of why I
didn't notice it earlier between 5.4.613 and 5.4.200.

At the top I wrote: "frequently, but intermittently, fail probe".  To
expand on that: Basically on the affected machines, the probe during
boot fails.  In one instance, I repeatedly ran `echo 00:05 >
/sys/bus/pnp/drivers/tpm_tis/bind`, and it successfully probed on the
7th try.  So something racy seems to be going on.

Regards,
Jason
