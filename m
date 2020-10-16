Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC0290C6B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411149AbgJPTq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411140AbgJPTq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:46:58 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF09C0613D3
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:46:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u8so4856416ejg.1
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NfyWpVTtN02LCd5BnMuo4kV/pu1My0vy1TFHMECYWXE=;
        b=KVwBRSDoZMiGe/hkkNS6cx4R7/CHnRqw4KIYuAU/G7AAghFqHcivh1a+t3PjrvEHr5
         PAy8P6mJpeL1Rq+VcFHPLiXmhU+ux2Sl6QHepVLre+mtw2sTEHZ1HwseIooppI7bVwZA
         NIXfiJw2MBDQd+0vTNd9H3GGE9RdaUpGYl9411+G3/zl0N8+83PuVut8urulmSZOmNPo
         9hrMxaqhEqdXAZUqK44NdbP+d/4cKcr+uetryVmUPFT/a1k7XumO36O2Vi+ygW2gMBL6
         jTJoH/BMyfH36Qh2MS/Kl+2PF2dUJ1oaXScZejLrR0lmca+TIVlXtlu/OaCxFOKR07Nf
         iDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NfyWpVTtN02LCd5BnMuo4kV/pu1My0vy1TFHMECYWXE=;
        b=DJvR5aG0QVyaWVkFrWHTgE3tLHWS8klAX3IQrFJpxcJdQzNYyN/lP1HnJYQM/NjyAd
         qObkM4yLN/ayHpsdfYdO4QgSmHsbWHAye+bOEcPe17EfsbPnTamh2QfuMsh/XxigT9ib
         mjeG+R0nUv8GQ0vb2xNlXmlVgErNCB7fP8iMRPNkCHmUptCVnxYjIRuKkAjiH+/Jkr9x
         aLxLDbgWssA94tje1qtJ2QZdf2Sv4+ju9q9be4G6lDyiGM0ruWuuCcNBSpa3LkjoFkDB
         gMWrrKOhruAEmcCRrGUx7Kmk6ZekQ0jLqQVYnbZThkwSenZLunUaXlhQJf+cVtFh8UyJ
         Xw5g==
X-Gm-Message-State: AOAM530qJ1kHgcyaJjT7fcGTXj41vT4WZTtf3R3KlgLIGkG7Y8bpqMZv
        Aw5FrlmlB44hWh448H8PC+otuFfy2cCnXZAdRsdsqg==
X-Google-Smtp-Source: ABdhPJzyg1mwPUSNbbOAZNrZPrun1WG/ET+PxjPyEo8MAVc93PxuwFM6YIapxG1iRt4ofVsCQiI+9T5Xa9zKP+RkQVQ=
X-Received: by 2002:a17:906:a0cb:: with SMTP id bh11mr5601938ejb.314.1602877615633;
 Fri, 16 Oct 2020 12:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201016180907.171957-1-mcroce@linux.microsoft.com> <20201016180907.171957-3-mcroce@linux.microsoft.com>
In-Reply-To: <20201016180907.171957-3-mcroce@linux.microsoft.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 16 Oct 2020 15:46:19 -0400
Message-ID: <CA+CK2bBiecpYsP3vHyEikrURgZeqd76ROv47aabz2mKBK0r2Nw@mail.gmail.com>
Subject: Re: [PATCH 2/2] reboot: fix parsing of reboot cpu number
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 2:09 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
>
> From: Matteo Croce <mcroce@microsoft.com>
>
> The kernel cmdline reboot= argument allows to specify the CPU used
> for rebooting, with the syntax `s####` among the other flags, e.g.
>
>   reboot=soft,s4
>   reboot=warm,s31,force
>
> In the early days the parsing was done with simple_strtoul(), later
> deprecated in favor of the safer kstrtoint() which handles overflow.
>
> But kstrtoint() returns -EINVAL if there are non-digit characters
> in a string, so if this flag is not the last given, it's silently
> ignored as well as the subsequent ones.
>
> To fix it, revert the usage of simple_strtoul(), which is no longer
> deprecated, and restore the old behaviour.
>
> While at it, merge two identical code blocks into one.
>
> Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
