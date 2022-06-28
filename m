Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2255CBBA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbiF1Bjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 21:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiF1Bjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 21:39:48 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010AB1C92D;
        Mon, 27 Jun 2022 18:39:45 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v38so9043855ybi.3;
        Mon, 27 Jun 2022 18:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ox6+Io6BGSC8s0kRQJwOIJGx439nhItnmMC9YkQAOrc=;
        b=hnyr3Pgs4SOImHVvxjD8CHgAVznJET4LCNMirseEGBRBdrFhWD3+1wy69a27JDyCl6
         OKzDJyvyzVC6AzOngE+BvP5SCwoRjtq1oiPKtx5KEwZMYl3e3bJ7h6bl3j+EUk00JXFQ
         XzsWeJnBdbfJvmF6DS4WbUeCXPWXFZHNPcBwLELhnnXAn7kq1W7WThQH1d0xfsvqJ5Bt
         68xnvsoFNobArPLoJngFhUSKT8csnQRpmdje6P1iM4zRgPhADlbCVNLE/jyh/ZxvmL1q
         KnAIWYWW32QSHKZ04D99PsDyc8hW6bbmkytsGtTh5f714kHtNRT2FSdGL3xSnKciSMrH
         suqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ox6+Io6BGSC8s0kRQJwOIJGx439nhItnmMC9YkQAOrc=;
        b=1aquROyabHcDRompxHd+wS32At0OtDolZzayI4kfDX5VmOci+SPMy42IgFHbpKVena
         8/Y0ogCpztUqiX1x0uAN/Yq93npBzVhkIQVYf1DBW8PYOURTMN+0YCHN9bbTUXOY2G58
         AbUb2IshpIYxk025CGUleE0dz8AR7nix38/3BF5E2WQUTGXqsbFnjPzo6UIkyiXvR7o0
         keFzBiW9L0zl8BbO8VQiEfL2tl41FHAoBY2bDqbXKker0xDtPb1vBzZGP1mAPD1lmsq4
         hBqfM7ZgTqmhvprKZX2NdT3Sl9FSMgMyGln4FW5H3sMk9N3SkbPmxmcCUKmlz003pnRE
         tjsA==
X-Gm-Message-State: AJIora84P4lN48KKFHdf5ch5w97yEQXHGMchXSRR/iDOkqwyg5TPoNtW
        1yHZEbBcMeVjb7YuX5M4JXxHMU3C8GiNbKKipWrWmHfxCmVLKg==
X-Google-Smtp-Source: AGRyM1tX9NrNa9lFUyRuVQmBjG9hD6YBesB/1lq96fdz99XMTuRDOnm7rIL/mDb42qJee3sRmU0MON8HoaTdlgJicrw=
X-Received: by 2002:a05:6902:726:b0:66d:e6d:e0b1 with SMTP id
 l6-20020a056902072600b0066d0e6de0b1mr4249776ybt.269.1656380385235; Mon, 27
 Jun 2022 18:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220627113749.564132-1-Jason@zx2c4.com> <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk>
In-Reply-To: <87y1xib8pv.fsf@toke.dk>
From:   Gregory Erwin <gregerwin256@gmail.com>
Date:   Mon, 27 Jun 2022 18:39:34 -0700
Message-ID: <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
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

On Mon, Jun 27, 2022 at 5:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > Even though hwrng provides a `wait` parameter, it doesn't work very wel=
l
> > when waiting for a long time. There are numerous deadlocks that emerge
> > related to shutdown. Work around this API limitation by waiting for a
> > shorter amount of time and erroring more frequently. This commit also
> > prevents hwrng from splatting messages to dmesg when there's a timeout
> > and switches to using schedule_timeout_interruptible(), so that the
> > kthread can be stopped.
> >
> > Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> > Tested-by: Gregory Erwin <gregerwin256@gmail.com>
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
> Gregory, care to take this version for a spin as well to double-check
> that it still resolves the issue? :)
>
> -Toke
>

With patch v6, reads from /dev/hwrng block for 5-6s, during which 'ip link =
set
wlan0 down' will also block. Otherwise, 'ip link set wlan0 down' returns
immediately. Similarly, wiphy_suspend() consistently returns in under 10ms.

Tested-by: Gregory Erwin <gregerwin256@gmail.com>
