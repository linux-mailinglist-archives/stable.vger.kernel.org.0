Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A989970034
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 14:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfGVMxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 08:53:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41094 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfGVMxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 08:53:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so38266315qtj.8;
        Mon, 22 Jul 2019 05:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dcEf8I7/m2lMn1t5WHBwpDegF2GOQrXyNgF8wvk2z0Q=;
        b=FqLFWkRTyCAS0NIROtwaiSjsMQBtiRt0p3d1k/9KeXbIQD31RnCPxmtDz0UB5qUIsQ
         9Qv2aDP5tbuPW5FQ8ZD3mhLjBGdoEUv2SLL7Q/rnACoiF5gkAyQKlfnpUKrElPOjALFP
         3fbuDCgeVOT+3FXfkphKCVOk0e3cLnG+OjcAin5pkWi1Yiwx1Ul+PQlVKrkCOFJTyuQx
         9XH2geu8dqLRNmQTAVI4/1sNKt7KiYOoZEqIc/G8nFftXfb7s0K1/qzXUvLt5ZIjw3h7
         HvuCAU3h8Kud72x4pq6CrxPTM/uFscBHJjshbgzCA9wKWVd4lekd4v/rvNI+Qultn36A
         XPgA==
X-Gm-Message-State: APjAAAVZys5p/EFwPu4zW7CgOJtDXTBqBx0j6tnzlrqdfJI5MKZu8MgO
        RvN/dC1VctK6cforbKzu2gSVWIhdKIa+FbBXZDQ=
X-Google-Smtp-Source: APXvYqxqDHdi0SquqiGUp1jmtJ6plkYDpw3TvBRqjntxHoVSucjD+1OsWE4KYg7uhDAvNDxkwcP1eWfLsW0/NHDVaY4=
X-Received: by 2002:a0c:b758:: with SMTP id q24mr50227938qve.45.1563799995616;
 Mon, 22 Jul 2019 05:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190722091050.2188664-1-arnd@arndb.de> <c7da8503-93bc-c130-2e50-918996abe6c7@virtuozzo.com>
In-Reply-To: <c7da8503-93bc-c130-2e50-918996abe6c7@virtuozzo.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Jul 2019 14:52:59 +0200
Message-ID: <CAK8P3a3pAEutcpfQJrCz+0m00LBEBn5qjxNnpRxK9HshnTjQww@mail.gmail.com>
Subject: Re: [PATCH] ubsan: build ubsan.c more conservatively
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sodagudi Prasad <psodagud@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 2:25 PM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> On 7/22/19 12:10 PM, Arnd Bergmann wrote:

> >
> > Fixes: 42440c1f9911 ("lib/ubsan: add type mismatch handler for new GCC/Clang")
>
> There was no uaccess validataion at that time, so the right fixes line is probably this:
>
> Fixes: d08965a27e84 ("x86/uaccess, ubsan: Fix UBSAN vs. SMAP")
>
> > Link: > +CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack) $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
>
> $(call cc-option, -fno-conserve-stack) can be removed entirely. It's just copy paste from kasan Makefile.
> It was added in kasan purely for performance reasons.

Ok, I addressed both of these and sent an updated patch, thanks for the review.

       Arnd
