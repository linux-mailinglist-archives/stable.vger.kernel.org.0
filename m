Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734FC34FAA
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 20:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfFDSOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 14:14:40 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51613 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDSOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 14:14:40 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so1680185itl.1;
        Tue, 04 Jun 2019 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCvwaoibVnjg9rjNg5TC6AzleXlhqUmKRsSL5YCF/MY=;
        b=AdRxKh1JZAxsWtP2YIms4M+pi5FfqgliDRG/gwm4NRjLcFbwmHOZ/qM7oFWJI1Kpml
         wbC6uLqRcgDx3wCG3+P5x0fSViBTaBtJxUh/fLJ8wztxCJ3ySDLRybYnqltJZYMBDb7Z
         6kf3NBaSJLh/fi9jn8WgUEQY4II9Ctg4jGHjAvCNDiUuwI/TE7mEJQb7thbqWS7RImCy
         JCVvQZ1vd6rGcsksQSQIMvX1pHRRN3cUcYbTZT1otg6W03t6WZKf/IdHMdTq1FVGIin5
         TaNMX0IiqoMs4W0tv0quyrYT7B5tIffjTQtPXl+AkGq69O6jePwzDp3ohuJyR8OkCH8S
         ZenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCvwaoibVnjg9rjNg5TC6AzleXlhqUmKRsSL5YCF/MY=;
        b=XbSv7sZb3a+T35UospUJHbwldTXjJ+GRxOp82KZ1HQowEs8YoFOUiDYdp7TUdVYfnk
         hksm/gRoJ4McZAhN1EU1sqFQfLaJA2pYGcIjzVGacWAHLs654ejIJk6iA7FWIhs1ibFk
         J/l0DJf3Deg1jwqO637x7t8QzZ9DK4BxXqXAhdv5kC013/HwJ00DWdosWCMosm0HZCFZ
         NgAay/zlo1M19/GCzlHjl5tshTVuzQq4iiNt7eQiHiTFacnIKfuf/OsxPKNY7XuSeaU1
         5edoBRfqMTc3Mzg8hDIUxrnCC+ZNtHTIx7q3CayJ+k/0QordBccYd7imuHzYCGF8m9TQ
         OhKA==
X-Gm-Message-State: APjAAAVF6Z9I96DSwX9xccZz7XS+7Wr7IP071o7/0QEi+uRfEP7emCX7
        v3ayLs9088Es4LhyvjlaPWmLnPrjylGIIgZAkPA=
X-Google-Smtp-Source: APXvYqwV0xjh0/S1wriLBmg1iqt9GRGOckgKE25tw9l5cMgEBO3aUMAmh/VeJfuix7PBi8K0c8yip4jc6vbial5JF7k=
X-Received: by 2002:a24:8988:: with SMTP id s130mr21613638itd.79.1559672079550;
 Tue, 04 Jun 2019 11:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com> <CAK8P3a3Dv+hqnQHWU2nG5rB+hGrqbcDC3DUoNGZAzNGJgJwizA@mail.gmail.com>
In-Reply-To: <CAK8P3a3Dv+hqnQHWU2nG5rB+hGrqbcDC3DUoNGZAzNGJgJwizA@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 4 Jun 2019 11:14:28 -0700
Message-ID: <CABeXuvp0c+KSimAWPXoV=5GYJGkAfL2s-a71PFZHFDfm4UykzA@mail.gmail.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in restore_user_sigmask()
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dbueso@suse.de, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Tue, Jun 4, 2019 at 3:41 PM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > This is the minimal fix for stable, I'll send cleanups later.
> >
> > The commit 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add
> > restore_user_sigmask()") introduced the visible change which breaks
> > user-space: a signal temporary unblocked by set_user_sigmask() can
> > be delivered even if the caller returns success or timeout.
> >
> > Change restore_user_sigmask() to accept the additional "interrupted"
> > argument which should be used instead of signal_pending() check, and
> > update the callers.
> >
> > Reported-by: Eric Wong <e@80x24.org>
> > Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> > cc: stable@vger.kernel.org (v5.0+)
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>

Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>

The original fix posted:
https://lore.kernel.org/patchwork/patch/1077355/ would also have been
a correct fix for this problem. But, given the cleanups that are in
the pipeline, this is a better fix.

-Deepa
