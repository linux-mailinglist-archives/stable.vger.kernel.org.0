Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BF378318
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhEJKmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232805AbhEJKkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F3A61964;
        Mon, 10 May 2021 10:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642667;
        bh=AERqpN5kleDe6IwFjMQe4lw55vjyM8uwmiBMCBR9VjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCCp8dMTDEOw4+ClDuSEphd8xwNjwqX498dVUdmI0WNF3j4oLzqzyaU4JnTEcjysy
         UVX2K0zUPsJ7F5OBOLH+OvyhXgu4GwXSK9JbsLaCZYv3y1wqM3hXhuxNKMUSh3F3a+
         xeS6l7yEbB0r6dNy6td80Lul0H86YEOK95MDCLIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 164/184] ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()
Date:   Mon, 10 May 2021 12:20:58 +0200
Message-Id: <20210510101955.483965393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 72ffb49a7b623c92a37657eda7cc46a06d3e8398 upstream.

When CONFIG_QUOTA is enabled, if we failed to mount the filesystem due
to some error happens behind ext4_orphan_cleanup(), it will end up
triggering a after free issue of super_block. The problem is that
ext4_orphan_cleanup() will set SB_ACTIVE flag if CONFIG_QUOTA is
enabled, after we cleanup the truncated inodes, the last iput() will put
them into the lru list, and these inodes' pages may probably dirty and
will be write back by the writeback thread, so it could be raced by
freeing super_block in the error path of mount_bdev().

After check the setting of SB_ACTIVE flag in ext4_orphan_cleanup(), it
was used to ensure updating the quota file properly, but evict inode and
trash data immediately in the last iput does not affect the quotafile,
so setting the SB_ACTIVE flag seems not required[1]. Fix this issue by
just remove the SB_ACTIVE setting.

[1] https://lore.kernel.org/linux-ext4/99cce8ca-e4a0-7301-840f-2ace67c551f3@huawei.com/T/#m04990cfbc4f44592421736b504afcc346b2a7c00

Cc: stable@kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Tested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210331033138.918975-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2675,9 +2675,6 @@ static void ext4_orphan_cleanup(struct s
 		sb->s_flags &= ~SB_RDONLY;
 	}
 #ifdef CONFIG_QUOTA
-	/* Needed for iput() to work correctly and not trash data */
-	sb->s_flags |= SB_ACTIVE;
-
 	/*
 	 * Turn on quotas which were not enabled for read-only mounts if
 	 * filesystem has quota feature, so that they are updated correctly.


