Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B5327CA83
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgI2Lf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729790AbgI2LfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D8523D21;
        Tue, 29 Sep 2020 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378965;
        bh=wNT+wgEq/onrFLwV6Wt3Ns5n98d+k00SFhxfTWKd6eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ac54E4dvfRa3fMm9ZcWSr7i13+CkTd9MU8T3QAmryS2D1xwVc5Kx7TOESYXFetzal
         GuKvXJvLUj8VCmXpKFt7U4HQhqiah/OeHS2FGYcfLonHIe2DfCUua1h9Kk7EqJ+sd7
         jvbV+vsjkrRP4KCS+wiyA8wOZPzeMKQ2eUgeF7Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f317896aae32eb281a58@syzkaller.appspotmail.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Hou Tao <houtao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/245] ubi: fastmap: Free unused fastmap anchor peb during detach
Date:   Tue, 29 Sep 2020 13:00:53 +0200
Message-Id: <20200929105956.806061670@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit c16f39d14a7e0ec59881fbdb22ae494907534384 ]

When CONFIG_MTD_UBI_FASTMAP is enabled, fm_anchor will be assigned
a free PEB during ubi_wl_init() or ubi_update_fastmap(). However
if fastmap is not used or disabled on the MTD device, ubi_wl_entry
related with the PEB will not be freed during detach.

So Fix it by freeing the unused fastmap anchor during detach.

Fixes: f9c34bb52997 ("ubi: Fix producing anchor PEBs")
Reported-by: syzbot+f317896aae32eb281a58@syzkaller.appspotmail.com
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 13efebb400225..e08f6b4637dda 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -48,6 +48,13 @@ static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
 	return victim;
 }
 
+static inline void return_unused_peb(struct ubi_device *ubi,
+				     struct ubi_wl_entry *e)
+{
+	wl_tree_add(e, &ubi->free);
+	ubi->free_count++;
+}
+
 /**
  * return_unused_pool_pebs - returns unused PEB to the free tree.
  * @ubi: UBI device description object
@@ -61,8 +68,7 @@ static void return_unused_pool_pebs(struct ubi_device *ubi,
 
 	for (i = pool->used; i < pool->size; i++) {
 		e = ubi->lookuptbl[pool->pebs[i]];
-		wl_tree_add(e, &ubi->free);
-		ubi->free_count++;
+		return_unused_peb(ubi, e);
 	}
 }
 
@@ -370,6 +376,11 @@ static void ubi_fastmap_close(struct ubi_device *ubi)
 	return_unused_pool_pebs(ubi, &ubi->fm_pool);
 	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
 
+	if (ubi->fm_anchor) {
+		return_unused_peb(ubi, ubi->fm_anchor);
+		ubi->fm_anchor = NULL;
+	}
+
 	if (ubi->fm) {
 		for (i = 0; i < ubi->fm->used_blocks; i++)
 			kfree(ubi->fm->e[i]);
-- 
2.25.1



