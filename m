Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B2C1C1E09
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 21:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgEATp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 15:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgEATp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 15:45:56 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 May 2020 12:45:56 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1071FC061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 12:45:56 -0700 (PDT)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 041J4F3d018035;
        Fri, 1 May 2020 20:20:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=xi2XwmEmO17lonRkhoOFjRCCYjvN8J3PUPNEZ5GSX4s=;
 b=cyUJfV0InaOm7AW4O/Dy9q+Evu5X1k7j0GLfKeY/0BzLliFRLq3Q17OOD2/d1kp1Q9IF
 kr5fk31dF0StAPKOw8GT6Tpk3NUytm7fN5RK76fbJeSr7+EcwfdbIJTARwDSDPV+ackx
 PA484vk2bDeRsv8fPU5Ck5h1sTULrGmb80ep0/KdqinfPq9CaS1N6sN2oRlByyGURTwc
 5eALAwGmArazIZDDvxkzFZ9oo0CKrFbEu7lQiVMib0cifVLRngAXk6XNTQ5DXbPODjGm
 xdEz/4xV99Dq3b5ikazFBMMCB+6YEOETs3dgglVIFbDcfpZNabpPTpi7PDOHruPkalVz Rw== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 30r7j1kr2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 20:20:47 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 041JIi2a003912;
        Fri, 1 May 2020 15:20:46 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint7.akamai.com with ESMTP id 30rs31r4jm-3;
        Fri, 01 May 2020 15:20:46 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id C284022024;
        Fri,  1 May 2020 19:20:45 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Roman Penyaev <rpenyaev@suse.de>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org
Subject: [PATCH] epoll: ensure ep_poll() doesn't miss wakeup events
Date:   Fri,  1 May 2020 15:15:33 -0400
Message-Id: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_14:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005010143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_11:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 suspectscore=1 bulkscore=0 clxscore=1011 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010142
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that the ep_events_available() check is done in a lockless way, and
we no longer perform wakeups from ep_scan_ready_list(), we need to ensure
that either ep->rdllist has items or the overflow list is active. Prior to:
commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested
epoll"), we did wake_up(&ep->wq) after manipulating the ep->rdllist and the
overflow list. Thus, any waiters would observe the correct state. However,
with that wake_up() now removed we need to be more careful to ensure that
condition.

Here's an example of what could go wrong:

We have epoll fds: epfd1, epfd2. And epfd1 is added to epfd2 and epfd2 is
added to a socket: epfd1->epfd2->socket. Thread a is doing epoll_wait() on
epfd1, and thread b is doing epoll_wait on epfd2. Then:

1) data comes in on socket

ep_poll_callback() wakes up threads a and b

2) thread a runs

ep_poll()
 ep_scan_ready_list()
  ep_send_events_proc()
   ep_item_poll()
     ep_scan_ready_list()
       list_splice_init(&ep->rdllist, &txlist);

3) now thread b is running

ep_poll()
 ep_events_available()
   returns false
 schedule_hrtimeout_range()

Thus, thread b has now scheduled and missed the wakeup.

Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: <stable@vger.kernel.org>
---
 fs/eventpoll.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aba03ee749f8..4af2d020f548 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -704,8 +704,14 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
 	 * in a lockless way.
 	 */
 	write_lock_irq(&ep->lock);
-	list_splice_init(&ep->rdllist, &txlist);
 	WRITE_ONCE(ep->ovflist, NULL);
+	/*
+	 * In ep_poll() we use ep_events_available() in a lockless way to decide
+	 * if events are available. So we need to preserve that either
+	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
+	 */
+	smp_wmb();
+	list_splice_init(&ep->rdllist, &txlist);
 	write_unlock_irq(&ep->lock);
 
 	/*
@@ -737,16 +743,21 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
 		}
 	}
 	/*
+	 * Quickly re-inject items left on "txlist".
+	 */
+	list_splice(&txlist, &ep->rdllist);
+	/*
+	 * In ep_poll() we use ep_events_available() in a lockless way to decide
+	 * if events are available. So we need to preserve that either
+	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
+	 */
+	smp_wmb();
+	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside
 	 * ep->rdllist.
 	 */
 	WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
-
-	/*
-	 * Quickly re-inject items left on "txlist".
-	 */
-	list_splice(&txlist, &ep->rdllist);
 	__pm_relax(ep->ws);
 	write_unlock_irq(&ep->lock);
 
-- 
2.7.4

