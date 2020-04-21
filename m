Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56D71B1D26
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 06:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgDUECr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 00:02:47 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33661 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgDUECr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 00:02:47 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9ffef1c0;
        Tue, 21 Apr 2020 03:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=b5Yc33rjro0LOJft6o7awVjkTZ0=; b=PyxDIl
        H9MWbDtDahbXjBBAyWJvpmLpmvikrFMo2CjFcCKoL+dLt1lHmcBzm7vhC5ZzJxqM
        v3xJbgeszgVR8hoCwoXK0iLKqjiQIvgvt9Z3R62+3wMIrNt8/HycnK9eJOrg8K5C
        P/KPeB633xgi/qzzOA7p+IpQprCNegFkxASMfyfEjDzLfWGbHr+U40lCcWV5GlUR
        gt44UgCYhgb8YuwPxrVF6wSPXMPtyQG8/UlbTcydAWxqziKN4cmBhtVQcMXpuDvA
        5ajoUGB/IdDPbzdHLbLXxbnfTLqxbRwx5zJun4KvjgbYnVyMZMlRqqGIRP0+JKkF
        3pj/dSLYtJ7JlOiQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f07f93df (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 21 Apr 2020 03:52:01 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id f3so13647296ioj.1;
        Mon, 20 Apr 2020 21:02:42 -0700 (PDT)
X-Gm-Message-State: AGi0PubU/q1Dff67GrvbKvvHPEiwJbzNHCqoTtlsbTamX4ww3Snr5XFv
        Miw9LgIVI3uxSeiaO3NnHaNOdv1XpjmR7a2epHM=
X-Google-Smtp-Source: APiQypJdNT8UItWFDKtAKDekJkgZ+KtTzn8bv/h9qcNsTyes4y9VnE4cLcMW9yqKJGy8Pyrq8to9I3nqyEWXr9nt7CI=
X-Received: by 2002:a05:6602:21d3:: with SMTP id c19mr18626695ioc.29.1587441762080;
 Mon, 20 Apr 2020 21:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
In-Reply-To: <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Apr 2020 22:02:31 -0600
X-Gmail-Original-Message-ID: <CAHmME9qfrHVQ+-4HjqCO2TaGF6DNTHmS1max1KcVaP5_QjUDRQ@mail.gmail.com>
Message-ID: <CAHmME9qfrHVQ+-4HjqCO2TaGF6DNTHmS1max1KcVaP5_QjUDRQ@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     David Laight <David.Laight@aculab.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 2:32 AM David Laight <David.Laight@aculab.com> wrote:
> Maybe kernel_fp_begin() should be passed the address of somewhere
> the address of an fpu save area buffer can be written to.
> Then the pre-emption code can allocate the buffer and save the
> state into it.
>
> However that doesn't solve the problem for non-preemptive kernels.
> The may need a cond_resched() in the loop if it might take 1ms (or so).
>
> kernel_fpu_begin() ought also be passed a parameter saying which
> fpu features are required, and return which are allocated.
> On x86 this could be used to check for AVX512 (etc) which may be
> available in an ISR unless it interrupted inside a kernel_fpu_begin()
> section (etc).
> It would also allow optimisations if only 1 or 2 fpu registers are
> needed (eg for some of the crypto functions) rather than the whole
> fpu register set.

There might be ways to improve lots of FPU things, indeed. This patch
here is just a patch to Herbert's branch in order to make uniform
usage of our existing solution for this, fixing the existing bug. I
wouldn't mind seeing more involved and better solutions in a patchset
for crypto-next.

Will follow up with your suggestion in a different thread, so as not
to block this one.
