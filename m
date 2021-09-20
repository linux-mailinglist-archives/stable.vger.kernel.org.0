Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD8641226A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347734AbhITSPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357777AbhITSE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E2E61A53;
        Mon, 20 Sep 2021 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158243;
        bh=PmciNb1mslTz2KO6YkVfzL4onW7x4xImscmzoQGHHek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMJN0ho17859Sq/gX26eNaabMvr4MbcM36bqmd83KmIxsLlcMTSUP5k4PVjIKEqGj
         mEB1U6UJeoalbQtDM97rhBKWurvICL1rbGk6jZpeozKKISuBolTJ3sL6fv5yHHWvfH
         CNzgQ8VViukc8ypG7LZ6nsLN0GT1Wn91HyF2Y4GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/260] dma-debug: fix debugfs initialization order
Date:   Mon, 20 Sep 2021 18:41:07 +0200
Message-Id: <20210920163932.773468371@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index cb6425e52bf7..01e893cf9b9f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -846,7 +846,7 @@ static int dump_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(dump);
 
-static void dma_debug_fs_init(void)
+static int __init dma_debug_fs_init(void)
 {
 	struct dentry *dentry = debugfs_create_dir("dma-api", NULL);
 
@@ -859,7 +859,10 @@ static void dma_debug_fs_init(void)
 	debugfs_create_u32("nr_total_entries", 0444, dentry, &nr_total_entries);
 	debugfs_create_file("driver_filter", 0644, dentry, NULL, &filter_fops);
 	debugfs_create_file("dump", 0444, dentry, NULL, &dump_fops);
+
+	return 0;
 }
+core_initcall_sync(dma_debug_fs_init);
 
 static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
@@ -944,8 +947,6 @@ static int dma_debug_init(void)
 		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
-	dma_debug_fs_init();
-
 	nr_pages = DIV_ROUND_UP(nr_prealloc_entries, DMA_DEBUG_DYNAMIC_ENTRIES);
 	for (i = 0; i < nr_pages; ++i)
 		dma_debug_create_entries(GFP_KERNEL);
-- 
2.30.2



