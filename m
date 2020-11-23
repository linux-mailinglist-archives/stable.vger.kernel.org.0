Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7D2C00C3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 08:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgKWHls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 02:41:48 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33142 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgKWHlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 02:41:47 -0500
Received: by mail-ot1-f65.google.com with SMTP id n12so11545805otk.0;
        Sun, 22 Nov 2020 23:41:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/aFWB6RaZl4bPbf4u8QBig1bHxal58mvCrDRYw2MDY=;
        b=tajGKBEdRIcXd5b1aWwlOD6pltPpI6iQMeVJbDnlKXtFjhg1b5xaF6nyr57psXy+Pf
         gH8lIoeew8gYTAa2FOYUdls1GYDubc6eXPnAi8SIhuuQeJwfxnta82/0BluY7pQmzCfY
         DiIT4pcWopwrGgq/AKmgr32cQu1vxXSb9vZg/k3/Ppynb2xtBKgKu4IjtrUgwoLL+tWC
         9RKA+kKFBGLrUsyFEKWz04Z3rJ5IpEizwrj5zhKWwjjGXueKzptAasExvVz8DQJokHae
         7bLRMdp5u5SljkBJklaG0okuInbIg+NqznucAbub+zP+IoWYzM3kX+L4jPs/iZa8fGdK
         53mA==
X-Gm-Message-State: AOAM531oACY0cuFpNFgq3pCkJj/iIg5DBSuuWjo1H9tbMPMcOvhJp/yI
        hx2McdRnyzUhq9zF7tNrqQRIlPVY6cV3mmktfxSKRvgI
X-Google-Smtp-Source: ABdhPJwOS4ETsQtrnuzwdglRTFc9o4bRkl73fYrQqy0ojA0VieDuwXIhtAd6Jk9B6DjFxUz/xh090HVbci/SooYB8j0=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr22819280oth.250.1606117306692;
 Sun, 22 Nov 2020 23:41:46 -0800 (PST)
MIME-Version: 1.0
References: <0c0fe1e4f11ccec202d4df09ea7d9d98155d101a.1606001297.git.fthain@telegraphics.com.au>
In-Reply-To: <0c0fe1e4f11ccec202d4df09ea7d9d98155d101a.1606001297.git.fthain@telegraphics.com.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 23 Nov 2020 08:41:35 +0100
Message-ID: <CAMuHMdWdt8r=wW1beX60KYpwFtzGzXDwQGP21iUYp2NKuK_w5w@mail.gmail.com>
Subject: Re: [PATCH v2] m68k: Fix WARNING splat in pmac_zilog driver
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joshua Thompson <funaho@jurai.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 22, 2020 at 12:40 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> Don't add platform resources that won't be used. This avoids a
> recently-added warning from the driver core, that can show up on a
> multi-platform kernel when !MACH_IS_MAC.
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at drivers/base/platform.c:224 platform_get_irq_optional+0x8e/0xce
> 0 is an invalid IRQ number
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 5.9.0-multi #1
> Stack from 004b3f04:
>         004b3f04 00462c2f 00462c2f 004b3f20 0002e128 004754db 004b6ad4 004b3f4c
>         0002e19c 004754f7 000000e0 00285ba0 00000009 00000000 004b3f44 ffffffff
>         004754db 004b3f64 004b3f74 00285ba0 004754f7 000000e0 00000009 004754db
>         004fdf0c 005269e2 004fdf0c 00000000 004b3f88 00285cae 004b6964 00000000
>         004fdf0c 004b3fac 0051cc68 004b6964 00000000 004b6964 00000200 00000000
>         0051cc3e 0023c18a 004b3fc0 0051cd8a 004fdf0c 00000002 0052b43c 004b3fc8
> Call Trace: [<0002e128>] __warn+0xa6/0xd6
>  [<0002e19c>] warn_slowpath_fmt+0x44/0x76
>  [<00285ba0>] platform_get_irq_optional+0x8e/0xce
>  [<00285ba0>] platform_get_irq_optional+0x8e/0xce
>  [<00285cae>] platform_get_irq+0x12/0x4c
>  [<0051cc68>] pmz_init_port+0x2a/0xa6
>  [<0051cc3e>] pmz_init_port+0x0/0xa6
>  [<0023c18a>] strlen+0x0/0x22
>  [<0051cd8a>] pmz_probe+0x34/0x88
>  [<0051cde6>] pmz_console_init+0x8/0x28
>  [<00511776>] console_init+0x1e/0x28
>  [<0005a3bc>] printk+0x0/0x16
>  [<0050a8a6>] start_kernel+0x368/0x4ce
>  [<005094f8>] _sinittext+0x4f8/0xc48
> random: get_random_bytes called from print_oops_end_marker+0x56/0x80 with crng_init=0
> ---[ end trace 392d8e82eed68d6c ]---
>
> Commit a85a6c86c25b ("driver core: platform: Clarify that IRQ 0 is invalid"),
> which introduced the WARNING, suggests that testing for irq == 0 is
> undesirable. Instead of that comparison, just test for resource existence.
>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Joshua Thompson <funaho@jurai.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Cc: stable@vger.kernel.org # v5.8+
> References: commit a85a6c86c25b ("driver core: platform: Clarify that IRQ 0 is invalid")
> Reported-by: Laurent Vivier <laurent@vivier.eu>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
i.e. will queue in the m68k for-v5.11 branch.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
