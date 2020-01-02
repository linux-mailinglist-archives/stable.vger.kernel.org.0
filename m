Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6012EDB1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgABWaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgABWav (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C02820863;
        Thu,  2 Jan 2020 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004251;
        bh=obYcbybQK0iRzuQodJ35Y2/yu1p1+C2bxabYBA70L0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfwnlQQOvgNIh0qLMZiGXcxFfLSZQloPPa9ljjmIri81y5sZqGmJrhQfl9yQ/E2go
         gY1TeVDl0fcNsu27R1a3NJ+Zj/F1wPXipZxVhRAuRnGNtH4l63Uuur2o8x0jxUnaA1
         dYvXc+MRHUOyT7WqFdYUA0pqZRAOgbQ9bNsV9axw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 075/171] btrfs: dont prematurely free work in end_workqueue_fn()
Date:   Thu,  2 Jan 2020 23:06:46 +0100
Message-Id: <20200102220557.382989729@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9d3352fe8dc9..b37519241eb1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1712,8 +1712,8 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_error = end_io_wq->error;
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
-	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 	bio_endio(bio);
+	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 }
 
 static int cleaner_kthread(void *arg)
-- 
2.20.1



