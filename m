Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620B31C4F4
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 10:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfENI2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 04:28:48 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34085 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfENI2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 04:28:48 -0400
Received: by mail-ua1-f67.google.com with SMTP id 7so1786842uah.1;
        Tue, 14 May 2019 01:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NA3o69AVedwbrS8I/JNFCMoka6aSRYx6sOSkm7j+ZY=;
        b=sWgbCysasls5T0fl83xIYjpsrFQUwdFB9c00tAyeFdNssQL6P4oHoo5COXUm+f/6A1
         ayG7O8p9Tgf2fUn8N6rzoQnSZUePC4/JzJQYlfE/ZbTkgMRO2yeAAefz8nq6YSGZ43UT
         W40o3xXh9d9538IE0NrDii59lG6ogBdYvkRa2IauaAG5xJ7uc1KuS/rQOnixZrAe7IkV
         1tUZYKZKemMSpYaD4ie9Edhd7FQdxBOUJtgHIEWJauyGGuCGGMc0SuzOceh1ZnGBbSPC
         gOkQ68MKkpGA/wWNks4CnVKO7XO27I/VfMbgbocICTjRhe0O03pSpCDWYas++gLnEgYC
         tp7g==
X-Gm-Message-State: APjAAAVvpSQ02Mb7kYjA24EDNaHNWCNtrKlOwY3H1QsyyQlsrRNOd5wH
        bc6ZGzQf0B8iRuPZ2FmWsH67XBV8TXG3PqFXj04=
X-Google-Smtp-Source: APXvYqwdcU+/txalebspsx4VOD+EnsWOMl3ldpM6w0yNu5aBmbUhQ7DwUL4yoq5BDqRktbvDVPuCHNLpcUJd09+lby0=
X-Received: by 2002:ab0:45e9:: with SMTP id u96mr4671687uau.75.1557822526733;
 Tue, 14 May 2019 01:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <1557762446-23811-1-git-send-email-george_davis@mentor.com>
In-Reply-To: <1557762446-23811-1-git-send-email-george_davis@mentor.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 May 2019 10:28:34 +0200
Message-ID: <CAMuHMdVaNWa=Q-7K-+_rM-8yYWB0-+4_o4hgACK6o-4BOrY07A@mail.gmail.com>
Subject: Re: [PATCH v2] serial: sh-sci: disable DMA for uart_console
To:     "George G. Davis" <george_davis@mentor.com>
Cc:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chris Brandt <chris.brandt@renesas.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS 
        <devicetree@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi George,

On Mon, May 13, 2019 at 5:48 PM George G. Davis <george_davis@mentor.com> wrote:
> As noted in commit 84b40e3b57ee ("serial: 8250: omap: Disable DMA for
> console UART"), UART console lines use low-level PIO only access functions
> which will conflict with use of the line when DMA is enabled, e.g. when
> the console line is also used for systemd messages. So disable DMA
> support for UART console lines.
>
> Fixes: https://patchwork.kernel.org/patch/10929511/

I don't think this is an appropriate reference, as it points to a patch that
was never applied.

As the problem has basically existed forever, IMHO no Fixes tag
is needed.

> Reported-by: Michael Rodin <mrodin@de.adit-jv.com>
> Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: George G. Davis <george_davis@mentor.com>
> ---
> v2: Clarify comment regarding DMA support on kernel console,
>     add {Tested,Reviewed}-by:, and Cc: linux-stable lines.

Thanks for the update!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
