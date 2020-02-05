Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B815350A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgBEQMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:12:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:56278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbgBEQMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 11:12:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B0DECADAB;
        Wed,  5 Feb 2020 16:12:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B12D8DA7E6; Wed,  5 Feb 2020 17:12:20 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: print message when tree-log replay starts
Date:   Wed,  5 Feb 2020 17:12:16 +0100
Message-Id: <20200205161216.24260-1-dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
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
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 28622de9e642..295d5ebc9d5e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3146,6 +3146,7 @@ int __cold open_ctree(struct super_block *sb,
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_info("start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;
-- 
2.24.0

