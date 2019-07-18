Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA246C764
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390574AbfGRDXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfGRDHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:07:51 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628B62053B;
        Thu, 18 Jul 2019 03:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419270;
        bh=wMdPNoj9T1GtWUxEQzxuJ8p/8iOFmwa+5cQ4Ej+wvbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRuTkeP5LdLAgZMu7rDZuAkhAVADVFJJR7U5xfg1afeE0z4AgRLh6Jp7Y4k3lcRc1
         Hn9ZRAhC402HujhjQ7pDXKlAATnfMM6KT1IO2wSoDzl3JV7shq9Wrd2w9MY8XEOfGO
         djS6aIkZ/eHin7jhZfdaKz0h+qZbKLOfE8+3IVD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 38/47] s390/qdio: (re-)initialize tiqdio list entries
Date:   Thu, 18 Jul 2019 12:01:52 +0900
Message-Id: <20190718030051.979282235@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/qdio_setup.c   |    2 ++
 drivers/s390/cio/qdio_thinint.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -151,6 +151,7 @@ static int __qdio_allocate_qs(struct qdi
 			return -ENOMEM;
 		}
 		irq_ptr_qs[i] = q;
+		INIT_LIST_HEAD(&q->entry);
 	}
 	return 0;
 }
@@ -179,6 +180,7 @@ static void setup_queues_misc(struct qdi
 	q->mask = 1 << (31 - i);
 	q->nr = i;
 	q->handler = handler;
+	INIT_LIST_HEAD(&q->entry);
 }
 
 static void setup_storage_lists(struct qdio_q *q, struct qdio_irq *irq_ptr,
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -87,14 +87,14 @@ void tiqdio_remove_input_queues(struct q
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


