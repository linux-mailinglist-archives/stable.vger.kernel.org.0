Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C14291F89
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJRTSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgJRTSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A554C2227F;
        Sun, 18 Oct 2020 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048689;
        bh=PaBaMle6cptMNlqbiY8LHyjI6EMdhE8w8qJDJ/Ffg0M=;
        h=From:To:Cc:Subject:Date:From;
        b=KBSC43zw848rkE/dNYfikaVWYHl4eWsyz4/66zJAjLkJH9T4x5BxqWCN85zknW21U
         q/bCjIt18G/BIoprt76MEOy3B4BIs8LZL5rdEcHlyvaUyl/gUOWMa2IJyaBUeZ4Uwk
         aAnZqK1pVV8QoAZxP2tnSGAQxhTnDsSBp8wsuvZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 001/111] md/bitmap: fix memory leak of temporary bitmap
Date:   Sun, 18 Oct 2020 15:16:17 -0400
Message-Id: <20201018191807.4052726-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

[ Upstream commit 1383b347a8ae4a69c04ae3746e6cb5c8d38e2585 ]

Callers of get_bitmap_from_slot() are responsible to free the bitmap.

Suggested-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c  | 3 ++-
 drivers/md/md-cluster.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b10c51988c8ee..c61ab86a28b52 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1949,6 +1949,7 @@ int md_bitmap_load(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_load);
 
+/* caller need to free returned bitmap with md_bitmap_free() */
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
@@ -2012,6 +2013,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	md_bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
+	md_bitmap_free(bitmap);
 
 	return rv;
 }
@@ -2615,4 +2617,3 @@ struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
-
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d50737ec40394..afbbc552c3275 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1166,6 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			 * can't resize bitmap
 			 */
 			goto out;
+		md_bitmap_free(bitmap);
 	}
 
 	return 0;
-- 
2.25.1

