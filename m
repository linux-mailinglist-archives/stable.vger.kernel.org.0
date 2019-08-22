Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091519A3B0
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405633AbfHVXWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:22:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36372 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405459AbfHVXWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:22:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so7326092wme.1
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zF3228PSgFDX4+jpWV9QqCljjDfY8nNiEPlbqDNQz0w=;
        b=Tdqx+nY5BXAlwTXe0GWrKcRQaazJmXZatIi4Xj71Qw4rLfBkNVFmsRL/Jjh8DQioRw
         PPwpF4MPgrwWSRtjEKMNsWStttnUaB/nORqQQ1ItvVdRVtCBscIdkZUuoZJRDWWwtGGq
         Cir6CjnuI8uwL31aHvvvfMvyGhaKdpuhyFIwPEeAOJ1UDcn7Fppq8A7XTssI/By4yzRj
         c4tWnGzef6QBmcVcwHjUuyFULJLyt8G6cxFCF/palC6Q0Rd6v/02ZH4sgCx21HMnZqXg
         BX0QmTnG+lyyboFpV2D9CUjA6iUGKsNtqI6MKs2M9dFeEdOE/I64u8z7cNy+ZPvDCxkp
         CyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zF3228PSgFDX4+jpWV9QqCljjDfY8nNiEPlbqDNQz0w=;
        b=XEC1sd2nm7f8wxqZHI98o3cH6xiyxCn706ywvpw4gvHk/klf94SAP6ZJo/srtkzv11
         cJWYHtl/KJslAaRP9Fg4zGL6sA3Gxc7Ga7ndHBeeineJJ217OL4KQlxgyJ6VqZA48ooO
         G+EJ47IbmF+BYhNrgHCqekQPofnvLIAZCTj9o5LY10fSyhDtLE7tdRmMieTNpbJ1fNKi
         Rvc1FnwPKyACfSdlLVrrvw8WWiA08cuCcLyks6yU14JtI6gVjr/X8PAueBgD1OLryGNv
         kAOCpNBKBrwRvWl/GPADq4RbBRINuUgmUdPk46onI1Bl5y62YRXDDU/1TVP4dRtAHgvA
         WTBw==
X-Gm-Message-State: APjAAAUOdFdhC7noE75gCmQ/Rl1q5GdmXZY70QW29hxK283FTIFDbLfY
        GVhFwLmvaLycjYozERkEXoEL2Y7umXxmbEOuVqxVKw==
X-Google-Smtp-Source: APXvYqz9j/IRq7uGfGi/34Bzb0LGEdXxhRf0hi2YM6OUKfjViGpQbt/lhqFSLCIhW4pSe4EuTca+uGtVpoME01JF7jY=
X-Received: by 2002:a7b:c745:: with SMTP id w5mr1319189wmk.21.1566516127285;
 Thu, 22 Aug 2019 16:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <1566357985-97781-1-git-send-email-joseph.qi@linux.alibaba.com>
 <20190822152107.adc0d4cd374fcc3eb8e148a9@linux-foundation.org>
 <CAJuCfpHULB5wQWf0Uxo=zSoyOAUmVFanrTZ0fo0-cfGc1o9hNQ@mail.gmail.com> <20190822161738.02297ead0abd424c44fb33b9@linux-foundation.org>
In-Reply-To: <20190822161738.02297ead0abd424c44fb33b9@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 22 Aug 2019 16:21:56 -0700
Message-ID: <CAJuCfpHq0hTsuyfZ8z3sDWzOERgnPUT2oWMdtyh=t2HjQJPOng@mail.gmail.com>
Subject: Re: [PATCH v3] psi: get poll_work to run when calling poll syscall
 next time
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Xing <kerneljasonxing@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 4:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 22 Aug 2019 16:11:15 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > On Thu, Aug 22, 2019 at 3:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 21 Aug 2019 11:26:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> > >
> > > > Only when calling the poll syscall the first time can user
> > > > receive POLLPRI correctly. After that, user always fails to
> > > > acquire the event signal.
> > > >
> > > > Reproduce case:
> > > > 1. Get the monitor code in Documentation/accounting/psi.txt
> > > > 2. Run it, and wait for the event triggered.
> > > > 3. Kill and restart the process.
> > > >
> > > > The question is why we can end up with poll_scheduled = 1 but the work
> > > > not running (which would reset it to 0). And the answer is because the
> > > > scheduling side sees group->poll_kworker under RCU protection and then
> > > > schedules it, but here we cancel the work and destroy the worker. The
> > > > cancel needs to pair with resetting the poll_scheduled flag.
> > >
> > > Should this be backported into -stable kernels?
> >
> > Adding GregKH and stable@vger.kernel.org
> >
> > I was able to cleanly apply this patch to stable master and
> > linux-5.2.y branches (these are the only branches that have psi
> > triggers).
> > Greg, Andrew got this patch into -mm tree. Please advise on how we
> > should proceed to land it in stable 5.2.y and master.
>
> That isn't the point - we know how to merge patches ;)
>
> What I'm asking is whether it is desirable that -stable kernels have
> this patch.  It certainly sounds like it from the changelog, so I'm
> wondering if the omission of cc:stable was intentional?

Sorry for my misunderstanding. I believe cc:stable omission was
unintentional. It's a fix for a bug which exists in stable branches I
mentioned above.
Thanks!
