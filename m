Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A4217F875
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgCJMsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbgCJMsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268CD2467D;
        Tue, 10 Mar 2020 12:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844491;
        bh=LPWEOXXHH5EmBECDqoJMdQuy16xACdmF1Y8tC/ZfenU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISNzU1erqjKptA/FMheDcF6Rswpg186h0RL7qXxxylTz6q6IwPUldff8quAosXRZm
         XuQOMsymy1NYmsVsqRJUNGX12gC1Apvn1sNbzN/Hi4syaeh7dBqOzPr7Ycd/kRfUCX
         1OaGJJPneofpsvCMdwCHUyJLi5JC94L06moqr9To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bob Liu <bob.liu@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Cengiz Can <cengiz@kernel.wtf>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/168] blktrace: fix dereference after null check
Date:   Tue, 10 Mar 2020 13:37:38 +0100
Message-Id: <20200310123636.981272933@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
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
index 4b2ad374167bc..e7e483cdbea61 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1888,8 +1888,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
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



