Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562A129A1CC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502419AbgJ0AoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409228AbgJZXuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A7FD21741;
        Mon, 26 Oct 2020 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756254;
        bh=YJnQu0a/mHSLYZusbjZ7E7CxSh2AwFB3Vvkd0QXN0nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsrssXK0386bV7RxGH+hPeeaebZ1y2WqCMDS2HqFQSxoSASKGhRLIN0nrSUtUkjog
         2/ZlAYVmOrTKUs++5vgz08uZRT2j6qmWGlHG+ZiaIb7MxEy2d7ISdSzRxD5qBDN+TT
         +ao3iU1f1i3RLHEIdq6WZiRnWsZ7N5pQ8VaUqOwk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 089/147] dm: change max_io_len() to use blk_max_size_offset()
Date:   Mon, 26 Oct 2020 19:48:07 -0400
Message-Id: <20201026234905.1022767-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 5091cdec56faeaefa79de4b6cb3c3c55e50d1ac3 ]

Using blk_max_size_offset() enables DM core's splitting to impose
ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
respecting q->limits.max_sectors if chunk_sectors isn't set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ed05ca65a0f8..3982012b1309c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1051,22 +1051,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
 static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 {
 	sector_t len = max_io_len_target_boundary(sector, ti);
-	sector_t offset, max_len;
+	sector_t max_len;
 
 	/*
 	 * Does the target need to split even further?
+	 * - q->limits.chunk_sectors reflects ti->max_io_len so
+	 *   blk_max_size_offset() provides required splitting.
+	 * - blk_max_size_offset() also respects q->limits.max_sectors
 	 */
-	if (ti->max_io_len) {
-		offset = dm_target_offset(ti, sector);
-		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
-			max_len = sector_div(offset, ti->max_io_len);
-		else
-			max_len = offset & (ti->max_io_len - 1);
-		max_len = ti->max_io_len - max_len;
-
-		if (len > max_len)
-			len = max_len;
-	}
+	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
+				      dm_target_offset(ti, sector));
+	if (len > max_len)
+		len = max_len;
 
 	return len;
 }
-- 
2.25.1

