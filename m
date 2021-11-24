Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2345C184
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345166AbhKXNTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348015AbhKXNQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:16:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F5A6142A;
        Wed, 24 Nov 2021 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757876;
        bh=Ku7w7nVqvgvgAZhf8s6vPEG9wKCmIZAmJfxENgU/Xjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAkjoaGwUjFlQWtvzdaiJPeV8IqsokBUWq48K1sBg+RuTWyx+2mNH4znkYJsb6WFd
         LMLcISvU70bFYka4kftjm8aKWW2wB+dx6fDpip0mRCJQUxowO8UA4B892aqZCIvt2n
         SL9wOSyb3UDkZJi+xdk8O5LLwHaAaKu7fIgVd92Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 306/323] ipc: WARN if trying to remove ipc object which is absent
Date:   Wed, 24 Nov 2021 12:58:16 +0100
Message-Id: <20211124115729.239929048@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

commit 126e8bee943e9926238c891e2df5b5573aee76bc upstream.

Patch series "shm: shm_rmid_forced feature fixes".

Some time ago I met kernel crash after CRIU restore procedure,
fortunately, it was CRIU restore, so, I had dump files and could do
restore many times and crash reproduced easily.  After some
investigation I've constructed the minimal reproducer.  It was found
that it's use-after-free and it happens only if sysctl
kernel.shm_rmid_forced = 1.

The key of the problem is that the exit_shm() function not handles shp's
object destroy when task->sysvshm.shm_clist contains items from
different IPC namespaces.  In most cases this list will contain only
items from one IPC namespace.

How can this list contain object from different namespaces? The
exit_shm() function is designed to clean up this list always when
process leaves IPC namespace.  But we made a mistake a long time ago and
did not add a exit_shm() call into the setns() syscall procedures.

The first idea was just to add this call to setns() syscall but it
obviously changes semantics of setns() syscall and that's
userspace-visible change.  So, I gave up on this idea.

The first real attempt to address the issue was just to omit forced
destroy if we meet shp object not from current task IPC namespace [1].
But that was not the best idea because task->sysvshm.shm_clist was
protected by rwsem which belongs to current task IPC namespace.  It
means that list corruption may occur.

Second approach is just extend exit_shm() to properly handle shp's from
different IPC namespaces [2].  This is really non-trivial thing, I've
put a lot of effort into that but not believed that it's possible to
make it fully safe, clean and clear.

Thanks to the efforts of Manfred Spraul working an elegant solution was
designed.  Thanks a lot, Manfred!

Eric also suggested the way to address the issue in ("[RFC][PATCH] shm:
In shm_exit destroy all created and never attached segments") Eric's
idea was to maintain a list of shm_clists one per IPC namespace, use
lock-less lists.  But there is some extra memory consumption-related
concerns.

An alternative solution which was suggested by me was implemented in
("shm: reset shm_clist on setns but omit forced shm destroy").  The idea
is pretty simple, we add exit_shm() syscall to setns() but DO NOT
destroy shm segments even if sysctl kernel.shm_rmid_forced = 1, we just
clean up the task->sysvshm.shm_clist list.

This chages semantics of setns() syscall a little bit but in comparision
to the "naive" solution when we just add exit_shm() without any special
exclusions this looks like a safer option.

[1] https://lkml.org/lkml/2021/7/6/1108
[2] https://lkml.org/lkml/2021/7/14/736

This patch (of 2):

Let's produce a warning if we trying to remove non-existing IPC object
from IPC namespace kht/idr structures.

This allows us to catch possible bugs when the ipc_rmid() function was
called with inconsistent struct ipc_ids*, struct kern_ipc_perm*
arguments.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -417,8 +417,8 @@ static int ipcget_public(struct ipc_name
 static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	if (ipcp->key != IPC_PRIVATE)
-		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
-				       ipc_kht_params);
+		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
+				       ipc_kht_params));
 }
 
 /**
@@ -433,7 +433,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 {
 	int idx = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, idx);
+	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, idx) != ipcp);
 	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;


