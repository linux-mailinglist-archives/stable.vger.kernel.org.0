Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA206CE4BB
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfJGOIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:08:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44579 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:08:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id u40so19262982qth.11
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gmVglyWKRL0YrCqpuD5CasPMTIWps3Y3h/zTwqC3fXU=;
        b=GrzxU0f2Hryzm14bKBcQi7M+Zw0ohMc6p+VXt12fPY6aMrEKDQI/qxU0LCRY+QUOnh
         yGdpwRwAMlUUcpufkQ3gv50XZ0X+0UfMTovmnCupdnEDFg1LJ9rmOWG9uyHeaOqSiQEG
         T1i2uAv/5z8alSFWJcavI1voAFIMUWIdzKXv/RAZiizYzmUPCxxKzE+IwvS7wF9gSFCT
         hVQ3mKbUhm1s9ANrpGWB4AbOxrL73wleW7W3jZhrCRJKVE7sxUMmL/cy4lJbaWKctnhl
         OXnhveF05yOxjKHTfrbH9SAn1cownt8F3ifloxGX8WpZB0gcG6KVlK1C3Jz5cjsu7mOD
         xiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gmVglyWKRL0YrCqpuD5CasPMTIWps3Y3h/zTwqC3fXU=;
        b=p8EMlrCvowMy9xs0rwMaNnuXHImvJWWDmYE90Ql6DSJGqkbhTeisBfCTgXDakK4hn6
         pgi9Ts0OjStGrGUpefIbQSudo27g9Rj8Bt3V9PFmV44b6HpZ5IlbSZ1zv/aUvBqN692u
         MAcOsiKkhaUiDSHCb4MycCmRT91YcIIuA3Dw6bK66U8IQKEPs2H11+a0m1DZkXeMRv14
         SWJ1YBkK4LbgzsqAbDGswcxQ3Po8H6YrB7K80tpNh/kp77IY1f6ebKdrqyzdPkA2HfXP
         DOB/lroMUTTWz5VAtRR+yV726Z0bj+7AeKAZ+b/o4wJJOP+BVJg55mk7SeoNm9H7B7yT
         52SQ==
X-Gm-Message-State: APjAAAVbhDXC35Sjwcqdt7BgA8oCcK344ENn4QVwSvh3Tnb5IhPDK2DA
        ubbtDcsjpl+KXi/ndyMrqPPKFPjb8dP5Oa/swvxWqw==
X-Google-Smtp-Source: APXvYqxSy1lbEJCuAAIxwrzbndpVVIPgkOUHJJwJfRmWxZqLhdEZLZlXBATpjpxKAyCgEk2lnVO7asE9kXNZJ0apHJk=
X-Received: by 2002:ac8:2c50:: with SMTP id e16mr29620165qta.257.1570457333306;
 Mon, 07 Oct 2019 07:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com> <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com> <20191007135527.qd5ibfyajnihsrsh@wittgenstein>
In-Reply-To: <20191007135527.qd5ibfyajnihsrsh@wittgenstein>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Oct 2019 16:08:41 +0200
Message-ID: <CACT4Y+Y3oohjuM59Mkdhgpv1UJT_Z_m88vSVtkU5Eq=yRTU2eg@mail.gmail.com>
Subject: Re: [PATCH v2] taskstats: fix data-race
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 7, 2019 at 3:55 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Oct 07, 2019 at 03:50:47PM +0200, Dmitry Vyukov wrote:
> > On Mon, Oct 7, 2019 at 3:18 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > On Mon, Oct 07, 2019 at 01:01:17PM +0200, Christian Brauner wrote:
> > > > When assiging and testing taskstats in taskstats_exit() there's a race
> > > > when writing and reading sig->stats when a thread-group with more than
> > > > one thread exits:
> > > >
> > > > cpu0:
> > > > thread catches fatal signal and whole thread-group gets taken down
> > > >  do_exit()
> > > >  do_group_exit()
> > > >  taskstats_exit()
> > > >  taskstats_tgid_alloc()
> > > > The tasks reads sig->stats holding sighand lock seeing garbage.
> > >
> > > You meant "without holding sighand lock" here, right?
> > >
> > >
> > > >
> > > > cpu1:
> > > > task calls exit_group()
> > > >  do_exit()
> > > >  do_group_exit()
> > > >  taskstats_exit()
> > > >  taskstats_tgid_alloc()
> > > > The task takes sighand lock and assigns new stats to sig->stats.
> > > >
> > > > Fix this by using READ_ONCE() and smp_store_release().
> > > >
> > > > Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> > > > Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> > > > Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> > > > ---
> > > > /* v1 */
> > > > Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> > > >
> > > > /* v2 */
> > > > - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
> > > >   - fix the original double-checked locking using memory barriers
> > > >
> > > > /* v3 */
> > > > - Andrea Parri <parri.andrea@gmail.com>:
> > > >   - document memory barriers to make checkpatch happy
> > > > ---
> > > >  kernel/taskstats.c | 21 ++++++++++++---------
> > > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > > > index 13a0f2e6ebc2..978d7931fb65 100644
> > > > --- a/kernel/taskstats.c
> > > > +++ b/kernel/taskstats.c
> > > > @@ -554,24 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > >  {
> > > >       struct signal_struct *sig = tsk->signal;
> > > > -     struct taskstats *stats;
> > > > +     struct taskstats *stats_new, *stats;
> > > >
> > > > -     if (sig->stats || thread_group_empty(tsk))
> > > > -             goto ret;
> > > > +     /* Pairs with smp_store_release() below. */
> > > > +     stats = READ_ONCE(sig->stats);
> > >
> > > This pairing suggests that the READ_ONCE() is heading an address
> > > dependency, but I fail to identify it: what is the target memory
> > > access of such a (putative) dependency?
> >
> > I would assume callers of this function access *stats. So the
> > dependency is between loading stats and accessing *stats.
>
> Right, but why READ_ONCE() and not smp_load_acquire here?

Because if all memory accesses we need to order have data dependency
between them, READ_ONCE is enough and is cheaper on some archs (e.g.
ARM).
In our case there is a data dependency between loading of stats and
accessing *stats (only Alpha could reorder that, other arches can't
load via a pointer before loading the pointer itself (sic!)).
