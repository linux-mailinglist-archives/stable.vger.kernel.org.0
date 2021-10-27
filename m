Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B97E43D6F3
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 00:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhJ0WyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 18:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhJ0WyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 18:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B78860EBD;
        Wed, 27 Oct 2021 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635375107;
        bh=ll9D1B8xRSIUCvKr3P+n5p4sxKlRcyRXsaos6oKIM+g=;
        h=Date:From:To:Subject:From;
        b=e9r8AgCqStVrVNPH0gTCdxoinbkOlVj07iFuZ424iH/4CQJYQEttITTpsSKlUJcAH
         7Yv9bAo8QFar6bQXq4j8rKPppKR0/kIL6q8ZcpukqcGQMq7RQH/xt8rhCu5KWoOY5j
         MjzgaD4odkrl9vBRhRLOVK46cV7zOr4LVrOdC5XI=
Date:   Wed, 27 Oct 2021 15:51:46 -0700
From:   akpm@linux-foundation.org
To:     alexander.mikhalitsyn@virtuozzo.com, avagin@gmail.com,
        dave@stgolabs.net, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, ptikhomirov@virtuozzo.com,
        stable@vger.kernel.org, vvs@virtuozzo.com
Subject:  +
 ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch added to -mm
 tree
Message-ID: <20211027225146.bU4xXW6Ma%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ipc: WARN if trying to remove ipc object which is absent
has been added to the -mm tree.  Its filename is
     ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: ipc: WARN if trying to remove ipc object which is absent

Patch series "shm: shm_rmid_forced feature fixes".

Some time ago I met kernel crash after CRIU restore procedure,
fortunately, it was CRIU restore, so, I had dump files and could do
restore many times and crash reproduced easily.  After some investigation
I've constructed the minimal reproducer.  It was found that it's
use-after-free and it happens only if sysctl kernel.shm_rmid_forced = 1.

The key of the problem is that the exit_shm() function not handles shp's
object destroy when task->sysvshm.shm_clist contains items from different
IPC namespaces.  In most cases this list will contain only items from one
IPC namespace.

Why this list may contain object from different namespaces?  Function
exit_shm() designed to clean up this list always when process leaves IPC
namespace.  But we made a mistake a long time ago and not add exit_shm()
call into setns() syscall procedures.  1st second idea was just to add
this call to setns() syscall but it's obviously changes semantics of
setns() syscall and that's userspace-visible change.  So, I gave up this
idea.

First real attempt to address the issue was just to omit forced destroy if
we meet shp object not from current task IPC namespace [1].  But that was
not the best idea because task->sysvshm.shm_clist was protected by rwsem
which belongs to current task IPC namespace.  It means that list
corruption may occur.

Second approach is just extend exit_shm() to properly handle shp's from
different IPC namespaces [2].  This is really non-trivial thing, I've put
a lot of effort into that but not believed that it's possible to make it
fully safe, clean and clear.

Thanks to the efforts of Manfred Spraul working an elegant solution was
designed.  Thanks a lot, Manfred!

Eric also suggested the way to address the issue in ("[RFC][PATCH] shm: In
shm_exit destroy all created and never attached segments") Eric's idea was
to maintain a list of shm_clists one per IPC namespace, use lock-less
lists.  But there is some extra memory consumption-related concerns.

Alternative solution which was suggested by me was implemented in ("shm:
reset shm_clist on setns but omit forced shm destroy") Idea is pretty
simple, we add exit_shm() syscall to setns() but DO NOT destroy shm
segments even if sysctl kernel.shm_rmid_forced = 1, we just clean up the
task->sysvshm.shm_clist list.  This chages semantics of setns() syscall a
little bit but in comparision to "naive" solution when we just add
exit_shm() without any special exclusions this looks like a safer option.

[1] https://lkml.org/lkml/2021/7/6/1108
[2] https://lkml.org/lkml/2021/7/14/736


This patch (of 2):

Let's produce a warning if we trying to remove non-existing IPC object
from IPC namespace kht/idr structures.

This allows to catch possible bugs when ipc_rmid() function was called
with inconsistent struct ipc_ids*, struct kern_ipc_perm* arguments.

Link: https://lkml.kernel.org/r/20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com
Link: https://lkml.kernel.org/r/20211027224348.611025-2-alexander.mikhalitsyn@virtuozzo.com
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/ipc/util.c~ipc-warn-if-trying-to-remove-ipc-object-which-is-absent
+++ a/ipc/util.c
@@ -447,8 +447,8 @@ static int ipcget_public(struct ipc_name
 static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	if (ipcp->key != IPC_PRIVATE)
-		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
-				       ipc_kht_params);
+		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
+				       ipc_kht_params));
 }
 
 /**
@@ -498,7 +498,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 {
 	int idx = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, idx);
+	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, idx) != ipcp);
 	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;
_

Patches currently in -mm which might be from alexander.mikhalitsyn@virtuozzo.com are

ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch
shm-extend-forced-shm-destroy-to-support-objects-from-several-ipc-nses.patch

