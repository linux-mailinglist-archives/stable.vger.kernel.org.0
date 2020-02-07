Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE46155A89
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGPUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 10:20:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgBGPUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 10:20:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EC8DAC5C;
        Fri,  7 Feb 2020 15:20:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CFBF3DA790; Fri,  7 Feb 2020 16:19:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, anand.jain@oracle.com,
        stable@vger.kernel.org
Subject: [PATCH v2] btrfs: log message when rw remount is attempted with unclean tree-log
Date:   Fri,  7 Feb 2020 16:19:55 +0100
Message-Id: <20200207151955.6647-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A remount to a read-write filesystem is not safe when there's tree-log
to be replayed. Files that could be opened until now might be affected
by the changes in the tree-log.

A regular mount is needed to replay the log so the filesystem presents
the consistent view with the pending changes included.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---

* fix typo in fs_info parameter

 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2bfccc40d0fb..5c16b4bcde9b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1841,6 +1841,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
+			btrfs_warn(fs_info,
+		"mount required to replay tree-log, cannot remount read-write");
 			ret = -EINVAL;
 			goto restore;
 		}
-- 
2.25.0

