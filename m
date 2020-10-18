Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53827291DA2
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgJRTWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgJRTWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB6E207DE;
        Sun, 18 Oct 2020 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048953;
        bh=+kDMFYPNlsQUHUHKdFrxk0ckCdUURXek0l2hYWeThDI=;
        h=From:To:Cc:Subject:Date:From;
        b=ocjM+73pjhffQwbUau+t9z99ur58//xEpXT/gIqwD/pgc84aE4SxfDZGR8ukjTwlj
         zkxBQlSqUPmulAtu/dkf39RU75ZL2snX1F3ad/zIgBGlfx4O9yfVJwKk1bagCy2ucX
         lRA2vBokWQIT12DsdwNEVB/HdabHFjKXMBzYT6ZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/80] md/bitmap: fix memory leak of temporary bitmap
Date:   Sun, 18 Oct 2020 15:21:12 -0400
Message-Id: <20201018192231.4054535-1-sashal@kernel.org>
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
index 3ad18246fcb3c..7227d03dbbea7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1954,6 +1954,7 @@ int md_bitmap_load(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_load);
 
+/* caller need to free returned bitmap with md_bitmap_free() */
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
@@ -2017,6 +2018,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	md_bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
+	md_bitmap_free(bitmap);
 
 	return rv;
 }
@@ -2620,4 +2622,3 @@ struct attribute_group md_bitmap_group = {
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

