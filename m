Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0056280B
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiGABRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 21:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGABRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 21:17:16 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34955A2C4;
        Thu, 30 Jun 2022 18:17:14 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id q132so1434541ybg.10;
        Thu, 30 Jun 2022 18:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fGaRW9f/FbC8eT5BqHh5zoKO5SaFnieDixEeIzZYM2s=;
        b=kr16HWO02WGKZk3cKmhKygPCn4mNRHVzjVn4icoMdbzfF0s+qPKJgmYHFCm6o626Vh
         ddTZIdfpnAgnTjsQSaMbLY3jpRvWUVjZ/DiLRTB9/ubx7pL0aqNQwgJMzteEBPAdIbHL
         9DHPz7hFjcoRq8vJTpf/emEIdSjNQ1iR5cKgVloU9Cs3nbrP9ydaHgE4wBdkm4AJnZAF
         S+bUbOZT8NvIqfGQvJ/L+2UB+BCfbpXp5hw+eKDbDFDDQM5K822yJWNnYHE4bJ3x9cxZ
         PmB99eOx1yQXrGpRjCmrlUrreYn460M9/RTcLKkuKD5M7/HQrpb078aRFr5fwYvqG6bp
         xkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fGaRW9f/FbC8eT5BqHh5zoKO5SaFnieDixEeIzZYM2s=;
        b=1qwcH+kHqaYVGjgP4ogFN5Fy4IndRj3UWL1q9DeLtPwCSz260Eo4IAoI0K0OhtH4aA
         Z+qa0Qz2KyK0zP0CcWJTMnf3EV6B7SXanXT3buTs13/Y6SIWIe7qPCJHA+lYQjOuZqnY
         nXGAGjrrw3vKOJHO5TAp+gnfAkMQKWRuJLceGb7/oGLbvVne61lVqt0Be095zTGFxX/P
         usBKoR6MpYNUFnC4GmM6dPHGqakRuHS2e6zztsCLDVvGRQgUSawbe9j0OrRPlXcczYXb
         Min9HqnxToGo1mfGzP3M6SX/DPA58x52yGM1v2HsaNpPqHfrQkhGjl5RbodsCQFICTpz
         PeFQ==
X-Gm-Message-State: AJIora9nCSjf0QaoSP/mkhCh7vCm0iFU5hv/zWdqStYU0t4tnUPgQtob
        MSEQAwJtF2QnL0wHOx2G3SmkQ/NSVyCYSryAORk=
X-Google-Smtp-Source: AGRyM1ukAzVBsUUJ9Uy0TkVZ/LDWl5vfY+1PFDz2j9Uo1CqWsH3oMBruiufaVHAJQwfNCC4QtBC7Pu6t6xofDP7JDPw=
X-Received: by 2002:a05:6902:1021:b0:66d:43a7:f79f with SMTP id
 x1-20020a056902102100b0066d43a7f79fmr12064237ybt.564.1656638233806; Thu, 30
 Jun 2022 18:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <Yrw5f8GN2fh2orid@zx2c4.com> <20220629114240.946411-1-Jason@zx2c4.com>
 <Yr2tM4fX4YjOSQxh@zx2c4.com>
In-Reply-To: <Yr2tM4fX4YjOSQxh@zx2c4.com>
From:   Gregory Erwin <gregerwin256@gmail.com>
Date:   Thu, 30 Jun 2022 18:17:03 -0700
Message-ID: <CAO+Okf7Yfdu7qMisxEDfPshQWwY+LhSULAvJaZ7jOH6pd=UyVg@mail.gmail.com>
Subject: Re: [PATCH v8] ath9k: let sleep be interrupted when unregistering hwrng
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 7:03 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Gregory,
>
> On Wed, Jun 29, 2022 at 01:42:40PM +0200, Jason A. Donenfeld wrote:
> > There are two deadlock scenarios that need addressing, which cause
> > problems when the computer goes to sleep, the interface is set down, an=
d
> > hwrng_unregister() is called. When the deadlock is hit, sleep is delaye=
d
> > for tens of seconds, causing it to fail. These scenarios are:
> >
> > 1) The hwrng kthread can't be stopped while it's sleeping, because it
> >    uses msleep_interruptible() instead of schedule_timeout_interruptibl=
e().
> >    The fix is a simple moving to the correct function. At the same time=
,
> >    we should cleanup a common and useless dmesg splat in the same area.
> >
> > 2) A normal user thread can't be interrupted by hwrng_unregister() whil=
e
> >    it's sleeping, because hwrng_unregister() is called from elsewhere.
> >    The solution here is to keep track of which thread is currently
> >    reading, and asleep, and signal that thread when it's time to
> >    unregister. There's a bit of book keeping required to prevent
> >    lifetime issues on current.
> >
> > Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Cc: Kalle Valo <kvalo@kernel.org>
> > Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: stable@vger.kernel.org
> > Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dump=
ing into random.c")
> > Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgD=
sFGTEjs0c00giw@mail.gmail.com/
> > Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY=
8Hys_DVXtent3HA@mail.gmail.com/
> > Link: https://bugs.archlinux.org/task/75138
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Hoping for your `Tested-by:` if this still works for you.
>
> Jason

Apologies for the delay.
Tested-by: Gregory Erwin <gregerwin256@gmail.com>
