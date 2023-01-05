Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC3465F651
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbjAEV7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 16:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbjAEV7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 16:59:06 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F656950A
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:59:06 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id c7so31243159qtw.8
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 13:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j0w58Jmxv23GOP82cSaTaJVOpSQ/WlFhaNSuDNLLtbw=;
        b=ZWrnuV/+oK0I3Jv9lK5gtYSMcmV/0S825Fft8v4+B9jE01S0vbNlAglhlXm1JBzOnt
         hA789qQ/CxOJyLAVaAiljJ8LwxY9uzFDesBGbhGuh64/4VlEraovgbmSdg4YkcLxbAsy
         KmBIDGAcYFHhTBTNHQpsOXZR/a/BtttWpNy4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0w58Jmxv23GOP82cSaTaJVOpSQ/WlFhaNSuDNLLtbw=;
        b=eE8ydaHNT6nj/gH9RjD7N0nDjYqoDNvkjHPKdreDorrSY7H+X09eA2o4pyjkl8HGx2
         9ptCeotlmvnfwYEfO+35iR6JbjX8/3idgrpwbWyboNYFc+JatLgwa6OSjYxSmYlYxek0
         +x1UuUU6kdF56Xo70P8eU0aBIC9WzGgfE0p1oSKuGy6vpm60w9TeM9mPR4FvOTgd6Upk
         R16NkKMuzNXns2LUfnYhqzJfuYctrmg6IqUi0D1N08uXH6rpKWhOgEC5ABrFtjdpGA39
         8I4Jla6+hdlBCYRHzt35Fn2ie/vA8ghy+hPgPdZ4EvoDVQfeV/tISKmDSAp9xUhWfYcS
         OW3A==
X-Gm-Message-State: AFqh2koLGhN7JtVKzY50qXaUHqd3sr//efucCaa1YwgtUZCiydGhL1EW
        UoDacA4ai8fiOdADm6bj84hoSy3ot8FwfB9F
X-Google-Smtp-Source: AMrXdXvNBaHKIFjlgWzmSTPbvaGUdstAkqlz/+3+iKBS2UJAdYAGOW3nRxOFtVfS+G5TuYAnu5CxFQ==
X-Received: by 2002:a05:622a:40ca:b0:3ab:ac3b:966f with SMTP id ch10-20020a05622a40ca00b003abac3b966fmr34994300qtb.29.1672955944908;
        Thu, 05 Jan 2023 13:59:04 -0800 (PST)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id x17-20020ac84d51000000b003a7f3c4dcdfsm22200741qtv.47.2023.01.05.13.59.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 13:59:04 -0800 (PST)
Received: by mail-qk1-f171.google.com with SMTP id f28so18560530qkh.10
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 13:59:04 -0800 (PST)
X-Received: by 2002:a37:a93:0:b0:6ff:812e:a82f with SMTP id
 141-20020a370a93000000b006ff812ea82fmr2294712qkk.336.1672955943954; Thu, 05
 Jan 2023 13:59:03 -0800 (PST)
MIME-Version: 1.0
References: <370a2808-a19b-b512-4cd3-72dc69dfe8b0@suse.cz> <20230105144742.3219571-1-Jason@zx2c4.com>
In-Reply-To: <20230105144742.3219571-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Jan 2023 13:58:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=whxaSHcHeo10JGz3EMJZBfC1LarcrerLos7uHbE1URhtQ@mail.gmail.com>
Message-ID: <CAHk-=whxaSHcHeo10JGz3EMJZBfC1LarcrerLos7uHbE1URhtQ@mail.gmail.com>
Subject: Re: [PATCH] tpm: Disable hwrng for TPM 1 if PM_SLEEP is enabled
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 5, 2023 at 6:48 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> TPM 1's support for its hardware RNG is broken across system suspends,
> due to races or locking issues or something else that haven't been
> diagnosed or fixed yet. These issues prevent the system from actually
> suspending. So disable the driver in this case. Later, when this is
> fixed properly, we can remove this.

How about just keeping it enabled, but not making it a fatal error if
the TPM saving doesn't work? IOW, just print the warning, and then
"return 0" from the suspend function.

I doubt anybody cares, but your patch disables that TPM device just
because PM is *enabled*. That's basically "all the time".

Imagine being on a desktop with a distro kernel that enables suspend -
because that kernel obviously is expected to work on laptops too.
You're never actually going to suspend things on that machine, but
maybe you still want to register it as a source of hw random data?

          Linus
