Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E86119B23
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfLJWFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:05:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbfLJWFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:05:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F71D208C3;
        Tue, 10 Dec 2019 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015519;
        bh=BE5tI+5QShgsKZHHwKQe+GmUkCaC9Qu6CyKBsseUrW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riUXnMqtJmEPGlCzWVY8ZQnUtc3PyEle5+2oHbr8MLAmktAT7WfdFFQ1dzyCPjpSZ
         FgZPU9A04Cw8/sTydsXVZv9QSk4p6pNYguBh97mm4HggzaMSVgHFP19z7/Z42ITQ8Y
         5d/UprJhrKLT+chqSWFFxTmeVmWclR9+fExJh0WQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 115/130] btrfs: don't prematurely free work in end_workqueue_fn()
Date:   Tue, 10 Dec 2019 17:02:46 -0500
Message-Id: <20191210220301.13262-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 9be490f1e15c34193b1aae17da58e14dd9f55a95 ]

Currently, end_workqueue_fn() frees the end_io_wq entry (which embeds
the work item) and then calls bio_endio(). This is another potential
instance of the bug in "btrfs: don't prematurely free work in
run_ordered_work()".

In particular, the endio call may depend on other work items. For
example, btrfs_end_dio_bio() can call btrfs_subio_endio_read() ->
__btrfs_correct_data_nocsum() -> dio_read_error() ->
submit_dio_repair_bio(), which submits a bio that is also completed
through a end_workqueue_fn() work item. However,
__btrfs_correct_data_nocsum() waits for the newly submitted bio to
complete, thus it depends on another work item.

This example currently usually works because we use different workqueue
helper functions for BTRFS_WQ_ENDIO_DATA and BTRFS_WQ_ENDIO_DIO_REPAIR.
However, it may deadlock with stacked filesystems and is fragile
overall. The proper fix is to free the work item at the very end of the
work function, so let's do that.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 813834552aa10..a8ea56218d6b6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1679,8 +1679,8 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_status = end_io_wq->status;
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
-	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 	bio_endio(bio);
+	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 }
 
 static int cleaner_kthread(void *arg)
-- 
2.20.1

