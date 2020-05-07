Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5301C8FF5
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgEGOga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgEGO2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B60B2084D;
        Thu,  7 May 2020 14:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861695;
        bh=ryjBNdDtm/1arVH5IDmIEcwKyKd10FYQTjhgnyy1IJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMBZ7SB58kbkwiiBQ4kDrf956obPeniN3JYPs6ZSpU8eqcoTNJLvS6GsN25FUNZiv
         J6sxIgI+/0OYAJgJi7vEuqJE6D2tJgwuUuKN8zX405ZcYD36MRRPDEKnvGWjaqfLd0
         mbWzgmGCK2TaOvPxgAHXh0yviDIyp5AsrfadfCRg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 38/50] Fix use after free in get_tree_bdev()
Date:   Thu,  7 May 2020 10:27:14 -0400
Message-Id: <20200507142726.25751-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit dd7bc8158b413e0b580c491e8bd18cb91057c7c2 ]

Commit 6fcf0c72e4b9, a fix to get_tree_bdev() put a missing blkdev_put() in
the wrong place, before a warnf() that displays the bdev under
consideration rather after it.

This results in a silent lockup in printk("%pg") called via warnf() from
get_tree_bdev() under some circumstances when there's a race with the
blockdev being frozen.  This can be caused by xfstests/tests/generic/085 in
combination with Lukas Czerner's ext4 mount API conversion patchset.  It
looks like it ought to occur with other users of get_tree_bdev() such as
XFS, but apparently doesn't.

Fix this by switching the order of the lines.

Fixes: 6fcf0c72e4b9 ("vfs: add missing blkdev_put() in get_tree_bdev()")
Reported-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ian Kent <raven@themaw.net>
cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index cd352530eca90..a288cd60d2aed 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1302,8 +1302,8 @@ int get_tree_bdev(struct fs_context *fc,
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		blkdev_put(bdev, mode);
 		warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
+		blkdev_put(bdev, mode);
 		return -EBUSY;
 	}
 
-- 
2.20.1

