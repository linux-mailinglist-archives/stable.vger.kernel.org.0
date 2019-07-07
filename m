Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF32616C0
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfGGTma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:42:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57606 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727434AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0006jB-U1; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005d5-6k; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nikolay Borisov" <nborisov@suse.com>,
        "David Sterba" <dsterba@suse.com>,
        "Dan Robertson" <dan@dlrobertson.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.537362158@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 084/129] btrfs: init csum_list before possible free
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Robertson <dan@dlrobertson.com>

commit e49be14b8d80e23bb7c53d78c21717a474ade76b upstream.

The scrub_ctx csum_list member must be initialized before scrub_free_ctx
is called. If the csum_list is not initialized beforehand, the
list_empty call in scrub_free_csums will result in a null deref if the
allocation fails in the for loop.

Fixes: a2de733c78fa ("btrfs: scrub")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -417,6 +417,7 @@ struct scrub_ctx *scrub_setup_ctx(struct
 	sctx->pages_per_rd_bio = pages_per_rd_bio;
 	sctx->curr = -1;
 	sctx->dev_root = dev->dev_root;
+	INIT_LIST_HEAD(&sctx->csum_list);
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -444,7 +445,6 @@ struct scrub_ctx *scrub_setup_ctx(struct
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sctx->csum_list);
 
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);

