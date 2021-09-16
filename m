Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEE940DFAA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhIPQMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234606AbhIPQJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5881B60F5B;
        Thu, 16 Sep 2021 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808479;
        bh=G1ZlR/KPppvgOA8cyS27zxnrqtMOzXMJDSDxRLDiTBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQxFDAEAADota2qXu0FqbWz6rXJkBQQASz+s/J3Oln/bicVcX09v9kDQo10gWhO71
         tMEe5UQqyuEOE78Nz5ei9tCtQakpA0/JAUnWYmDGqhQ1nQ2RBMv/2ygQmo0U4L4308
         vjY3Law5aTLbvG8p7sMIsVQHenh021C5QD9nV27A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/306] dma-debug: fix debugfs initialization order
Date:   Thu, 16 Sep 2021 17:56:59 +0200
Message-Id: <20210916155756.581873333@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit 173735c346c412d9f084825ecb04f24ada0e2986 ]

Due to link order, dma_debug_init is called before debugfs has a chance
to initialize (via debugfs_init which also happens in the core initcall
stage), so the directories for dma-debug are never created.

Decouple dma_debug_fs_init from dma_debug_init and defer its init until
core_initcall_sync (after debugfs has been initialized) while letting
dma-debug initialization occur as soon as possible to catch any early
mappings, as suggested in [1].

[1] https://lore.kernel.org/linux-iommu/YIgGa6yF%2Fadg8OSN@kroah.com/

Fixes: 15b28bbcd567 ("dma-debug: move initialization to common code")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 14de1271463f..445754529917 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -794,7 +794,7 @@ static int dump_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(dump);
 
-static void dma_debug_fs_init(void)
+static int __init dma_debug_fs_init(void)
 {
 	struct dentry *dentry = debugfs_create_dir("dma-api", NULL);
 
@@ -807,7 +807,10 @@ static void dma_debug_fs_init(void)
 	debugfs_create_u32("nr_total_entries", 0444, dentry, &nr_total_entries);
 	debugfs_create_file("driver_filter", 0644, dentry, NULL, &filter_fops);
 	debugfs_create_file("dump", 0444, dentry, NULL, &dump_fops);
+
+	return 0;
 }
+core_initcall_sync(dma_debug_fs_init);
 
 static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
@@ -892,8 +895,6 @@ static int dma_debug_init(void)
 		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
-	dma_debug_fs_init();
-
 	nr_pages = DIV_ROUND_UP(nr_prealloc_entries, DMA_DEBUG_DYNAMIC_ENTRIES);
 	for (i = 0; i < nr_pages; ++i)
 		dma_debug_create_entries(GFP_KERNEL);
-- 
2.30.2



