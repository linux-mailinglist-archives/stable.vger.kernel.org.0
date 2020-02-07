Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA93155A7C
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 16:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgBGPRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 10:17:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:33628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGPRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 10:17:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A0A1AC5C;
        Fri,  7 Feb 2020 15:17:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7667BDA790; Fri,  7 Feb 2020 16:17:00 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, anand.jain@oracle.com,
        Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
Subject: [PATCH v2] btrfs: print message when tree-log replay starts
Date:   Fri,  7 Feb 2020 16:16:57 +0100
Message-Id: <20200207151657.2824-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's no logged information about tree-log replay although this is
something that points to previous unclean unmount. Other filesystems
report that as well.

Suggested-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---

* add missing fs_info to btrfs_info

 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8fee95916be4..db16014abd64 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3224,6 +3224,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;
-- 
2.25.0

