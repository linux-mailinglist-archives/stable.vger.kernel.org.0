Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B403D20599D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgFWRmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387423AbgFWRfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEDA620780;
        Tue, 23 Jun 2020 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933754;
        bh=l/Fx7AtissAOI7sKQ4NNbynURHbMMk6kMVPfC3gUQEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2V8flgVaurnW99fxuk21cfIsW1wYFgZLYbtFwLuU1sR29SrDdQ2OXbMckJBgZ07t5
         9lqFyPyIYswdMJqug/ekA3X8RmrBa7K6JI7FGteeE2hd46f2iMSXoLD9ed7XgtmsCs
         LIZXGE6B8SLgyV4kQBY9/ILQy7q0dxkL408NOKIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>, Jan Kara <jack@suse.cz>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 25/28] blktrace: break out of blktrace setup on concurrent calls
Date:   Tue, 23 Jun 2020 13:35:20 -0400
Message-Id: <20200623173523.1355411-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 1b0b283648163dae2a214ca28ed5a99f62a77319 ]

We use one blktrace per request_queue, that means one per the entire
disk.  So we cannot run one blktrace on say /dev/vda and then /dev/vda1,
or just two calls on /dev/vda.

We check for concurrent setup only at the very end of the blktrace setup though.

If we try to run two concurrent blktraces on the same block device the
second one will fail, and the first one seems to go on. However when
one tries to kill the first one one will see things like this:

The kernel will show these:

```
debugfs: File 'dropped' in directory 'nvme1n1' already present!
debugfs: File 'msg' in directory 'nvme1n1' already present!
debugfs: File 'trace0' in directory 'nvme1n1' already present!
``

And userspace just sees this error message for the second call:

```
blktrace /dev/nvme1n1
BLKTRACESETUP(2) /dev/nvme1n1 failed: 5/Input/output error
```

The first userspace process #1 will also claim that the files
were taken underneath their nose as well. The files are taken
away form the first process given that when the second blktrace
fails, it will follow up with a BLKTRACESTOP and BLKTRACETEARDOWN.
This means that even if go-happy process #1 is waiting for blktrace
data, we *have* been asked to take teardown the blktrace.

This can easily be reproduced with break-blktrace [0] run_0005.sh test.

Just break out early if we know we're already going to fail, this will
prevent trying to create the files all over again, which we know still
exist.

[0] https://github.com/mcgrof/break-blktrace

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index ca39dc3230cb3..3a89aeb73d690 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -3,6 +3,9 @@
  * Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
@@ -494,6 +497,16 @@ static int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	 */
 	strreplace(buts->name, '/', '_');
 
+	/*
+	 * bdev can be NULL, as with scsi-generic, this is a helpful as
+	 * we can be.
+	 */
+	if (q->blk_trace) {
+		pr_warn("Concurrent blktraces are not allowed on %s\n",
+			buts->name);
+		return -EBUSY;
+	}
+
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
 	if (!bt)
 		return -ENOMEM;
-- 
2.25.1

