Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BDD1C2F42
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 22:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgECUh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 16:37:26 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34207 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgECUhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 May 2020 16:37:25 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1c1f5387;
        Sun, 3 May 2020 20:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=4oxhkRayVlbQD2eyndSaQE0tWZc=; b=vA549m
        QfhxuqTQ/UFjGIJfh7Pmgt4ABg7edALWKWwfr+p1a7XQUU+OstnbhpbqS7SAvgVk
        JFyEkLs4sNxlV9cfnMyfQiOhNv8VH/FGPtfK/S7mOPo27jeZnLCbYU0L+gGOFXQu
        1RgrDZSj7KWXUHl6carogwlb1a+TMju+JstP1XP0BCDYgp98tGi0Iy+NGRdP/dSX
        6+xKXkjuhXYnkF7XDe9v8kJcWoGC/9VzqXlXxJ9F3XTtWuTCiQ9ZpeZrRma29Mgj
        8kEEb52x9xW3FrJraAMXywcoqdn9XLgo4hnAGX17f0+21BfKZUNP3o78SZ/JWKHz
        h1kU4mhSVxR+Rk3g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 285f47ea (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 3 May 2020 20:24:59 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e8so9415329ilm.7;
        Sun, 03 May 2020 13:37:19 -0700 (PDT)
X-Gm-Message-State: AGi0Pua+ijx82Dzriaz7H1o1IcFJQHPygzRe43uD+7WreGMoHNNsu8+s
        xGG0QhTnjDNu26RiyS7xIHFco0mxsfhaDm/4aI0=
X-Google-Smtp-Source: APiQypIRfBeAuZGWtTR/twhRA+JKgfG0fxdVuT4KIOOzAu177n+yQghVKAOj9DMvm3a8v0062/KgRLH/QmcumDNrKd4=
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr13779158ilm.38.1588538238517;
 Sun, 03 May 2020 13:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200503203108.15420-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200503203108.15420-1-chris@chris-wilson.co.uk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 3 May 2020 14:37:07 -0600
X-Gmail-Original-Message-ID: <CAHmME9rK29z+uoEU4wBuZFF+=0vC_0zQWKcaW71ZrGV2spjwjw@mail.gmail.com>
Message-ID: <CAHmME9rK29z+uoEU4wBuZFF+=0vC_0zQWKcaW71ZrGV2spjwjw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Avoid using simd from interrupt context
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 3, 2020 at 2:31 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Query whether or not we are in a legal context for using SIMD, before
> using SSE4.2 registers.
>
> Suggested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_memcpy.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_memcpy.c b/drivers/gpu/drm/i915/i915_memcpy.c
> index 7b3b83bd5ab8..fc18d6c28d5f 100644
> --- a/drivers/gpu/drm/i915/i915_memcpy.c
> +++ b/drivers/gpu/drm/i915/i915_memcpy.c
> @@ -24,6 +24,7 @@
>
>  #include <linux/kernel.h>
>  #include <asm/fpu/api.h>
> +#include <asm/simd.h>
>
>  #include "i915_memcpy.h"
>
> @@ -115,6 +116,9 @@ bool i915_memcpy_from_wc(void *dst, const void *src, unsigned long len)
>         if (unlikely(((unsigned long)dst | (unsigned long)src | len) & 15))
>                 return false;
>
> +       if (unlikely(!may_use_simd()))
> +               return false;
> +
>         if (static_branch_likely(&has_movntdqa)) {
>                 if (likely(len))
>                         __memcpy_ntdqa(dst, src, len >> 4);
> --
> 2.20.1

Looks like you beat me to the punch. Thanks for doing this.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
