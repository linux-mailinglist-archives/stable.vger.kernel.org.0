Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE9555CC39
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344294AbiF1KtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345069AbiF1KtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:49:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6E5BF44;
        Tue, 28 Jun 2022 03:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF8C6192F;
        Tue, 28 Jun 2022 10:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC72C3411D;
        Tue, 28 Jun 2022 10:49:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ab+OweOz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656413342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HURAS/8CFysnmlmrd00fLEocYq88R+/wRdD7aPhyG+4=;
        b=ab+OweOz4ndI/uCrLcPqXMLGGyWScN1vuKwU+eZ9FHZTYJUihpE73hGh0OLNl8lQuKFFcx
        pzN8Ux0801kN6ZA61hRumyTW3fR1x0qgKcWdmQh3bDft5lTfwFJ9+krFJ+hZFlyUsEpKJw
        obWG/5KpiCfc9V7O3pyqsuNM2QSNp8k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2031dc96 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 28 Jun 2022 10:49:02 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id p13so7911172ilq.0;
        Tue, 28 Jun 2022 03:49:02 -0700 (PDT)
X-Gm-Message-State: AJIora81NOh2q1PVGofT7JtP4uaA8B4cd39DqzXHZ3TiTWQZPbOg7qZq
        eGEL/FZJplPFrGwKw5qonztk4TskggAr0utbVT4=
X-Google-Smtp-Source: AGRyM1tkSosQ9JI+bhDpgTkEUJwZBPGz0+cxzJ6Yrbm6xfXXCghAQehxQpAZVGG3mH/jN3dsY4Da3xsqVcDjN2scQZw=
X-Received: by 2002:a05:6e02:20c6:b0:2d8:e62f:349f with SMTP id
 6-20020a056e0220c600b002d8e62f349fmr9946650ilq.160.1656413340834; Tue, 28 Jun
 2022 03:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220627113749.564132-1-Jason@zx2c4.com> <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk> <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
 <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
In-Reply-To: <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Jun 2022 12:48:50 +0200
X-Gmail-Original-Message-ID: <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com>
Message-ID: <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com>
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
To:     Gregory Erwin <gregerwin256@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 12:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote=
:
>
> Hi Gregory,
>
> On Tue, Jun 28, 2022 at 3:39 AM Gregory Erwin <gregerwin256@gmail.com> wr=
ote:
> >
> > On Mon, Jun 27, 2022 at 5:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> > >
> > > > Even though hwrng provides a `wait` parameter, it doesn't work very=
 well
> > > > when waiting for a long time. There are numerous deadlocks that eme=
rge
> > > > related to shutdown. Work around this API limitation by waiting for=
 a
> > > > shorter amount of time and erroring more frequently. This commit al=
so
> > > > prevents hwrng from splatting messages to dmesg when there's a time=
out
> > > > and switches to using schedule_timeout_interruptible(), so that the
> > > > kthread can be stopped.
> > > >
> > > > Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> > > > Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> > > > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > > Cc: Kalle Valo <kvalo@kernel.org>
> > > > Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly =
dumping into random.c")
> > > > Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHy=
tGgDsFGTEjs0c00giw@mail.gmail.com/
> > > > Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4P=
O7EY8Hys_DVXtent3HA@mail.gmail.com/
> > > > Link: https://bugs.archlinux.org/task/75138
> > > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > >
> > > Gregory, care to take this version for a spin as well to double-check
> > > that it still resolves the issue? :)
> > >
> > > -Toke
> > >
> >
> > With patch v6, reads from /dev/hwrng block for 5-6s, during which 'ip l=
ink set
> > wlan0 down' will also block. Otherwise, 'ip link set wlan0 down' return=
s
> > immediately. Similarly, wiphy_suspend() consistently returns in under 1=
0ms.
> >
> > Tested-by: Gregory Erwin <gregerwin256@gmail.com>
>
> Oh 5-6s... so it's actually worse. Yikes. Sounds like v4 might have
> been the better patch, then?

$ curl https://lore.kernel.org/lkml/20220627104955.534013-1-Jason@zx2c4.com=
/raw
| git am

That one, if you want to give it a spin and see if that 5-6s is back
to ~1s or less.

Jason
