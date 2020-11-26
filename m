Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30D92C514D
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 10:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbgKZJbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 04:31:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41735 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730908AbgKZJbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 04:31:48 -0500
Received: by mail-qk1-f195.google.com with SMTP id d9so1019446qke.8;
        Thu, 26 Nov 2020 01:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m7rrJTHCOqfGVq2YH9fpddLIPmI3lIR6B6JPtIwfF0Y=;
        b=FDwYMmXCJwc9CP6gzzg+L+8KgAnYdRwjs1YKoIa4kcw3lmDCxn0HF3RRjSDJw+fiZ6
         oW8rvSmhp7Rruw6o+MbWhpx+HPYfz6RIh9+r27YhRMYMZ+A613UeAVnmSF4dphoaEoYv
         4oOwEL7whuZ6FL87cF5h+e+E8Mp1NPG7rDk2hxUM08IRo00UYjwNSKqKDOiYZbPBxEDX
         Q9ML5vLkDRl7zvPCm49EG/d0jeN6pVqpR8w6bb2wjYjSz+LI8qb4ShO4vIxzFYXDpI+u
         zb+0VvOEJI9oC/QnQR3rm/S+fdWioXh9C+I0/hphrNMtBMIIwkoh+PlvewscXDX+tNa9
         JtxA==
X-Gm-Message-State: AOAM531L+FMBKwZtiWNA0BsMz6GSJxzCLpFCmGELRnxneYLWVe1PFOhg
        BBzSauR5M7dZfjEyaW2BmBIXa4lNQAgoacerFLE=
X-Google-Smtp-Source: ABdhPJwd95vo1L81hrFJrEHdm8ACPCCwJuOgG1VX9+Z6Jl/0f+Ta+4Yp24jkZsJTX+cj9jjZ8H6hmC98uhDS0L4+PEk=
X-Received: by 2002:a05:620a:2e8:: with SMTP id a8mr2433728qko.144.1606383107454;
 Thu, 26 Nov 2020 01:31:47 -0800 (PST)
MIME-Version: 1.0
References: <20201125225654.1618966-1-minchan@kernel.org> <X79Ch+WDwYwqWGk8@kroah.com>
In-Reply-To: <X79Ch+WDwYwqWGk8@kroah.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Thu, 26 Nov 2020 18:31:35 +0900
Message-ID: <CAM9d7cgr+c=kNQoEAaWiZ8Q6VjpZd-4gF4Uy90EZuq9WpkgYBA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Fix align of static buffer
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Minchan Kim <minchan@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 26, 2020 at 2:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 25, 2020 at 02:56:54PM -0800, Minchan Kim wrote:
> > With 5.9 kernel on ARM64, I found ftrace_dump output was broken but
> > it had no problem with normal output "cat /sys/kernel/debug/tracing/trace".
> >
> > With investigation, it seems coping the data into temporal buffer seems to
> > break the align binary printf expects if the static buffer is not aligned
> > with 4-byte. IIUC, get_arg in bstr_printf expects that args has already
> > right align to be decoded and seq_buf_bprintf says ``the arguments are saved
> > in a 32bit word array that is defined by the format string constraints``.
> > So if we don't keep the align under copy to temporal buffer, the output
> > will be broken by shifting some bytes.
> >
> > This patch fixes it.
>
> Does this resolve the issue reported at:
>         https://lore.kernel.org/r/20201124223917.795844-1-elavila@google.com
> ?

No, it's a different issue.

Thanks,
Namhyung
