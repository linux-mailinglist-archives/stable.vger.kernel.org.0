Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D19A390
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbfHVXLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:11:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41168 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405587AbfHVXL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:11:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so6892722wrr.8
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfEhcEl74/9KocN4cD/EXkYKVnogdnjEwxXf1BxsH1o=;
        b=OWjLhgYfYnWZZ7PLhlNfqVkMCX6aJuh9gqvxSm01UDSpFpVgFFsh4Bdj+zkP7s3Scj
         HiUAe98GnQhYmcxZertaWg+qiJerRC6zKGoKiqU2yWwD4C16H6tSJFbez4ssfxbsX2NI
         AxvTBFcQwz4aF3zmKgdYRGAOk6qM3iziebMPED9IXrFcj/Il6Tv8IdX5Fp6RpPxSpBS7
         u/NLidEXezkoDJ0/daQd7MYkkt+ppJGzcewoCpaIPr/Rjbue5jFzsF+vGKUlY7a64M1T
         QuCzazwiYDzhfXB8HYuxAALyBcxMQxrqD8Wu1jWauWViuPkaRZYSxVd0EcjL7oEhXzrd
         GmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfEhcEl74/9KocN4cD/EXkYKVnogdnjEwxXf1BxsH1o=;
        b=MKI0kLFNCjgk7bCVMd9zmBbMSUZN3EEKFCeNUXXF5KUR1jT09gudH3La3Yyd8Hsmo6
         ELHGRd0ouLcKIR1ZVDsG1FkK/6dlTEKZVbibDxO4bAJmkbHhXe74mtHBmusfLdAF5qw2
         v9uX1OeAfXO82nDsuzalypFFrQk9+YsCIXlsG0+bIIJkSXnqldHU9uraHn8n2z4lek+y
         /8w+fKlu6i8e21deZ3KJMWbvcuULJl3WOydvjzjbuoBCdgCJaqxGmf3QB4sCWY4aHcE/
         /G5sjqzwEKdCQvSXScyc8HWYH6SQoxY66djMAeOy9Ax3La/TjysL4pvejZYYxIxdynO/
         gy0A==
X-Gm-Message-State: APjAAAUupIahlu86B3oAJW+CJMfejCie8suiQP1WzRVWKldsSdo7a9Kr
        S+F7DCimoQanVJLHvividf+7fB78s7tMQdCWBd/RKg==
X-Google-Smtp-Source: APXvYqzSHG8uiKZmb3VCFgbyFvoqhUi4BYz6qYbEmjQZ+c3NGOkDIDIjp/W4h0bWxgXqNm9/Ziq3OKxA2ZIXTwFpkbU=
X-Received: by 2002:adf:9222:: with SMTP id 31mr1269673wrj.93.1566515486339;
 Thu, 22 Aug 2019 16:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <1566357985-97781-1-git-send-email-joseph.qi@linux.alibaba.com> <20190822152107.adc0d4cd374fcc3eb8e148a9@linux-foundation.org>
In-Reply-To: <20190822152107.adc0d4cd374fcc3eb8e148a9@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 22 Aug 2019 16:11:15 -0700
Message-ID: <CAJuCfpHULB5wQWf0Uxo=zSoyOAUmVFanrTZ0fo0-cfGc1o9hNQ@mail.gmail.com>
Subject: Re: [PATCH v3] psi: get poll_work to run when calling poll syscall
 next time
To:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
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

On Thu, Aug 22, 2019 at 3:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 21 Aug 2019 11:26:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> > Only when calling the poll syscall the first time can user
> > receive POLLPRI correctly. After that, user always fails to
> > acquire the event signal.
> >
> > Reproduce case:
> > 1. Get the monitor code in Documentation/accounting/psi.txt
> > 2. Run it, and wait for the event triggered.
> > 3. Kill and restart the process.
> >
> > The question is why we can end up with poll_scheduled = 1 but the work
> > not running (which would reset it to 0). And the answer is because the
> > scheduling side sees group->poll_kworker under RCU protection and then
> > schedules it, but here we cancel the work and destroy the worker. The
> > cancel needs to pair with resetting the poll_scheduled flag.
>
> Should this be backported into -stable kernels?

Adding GregKH and stable@vger.kernel.org

I was able to cleanly apply this patch to stable master and
linux-5.2.y branches (these are the only branches that have psi
triggers).
Greg, Andrew got this patch into -mm tree. Please advise on how we
should proceed to land it in stable 5.2.y and master.
Thanks,
Suren.
