Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3B41C2F40
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 22:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgECUfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 16:35:21 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55001 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgECUfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 May 2020 16:35:21 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e7525e37;
        Sun, 3 May 2020 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=z5Do7NyDKuHfMJ/mAldD8G6RJ60=; b=e/VPTE
        L65O0OQ1o9jg74xixPwpiZoUamL3h2sC5/EZ3eitxMEVhQ72lh4vZw82PPFwwIQn
        3Ft31VWYR1iszDXqTIVyksn3ccsxfWJSY4CKtAMu0ASxTaJPkDeQ8Z3SXGV/ZUdr
        7acbxP5Upx9fzjHZqlWrrWDLufLJWOlYdRZy/FjCR+1w0EyNI3RLST7C9U8Se01L
        12Luica0tiD3Cpvy0xD3DxX/NIBBX1ny1Jj5ymBjl4HTzVr+G2YkzBCv0qMEegzu
        7aFEViPQ26u858asbgXP8YKOcidXe2teSnLC6Q5wddff/R3mH8tsm7nkGmxsGM4s
        Frhisbmv1xPsyHaw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b1037895 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 3 May 2020 20:22:56 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id c16so9411832ilr.3;
        Sun, 03 May 2020 13:35:15 -0700 (PDT)
X-Gm-Message-State: AGi0PuZA+AWx/5FN9xzyBKuKGRtdXxxzmdHORCw4hdQySmWPGchOjy19
        ITq2QH7nCSCeci02rMGJGoR0O0FqCl3icqr6jdM=
X-Google-Smtp-Source: APiQypIUEcNyFcnsHFVMbKCh4WfUv2KcwZdBYHy02yKWsXCGZThmATTnJ/z6CY+STZVhkP88X18Q9XG3mHkF5ndh8mY=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr13749187ilg.231.1588538114849;
 Sun, 03 May 2020 13:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200430221016.3866-1-Jason@zx2c4.com> <158853782127.10831.11598587258154009671@build.alporthouse.com>
In-Reply-To: <158853782127.10831.11598587258154009671@build.alporthouse.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 3 May 2020 14:35:03 -0600
X-Gmail-Original-Message-ID: <CAHmME9o51exzeeV6C95-9b=608-qFWag2X_jPTYEmuBUtUU3WQ@mail.gmail.com>
Message-ID: <CAHmME9o51exzeeV6C95-9b=608-qFWag2X_jPTYEmuBUtUU3WQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Sebastian Siewior <bigeasy@linutronix.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 3, 2020 at 2:30 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Quoting Jason A. Donenfeld (2020-04-30 23:10:16)
> > Sometimes it's not okay to use SIMD registers, the conditions for which
> > have changed subtly from kernel release to kernel release. Usually the
> > pattern is to check for may_use_simd() and then fallback to using
> > something slower in the unlikely case SIMD registers aren't available.
> > So, this patch fixes up i915's accelerated memcpy routines to fallback
> > to boring memcpy if may_use_simd() is false.
> >
> > Cc: stable@vger.kernel.org
>
> The same argument as on the previous submission is that we return to the
> caller if we can't use movntqda as their fallback path should be faster
> than uncached memcpy.

Oh, THAT's what you meant before. Okay, will follow up.
