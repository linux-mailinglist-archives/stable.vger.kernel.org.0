Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7055D1D2416
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 02:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgENAuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 20:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAut (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 20:50:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA2E2065C;
        Thu, 14 May 2020 00:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589417449;
        bh=cyxWQd0GdMNFqFcobEzn6Kiq0AZWUu6yL4nHjzOM57M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DadiJEPIKXXomoYyy+zwrkDTfnq0K31kLI/uB3E/plUZ4J9/5aoBQQDrv9uBryF0r
         V6lADcjnctYjh2IIVo7qvzWoLu8Y7v7xZvux1od0OaJdVuH/XkIRIkmDVBEOjGxAQ9
         N+O34UrAHAAlZcu6gwKnodMbmbAuebIlaapr3VIE=
Date:   Wed, 13 May 2020 17:50:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave@stgolabs.net, linux-mm@kvack.org,
        longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com,
        rostedt@goodmis.org, schwab@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vvs@virtuozzo.com
Subject:  [patch 5/7] ipc/util.c: sysvipc_find_ipc() incorrectly
 updates position index
Message-ID: <20200514005048.N5zHLNCxr%akpm@linux-foundation.org>
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
