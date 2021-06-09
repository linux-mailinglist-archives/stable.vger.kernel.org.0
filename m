Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05C03A1F2D
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 23:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFIVrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 17:47:19 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:44920 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFIVrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 17:47:19 -0400
Received: by mail-lf1-f49.google.com with SMTP id r198so37039512lff.11
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 14:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aaXF2yQYlF3XaWxmnf9WH9rzEvbnGjon/80g8w4+GyI=;
        b=I0Uv1/Obcy6RZhS3152uYEHuLVSidy2Itl/6Pz8iSIW5HjbdZiHIic91RTMHJu5nBU
         W1zV/GRWkSf8fG3bTYSYA7A1IUfcQ7z+NLf6Pc+4PlIpLqHS3KhxsY5r4DnUxChi0o2U
         JGC6Ia6Pgrb6fYuxAFQpZcxJZ7vJMdjMpMdbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aaXF2yQYlF3XaWxmnf9WH9rzEvbnGjon/80g8w4+GyI=;
        b=beu/uSkpom69yU4Ual7ATEBaFREiqjvvg5MxQx9UkoppOjnOtsQv4PO386Bu5F/SXd
         cyi9LOHX/tXQlxVAwvMpE0Z5BCx1Lp+KPlXgO4oS7027Gom5zs/u2mtAcFeaQAs9MxbU
         6z3xJRHVVbrHHvDrKEe795ZMuOw3b45llaqip0UM5cTto360N8Ohz8kojFsb4pBlvx26
         AU7StVvedMHTxAZfhTcKV77hKJHD763Ipc1zoQiGLOumXBbxWrkn5xIqNiEvwK1Nidsz
         TDYdui0mjHRuveOQMcxm6uQ7lt6XQwCdY7V5zxW21HWgOXLfmfcTbRSZHGc/fdCuWlfP
         HDpw==
X-Gm-Message-State: AOAM530rwZ41mbptA/m2VTh0Dkb0d81H28V/1ZVNWw1Ojjh2nAxFJ3rb
        wqrr7iqX44nVZou1UFPN31ix+2qR+jUNlVEqSg4=
X-Google-Smtp-Source: ABdhPJzU5j9aseQgnw6e8R5ETXveZkY2+1FJGYos/29/VxhVwMxHfCPs3cbS6hLZu3Md/dIc0isFFg==
X-Received: by 2002:a19:480b:: with SMTP id v11mr991323lfa.126.1623275050134;
        Wed, 09 Jun 2021 14:44:10 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id p5sm107242ljc.117.2021.06.09.14.44.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 14:44:08 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id 131so1796124ljj.3
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 14:44:07 -0700 (PDT)
X-Received: by 2002:a2e:8587:: with SMTP id b7mr1307218lji.465.1623275047231;
 Wed, 09 Jun 2021 14:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
 <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com> <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
 <20210609165154.3eab1749@oasis.local.home>
In-Reply-To: <20210609165154.3eab1749@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Jun 2021 14:43:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com>
Message-ID: <CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory corruption
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 9, 2021 at 1:52 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > That "sizeof(*entry)" is clearly wrong, because it doesn't take the
> > unsized array into account.
>
> Correct. That's because I forgot that the structure has that empty array :-(

Note that 'sparse' does have the option to warn about odd flexible
array uses. Including 'sizeof()'.

You can do something like

    CF='-Wflexible-array-sizeof' make C=2 kernel/trace/trace.o

and you'll see

  kernel/trace/trace.c:1022:17: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:2645:17: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:2739:41: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:3290:16: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:3350:16: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:6989:16: warning: using sizeof on a flexible structure
  kernel/trace/trace.c:7070:16: warning: using sizeof on a flexible structure

and I suspect every single one of those should be using
'struct_size()' instead for a sizeof() on the base structure plus some
manual arithmetic (or, as in the case of this bug, _without_ the extra
arithmetic).

And yeah, it isn't just the tracing code that does this. We have it
all over, so that sparse check isn't on by default. Sparse is pretty
darn noisy even without it, but it can be worth using that
CF='-Wflexible-array-sizeof' on individual files that you want to
check.

               Linus
