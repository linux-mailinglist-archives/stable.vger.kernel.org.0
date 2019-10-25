Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C075E531B
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfJYSHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46804 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731440AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0008P3-Ur; Fri, 25 Oct 2019 19:05:37 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001jy-3D; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Julian Wiedmann" <jwi@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>
Date:   Fri, 25 Oct 2019 19:03:32 +0100
Message-ID: <lsq.1572026582.592686556@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 31/47] s390/qdio: (re-)initialize tiqdio list entries
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Wiedmann <jwi@linux.ibm.com>

commit e54e4785cb5cb4896cf4285964aeef2125612fb2 upstream.

When tiqdio_remove_input_queues() removes a queue from the tiq_list as
part of qdio_shutdown(), it doesn't re-initialize the queue's list entry
and the prev/next pointers go stale.

If a subsequent qdio_establish() fails while sending the ESTABLISH cmd,
it calls qdio_shutdown() again in QDIO_IRQ_STATE_ERR state and
tiqdio_remove_input_queues() will attempt to remove the queue entry a
second time. This dereferences the stale pointers, and bad things ensue.
Fix this by re-initializing the list entry after removing it from the
list.

For good practice also initialize the list entry when the queue is first
allocated, and remove the quirky checks that papered over this omission.
Note that prior to
commit e521813468f7 ("s390/qdio: fix access to uninitialized qdio_q fields"),
these checks were bogus anyway.

setup_queues_misc() clears the whole queue struct, and thus needs to
re-init the prev/next pointers as well.

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/cio/qdio_setup.c   | 2 ++
 drivers/s390/cio/qdio_thinint.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -100,6 +100,7 @@ static int __qdio_allocate_qs(struct qdi
 			return -ENOMEM;
 		}
 		irq_ptr_qs[i] = q;
+		INIT_LIST_HEAD(&q->entry);
 	}
 	return 0;
 }
@@ -128,6 +129,7 @@ static void setup_queues_misc(struct qdi
 	q->mask = 1 << (31 - i);
 	q->nr = i;
 	q->handler = handler;
+	INIT_LIST_HEAD(&q->entry);
 }
 
 static void setup_storage_lists(struct qdio_q *q, struct qdio_irq *irq_ptr,
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -88,14 +88,14 @@ void tiqdio_remove_input_queues(struct q
 	struct qdio_q *q;
 
 	q = irq_ptr->input_qs[0];
-	/* if establish triggered an error */
-	if (!q || !q->entry.prev || !q->entry.next)
+	if (!q)
 		return;
 
 	mutex_lock(&tiq_list_lock);
 	list_del_rcu(&q->entry);
 	mutex_unlock(&tiq_list_lock);
 	synchronize_rcu();
+	INIT_LIST_HEAD(&q->entry);
 }
 
 static inline int has_multiple_inq_on_dsci(struct qdio_irq *irq_ptr)

