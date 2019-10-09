Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48776D0A73
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbfJII6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:58:35 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41887 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfJII6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 04:58:35 -0400
Received: by mail-oi1-f194.google.com with SMTP id w65so1105744oiw.8;
        Wed, 09 Oct 2019 01:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wo2kjN4H/yTZ+Qvso8PVz8oEZSH3WEZaSyFp4BvOWkI=;
        b=HiQttlkQmA/zYTS4K8XqHWxWVqf7zulKwsh39VsjezfMyKBtsKRXWUIqL4dbJNcgVn
         XxjXeY+5ppmBGxreRP6m0CdrF0nI6Sl3GSos1Imey8mr5gXgekrQDp501JNQpQo/yYiH
         ZbRLO+uYfDBV5uuQobGFBA+s0PdafzC+79LirRnZkhxH5ZutO59INIMCpA0dbmTaHADD
         shvu0eGY9u5HI4k+9klOn59nqAz8oZNcNQYDEKtOEL4t+fvzls0v9Mrekdx0QU93bisp
         q9o/cB5grgIxcxQ4Gv5U9FvrIslJihLMxyLCiVryTyVjgK7lzxOSqiUb6rmaQ7qwWevG
         IQQA==
X-Gm-Message-State: APjAAAV6Pin3a/VlENPl/l0m6QI5NcHAuaLf8koeD+iT4LCqsx2YCJ2X
        oUFJXYNnUa1BJsMlFPb407hJkHhene62NwdhE5Y=
X-Google-Smtp-Source: APXvYqxpbz5RkNCvw72+QZmq4+gUjbz3Ln/Z3nhtLQYp0/hiF7s4zBN2qOIIQNkBdsHmpiYNXHE7E4St0r1WOJrBlr0=
X-Received: by 2002:aca:882:: with SMTP id 124mr1434880oii.54.1570611514439;
 Wed, 09 Oct 2019 01:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 9 Oct 2019 10:58:23 +0200
Message-ID: <CAMuHMdV5N=JrVi3EwfFV4wgXo-xDQL0ptaqmauvzzQbDfWq+CQ@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Simon Horman <horms@verge.net.au>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Wed, Oct 9, 2019 at 6:03 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
> should be written to 0 because the register is set to 1 on reset.
> To avoid unexpected behaviors from this incorrect setting, this
> patch fixes it.
>
> Fixes: b3327f7fae66 ("PCI: rcar: Try increasing PCIe link speed to 5 GT/s at boot")
> Cc: <stable@vger.kernel.org> # v4.9+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Thanks for your patch!

This patch fixes the issue where the register is written, so
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

However, according to the R-Car H1, Gen2, and Gen3 Hardware User's
Manuals, this reserved bit should be cleared on initialization.
Are we sure that is guaranteed to happen? If the checks at the top of
rcar_pcie_force_speedup() trigger, the register is never written to,
and the bit may still be set?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
