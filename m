Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1E2F500F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKHPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:43:16 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:42343 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfKHPnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 10:43:15 -0500
Received: by mail-vs1-f65.google.com with SMTP id a143so4060641vsd.9
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 07:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGjT7TWbvgKww1gKFH3YW9K0vvn/tyeamLoiCmtdiQE=;
        b=cFoW5STk64gLB/Se0CtRRDgBvuwh2WZ5ZT0DmguvHkYElQxrBIzmAIJG3JMgDtZKTY
         x2elhu4qOmfe6e231s8BY1wJIIs0/xk72m0RwQHZavlvonlmLT0g2TyineahtuZp9TtL
         L6GsHs0muNMXO40ptUgHLa6Gp/41A3ca6VlBoVA5b9o+m4qxSSJQd/rJbTbVHYOCSWVx
         v8SGjVIGYdZHyPx/SttTjqm1z9nWN3gSmi9H3FdHJLkgA/fTqdZNNN3c/OvwwHhwZS8f
         bk6vfVVzQ7el6AzKk8KjUPDNfT7/bVwaXARMtWJbwBNK91h8iqqR1K5+gHpXTd8tToZ7
         bXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGjT7TWbvgKww1gKFH3YW9K0vvn/tyeamLoiCmtdiQE=;
        b=X2HMdpBMtrmFSVlplxB/EM0ol4VfXxemaP3ZEDfs8UJEvaZORV+eHGZ2RiYa4L/1mf
         MkbFQ/SbuHjm9JtwyMp+D92RdSMkZFU30YJ2z/TxqlzT0xyDunAGveg34+VEA6q6ErGh
         eu8b3i0OLXqjNyOE54pGt4LxTm6JnLnAXt025pRX8gZwq6LBATSl8QlR3dXMMhPLP0J5
         8zjZL2jx/aE6U8Dg9QUmbcwynWCYbhYeWGk4aKawfNVxhYRpt2QTtX+uyW6zkQVObjTz
         D7f+i9Qrg2TBLndBUyw6hsHrZ+6ghFx5XZX29QrwwCeOvfeoeo/v5+ap1t5uRQODfiwt
         nX+Q==
X-Gm-Message-State: APjAAAXwUsXWvZQ+ajmfjYoBAHy+wiH6ZlG7N6Wfg4its0Mx2fM2iIV7
        qbX/JUNByhvEKdK1evikwnsz0lgAyVS4caLiaYS0XQ==
X-Google-Smtp-Source: APXvYqxp04xHQEba15O1HQzhevwV2s1jY83eZkv6cc9Ef35IR02ANas7TuaKdxToBZrJxAGE6aNlLHuaC7ugF+ByNxA=
X-Received: by 2002:a67:db9a:: with SMTP id f26mr8293743vsk.84.1573227794675;
 Fri, 08 Nov 2019 07:43:14 -0800 (PST)
MIME-Version: 1.0
References: <20191108123554.29004-1-ardb@kernel.org>
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 8 Nov 2019 16:43:02 +0100
Message-ID: <CACRpkdY4OmFvjAstHTcSX8e5wspY++zx1Sz+RFuW3w8s8MvUrQ@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.4 00/50] ARM: spectre v1/v2 mitigations
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 8, 2019 at 1:36 PM Ard Biesheuvel <ardb@kernel.org> wrote:

> This is a backport to v4.4 of the Spectre v1 and v2 mitigations for 32-bit
> ARM that have already been backported to v4.9.
>
> Patches #17 and up were cherry-picked from the v4.9 tree, and applied cleanly.
> The first 16 patches are prerequisites that were introduced between v4.4 and
> v4.9, and some needed minor massaging to apply. Some notable issues:
> - the 32-bit KVM host parts were omitted, given the lack of demand and the
>   fact that those pieces saw significantly more churn during the v4.4-v4.9
>   timeframe due to the fact that the code is shared with arm64
> - some other changes are shared between ARM and arm64 (notably, the ARM SMCCCC
>   changes), so the backport affects both architectures.
>
> Patches can be found at [0]. They were build and boot tested using a variety
> of ARM and arm64 configs and platforms, both locally and on KernelCI.
>
> An RFC of this series was sent out to the linux-arm-kernel mailing list
> and cc'ed to the maintainer, and no objections were raised. (The only
> difference between the RFC and this submission is that I have dropped
> a couple of mostly unrelated patches that were only there to make patch #8
> match its context more closely in the file include/linux/arm-smccc.h)
>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>

I felt responsible so I took it for a ride on a number of physical
systems (no QEMU!).

It works flawlessly on:
- Ux500 ARMv7 A9 x 2
- Versatile AB ARMv5 ARM926EJ-S
- Integrator CP ARMv4t ARM920T

It bombs on RealView PB11MPCore but it's not your fault, it
also hangs on v4.4.186 and a clean v4.4. However it boots
fine with v5.6-rc1 and -next, anything using ARM11 in MPcore
configurations (such as the Oxnas routers) should use a newer
kernel and stay away from v4.4.

Anyways:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
