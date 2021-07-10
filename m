Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D762B3C2C54
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 03:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhGJBTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 21:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhGJBTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 21:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B792E6120D;
        Sat, 10 Jul 2021 01:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625879810;
        bh=T0jnMKfrJ6f8hQhHhOmb4e5hFvUAz00D0xm4WO8CVqU=;
        h=Date:From:To:Subject:From;
        b=ZRbTuL9BVAoq7wxLVYsUNNqT+HYbo4ejk0TDD+xlm9XsPd6yXj6FvNDLa3A48sqBl
         orM4LDXZ3p17kXPsucx3Io2Uwmhiq2tqUd/P1MMFmbVFYpzwTRkRaf1oSGiV/M0ReY
         4Ia8BekbvljoFeIOPEm1rFaau8GGPi7eWfBkYW/0=
Date:   Fri, 09 Jul 2021 18:16:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ptikhomirov@virtuozzo.com, miltonm@bga.com, millerjo@us.ibm.com,
        manfred@colorfullife.com, ebiederm@xmission.com, dave@stgolabs.net,
        alexander@mihalicyn.com, alexander.mikhalitsyn@virtuozzo.com
Subject:  +
 shm-skip-shm_destroy-if-task-ipc-namespace-was-changed.patch added to -mm
 tree
Message-ID: <20210710011649.R8BLi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: shm: skip shm_destroy if task IPC namespace was changed
has been added to the -mm tree.  Its filename is
     shm-skip-shm_destroy-if-task-ipc-namespace-was-changed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shm-skip-shm_destroy-if-task-ipc-namespace-was-changed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shm-skip-shm_destroy-if-task-ipc-namespace-was-changed.patch

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
Subject: shm: skip shm_destroy if task IPC namespace was changed

Patch series "shm: omit forced shm destroy if task IPC namespace was changed".

Task IPC namespace shm's has shm_rmid_forced feature which is per IPC
namespace and controlled by kernel.shm_rmid_forced sysctl.  When feature
is turned on, then during task exit (and unshare(CLONE_NEWIPC)) all
sysvshm's will be destroyed by exit_shm(struct task_struct *task)
function.

But there is a problem if task was changed IPC namespace since shmget()
call.  In such situation exit_shm() function will try to call
shm_destroy(<new_ipc_namespace_ptr>, <sysvshmem_from_old_ipc_namespace>)
which leads to the situation when sysvshm object still attached to old IPC
namespace but freed; later during old IPC namespace cleanup we will try to
free such sysvshm object for the second time and will get the problem :)

First patch solves this problem by postponing shm_destroy to the moment
when IPC namespace cleanup will be called.  Second patch is useful to
prevent (or easy catch) such bugs in the future by adding corresponding
WARNings.


This patch (of 2):

Task may change IPC namespace by doing setns() but sysvshm objects remains
at the origin IPC namespace (=IPC namespace where task was when shmget()
was called).  Let's skip forced shm destroy in such case because we can't
determine IPC namespace by shm only.  These problematic sysvshm's will be
destroyed on ipc namespace cleanup.

Link: https://lkml.kernel.org/r/20210706132259.71740-1-alexander.mikhalitsyn@virtuozzo.com
Link: https://lkml.kernel.org/r/20210706132259.71740-2-alexander.mikhalitsyn@virtuozzo.com
Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Jack Miller <millerjo@us.ibm.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/ipc/shm.c~shm-skip-shm_destroy-if-task-ipc-namespace-was-changed
+++ a/ipc/shm.c
@@ -173,6 +173,14 @@ static inline struct shmid_kernel *shm_o
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
+static inline bool is_shm_in_ns(struct ipc_namespace *ns, struct shmid_kernel *shp)
+{
+	int idx = ipcid_to_idx(shp->shm_perm.id);
+	struct shmid_kernel *tshp = shm_obtain_object(ns, idx);
+
+	return !IS_ERR(tshp) && tshp == shp;
+}
+
 /*
  * shm_lock_(check_) routines are called in the paths where the rwsem
  * is not necessarily held.
@@ -415,7 +423,7 @@ void exit_shm(struct task_struct *task)
 	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
 		shp->shm_creator = NULL;
 
-		if (shm_may_destroy(ns, shp)) {
+		if (is_shm_in_ns(ns, shp) && shm_may_destroy(ns, shp)) {
 			shm_lock_by_ptr(shp);
 			shm_destroy(ns, shp);
 		}
_

Patches currently in -mm which might be from alexander.mikhalitsyn@virtuozzo.com are

shm-skip-shm_destroy-if-task-ipc-namespace-was-changed.patch
ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch

