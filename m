Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8B2D04B0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgLFMGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgLFMGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 07:06:37 -0500
Date:   Sun, 6 Dec 2020 13:07:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607256356;
        bh=HykN30l+JNQ7Az9wYE07hKTyOFCtswEBbQAICUYD3c0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rAUSLk2TZReZkSdbA6qON+BeneWgCUu8i5W4o82Mih6A80mceUnozCVIcCJ8IYYHY
         vhjx+xw8C77Zlo5/LX8A74FMc722AZtD04T2H6VMhu9Ty4rMXks6RxLi7ICGAstsxx
         e8uxMsiWfKfoGaizfnxy38IxipDk7ywGAbwaDCqk=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <X8zJbSgaegj5He+i@kroah.com>
References: <159041776924279@kroah.com>
 <20200525172709.GB7427@vingu-book>
 <X8yq+7/dQADbrTTL@kroah.com>
 <CAKfTPtDmpYYA2nc-+d3OfT-=2kf82+3O50WGguDQ=XOXTnbZGQ@mail.gmail.com>
 <X8zDGGvVkyDGbco/@kroah.com>
 <CAKfTPtBTXdVVwB+st4agBbJ3oXnB5gJ7BwvgM7=191PWvvxMLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKfTPtBTXdVVwB+st4agBbJ3oXnB5gJ7BwvgM7=191PWvvxMLg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 12:54:57PM +0100, Vincent Guittot wrote:
> On Sun, 6 Dec 2020 at 12:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Dec 06, 2020 at 12:25:12PM +0100, Vincent Guittot wrote:
> > > On Sun, 6 Dec 2020 at 10:56, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
> > > > > Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
> > > > > >
> > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > >
> > > > > This patch needs  commit
> > > > >     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
> > > > > to be applied first. But then, it will not apply. The backport is :
> > > > >
> > > > > [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]
> > > > >
> > > > > Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
> > > > > are quite close and follow the same sequence for enqueuing an entity in the
> > > > > cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
> > > > > enqueue_task_fair(). This fixes a problem already faced with the latter and
> > > > > add an optimization in the last for_each_sched_entity loop.
> > > > >
> > > > > Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> > > > > Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
> > > > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > > Reviewed-by: Phil Auld <pauld@redhat.com>
> > > > > Reviewed-by: Ben Segall <bsegall@google.com>
> > > > > Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org
> > > > > ---
> > > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
> > > > >  1 file changed, 28 insertions(+), 8 deletions(-)
> > > >
> > > > This patch doesn't apply to the 5.4.y tree at all.  Can someone please
> > > > provide a working backport?
> > >
> > > It seems that commit b34cb07dde7c ("sched/fair: Fix
> > > enqueue_task_fair() warning some more") has already been applied back
> > > in May. But then, I'm able to apply this patch on top of
> > > v5.4.y/v5.4.81
> > >
> >
> > What is "this patch" here?  I tried to apply 39f23ce07b93 ("sched/fair:
> > Fix unthrottle_cfs_rq() for leaf_cfs_rq list") directly to the 5.4 tree
> > and it too did not apply.
> 
> commit 39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for
> leaf_cfs_rq list") can't apply because there are several changes which
> are not fixes which have been applied since v5.4 on the same code.
> 
> This patch is the backport on v5.4 of the commit 39f23ce07b93

What is "this"?  I tried to apply the above patch to the 5.4.y tree, and
it didn't apply.  So I still do not understand what I can do here...

greg k-h
