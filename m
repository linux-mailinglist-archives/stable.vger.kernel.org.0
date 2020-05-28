Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E381E6E93
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 00:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436893AbgE1WWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 18:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437001AbgE1WWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 18:22:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25F4C08C5C8
        for <stable@vger.kernel.org>; Thu, 28 May 2020 15:22:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m18so138170ljo.5
        for <stable@vger.kernel.org>; Thu, 28 May 2020 15:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G22kYXML7tLF/Qm6fmw1wMduvw7Qs9a/nrPLifNe//k=;
        b=ELWOFCal0EeTIc1/idq8cg4c1801b2rPZj3VsNmuOidra2D5FUjrT9K0ppqPFn0tIB
         NQ4/iV+EIj20hIa+c5GZwB1yNT2EnkDib0/P1zDP3UGy8fRM5wa+f4qNHgkg0kSBb+m9
         WTS7HHrkffZzpSWzbK8n7jzcPgHJRjCdAFahQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G22kYXML7tLF/Qm6fmw1wMduvw7Qs9a/nrPLifNe//k=;
        b=rbW7N5Ag+15o6kOKji9vzxCacXUUbMm0qyVFMcSYBpJgQDUQemBaS/RgfhZDPWBviu
         dYkXe2SmG23WP29s/UfNzA90RG/h/uPQtvg4a0cB3Bx9f0un27dcAF6TfHNAJ0aQUEnA
         iD/qeMn80OFQqSHNP3gErTm1+glIbSdhM7LFlJCSwXXC0BQpMmczMz8pwjwLOF7C5FEW
         WldBD5CfOQoEJ34Fci8zNtntMxq7kuXoHWrgZk55djQpYC6R+G6LjU9fB9x8jWZQWBLI
         jWKgCunceugg/qzLaD30jhndZjcgdHPS3j7Ec/eJSon0R+8WgqNvBxJCh/Etq5yhh8j0
         /Nzw==
X-Gm-Message-State: AOAM530EmJOoL3dPbDwp9SN3twNZvboH4Eh4VAqF74CEcjR/pE+TeOb7
        Ez32S868D3H+llb3jN6zMGDZ5OLl28s=
X-Google-Smtp-Source: ABdhPJx7k48VTdUEFVHInoxYF1thMaY2YWtyizP2GHxjgw2VOYkvW0Fh2MmVfyNCcLxHZG48b0DW5A==
X-Received: by 2002:a2e:8047:: with SMTP id p7mr2655975ljg.173.1590704534938;
        Thu, 28 May 2020 15:22:14 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id o23sm2133250lfg.0.2020.05.28.15.22.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:22:13 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id u16so88715lfl.8
        for <stable@vger.kernel.org>; Thu, 28 May 2020 15:22:12 -0700 (PDT)
X-Received: by 2002:a19:4048:: with SMTP id n69mr2737484lfa.31.1590704532092;
 Thu, 28 May 2020 15:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200528135552.GA87103@google.com>
In-Reply-To: <20200528135552.GA87103@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 May 2020 15:21:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
Message-ID: <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
Subject: Re: [PATCH] sched/headers: Fix sched_setattr userspace compilation breakage
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        matthewb@google.com, Jesse Barnes <jsbarnes@google.com>,
        vapier@google.com, Christian Brauner <christian@brauner.io>,
        vpillai <vpillai@digitalocean.com>, vineethrp@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 6:55 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> On a modern Linux distro, compiling the following program fails:
>  #include<stdlib.h>
>  #include<stdint.h>
>  #include<pthread.h>
>  #include<linux/sched/types.h>

You shouldn't include kernel headers in user space - that's the job of
glibc and friends.

> --- a/include/uapi/linux/sched/types.h
> +++ b/include/uapi/linux/sched/types.h
> @@ -4,9 +4,11 @@
>
>  #include <linux/types.h>
>
> +#if defined(__KERNEL__)
>  struct sched_param {
>         int sched_priority;
>  };
> +#endif

This makes no sense.

The point of a 'uapi' header is to export things to user space. Yes,
they sometimes mix kernel-internal thngs in there (because of how they
were created by just moving kernel headers to the uapi directory), but
that ' struct sched_param' is very much part of the very interface
definition that that file is all about exporting.

So no, this patch is fundamentally wrong. It negates the whole point
of having a uapi header at all.

The glibc-provided "<sched.h>" should have been where you got all
these declarations and #defines from, and the point of the uapi file
was always to help glibc (and other library implementations) get them
from the kernel.

So why are you including kernel header files and mixing them with
system-provided stuff?

              Linus
