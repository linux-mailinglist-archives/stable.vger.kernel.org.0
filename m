Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD7147DF0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388548AbgAXKEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388694AbgAXKEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:04:24 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F26208C4;
        Fri, 24 Jan 2020 10:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860264;
        bh=am4pkmskYqjK8X4F25lbDrfas4anZNJMxIlFNg/Pt8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnHtHfYdyGLll+o9AfXq4XbHD17f9Zk3exYLOAnEksBEGxL9m67DowOdqx9sNwrdz
         5OwfHLOSL79zPHy/jZ+fRjeyicAIGNAYjICCY4gYmMsGIadJdQUoCv/zz18L3bj2Kp
         5CRfmI2qtpehwNovSnwYnFBWYs+yFWMrG1EnKraU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 298/343] Btrfs: fix inode cache waiters hanging on path allocation failure
Date:   Fri, 24 Jan 2020 10:31:56 +0100
Message-Id: <20200124092959.138875840@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index b1c3a4ec76c8c..2ae32451fb5b0 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -55,8 +55,10 @@ static int caching_kthread(void *data)
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



