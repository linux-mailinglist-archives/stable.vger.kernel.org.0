Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD421BC84C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgD1SbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbgD1SbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E9021744;
        Tue, 28 Apr 2020 18:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098680;
        bh=zDU983lV9ssarBU6MRZRTDQZ3hKmpKdpJadL0LcKvcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up501uDOD1pwupw5K9IVlm43XNk2vrd6UUU+4Xs18CgQsHuy+hR4r00S8p9hjtOm9
         eXDf+OQBKdAvdbcMqs6EWiSxjjVXSsyZYhe6lcJBFxjnwPClHwscAbz/O71gUXye0Q
         yQo1Ip1Wu8j6OfJ3iSZHzK1WpJNkHMrKQGTLC4us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bob Liu <bob.liu@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Cengiz Can <cengiz@kernel.wtf>, Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/131] blktrace: fix dereference after null check
Date:   Tue, 28 Apr 2020 20:24:12 +0200
Message-Id: <20200428182230.107725743@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 99f6cdbf2f540..6cea8bbca03cb 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1893,8 +1893,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
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
-- 
2.20.1



