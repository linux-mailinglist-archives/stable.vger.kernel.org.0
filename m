Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F0A27184
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 23:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfEVVTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 17:19:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35354 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbfEVVTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 17:19:17 -0400
Received: by mail-qk1-f195.google.com with SMTP id c15so2502130qkl.2;
        Wed, 22 May 2019 14:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QutE0frdZrFjtR+kepVTzgGv/IyM+j4DHLDgWKVoQ6Q=;
        b=Mz9dCjiGwJ8XlmlfA1S6hkj0JBuO1pBCWDvRhcSjERE5azzOG5QvxSyExhb+Cj+Bz7
         eYykbfDMxiAJG5rEC25BEJpUssKOXGgNZ4UYodL8Aohm7IHDBHmwlkROhd8uMBmIYl2w
         7Ki18i8KkSkfh7Fk6ta5RVAKxMpJxrHEpWtv/ZM3J5hajJcY6VPIqgOA0zfe5qjPi9Sl
         BpMaMemYTx5z8A1BtRHyVdI1B+P4GoTqP9DqYNPEGFvK4hO1g0d7MPropxjYGu/T4ll6
         xBwQwUzTk7GzVl9A9cqaKCRXk2IJ4rjc9J+hP9o6buC8ezeR+BN3PuGDalNU64/qI/ze
         dL0w==
X-Gm-Message-State: APjAAAXejuDlNrmqs3c7JvjYo//w1OZZAiCs/naAav8S1O1ahfvZD+A/
        mOCwRcs6rMUci/OqF3nhayogQkGpxjrz1sIDpJQ=
X-Google-Smtp-Source: APXvYqxCir3wrX6L1jXsw3Px1arKsbfl9A3itEJSiGEgdt2ARr2HDcktWKkyZAkkEr+hpug5uyPyR+Ih5pJ0B8bSgjE=
X-Received: by 2002:a05:620a:5ed:: with SMTP id z13mr33906637qkg.84.1558559956356;
 Wed, 22 May 2019 14:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190522132250.26499-1-mark.rutland@arm.com>
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 May 2019 23:18:59 +0200
Message-ID: <CAK8P3a3X-7Yq9W+wEMRf3QvoEhrPHYmYukLaAr_39iKhJLC-bA@mail.gmail.com>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        James Hogan <jhogan@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Matt Turner <mattst88@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Burton <paul.burton@mips.com>,
        Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Henderson <rth@twiddle.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 3:23 PM Mark Rutland <mark.rutland@arm.com> wrote:
>
> Currently architectures return inconsistent types for atomic64 ops. Some return
> long (e..g. powerpc), some return long long (e.g. arc), and some return s64
> (e.g. x86).
>
> This is a bit messy, and causes unnecessary pain (e.g. as values must be cast
> before they can be printed [1]).
>
> This series reworks all the atomic64 implementations to use s64 as the base
> type for atomic64_t (as discussed [2]), and to ensure that this type is
> consistently used for parameters and return values in the API, avoiding further
> problems in this area.
>
> This series (based on v5.1-rc1) can also be found in my atomics/type-cleanup
> branch [3] on kernel.org.

Nice cleanup!

I've provided an explicit Ack for the asm-generic patch if someone wants
to pick up the entire series, but I can also put it all into my asm-generic
tree if you want, after more people have had a chance to take a look.

     Arnd
