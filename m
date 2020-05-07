Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D111C9F4F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 01:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgEGXxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 19:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgEGXxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 19:53:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FA920720;
        Thu,  7 May 2020 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588895624;
        bh=4cQyWJROk5wGYMXFEIKUKovpkS26o5KvIY2HePmm3Gg=;
        h=Date:From:To:Subject:From;
        b=k/FSwels1XVm9hN+P37irMRBZRh+lsmjNsMPg24oyCS/dPPXlofdfl21x8vwSyQmj
         3tEblN+TmrFrZZhPCu6rtE5hfj9lDVl14AWpi/9L0WrdbROay30nLgGrOLNkE6Or9t
         z6R55HEFOXm3XG99YQeu6OKlsPk8nSWNHSZkQqqk=
Date:   Thu, 07 May 2020 16:53:43 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com,
        oberpar@linux.ibm.com, rostedt@goodmis.org, schwab@suse.de,
        stable@vger.kernel.org, vvs@virtuozzo.com
Subject:  +
 ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index.patch added
 to -mm tree
Message-ID: <20200507235343.GG9mhhjlf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ipc/util.c: sysvipc_find_ipc() incorrectly updates position index
has been added to the -mm tree.  Its filename is
     ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

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

new_pos should jump through hole of unused ids, pos can be updated inside
"for" cycle.

Link: http://lkml.kernel.org/r/4921fe9b-9385-a2b4-1dc4-1099be6d2e39@virtuozzo.com
Fixes: 89163f93c6f9 ("ipc/util.c: sysvipc_find_ipc() should increase position index")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reported-by: Andreas Schwab <schwab@suse.de>
Acked-by: Waiman Long <longman@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/ipc/util.c~ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index
+++ a/ipc/util.c
@@ -764,21 +764,21 @@ static struct kern_ipc_perm *sysvipc_fin
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
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index.patch

