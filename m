Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FA655C78C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiF1Kq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiF1Kq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0326D31387;
        Tue, 28 Jun 2022 03:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 938EC61952;
        Tue, 28 Jun 2022 10:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6092CC3411D;
        Tue, 28 Jun 2022 10:46:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a9feM0oh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656413213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1+XQe9PqcwgQsDSvyoCmP1LY8+BTuhpoUQPoquwuoI=;
        b=a9feM0ohd6QI8kuAMcG7qcWI25IdpdFm1QC1D9Oy8jiMeMwQ2vpFv4Bd2sGx3iGEgwPJRl
        5PIgXjojR1EQS4K/RQCRyxfQCzmy9wDfLqDr0skeeltDL/z6e+fI8aSFUBy/4NLUvvwoL3
        34ihvBoSC8Ub2ZTMq1uPTFGaVX7wzbM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f01c9ff3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 28 Jun 2022 10:46:53 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id p69so12389637iod.10;
        Tue, 28 Jun 2022 03:46:52 -0700 (PDT)
X-Gm-Message-State: AJIora/t8xFC8m1R4FLUZysfPfy+17EjNumSo1QwpkQz3Z2yrT1gM+af
        EdW5SDie1wGgbHJXDd/r9QMOkmJOtdlKIhi5WcI=
X-Google-Smtp-Source: AGRyM1sZkA27UHQAkQ/MTTEnFeDep7LXqdjn21vxh3zhfJKtqyL6QvQR//J+QtkLmTcISaslz3AHEoOzUa5vALZiYrQ=
X-Received: by 2002:a6b:fe16:0:b0:675:4768:67be with SMTP id
 x22-20020a6bfe16000000b00675476867bemr3669363ioh.24.1656413211694; Tue, 28
 Jun 2022 03:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220627113749.564132-1-Jason@zx2c4.com> <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk> <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
In-Reply-To: <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Jun 2022 12:46:40 +0200
X-Gmail-Original-Message-ID: <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
Message-ID: <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
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

Hi Gregory,

On Tue, Jun 28, 2022 at 3:39 AM Gregory Erwin <gregerwin256@gmail.com> wrot=
e:
>
> On Mon, Jun 27, 2022 at 5:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> >
> > > Even though hwrng provides a `wait` parameter, it doesn't work very w=
ell
> > > when waiting for a long time. There are numerous deadlocks that emerg=
e
> > > related to shutdown. Work around this API limitation by waiting for a
> > > shorter amount of time and erroring more frequently. This commit also
> > > prevents hwrng from splatting messages to dmesg when there's a timeou=
t
> > > and switches to using schedule_timeout_interruptible(), so that the
> > > kthread can be stopped.
> > >
> > > Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> > > Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> > > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Cc: Kalle Valo <kvalo@kernel.org>
> > > Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: stable@vger.kernel.org
> > > Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly du=
mping into random.c")
> > > Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytG=
gDsFGTEjs0c00giw@mail.gmail.com/
> > > Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7=
EY8Hys_DVXtent3HA@mail.gmail.com/
> > > Link: https://bugs.archlinux.org/task/75138
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > Gregory, care to take this version for a spin as well to double-check
> > that it still resolves the issue? :)
> >
> > -Toke
> >
>
> With patch v6, reads from /dev/hwrng block for 5-6s, during which 'ip lin=
k set
> wlan0 down' will also block. Otherwise, 'ip link set wlan0 down' returns
> immediately. Similarly, wiphy_suspend() consistently returns in under 10m=
s.
>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>

Oh 5-6s... so it's actually worse. Yikes. Sounds like v4 might have
been the better patch, then?

Jason
