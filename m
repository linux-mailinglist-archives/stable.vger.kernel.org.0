Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF00F27A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 11:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfD3JI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 05:08:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42838 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfD3JI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 05:08:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id c190so7674263qke.9;
        Tue, 30 Apr 2019 02:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LqvnYPQ4d9M13B73C2lxCghPlB6ymNoLCZdoFF0EvzU=;
        b=KZcmA2f4niqqeByEknlgvYCwFcNZ9VP/keiX4wNYO4YWPJhWEv5DbpN4SSJDP1ZgkW
         fC75jxAiWjQ7tuRjtsR8bAl1a3KRebWwST0xV9C744PnN3EApN4vKEhjJB7MmAV4Y06x
         Cw8GL4ez5HaU+RtoYR0CfNIZLRhZk8GSP1zBXc3W8zCjGSSydlZdoaxc8/Ob/YvW6/n1
         iE4pAW0LmBkb40Gy+gRyAU34G4RkQ1ZThBZzOc2M7OKDzSKrrwKo8xU5aM4FCI7GzTwg
         GsyiiOB/21Kt7cwbq4QFavJ5uds8u8VaX1mWTr2Yet7d0VChfLKNiJgkcr230zBACriY
         pV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LqvnYPQ4d9M13B73C2lxCghPlB6ymNoLCZdoFF0EvzU=;
        b=GojE6XBEY2rP8JfG77+XSNKwv+cdxdn/YXKJpoK4pzNVJ558meA1HCCwBid5YETzri
         EH9pJZY/y76gAs5aYP0Q3ycAbNOJ24oBjettwkB9KWQbVtlHKKMheFZBvCLeFCyJYphs
         5PEwMrtGuvQAkfKRd0gRx5qLKcZ32xdbGXIuM5ocmEkyJCQ7prCisQX2pOBRzxyMeQHa
         gQOxc17WqCAkiud/VebWS1lrbabvKJLR48PLYm7x2rZNouUb28Iz5Ue7CSV9giIzvh2o
         V3GM9/nB8qvbPer1cMvLY7vSrkpUNPChAf9tzf263qJfACFvqZxa7fFJ956XxH87go2z
         YeCg==
X-Gm-Message-State: APjAAAX//3WRRaajd52z4H4AkIpVbFVPaXMJov5cFo1v2Xkn+JSxUENH
        JMQkBxZUxa3DeVxuv5IUus97FytERy1aS7huchT7sEKPYeY=
X-Google-Smtp-Source: APXvYqwJnFMNmOWp4NCMQ/VWckpj+QMhlMDViEHvtuvWCtTXAo1bj68NZ74qvdtrNtiHaUIPQpel6OBjZat4HvJW7TQ=
X-Received: by 2002:a37:6557:: with SMTP id z84mr24988121qkb.221.1556615334948;
 Tue, 30 Apr 2019 02:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com> <20190430082332.GB2677@hirez.programming.kicks-ass.net>
In-Reply-To: <20190430082332.GB2677@hirez.programming.kicks-ass.net>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 30 Apr 2019 17:08:43 +0800
Message-ID: <CAAM7YA=YOM79GJK8b7OOQbzT_-sYRD2UFHYithY7Li1yQt5Hog@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: fix improper use of smp_mb__before_atomic()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 4:26 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Apr 29, 2019 at 10:15:00PM +0200, Andrea Parri wrote:
> > This barrier only applies to the read-modify-write operations; in
> > particular, it does not apply to the atomic64_set() primitive.
> >
> > Replace the barrier with an smp_mb().
> >
>
> > @@ -541,7 +541,7 @@ static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
> >                                          long long release_count,
> >                                          long long ordered_count)
> >  {
> > -     smp_mb__before_atomic();
>
> same
>         /*
>          * XXX: the comment that explain this barrier goes here.
>          */
>

makes sure operations that setup readdir cache (update page cache and
i_size) are strongly ordered with following atomic64_set.

> > +     smp_mb();
>
> >       atomic64_set(&ci->i_complete_seq[0], release_count);
> >       atomic64_set(&ci->i_complete_seq[1], ordered_count);
> >  }
> > --
> > 2.7.4
> >
