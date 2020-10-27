Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C0B29C0E5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368550AbgJ0Oy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbgJ0OnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:43:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5972222C;
        Tue, 27 Oct 2020 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809798;
        bh=+kDMFYPNlsQUHUHKdFrxk0ckCdUURXek0l2hYWeThDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQNwqJhkHayYBh5bAKBbUY799WbDWOyHksD23DGPSit5ICQVnqyMt9mAPxeZ3yA03
         IsNU9Woo1dwuRNDgite6uMuu2nGF0nGj8x7O9Rqqrop+TQWLRwJGUIyVyy+RUp3S/h
         FM1268LoqarcpzoMmSLRPJaijvDqtUyxtxs1AhBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/408] md/bitmap: fix memory leak of temporary bitmap
Date:   Tue, 27 Oct 2020 14:54:22 +0100
Message-Id: <20201027135510.055053083@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



