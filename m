Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6FE33BBC0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhCOOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:20:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:42442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhCOOUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:20:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615818029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5gE66j2cZJmNMTjztjocXk679yuqkWRZ62x7icoKbwA=;
        b=qA74s9uopuZ2qxCcUukUcnoULHxA4VIfwvN6D0M3ys+rBor32T31733rR/sNd7xVEbKew+
        gDZIn7zA6Q8+Hy9wYQoX5JFzqOW3GpDIhyUs2flW8dLJh7bZujBnp5nRVPwE8LDqZ+fpfF
        sIEEvdbE4BsbPFwWRC88/apROs/Tzz4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 61D20AEA3;
        Mon, 15 Mar 2021 14:20:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27FCCDA6E2; Mon, 15 Mar 2021 15:18:27 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Vlastimil Babka <vbabka@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] btrfs: fix slab cache flags for free space tree bitmap
Date:   Mon, 15 Mar 2021 15:18:24 +0100
Message-Id: <20210315141824.26099-1-dsterba@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The free space tree bitmap slab cache is created with SLAB_RED_ZONE but
that's a debugging flag and not always enabled. Also the other slabs are
created with at least SLAB_MEM_SPREAD that we want as well to average
the memory placement cost.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 3acd48507dc4 ("btrfs: fix allocation of free space cache v1 bitmap pages")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 35bfa0533f23..17ec5c4ae18c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9008,7 +9008,7 @@ int __init btrfs_init_cachep(void)
 
 	btrfs_free_space_bitmap_cachep = kmem_cache_create("btrfs_free_space_bitmap",
 							PAGE_SIZE, PAGE_SIZE,
-							SLAB_RED_ZONE, NULL);
+							SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_bitmap_cachep)
 		goto fail;
 
-- 
2.29.2

