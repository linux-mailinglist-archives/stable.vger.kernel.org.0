Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD201D8258
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgERRzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbgERRzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FA3207C4;
        Mon, 18 May 2020 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824532;
        bh=BEUWMUQxwatFeo/5l8VvlQUF3ITZ2kX7a3zK9Hqp7dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5tWIC67FPjwt1xw9fyhBcv4lGi5Etoza48WISMRGyZN8+KSVKig9k7eo5F9lssKh
         3hdGv13IKYtnyMWEhKqqRBLDlMQuRrNBr6Q+dC/veOaw2Ow+GtAI/LLXWyF6nsZD5w
         FZWuN5v3r8gty2pO0kHihu/bHTPGPFhzO8drWow8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>, NeilBrown <neilb@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/147] ipc/util.c: sysvipc_find_ipc() incorrectly updates position index
Date:   Mon, 18 May 2020 19:36:13 +0200
Message-Id: <20200518173520.206794779@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 5e698222c70257d13ae0816720dde57c56f81e15 ]

Commit 89163f93c6f9 ("ipc/util.c: sysvipc_find_ipc() should increase
position index") is causing this bug (seen on 5.6.8):

   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages

   # ipcmk -Q
   Message queue id: 0
   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages
   0x82db8127 0          root       644        0            0

   # ipcmk -Q
   Message queue id: 1
   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages
   0x82db8127 0          root       644        0            0
   0x76d1fb2a 1          root       644        0            0

   # ipcrm -q 0
   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages
   0x76d1fb2a 1          root       644        0            0
   0x76d1fb2a 1          root       644        0            0

   # ipcmk -Q
   Message queue id: 2
   # ipcrm -q 2
   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages
   0x76d1fb2a 1          root       644        0            0
   0x76d1fb2a 1          root       644        0            0

   # ipcmk -Q
   Message queue id: 3
   # ipcrm -q 1
   # ipcs -q

   ------ Message Queues --------
   key        msqid      owner      perms      used-bytes   messages
   0x7c982867 3          root       644        0            0
   0x7c982867 3          root       644        0            0
   0x7c982867 3          root       644        0            0
   0x7c982867 3          root       644        0            0

Whenever an IPC item with a low id is deleted, the items with higher ids
are duplicated, as if filling a hole.

new_pos should jump through hole of unused ids, pos can be updated
inside "for" cycle.

Fixes: 89163f93c6f9 ("ipc/util.c: sysvipc_find_ipc() should increase position index")
Reported-by: Andreas Schwab <schwab@suse.de>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/4921fe9b-9385-a2b4-1dc4-1099be6d2e39@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/util.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 594871610d454..1821b6386d3b4 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -764,21 +764,21 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 			total++;
 	}
 
-	*new_pos = pos + 1;
+	ipc = NULL;
 	if (total >= ids->in_use)
-		return NULL;
+		goto out;
 
 	for (; pos < ipc_mni; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			rcu_read_lock();
 			ipc_lock_object(ipc);
-			return ipc;
+			break;
 		}
 	}
-
-	/* Out of range - return NULL to terminate iteration */
-	return NULL;
+out:
+	*new_pos = pos + 1;
+	return ipc;
 }
 
 static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
-- 
2.20.1



