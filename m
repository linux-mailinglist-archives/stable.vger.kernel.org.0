Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7709E61E1C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGHMBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbfGHMBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 08:01:35 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 587B13082A98;
        Mon,  8 Jul 2019 12:01:35 +0000 (UTC)
Received: from localhost (ovpn-204-155.brq.redhat.com [10.40.204.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF3D45C226;
        Mon,  8 Jul 2019 12:01:34 +0000 (UTC)
Date:   Mon, 8 Jul 2019 14:01:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4.14.y] stable/btrfs: fix backport bug in d819d97ea025
 ("btrfs: honor path->skip_locking in backref code")
Message-ID: <20190708120130.GA25587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 08 Jul 2019 12:01:35 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 38e3eebff643 ("btrfs: honor path->skip_locking in
backref code") was incorrectly backported to 4.14.y . It misses removal
of two lines from original commit, what cause deadlock.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203993
Reported-by: Olivier Mazouffre <olivier.mazouffre@ims-bordeaux.fr>
Fixes: d819d97ea025 ("btrfs: honor path->skip_locking in backref code")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I did not test the patch, not even compile, but backport looks
obviously wrong compared to original commit.

 fs/btrfs/backref.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d826fbaf7d50..e4d5e6eae409 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1290,8 +1290,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 					ret = -EIO;
 					goto out;
 				}
-				btrfs_tree_read_lock(eb);
-				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				if (!path->skip_locking) {
 					btrfs_tree_read_lock(eb);
 					btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
-- 
2.20.1

