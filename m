Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EE043D6DE
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 00:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhJ0Wqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 18:46:40 -0400
Received: from relay.sw.ru ([185.231.240.75]:45836 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhJ0Wqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 18:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=yHdp9tOZ7y1Mwfs+YkJJ25dLtIO+Tt3gV9cviUbRGcA=; b=CyhB2X7sZcDq
        En9KVWHoUzf7flwOVHxLNIQaAamPUGAa2XatDb8wK1m2fpChqukWeOBQTX1xjA3acPSCwU+Q/acYh
        thknzRkIUYrBrc1AangJbDLZMbFoBTA21Hv6lO3JBP5tZKhlqggvT+MUFux4Orb2YI6XdP033kbwa
        2FLiI=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mfreT-007RG6-35; Thu, 28 Oct 2021 01:44:09 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
Subject: [PATCH 0/2] shm: shm_rmid_forced feature fixes
Date:   Thu, 28 Oct 2021 01:43:46 +0300
Message-Id: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A long story behind all of that...

Some time ago I met kernel crash after CRIU restore procedure,
fortunately, it was CRIU restore, so, I had dump files and could
do restore many times and crash reproduced easily. After some
investigation I've constructed the minimal reproducer. It was
found that it's use-after-free and it happens only if
sysctl kernel.shm_rmid_forced = 1.

The key of the problem is that the exit_shm() function
not handles shp's object destroy when task->sysvshm.shm_clist
contains items from different IPC namespaces. In most cases
this list will contain only items from one IPC namespace.

Why this list may contain object from different namespaces?
Function exit_shm() designed to clean up this list always when
process leaves IPC namespace. But we made a mistake a long time ago
and not add exit_shm() call into setns() syscall procedures.
1st second idea was just to add this call to setns() syscall but
it's obviously changes semantics of setns() syscall and that's
userspace-visible change. So, I gave up this idea.

First real attempt to address the issue was just to omit forced destroy
if we meet shp object not from current task IPC namespace [1]. But
that was not the best idea because task->sysvshm.shm_clist was
protected by rwsem which belongs to current task IPC namespace.
It means that list corruption may occur.

Second approach is just extend exit_shm() to properly handle
shp's from different IPC namespaces [2]. This is really
non-trivial thing, I've put a lot of effort into that but
not believed that it's possible to make it fully safe, clean
and clear.

Thanks to the efforts of Manfred Spraul working and elegant
solution was designed. Thanks a lot, Manfred!

Eric also suggested the way to address the issue in
("[RFC][PATCH] shm: In shm_exit destroy all created and never attached segments")
Eric's idea was to maintain a list of shm_clists one per IPC namespace,
use lock-less lists. But there is some extra memory consumption-related concerns.

Alternative solution which was suggested by me was implemented in
("shm: reset shm_clist on setns but omit forced shm destroy")
Idea is pretty simple, we add exit_shm() syscall to setns() but DO NOT
destroy shm segments even if sysctl kernel.shm_rmid_forced = 1, we just
clean up the task->sysvshm.shm_clist list. This chages semantics of
setns() syscall a little bit but in comparision to "naive" solution
when we just add exit_shm() without any special exclusions this looks
like a safer option.

[1] https://lkml.org/lkml/2021/7/6/1108
[2] https://lkml.org/lkml/2021/7/14/736

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

Alexander Mikhalitsyn (2):
  ipc: WARN if trying to remove ipc object which is absent
  shm: extend forced shm destroy to support objects from several IPC
    nses

 include/linux/ipc_namespace.h |  15 +++
 include/linux/sched/task.h    |   2 +-
 include/linux/shm.h           |   2 +-
 ipc/shm.c                     | 170 +++++++++++++++++++++++++---------
 ipc/util.c                    |   6 +-
 5 files changed, 145 insertions(+), 50 deletions(-)

-- 
2.31.1

