Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A2212EF8C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgABWaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbgABWaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC7620866;
        Thu,  2 Jan 2020 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004212;
        bh=62y6fMdHxwp4nQAatzWsMLdvOZXd8xkaWKa+8vceoJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBr/vhwKBIBsOkik7hBSRDku6YgK+OaqCb4A30rVkKootGtDwAYczUawoQC/VDMNO
         JaDpkTEoPUXaKTsyqDY2Sq3C0CKyzqB/uTWUuWiXGAKDV+EsMhpNB1OKJ7y2085zSp
         Jpv61HTlRXaPrs7bSUb6lbDk0b9zii997MvS0oKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/171] btrfs: dont prematurely free work in reada_start_machine_worker()
Date:   Thu,  2 Jan 2020 23:06:56 +0100
Message-Id: <20200102220558.786641120@linuxfoundation.org>
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

[ Upstream commit e732fe95e4cad35fc1df278c23a32903341b08b3 ]

Currently, reada_start_machine_worker() frees the reada_machine_work and
then calls __reada_start_machine() to do readahead. This is another
potential instance of the bug in "btrfs: don't prematurely free work in
run_ordered_work()".

There _might_ already be a deadlock here: reada_start_machine_worker()
can depend on itself through stacked filesystems (__read_start_machine()
-> reada_start_machine_dev() -> reada_tree_block_flagged() ->
read_extent_buffer_pages() -> submit_one_bio() ->
btree_submit_bio_hook() -> btrfs_map_bio() -> submit_stripe_bio() ->
submit_bio() onto a loop device can trigger readahead on the lower
filesystem).

Either way, let's fix it by freeing the work at the end.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/reada.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 94441fdb1ecf..0d1565d71231 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -734,21 +734,19 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 static void reada_start_machine_worker(struct btrfs_work *work)
 {
 	struct reada_machine_work *rmw;
-	struct btrfs_fs_info *fs_info;
 	int old_ioprio;
 
 	rmw = container_of(work, struct reada_machine_work, work);
-	fs_info = rmw->fs_info;
-
-	kfree(rmw);
 
 	old_ioprio = IOPRIO_PRIO_VALUE(task_nice_ioclass(current),
 				       task_nice_ioprio(current));
 	set_task_ioprio(current, BTRFS_IOPRIO_READA);
-	__reada_start_machine(fs_info);
+	__reada_start_machine(rmw->fs_info);
 	set_task_ioprio(current, old_ioprio);
 
-	atomic_dec(&fs_info->reada_works_cnt);
+	atomic_dec(&rmw->fs_info->reada_works_cnt);
+
+	kfree(rmw);
 }
 
 static void __reada_start_machine(struct btrfs_fs_info *fs_info)
-- 
2.20.1



