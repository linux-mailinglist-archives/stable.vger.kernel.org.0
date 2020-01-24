Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689981482D8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391772AbgAXLbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391771AbgAXLbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:12 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A537F206D4;
        Fri, 24 Jan 2020 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865472;
        bh=RSvTYQOq+dqRtFvcEwo6b1yZz81thGkC5mHRNSKdeQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFExUUN4xyCnKkXpuBX3OnZWCiG5cOC0seKaIL6YRxVVXeneiF/LzMO3MZ8sWRBLb
         FyNpJq8KROgy1HrhhnmWwE2pSjqptxL4R337w0xBeQPn/TcjHWnpezj1yKJSsRFwX9
         XLSJRZ8Br2h1aXwcfHX1bCwzFv5NlIEk2nQV6VUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 555/639] Btrfs: fix inode cache waiters hanging on path allocation failure
Date:   Fri, 24 Jan 2020 10:32:05 +0100
Message-Id: <20200124093158.757266300@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7c4d0107c6fb9..c7dcb7c521086 100644
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



