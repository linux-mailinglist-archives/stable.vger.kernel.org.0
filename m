Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F731EB260
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgFAXsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFAXso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:48:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCC2C03E96B
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 16:48:42 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so552076pjd.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 16:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNBmHiSKwvMr5X38foIQI0sKfyxQ431ExlrJTn0/i7Y=;
        b=JP+Lp/jNYkdXX/HqPZKX2SgK5X0i+zDFGOg2ww7dtjG0sp6+PGSQ9bK3jx7AAwgHgJ
         o4FT4hVdzYCxXc0WH1nFHjqoOyqVRS88r7xLjnMssWgONz5eA+xjJ69RP6XO0zAq2X7M
         XJ3HbDqOKrcI58B5+9jcBtMDajE5h35bKOQBKIVMzttYj+uUId6KcRVn55gYO9ZYTHIJ
         90CfC5AreAzmnRK53W2uiqONvL5NPR53F8EQR6ykK0w6XL51XbB86M2HVM8mWb/FGgEn
         JR5eXLsDjabEHuSKeT8o+NWzFLtsVkkP2y157PXkg56HkTU0VZ0WhUg8vG3zI/f55YC8
         01Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNBmHiSKwvMr5X38foIQI0sKfyxQ431ExlrJTn0/i7Y=;
        b=KsSNr6fUWiOBKkk2FtGCQJ02D+jYXaMnHPc19ae0Srhc6LjtE3fS/j/DIeY1Vbsnp1
         AUlLgR68Wwg+rH11ao5vP3QjEMs8QBEZhvLfGW8lDa+RvPkJz8N+jhm+u26SL07Lh7UE
         uieAyb9ibhNLt3el91JYJaH0MElxg0DUBtJyJI5Gt3/iX25Gq8XNb/c0wwO6S/78Glpi
         KvRd6SE4abd8Li5HSkCPzrix/4vhBh150JqI5V2+JbQJZIWhXFsH0WUhZEuxTBfLnOzQ
         bMijyxY288Obl6fgRadgtkPNqbSD4fdZqTC2AyMUKxZxDWkjyjo48610tY+HVPlMbabu
         +Ibw==
X-Gm-Message-State: AOAM532OwyXub6vDiS9h3olRX2UHi+1suwVPhldbItQ/8BPmfKQ1BGrP
        jEjrogZqUfFrn6PyRf9IOT4gGOcFIae7RNz6HhzdFA==
X-Google-Smtp-Source: ABdhPJzPdil5JHB2JFiBUPImTahZQgK7CsLdhBg5zRviWYOCKk53kYc+N0bKVKMXxkL7FCDBIFnYLwHPPms3V0bgy48=
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr22127472pll.223.1591055321894;
 Mon, 01 Jun 2020 16:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com> <CAMn1gO7MrbgpEzaAYZ3vNnbWPdSsHhMkDNXq9rZajur+sqtBsw@mail.gmail.com>
In-Reply-To: <CAMn1gO7MrbgpEzaAYZ3vNnbWPdSsHhMkDNXq9rZajur+sqtBsw@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 1 Jun 2020 16:48:29 -0700
Message-ID: <CAKwvOd=BgiaiWWkHX=Z4OX927KNGu1CTnvVkhKRJ=vRTQKbu8Q@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
To:     Peter Collingbourne <pcc@google.com>
Cc:     Robert Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 1, 2020 at 4:37 PM Peter Collingbourne <pcc@google.com> wrote:
>
> On Mon, Jun 1, 2020 at 4:18 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > Will reported UBSAN warnings:
> > UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
> > UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> >
> > Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
> > can avoid this by using the compiler builtin, __builtin_offsetof.
>
> Would it be better to s/ACPI_OFFSET/offsetof/g the existing users of
> this macro and remove it? It looks like offsetof is already being used
> pervasively in the kernel, and its definition comes from
> <linux/stddef.h>.

I count only 9 uses in the tree, so not too bad a yak shave. Good
idea; I'll send tomorrow short of any other feedback.  I still think
we want the builtin, since we don't want to include stddef.h in the
kernel, I think.
-- 
Thanks,
~Nick Desaulniers
