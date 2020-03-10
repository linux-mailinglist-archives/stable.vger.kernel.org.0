Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52F817F97D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgCJM5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbgCJM5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 152082468C;
        Tue, 10 Mar 2020 12:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845033;
        bh=opVUpIVvQuO7xRxLPra1xBHeYEX2mK5yVlA+tA2+qKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBD1zdL/nUv4ysDYCIHvRWaONjZGCjceZgvQH+AOs7lgdEoXLdJ5lYji6HcdozSlW
         ARHO2kRs16gEFs9euVN6WeBiQPBllc5kHDELL6Kr5bF6DTqjpeJQZRdP+O4L2h0P00
         oXZjD/y3z6iSOlDCp7GVIzMxSfV2t8j2d7cDXxis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bob Liu <bob.liu@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Cengiz Can <cengiz@kernel.wtf>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 009/189] blktrace: fix dereference after null check
Date:   Tue, 10 Mar 2020 13:37:26 +0100
Message-Id: <20200310123640.492907229@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cengiz Can <cengiz@kernel.wtf>

[ Upstream commit 153031a301bb07194e9c37466cfce8eacb977621 ]

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
Cc: stable@vger.kernel.org
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a6d3016410eba..840ef7af20e04 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1896,8 +1896,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
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



