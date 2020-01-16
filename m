Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C516E13E4EF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbgAPRLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390298AbgAPRLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6AB24681;
        Thu, 16 Jan 2020 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194701;
        bh=KSoKe2uNa26+Y18rL2LmmLbZTgJ4wbXGLJZvGBEYWNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dA46RSRF+6cllmPdwWzwTOCeYQ1QcXopZSaXGIB/N2aq9jxnr75bc+XYMEKAQ1FpU
         FoJJLj+eREUMgNZan73OeD6SCMvTew3y0JQ9AHAlYCYbNmdOIG1yhIdOWi8fl5lnb4
         xK6m4A11Frzw7QMGBD9ypY/ADt6aLyWhvgLdutkc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 541/671] Btrfs: fix inode cache waiters hanging on path allocation failure
Date:   Thu, 16 Jan 2020 12:02:59 -0500
Message-Id: <20200116170509.12787-278-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9d123a35d7e97bb2139747b16127c9b22b6a593e ]

If the caching thread fails to allocate a path, it returns without waking
up any cache waiters, leaving them hang forever. Fix this by following the
same approach as when we fail to start the caching thread: print an error
message, disable inode caching and make the wakers fallback to non-caching
mode behaviour (calling btrfs_find_free_objectid()).

Fixes: 581bb050941b4f ("Btrfs: Cache free inode numbers in memory")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode-map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 7c4d0107c6fb..c7dcb7c52108 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -41,8 +41,10 @@ static int caching_kthread(void *data)
 		return 0;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		fail_caching_thread(root);
 		return -ENOMEM;
+	}
 
 	/* Since the commit root is read-only, we can safely skip locking. */
 	path->skip_locking = 1;
-- 
2.20.1

