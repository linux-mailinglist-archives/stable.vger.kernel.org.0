Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18A82D05A0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 16:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLFPSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 10:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgLFPSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 10:18:42 -0500
Date:   Sun, 6 Dec 2020 10:18:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607267881;
        bh=z/0+2fBlDxri3UNTZZPz3BOCbaNQen6BCeUnYPXUHi0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=vAvcHop5Awz7s2MBmG6gYPRQZWddnGZgQUWP8UU5+iNwgX4YSr5v+4Y1xM2bljT/T
         2ixtgZA0ID+g517oifZhYPjqnMeFs+QZLcV0PXRThNdX1uYfnBqZiYHd+yDOr47/DQ
         0m8UpOmxpIFbfLQdUuyUtoYWndMv60KUDM1ghRSakCA9hmzbtvDY2rTGw+OXhwyvOG
         F+s2tEQ7C0ZvKGi1kp+nU2+dz51+82nvSWFgbdVt2XuXM7emsKMs8GPAatBjSO+6Nm
         vDo15eXf9g2K740LSQuxFqUvx3oaJWTlz6jjJMiuRv6Vbr4xgLQlwFVIoExJt4eO6/
         3xXMwuLplGtOg==
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20201206151800.GE643756@sasha-vm>
References: <159041776924279@kroah.com>
 <20200525172709.GB7427@vingu-book>
 <X8yq+7/dQADbrTTL@kroah.com>
 <CAKfTPtDmpYYA2nc-+d3OfT-=2kf82+3O50WGguDQ=XOXTnbZGQ@mail.gmail.com>
 <X8zDGGvVkyDGbco/@kroah.com>
 <CAKfTPtBTXdVVwB+st4agBbJ3oXnB5gJ7BwvgM7=191PWvvxMLg@mail.gmail.com>
 <X8zJbSgaegj5He+i@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X8zJbSgaegj5He+i@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 01:07:09PM +0100, Greg KH wrote:
>On Sun, Dec 06, 2020 at 12:54:57PM +0100, Vincent Guittot wrote:
>> On Sun, 6 Dec 2020 at 12:47, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >
>> > On Sun, Dec 06, 2020 at 12:25:12PM +0100, Vincent Guittot wrote:
>> > > On Sun, 6 Dec 2020 at 10:56, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > > >
>> > > > On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
>> > > > > Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
>> > > > > >
>> > > > > > The patch below does not apply to the 5.4-stable tree.
>> > > > > > If someone wants it applied there, or to any other stable or longterm
>> > > > > > tree, then please email the backport, including the original git commit
>> > > > > > id to <stable@vger.kernel.org>.
>> > > > >
>> > > > > This patch needs  commit
>> > > > >     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
>> > > > > to be applied first. But then, it will not apply. The backport is :
>> > > > >
>> > > > > [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]
>> > > > >
>> > > > > Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
>> > > > > are quite close and follow the same sequence for enqueuing an entity in the
>> > > > > cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
>> > > > > enqueue_task_fair(). This fixes a problem already faced with the latter and
>> > > > > add an optimization in the last for_each_sched_entity loop.
>> > > > >
>> > > > > Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
>> > > > > Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
>> > > > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> > > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> > > > > Reviewed-by: Phil Auld <pauld@redhat.com>
>> > > > > Reviewed-by: Ben Segall <bsegall@google.com>
>> > > > > Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org
>> > > > > ---
>> > > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
>> > > > >  1 file changed, 28 insertions(+), 8 deletions(-)
>> > > >
>> > > > This patch doesn't apply to the 5.4.y tree at all.  Can someone please
>> > > > provide a working backport?
>> > >
>> > > It seems that commit b34cb07dde7c ("sched/fair: Fix
>> > > enqueue_task_fair() warning some more") has already been applied back
>> > > in May. But then, I'm able to apply this patch on top of
>> > > v5.4.y/v5.4.81
>> > >
>> >
>> > What is "this patch" here?  I tried to apply 39f23ce07b93 ("sched/fair:
>> > Fix unthrottle_cfs_rq() for leaf_cfs_rq list") directly to the 5.4 tree
>> > and it too did not apply.
>>
>> commit 39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for
>> leaf_cfs_rq list") can't apply because there are several changes which
>> are not fixes which have been applied since v5.4 on the same code.
>>
>> This patch is the backport on v5.4 of the commit 39f23ce07b93
>
>What is "this"?  I tried to apply the above patch to the 5.4.y tree, and
>it didn't apply.  So I still do not understand what I can do here...

It's already in our 5.4 tree I've added it there a few days ago :)

-- 
Thanks,
Sasha
