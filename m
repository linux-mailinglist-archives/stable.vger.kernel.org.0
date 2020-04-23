Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1BE1B67CC
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgDWXG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50448 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728603AbgDWXGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvf-0004tC-UC; Fri, 24 Apr 2020 00:06:48 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkva-00E70g-PO; Fri, 24 Apr 2020 00:06:42 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Cengiz Can" <cengiz@kernel.wtf>, "Bob Liu" <bob.liu@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Ming Lei" <ming.lei@redhat.com>, "Jens Axboe" <axboe@kernel.dk>
Date:   Fri, 24 Apr 2020 00:07:20 +0100
Message-ID: <lsq.1587683028.504333663@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 213/245] blktrace: fix dereference after null check
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cengiz Can <cengiz@kernel.wtf>

commit 153031a301bb07194e9c37466cfce8eacb977621 upstream.

There was a recent change in blktrace.c that added a RCU protection to
`q->blk_trace` in order to fix a use-after-free issue during access.

However the change missed an edge case that can lead to dereferencing of
`bt` pointer even when it's NULL:

Coverity static analyzer marked this as a FORWARD_NULL issue with CID
1460458.

```
/kernel/trace/blktrace.c: 1904 in sysfs_blk_trace_attr_store()
1898            ret = 0;
1899            if (bt == NULL)
1900                    ret = blk_trace_setup_queue(q, bdev);
1901
1902            if (ret == 0) {
1903                    if (attr == &dev_attr_act_mask)
>>>     CID 1460458:  Null pointer dereferences  (FORWARD_NULL)
>>>     Dereferencing null pointer "bt".
1904                            bt->act_mask = value;
1905                    else if (attr == &dev_attr_pid)
1906                            bt->pid = value;
1907                    else if (attr == &dev_attr_start_lba)
1908                            bt->start_lba = value;
1909                    else if (attr == &dev_attr_end_lba)
```

Added a reassignment with RCU annotation to fix the issue.

Fixes: c780e86dd48 ("blktrace: Protect q->blk_trace with RCU")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/blktrace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1834,8 +1834,11 @@ static ssize_t sysfs_blk_trace_attr_stor
 	}
 
 	ret = 0;
-	if (bt == NULL)
+	if (bt == NULL) {
 		ret = blk_trace_setup_queue(q, bdev);
+		bt = rcu_dereference_protected(q->blk_trace,
+				lockdep_is_held(&q->blk_trace_mutex));
+	}
 
 	if (ret == 0) {
 		if (attr == &dev_attr_act_mask)

